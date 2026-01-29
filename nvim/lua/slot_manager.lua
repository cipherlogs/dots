-- slot_manager.lua
local M = {}

-- defaults
M.opts = { scope = "repo", nslots = 5 }
local slots = {}
local inited = false

-- helpers (use M.opts where needed)
local function stdpath(p)
  return vim.fn.stdpath "data" .. "/" .. p
end

local function git_root()
  local out = vim.fn.systemlist "git rev-parse --show-toplevel 2>/dev/null"
  if vim.v.shell_error ~= 0 or #out == 0 then
    return nil
  end
  return out[1]
end

local function git_branch()
  local out = vim.fn.systemlist "git rev-parse --abbrev-ref HEAD 2>/dev/null"
  if vim.v.shell_error ~= 0 or #out == 0 then
    return nil
  end
  return out[1]
end

local function get_slotfile()
  local scope = M.opts.scope or "repo"
  if scope == "global" then
    return stdpath "nvim_slots.json"
  end

  local root = git_root()
  if not root then
    return stdpath "nvim_slots_global.json"
  end

  local id = vim.fn.sha256(root)
  if scope == "repo" then
    return stdpath(("nvim_slots_repo_%s.json"):format(id))
  end

  if scope == "branch" then
    local branch = git_branch() or "detached"
    branch = branch:gsub("/", "_")
    return stdpath(("nvim_slots_repo_%s_branch_%s.json"):format(id, branch))
  end

  return stdpath "nvim_slots.json"
end

local function load_slots()
  slots = {}
  local slotfile = get_slotfile()
  if vim.fn.filereadable(slotfile) == 1 then
    local content = table.concat(vim.fn.readfile(slotfile), "\n")
    if content ~= "" then
      local ok, decoded = pcall(vim.fn.json_decode, content)
      if ok and type(decoded) == "table" then
        for i = 1, M.opts.nslots do
          slots[i] = decoded[i]
        end
      end
    end
  else
    for i = 1, M.opts.nslots do
      slots[i] = nil
    end
  end
end

local function save_slots()
  local slotfile = get_slotfile()
  local enc = vim.fn.json_encode(slots)
  vim.fn.mkdir(vim.fn.fnamemodify(slotfile, ":h"), "p")
  vim.fn.writefile({ enc }, slotfile)
end

local function cur_file()
  local name = vim.api.nvim_buf_get_name(0)
  if name == nil or name == "" then
    return nil
  end
  return vim.fn.fnamemodify(name, ":p")
end

function M.set_slot(i)
  if i < 1 or i > M.opts.nslots then
    vim.notify("slot out of range: " .. tostring(i), vim.log.levels.ERROR)
    return
  end
  local f = cur_file()
  if not f then
    vim.notify("No file in current buffer to set.", vim.log.levels.WARN)
    return
  end
  slots[i] = f
  save_slots()
  vim.notify(("Slot %d ← %s (scope=%s)"):format(i, f, M.opts.scope))
end

function M.open_slot(i)
  if i < 1 or i > M.opts.nslots then
    vim.notify("slot out of range: " .. tostring(i), vim.log.levels.ERROR)
    return
  end
  local f = slots[i]
  if not f then
    vim.notify(
      ("Slot %d is empty (scope=%s)"):format(i, M.opts.scope),
      vim.log.levels.WARN
    )
    return
  end
  if vim.fn.filereadable(f) == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(f))
  else
    vim.notify(("File not found: %s"):format(f), vim.log.levels.WARN)
  end
end

function M.toggle_slot(i)
  print "hi"
  local f = cur_file()
  if f then
    M.set_slot(i)
  else
    M.open_slot(i)
  end
end

function M.show_slots()
  print(
    ("Slots (scope=%s) -- slot file: %s"):format(M.opts.scope, get_slotfile())
  )
  for i = 1, M.opts.nslots do
    local val = slots[i] or "<empty>"
    print(("%d: %s"):format(i, val))
  end
end

-- configure + initialize
function M.setup(opts)
  if inited then
    return
  end
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  load_slots()

  -- create keymaps (toggle behaviour)
  local map = vim.keymap.set
  map("n", "<BS>h", function()
    M.toggle_slot(1)
  end, { desc = "Toggle slot 1 (h)" })
  map("n", "<BS>j", function()
    M.toggle_slot(2)
  end, { desc = "Toggle slot 2 (j)" })
  map("n", "<BS>k", function()
    M.toggle_slot(3)
  end, { desc = "Toggle slot 3 (k)" })
  map("n", "<BS>l", function()
    M.toggle_slot(4)
  end, { desc = "Toggle slot 4 (l)" })
  map("n", "<BS>;", function()
    M.toggle_slot(5)
  end, { desc = "Toggle slot 5 (;)" })

  vim.api.nvim_create_user_command("ShowSlots", function()
    M.show_slots()
  end, {})
  inited = true
end

return M
