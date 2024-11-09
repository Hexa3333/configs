-- LSP configurations (Keymaps etc.)
local M = {}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

-- Private function
local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

-- !KEYMAPS!
local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- Go to definition
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- Go to Declaration
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts) -- List references

  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- Pop-up information

  vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- Pop-up error/warn message
  vim.api.nvim_buf_set_keymap(bufnr, "n", "g<leader>", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts) -- Pop-up error list (Entire File)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]] -- NO IDEA WHAT THIS DOES
end

------------------------------
-- SPESIFIC CODE FOR LANGUAGES SECTION
------------------------------

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight_document(client)

  -- lua_ls: Disable unused-local
  if client.name == "lua_ls" then
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
      if result.diagnostics then
        local filtered_diagnostics = {}
        for _, diagnostic in ipairs(result.diagnostics) do
          -- Check for diagnostic code related to "unused-code"
          if diagnostic.code ~= "unused-local" and diagnostic.code ~= "unused-function" and diagnostic.code ~= "undefined-global" then
            table.insert(filtered_diagnostics, diagnostic)
          end

        end
        result.diagnostics = filtered_diagnostics
      end
      vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, config)
    end
  end

end
--------------------------------------------------------------------------

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_ok then
  M.capabilities = cmp_nvim_lsp.default_capabilities()
end

-- return M
return M
