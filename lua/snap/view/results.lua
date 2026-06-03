local _2afile_2a = "fnl/snap/view/results.fnl"
local _2amodule_name_2a = "snap.view.results"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local buffer, register, size, window = require("snap.common.buffer"), require("snap.common.register"), require("snap.view.size"), require("snap.common.window")
do end (_2amodule_locals_2a)["buffer"] = buffer
_2amodule_locals_2a["register"] = register
_2amodule_locals_2a["size"] = size
_2amodule_locals_2a["window"] = window
local group = vim.api.nvim_create_augroup("SnapResults", {clear = true})
local function layout(config)
  local _let_1_ = config.layout()
  local width = _let_1_["width"]
  local height = _let_1_["height"]
  local row = _let_1_["row"]
  local col = _let_1_["col"]
  local has_views = config["has-views"]()
  local stacked_3f = (has_views and (width < size["narrow-threshold"]))
  local available_height = (height - size.border - size.border - size.padding)
  local results_height
  if stacked_3f then
    results_height = math.floor((available_height * (1 - size["view-width"])))
  else
    results_height = available_height
  end
  local _3_
  if (has_views and not stacked_3f) then
    _3_ = (math.floor((width * size["view-width"])) - size.padding - size.padding)
  else
    _3_ = width
  end
  local _5_
  if config.reverse then
    _5_ = (row + size.border + size.padding + size.padding)
  else
    _5_ = row
  end
  return {width = _3_, height = results_height, title = "Results", row = _5_, col = col, focusable = false}
end
local function create(config)
  local bufnr = buffer.create()
  local layout_config = layout(config)
  local winnr = window.create(bufnr, layout_config)
  vim.api.nvim_set_option_value("buftype", "prompt", {buf = bufnr})
  vim.api.nvim_set_option_value("textwidth", 0, {buf = bufnr})
  vim.api.nvim_set_option_value("wrapmargin", 0, {buf = bufnr})
  vim.api.nvim_set_option_value("wrap", false, {win = winnr})
  vim.api.nvim_set_option_value("cursorline", true, {win = winnr})
  vim.api.nvim_set_option_value("winhl", "CursorLine:SnapSelect,Normal:SnapNormal,FloatBorder:SnapBorder", {win = winnr})
  local function delete()
    if vim.api.nvim_win_is_valid(winnr) then
      window.close(winnr)
    else
    end
    if vim.api.nvim_buf_is_valid(bufnr) then
      return buffer.delete(bufnr)
    else
      return nil
    end
  end
  local function update(view)
    if vim.api.nvim_win_is_valid(winnr) then
      local layout_config0 = layout(config)
      window.update(winnr, layout_config0)
      vim.api.nvim_set_option_value("cursorline", true, {win = winnr})
      do end (view)["height"] = layout_config0.height
      view["width"] = layout_config0.width
      return nil
    else
      return nil
    end
  end
  local view = {update = update, delete = delete, bufnr = bufnr, winnr = winnr, width = layout_config.width, height = layout_config.height}
  local function _10_()
    return view:update()
  end
  vim.api.nvim_create_autocmd("VimResized", {group = group, callback = _10_})
  return view
end
_2amodule_2a["create"] = create
return _2amodule_2a