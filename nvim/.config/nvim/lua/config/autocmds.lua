-- Custom autocommands (LazyVim provides good defaults).

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Keep a real editor window alive next to side panels.
--
-- The cockpit often runs three columns: Neo-tree (left), your file (center) and
-- a Claude Code terminal split (right). Closing the *center* with `:q` used to
-- strand the layout as just `[neo-tree | claude]` — the panels then balloon to
-- fill the freed space and the next file you open lands in a useless sliver.
--
-- Fix: when (and only when) closing a window leaves side panels but NO normal
-- editor window, recreate one centered editor. This preserves plain `:q` and the
-- side-by-side cockpit; it does nothing on a normal `:q` that still leaves a file
-- window open, so it never spawns stray `[No Name]` buffers.
local panel_fts = {
  ["neo-tree"] = true,
  ["snacks_terminal"] = true,
  ["trouble"] = true,
  ["aerial"] = true,
  ["Outline"] = true,
}

local function is_panel(win)
  local buf = vim.api.nvim_win_get_buf(win)
  return panel_fts[vim.bo[buf].filetype] == true or vim.bo[buf].buftype == "terminal"
end

local function is_floating(win)
  return vim.api.nvim_win_get_config(win).relative ~= ""
end

vim.api.nvim_create_autocmd("WinClosed", {
  group = vim.api.nvim_create_augroup("keep_editor_window", { clear = true }),
  callback = function()
    if vim.v.exiting ~= vim.NIL then
      return -- don't fight Neovim while it's quitting
    end
    vim.schedule(function()
      if vim.v.exiting ~= vim.NIL then
        return
      end
      local panels, editors = {}, 0
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(win) and not is_floating(win) then
          if is_panel(win) then
            table.insert(panels, win)
          else
            editors = editors + 1
          end
        end
      end

      -- Only act on the degenerate state: panels open, zero editor windows.
      if editors > 0 or #panels == 0 then
        return
      end

      -- Reuse the previously-viewed file if we still can, else an empty buffer.
      local alt = vim.fn.bufnr("#")
      local reusable = alt > 0
        and vim.api.nvim_buf_is_valid(alt)
        and vim.bo[alt].buflisted
        and vim.bo[alt].buftype == ""
      local buf = reusable and alt or vim.api.nvim_create_buf(true, false)

      -- Anchor the new editor in the center: right of Neo-tree if present, else
      -- left of the first panel. Then equalize so it claims the freed width.
      local left_anchor
      for _, win in ipairs(panels) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree" then
          left_anchor = win
          break
        end
      end
      if left_anchor then
        vim.api.nvim_open_win(buf, true, { split = "right", win = left_anchor })
      else
        vim.api.nvim_open_win(buf, true, { split = "left", win = panels[1] })
      end
      vim.cmd("wincmd =")
    end)
  end,
})
