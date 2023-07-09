return {
  "jose-elias-alvarez/null-ls.nvim",
  commit = "a138b14099e9623832027ea12b4631ddd2a49256",
  event = "VeryLazy",
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    -- function to check if executable is present
    local function is_executable_present(executable)
      local handle = io.popen('command -v ' .. executable)
      if handle then
        local result = handle:read("*a")
        handle:close()
        return result ~= "" and result ~= nil
      else
        return false
      end
    end

    -- map of built-ins to their executables
    local builtins_to_executables = {
      [diagnostics.flake8] = "flake8",
      [diagnostics.mypy] = "mypy",
      [formatting.black] = "black",
      [formatting.isort] = "isort",
      [formatting.prettierd] = "prettierd",
      [formatting.ruff] = "ruff",
      [diagnostics.ruff] = "ruff",
    }

    -- construct sources list with available executables
    local sources = {
      formatting.stylua
    }
    for builtin, executable in pairs(builtins_to_executables) do
      if is_executable_present(executable) then
        table.insert(sources, builtin)
      end
    end

    null_ls.setup({
      -- Set this to true to start logging
      -- Also use ":checkhealth null-ls" for more troubleshooting
      debug = false,
      log_level = "warn",
      -- See available sources: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
      sources = sources,
    })
  end,
}
