local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup {
    ensure_installed = {"c", "cpp", "javascript", "typescript", "lua", "bash", "html", "css", "scss", "json", "tsx", "markdown", "yaml"},
    sync_install = false,
    ignore_install = {"unmaintained"},
    highlight = {
        enable = true,
        disable = { "" },
        additional_vim_regex_highlighting = true,
    },
    indent = {enable = true, disable = { "yaml" }},
}
