local _2afile_2a = "fnl/snap/common/tbl.fnl"
local _2amodule_name_2a = "snap.common.tbl"
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
local function max_length(tbl)
  local max = 0
  for _, line in ipairs(tbl) do
    local len = #line
    if (len > max) then
      max = len
    else
      max = max
    end
  end
  return max
end
_2amodule_2a["max-length"] = max_length
local function acc(tbl, vals)
  if (vals ~= nil) then
    for _, value in ipairs(vals) do
      if (tostring(value) ~= "") then
        table.insert(tbl, value)
      else
      end
    end
    return nil
  else
    return nil
  end
end
_2amodule_2a["acc"] = acc
local function merge(tbl1, tbl2)
  local result = {}
  for key, val in pairs(tbl1) do
    result[key] = val
  end
  for key, val in pairs(tbl2) do
    result[key] = val
  end
  return result
end
_2amodule_2a["merge"] = merge
local function concat(tbl_a, tbl_b)
  local tbl = {}
  for _, value in ipairs(tbl_a) do
    table.insert(tbl, value)
  end
  for _, value in ipairs(tbl_b) do
    table.insert(tbl, value)
  end
  return tbl
end
_2amodule_2a["concat"] = concat
local function take(tbl, num)
  local partial_tbl = {}
  for _, value in ipairs(tbl) do
    if (num == #partial_tbl) then break end
    table.insert(partial_tbl, value)
  end
  return partial_tbl
end
_2amodule_2a["take"] = take
local function sum(tbl)
  local count = 0
  for _, val in ipairs(tbl) do
    count = (count + val)
  end
  return count
end
_2amodule_2a["sum"] = sum
local function first(tbl)
  if tbl then
    return tbl[1]
  else
    return nil
  end
end
_2amodule_2a["first"] = first
local function allocate(total, divisor)
  local remainder = total
  local parts = {}
  local part = math.floor((total / divisor))
  for i = 1, divisor do
    if (i == divisor) then
      table.insert(parts, remainder)
    else
      table.insert(parts, part)
      remainder = (remainder - part)
    end
  end
  return parts
end
_2amodule_2a["allocate"] = allocate
local function partition(tbl, p, r, comp)
  local x = tbl[r]
  local i = (p - 1)
  for j = p, (r - 1), 1 do
    if comp(tbl[j], x) then
      i = (i + 1)
      local temp = tbl[i]
      tbl[i] = tbl[j]
      tbl[j] = temp
    else
    end
  end
  local temp = tbl[(i + 1)]
  tbl[(i + 1)] = tbl[r]
  tbl[r] = temp
  return (i + 1)
end
local function partial_quicksort(tbl, p, r, m, comp)
  if (p < r) then
    local q = partition(tbl, p, r, comp)
    partial_quicksort(tbl, p, (q - 1), m, comp)
    if (p < (m - 1)) then
      return partial_quicksort(tbl, (q + 1), r, m, comp)
    else
      return nil
    end
  else
    return nil
  end
end
_2amodule_2a["partial-quicksort"] = partial_quicksort
local function max_length0(tbl)
  local max = 0
  for _, val in ipairs(tbl) do
    local len = #tostring(val)
    if (len > max) then
      max = len
    else
      max = max
    end
  end
  return max
end
_2amodule_2a["max-length"] = max_length0
local function allocate_custom(total, configs)
  local allocated = {}
  local remaining = total
  local fill_indices = {}
  local fill_count = 0
  for i, config in ipairs(configs) do
    if (type(config) == "number") then
      allocated[i] = config
      remaining = (remaining - config)
    elseif (type(config) == "string") then
      if config:match("^%d+%%$") then
        local percent = tonumber(config:match("^(%d+)%%$"))
        local height = math.floor((total * percent * 0.01))
        do end (allocated)[i] = height
        remaining = (remaining - height)
      elseif (config == "fill") then
        table.insert(fill_indices, i)
        fill_count = (fill_count + 1)
        do end (allocated)[i] = 0
      else
        allocated[i] = 1
        remaining = (remaining - 1)
      end
    else
      allocated[i] = 1
      remaining = (remaining - 1)
    end
  end
  if (fill_count > 0) then
    local per_fill = math.floor((remaining / fill_count))
    for _, idx in ipairs(fill_indices) do
      allocated[idx] = per_fill
    end
    if ((remaining % fill_count) > 0) then
      allocated[fill_indices[1]] = (allocated[fill_indices[1]] + (remaining % fill_count))
    else
    end
  else
  end
  return allocated
end
_2amodule_2a["allocate-custom"] = allocate_custom
return _2amodule_2a