-- none-ls currently depends on a private Neovim LSP API removed in 0.12.
-- This configuration does not register any none-ls sources, so keep it disabled.

-- Customize None-ls sources

---@type LazySpec
return {
  { "nvimtools/none-ls.nvim", enabled = false },
  { "jay-babu/mason-null-ls.nvim", enabled = false },
}
