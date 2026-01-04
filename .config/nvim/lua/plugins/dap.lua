return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP step over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP step into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP step out" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "DAP conditional breakpoint" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP repl" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "DAP run last" })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      automatic_installation = true,
      ensure_installed = { "python", "js-debug-adapter" },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap", "williamboman/mason.nvim" },
    config = function()
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(mason_path)
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap = require("dap")
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })

      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome (React)",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
