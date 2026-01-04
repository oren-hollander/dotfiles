local group = vim.api.nvim_create_augroup("UserAutoCmds", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "python",
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

local reload_group = vim.api.nvim_create_augroup("UserConfigReload", { clear = true })
local config_dir = vim.fn.stdpath("config")

vim.api.nvim_create_autocmd("BufWritePost", {
  group = reload_group,
  pattern = "*.lua",
  callback = function(args)
    local file = args.file
    if file == config_dir .. "/init.lua" then
      vim.cmd("source " .. vim.fn.fnameescape(file))
      vim.notify("Reloaded " .. vim.fn.fnamemodify(file, ":~"))
      return
    end

    if file:find(config_dir .. "/lua/config/", 1, true) then
      dofile(file)
      vim.notify("Reloaded " .. vim.fn.fnamemodify(file, ":~"))
      return
    end

    if file:find(config_dir .. "/lua/plugins/", 1, true) then
      local ok = pcall(vim.cmd, "Lazy sync")
      if ok then
        vim.notify("Synced plugins")
      else
        vim.notify("Saved plugin file; run :Lazy sync to apply changes")
      end
    end
  end,
})
