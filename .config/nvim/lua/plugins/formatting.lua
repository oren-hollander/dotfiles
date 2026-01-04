return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        css = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        scss = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        python = { "ruff_format_uv" },
      },
      format_on_save = { timeout_ms = 1000, lsp_fallback = true },
      formatters = {
        ruff_format_uv = {
          command = "uv",
          args = { "run", "ruff", "format", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        python = { "ruff_uv" },
      }

      local ruff = vim.deepcopy(lint.linters.ruff or {})
      ruff.cmd = "uv"
      ruff.args = {
        "run",
        "ruff",
        "check",
        "--force-exclude",
        "--stdin-filename",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
        "-",
      }
      ruff.stdin = true
      ruff.ignore_exitcode = true
      lint.linters.ruff_uv = ruff

      local group = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
        group = group,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
