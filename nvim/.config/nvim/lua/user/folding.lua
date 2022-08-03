--- 
vim.opt.foldmethod="expr"
vim.opt.foldexpr="nvim_treesitter#foldexpr()"
vim.opt.foldtext="getline(v:foldstart).'...'.trim(getline(v:foldend))"
vim.opt.fillchars="fold:\\"
vim.opt.foldnestmax=3
vim.opt.foldminlines=1
vim.api.nvim_create_autocmd("BufReadPost,FileReadPost", {
    command = "normal zR",
    group = vim.api.nvim_create_augroup("OpenFolds", { clear = true })
})
