-- timing-bar.lua
-- Normalizes timing metadata into hidden data spans that the JS plugin reads
-- from the rendered slides, and emits a JSON config block with global options.

if not quarto.doc.is_format("revealjs") then
  return {}
end

local config = {}

local function data_span(attrs)
  local parts = { '<span class="timing-bar-data" style="display:none"' }
  for key, value in pairs(attrs) do
    if value ~= nil then
      table.insert(parts, string.format(' data-%s="%s"', key, tostring(value)))
    end
  end
  table.insert(parts, "></span>")
  return pandoc.RawBlock("html", table.concat(parts))
end

local function Meta(meta)
  local tb = meta["timing-bar"]
  if tb ~= nil then
    if type(tb) == "table" and (tb.duration ~= nil or tb.position ~= nil) then
      if tb.duration ~= nil then
        config.duration = pandoc.utils.stringify(tb.duration)
      end
      if tb.position ~= nil then
        config.position = pandoc.utils.stringify(tb.position)
      end
    else
      config.duration = pandoc.utils.stringify(tb)
    end
  end
  return meta
end

local function Header(el)
  local duration = el.attributes["timing-duration"]
  local title = el.attributes["timing-title"]
  local is_section = el.classes:includes("timing-section")
  if duration == nil and title == nil and not is_section then
    return nil
  end
  el.attributes["timing-duration"] = nil
  el.attributes["timing-title"] = nil
  local span = data_span({
    duration = duration,
    title = title,
    section = is_section and "true" or nil,
  })
  return { el, span }
end

local function Div(el)
  if not el.classes:includes("timing") then
    return nil
  end
  return data_span({
    duration = el.attributes["duration"],
    title = el.attributes["title"],
    section = el.attributes["section"],
  })
end

local function Pandoc(doc)
  local json = quarto.json.encode(config)
  local script = string.format(
    '<script type="application/json" id="timing-bar-config">%s</script>',
    json
  )
  table.insert(doc.blocks, pandoc.RawBlock("html", script))
  return doc
end

return {
  { Meta = Meta },
  { Header = Header, Div = Div },
  { Pandoc = Pandoc },
}
