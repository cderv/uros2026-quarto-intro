You are reviewing the WORDING of a 15-minute conference talk, not its code or structure.

Files (read-only, do not edit anything):
- index.qmd: the slide deck (Quarto revealjs). Review every heading, slide line, fragment,
  figure caption, fig-alt text and every `::: notes` block.
- .claude/references/talk-voice.md: how the speaker writes and talks. Read section 0 (F1-F9),
  section 14 (machine tells) and section 10 (lines in his own hand) before you start.

Context: the speaker is a French software engineer giving the talk in English to official
statisticians, many of them non-native English speakers. Slides were drafted with an AI
assistant. The goal is slides and notes that read as if he wrote them himself: plain, spoken,
a little dry, short labels on slides. The notes are the spoken script he learns and says: check
them as speech, against section 18 of `.claude/references/talk-voice.md`.

Flag every line that sounds machine-written or not like a person speaking, for example:
- polished marketing rhythm, three-part lists or slogans, "X isn't just Y", "not X, but Y";
- dramatic hooks, inflated stakes, hype adjectives (seamless, powerful, effortless, robust...);
- abstract nouns where a concrete word would do ("workflow", "pipeline", "journey", "story");
- over-symmetrical parallel phrasing across slides, colon-titles everywhere;
- em-dashes, semicolons and other written-only punctuation in spoken text;
- notes that only work when read: colons, brackets or dashes, long sentences, words that mean
  something else to an R user, code or symbols read aloud, more words than the slide's seconds;
- idioms or rare words a non-native listener may miss;
- anything you would bet a language model wrote.

Also list the lines that already sound human, so they are kept as anchors.

Do not impose your own house style: a rewrite must be shorter or plainer than the original,
never more polished. If a line is fine, say nothing about it.

Report, in this order:
1. Verdict in 3 lines: how "AI-written" the deck sounds overall, and where it is worst.
2. A table: | slide id | index.qmd:line | current text | why it sounds machine-written | plainer rewrite |
   ordered by slide, each row tagged P0 (a listener would notice), P1 (noticeable on reading),
   P2 (polish).
3. Lines that already sound like a person talking (keep).
4. Patterns that repeat across the deck (phrasing tics), with counts.
