/* timing-bar: section-based timing bar for Quarto revealjs speaker view.
 *
 * All timing is per-slide: a `timing-duration` on any slide heading (or a
 * `.timing` div inside a slide) budgets that one slide. Sections (slides with
 * an h1, or tagged .timing-section) only group slides into bar segments; a
 * segment's planned time is the sum of its slides. Slides without an explicit
 * duration split the remaining global budget evenly.
 */
window.RevealTimingBar = {
  id: "timing-bar",

  init: function (deck) {
    "use strict";

    /* ---------- environment ---------- */
    // In the reveal.js speaker view, the deck is reloaded inside iframes with
    // `receiver` in the query string. Only the current-slide iframe gets
    // `postMessageEvents=true` (newer reveal marks the upcoming iframe with
    // `loop=true` instead); that iframe is the leader that owns the bar.
    const search = window.location.search;
    const inSpeaker = window.self !== window.top && /receiver/.test(search);
    const isLeader =
      /postMessageEvents=true/.test(search) && !/loop=true/.test(search);
    if (!inSpeaker || !isLeader) return;

    let host;
    try {
      void window.parent.document.body; // same-origin check
      host = window.parent.document;
    } catch (e) {
      host = document;
    }
    if (host.getElementById("timing-bar")) return;

    // The plugin stylesheet is loaded in the deck (iframe) document; when
    // injecting into the speaker window we must copy it there too.
    if (!host.getElementById("timing-bar-style")) {
      const link = document.querySelector('link[href*="timing-bar.css"]');
      if (link) {
        const clone = host.createElement("link");
        clone.id = "timing-bar-style";
        clone.rel = "stylesheet";
        clone.href = new URL(link.getAttribute("href"), window.location.href).href;
        host.head.appendChild(clone);
      }
    }

    /* ---------- helpers ---------- */
    function parseDuration(str) {
      if (str == null) return null;
      if (typeof str === "number") return str * 60;
      let total = 0;
      let matched = false;
      const re = /(\d+(?:\.\d+)?)\s*([a-z]*)/gi;
      let m;
      while ((m = re.exec(String(str))) !== null) {
        if (m[0].trim() === "") continue;
        const n = parseFloat(m[1]);
        const unit = m[2].toLowerCase();
        matched = true;
        if (unit === "h" || unit.startsWith("hour")) total += n * 3600;
        else if (unit === "s" || unit.startsWith("sec")) total += n;
        else total += n * 60; // "", "m", "min", "minutes"
      }
      return matched ? total : null;
    }

    function fmt(seconds) {
      seconds = Math.round(seconds);
      const sign = seconds < 0 ? "-" : "";
      seconds = Math.abs(seconds);
      const h = Math.floor(seconds / 3600);
      const min = Math.floor((seconds % 3600) / 60);
      const s = seconds % 60;
      const mm = String(min).padStart(h > 0 ? 2 : 1, "0");
      const ss = String(s).padStart(2, "0");
      return h > 0 ? `${sign}${h}:${mm}:${ss}` : `${sign}${mm}:${ss}`;
    }

    /* ---------- build the model ---------- */
    const cfgEl = document.getElementById("timing-bar-config");
    const cfg = cfgEl ? JSON.parse(cfgEl.textContent || "{}") : {};

    // Exclude vertical-stack wrapper sections; only leaf slides count.
    const slides = deck
      .getSlides()
      .filter(function (el) {
        return !el.querySelector(":scope > section");
      })
      .map(function (el, i) {
      const dataEl = el.querySelector(".timing-bar-data");
      const explicit = dataEl ? parseDuration(dataEl.dataset.duration) : null;
      const isSection =
        !!el.querySelector("h1") ||
        el.classList.contains("timing-section") ||
        (dataEl && dataEl.dataset.section === "true");
      const headingEl = el.querySelector("h1, h2, h3");
      const title =
        (dataEl && dataEl.dataset.title) ||
        (headingEl ? headingEl.textContent.trim() : "") ||
        "Slide " + (i + 1);
      return {
        el: el,
        index: i,
        explicit: explicit,
        isSection: isSection,
        title: title,
        planned: 0,
        actual: 0,
      };
    });

    /* ---------- allocation ---------- */
    const explicitSum = slides.reduce(function (acc, s) {
      return acc + (s.explicit || 0);
    }, 0);
    const implicitCount = slides.filter(function (s) {
      return s.explicit == null;
    }).length;

    let totalPlanned = parseDuration(cfg.duration);
    if (totalPlanned == null && explicitSum > 0) totalPlanned = explicitSum;
    if (totalPlanned == null || totalPlanned <= 0 || slides.length === 0) {
      return; // nothing to show
    }

    if (explicitSum > totalPlanned) {
      const scale = totalPlanned / explicitSum;
      slides.forEach(function (s) {
        s.planned = s.explicit != null ? s.explicit * scale : 0;
      });
    } else {
      const share = implicitCount > 0 ? (totalPlanned - explicitSum) / implicitCount : 0;
      slides.forEach(function (s) {
        s.planned = s.explicit != null ? s.explicit : share;
      });
    }

    // cumulative planned start per slide
    let cum = 0;
    slides.forEach(function (s) {
      s.plannedStart = cum;
      cum += s.planned;
    });

    // group into sections (prologue slides before the first section form one)
    const sections = [];
    slides.forEach(function (s) {
      if (s.isSection || sections.length === 0) {
        sections.push({
          title: s.isSection ? s.title : "Intro",
          slides: [],
        });
      }
      s.section = sections[sections.length - 1];
      s.section.slides.push(s);
    });
    sections.forEach(function (sec) {
      sec.planned = sec.slides.reduce(function (acc, s) {
        return acc + s.planned;
      }, 0);
      sec.plannedStart = sec.slides[0].plannedStart;
    });

    /* ---------- recording state ---------- */
    const storeKey = "timing-bar:" + window.location.pathname;
    let startTime = null; // ms epoch; timer starts on first navigation
    let lastChange = null;
    let pausedAt = null; // ms epoch while paused, else null
    let currentIndex = flatIndex(deck.getIndices());

    try {
      const saved = JSON.parse(sessionStorage.getItem(storeKey) || "null");
      if (saved && saved.actuals && saved.actuals.length === slides.length) {
        saved.actuals.forEach(function (a, i) {
          slides[i].actual = a;
        });
        if (saved.startTime) {
          startTime = saved.startTime;
          lastChange = Date.now();
        }
      }
    } catch (e) {
      /* ignore corrupted storage */
    }

    function flatIndex(indices) {
      const el = deck.getSlide(indices.h, indices.v);
      return slides.findIndex(function (s) {
        return s.el === el;
      });
    }

    function persist() {
      try {
        sessionStorage.setItem(
          storeKey,
          JSON.stringify({
            startTime: startTime,
            actuals: slides.map(function (s) {
              return s.actual;
            }),
          })
        );
      } catch (e) {
        /* storage full or unavailable */
      }
    }

    function elapsed() {
      if (startTime == null) return 0;
      return ((pausedAt != null ? pausedAt : Date.now()) - startTime) / 1000;
    }

    /* ---------- DOM ---------- */
    const bar = host.createElement("div");
    bar.id = "timing-bar";
    if (cfg.position === "top") bar.classList.add("timing-bar-top");

    const segmentsEl = host.createElement("div");
    segmentsEl.className = "timing-bar-segments";
    bar.appendChild(segmentsEl);

    sections.forEach(function (sec) {
      const seg = host.createElement("div");
      seg.className = "timing-bar-segment";
      seg.style.flexGrow = String(Math.max(sec.planned, 1));
      seg.title = sec.title + " (" + fmt(sec.planned) + ")\n" +
        sec.slides.map(function (s) { return "• " + s.title; }).join("\n");
      const fill = host.createElement("div");
      fill.className = "timing-bar-fill";
      seg.appendChild(fill);
      const label = host.createElement("span");
      label.className = "timing-bar-label";
      label.textContent = sec.title;
      seg.appendChild(label);
      seg.addEventListener("click", function () {
        const idx = deck.getIndices(sec.slides[0].el);
        deck.slide(idx.h, idx.v);
      });
      sec.segEl = seg;
      sec.fillEl = fill;
      segmentsEl.appendChild(seg);
    });

    const marker = host.createElement("div");
    marker.className = "timing-bar-marker";
    segmentsEl.appendChild(marker);

    const controls = host.createElement("div");
    controls.className = "timing-bar-controls";

    const clock = host.createElement("span");
    clock.className = "timing-bar-clock";
    clock.textContent = "0:00 / " + fmt(totalPlanned);
    controls.appendChild(clock);

    const resetBtn = host.createElement("button");
    resetBtn.className = "timing-bar-btn";
    resetBtn.textContent = "↺";
    resetBtn.title = "Reset timer and recorded timings";
    resetBtn.addEventListener("click", function () {
      startTime = null;
      lastChange = null;
      pausedAt = null;
      pauseBtn.textContent = "⏸";
      pauseBtn.title = "Pause the timer";
      slides.forEach(function (s) {
        s.actual = 0;
      });
      persist();
      render();
    });
    controls.appendChild(resetBtn);

    const pauseBtn = host.createElement("button");
    pauseBtn.className = "timing-bar-btn";
    pauseBtn.textContent = "⏸";
    pauseBtn.title = "Pause the timer";
    pauseBtn.addEventListener("click", function () {
      if (startTime == null) return; // timer not running yet
      if (pausedAt == null) {
        recordDwell();
        lastChange = null; // no dwell accrues while paused
        pausedAt = Date.now();
        pauseBtn.textContent = "▶";
        pauseBtn.title = "Resume the timer";
      } else {
        startTime += Date.now() - pausedAt;
        pausedAt = null;
        lastChange = Date.now();
        pauseBtn.textContent = "⏸";
        pauseBtn.title = "Pause the timer";
      }
      persist();
      render();
    });
    controls.appendChild(pauseBtn);

    const summaryBtn = host.createElement("button");
    summaryBtn.className = "timing-bar-btn";
    summaryBtn.textContent = "📋";
    summaryBtn.title = "Show planned vs. actual timings";
    summaryBtn.addEventListener("click", toggleSummary);
    controls.appendChild(summaryBtn);

    bar.appendChild(controls);
    host.body.appendChild(bar);

    /* ---------- summary modal ---------- */
    let modal = null;

    function toggleSummary() {
      if (modal) {
        modal.remove();
        modal = null;
        return;
      }
      recordDwell();
      modal = host.createElement("div");
      modal.className = "timing-bar-modal";
      const inner = host.createElement("div");
      inner.className = "timing-bar-modal-inner";
      let html =
        "<h3>Timing summary</h3>" +
        "<table><thead><tr><th></th><th>Planned</th><th>Actual</th><th>Diff</th></tr></thead><tbody>";
      const rows = [];
      sections.forEach(function (sec) {
        const secActual = sec.slides.reduce(function (acc, s) {
          return acc + s.actual;
        }, 0);
        html += rowHtml(sec.title, sec.planned, secActual, "timing-bar-row-section");
        rows.push({ name: sec.title, planned: fmt(sec.planned), actual: fmt(secActual) });
        sec.slides.forEach(function (s) {
          html += rowHtml(" " + s.title, s.planned, s.actual, "");
          rows.push({ name: "  " + s.title, planned: fmt(s.planned), actual: fmt(s.actual) });
        });
      });
      html += "</tbody></table><p class='timing-bar-modal-hint'>Click anywhere to close.</p>";
      inner.innerHTML = html;
      modal.appendChild(inner);
      modal.addEventListener("click", toggleSummary);
      host.body.appendChild(modal);
      console.table(rows);
    }

    function rowHtml(name, planned, actual, cls) {
      const diff = actual - planned;
      const diffCls = diff > 0 ? "timing-bar-over" : "timing-bar-under";
      return (
        "<tr class='" + cls + "'><td>" + escapeHtml(name) + "</td><td>" +
        fmt(planned) + "</td><td>" + fmt(actual) + "</td><td class='" + diffCls + "'>" +
        (actual === 0 ? "—" : (diff > 0 ? "+" : "") + fmt(diff)) + "</td></tr>"
      );
    }

    function escapeHtml(s) {
      return s.replace(/[&<>"]/g, function (c) {
        return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c];
      });
    }

    /* ---------- rendering loop ---------- */
    function render() {
      const e = elapsed();
      clock.textContent = fmt(e) + " / " + fmt(totalPlanned);

      // marker position along the whole bar
      const frac = Math.min(e / totalPlanned, 1);
      marker.style.left = (frac * 100).toFixed(3) + "%";

      // schedule status relative to the current slide's planned window
      const cur = slides[currentIndex] || slides[0];
      marker.classList.remove("timing-bar-ahead", "timing-bar-behind");
      if (startTime != null && cur) {
        if (e < cur.plannedStart) marker.classList.add("timing-bar-ahead");
        else if (e > cur.plannedStart + cur.planned) marker.classList.add("timing-bar-behind");
      }

      // segment fills and current-section highlight
      sections.forEach(function (sec) {
        const consumed = sec.planned > 0
          ? Math.max(0, Math.min(1, (e - sec.plannedStart) / sec.planned))
          : (e > sec.plannedStart ? 1 : 0);
        sec.fillEl.style.width = (consumed * 100).toFixed(2) + "%";
        sec.segEl.classList.toggle("timing-bar-current", cur && cur.section === sec);
      });
    }

    function recordDwell() {
      const now = Date.now();
      if (lastChange != null && slides[currentIndex]) {
        slides[currentIndex].actual += (now - lastChange) / 1000;
      }
      lastChange = now;
    }

    deck.on("slidechanged", function (event) {
      if (startTime == null) {
        startTime = Date.now();
        lastChange = startTime;
      } else {
        recordDwell();
      }
      currentIndex = flatIndex(deck.getIndices());
      persist();
      render();
    });

    setInterval(render, 1000);
    render();
  },
};
