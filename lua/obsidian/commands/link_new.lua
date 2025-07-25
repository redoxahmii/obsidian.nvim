local log = require "obsidian.log"
local api = require "obsidian.api"

---@param client obsidian.Client
---@param data CommandArgs
return function(client, data)
  local viz = api.get_visual_selection()
  if not viz then
    log.err "ObsidianLink must be called with visual selection"
    return
  elseif #viz.lines ~= 1 then
    log.err "Only in-line visual selections allowed"
    return
  end

  local line = assert(viz.lines[1])

  local title
  if string.len(data.args) > 0 then
    title = data.args
  else
    title = viz.selection
  end

  local note = client:create_note { title = title }

  local new_line = string.sub(line, 1, viz.cscol - 1)
    .. client:format_link(note, { label = title })
    .. string.sub(line, viz.cecol + 1)

  vim.api.nvim_buf_set_lines(0, viz.csrow - 1, viz.csrow, false, { new_line })
end
