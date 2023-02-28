-- vim:fdm=marker
--
-- Gabriel's Nyanvim configs UwU
--
-- <3

o = vim.o
g = vim.g

-- plugins {{{
require "paq" {
    "savq/paq-nvim",

    "Mofiqul/dracula.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "tpope/vim-fugitive",
    "preservim/vim-markdown",
    "echasnovski/mini.nvim",
    "gboncoffee/lf.lua",
    "gboncoffee/run.lua",
    "gboncoffee/nvim-rsi",
    "gboncoffee/licenses.lua",
} -- }}}

-- appearance/visual helpers {{{
o.wrap        = false
o.signcolumn  = "no"
o.nu          = true
o.rnu         = true
o.scrolloff   = 10
o.laststatus  = 3
o.guicursor   = "n-v-c-sm:block,i-ve:ver25"
o.hlsearch    = false
o.colorcolumn = "+1"

require "dracula".setup {
    show_end_of_buffer = true,
    transparent_bg     = true,
    italic_comment     = true,
    overrides = {
        StatusLine   = { bg = "#21222c" },
        StatusLineNC = { bg = "#21222c", fg = "#6272a4" },
        VertSplit    = { fg = "#abb2bf" },
        LineNrAbove  = { fg = "#6272a4" },
        LineNrBelow  = { link = "LineNrAbove" },
        LineNr       = { fg = "#bd93f9", bold = true },
        ColorColumn  = { link = "StatusLine" },
    }
}
vim.cmd "colorscheme dracula"
-- }}}

-- editor settings {{{
o.tw            = 80
o.ignorecase    = true
o.tabstop       = 4
o.shiftwidth    = 4
o.expandtab     = true
o.title         = true
o.titlestring   = "%t"
o.conceallevel  = 2
o.foldmethod    = "syntax"

g.Licenses_name = "Gabriel G. de Brito"
g.Licenses_mail = "gabrielgbrito@icloud.com"
-- }}}

-- telescope setup {{{
ta = require "telescope.actions"
require "telescope".setup {
    defaults = {
        mappings = { i = {
                ["<C-k>"] = ta.move_selection_previous,
                ["<C-j>"] = ta.move_selection_next, 
                ["<Esc>"] = ta.close,
                ["<C-d>"] = ta.close, },
        },
    },
    pickers = {
        find_files = { find_command = { "rg", "--glob", "!*.git*", "--hidden", "--files" } },
    },
} --- }}}

-- mini.nvim {{{
require "mini.align".setup()
require "mini.comment".setup()
require "mini.surround".setup()
require "mini.pairs".setup()
require "mini.completion".setup()
require "mini.move".setup()
require "mini.tabline".setup()
-- }}}

-- mappings {{{
map = vim.keymap.set

-- run.lua
map("n", "<Space>b", ":wall | Compile<CR>")
map("n", "<Space>a", ":wall | CompileAuto<CR>")
map("n", "<Space>r", ":wall | CompileReset<CR>")
map("n", "<Space>t",        ":CompileFocus<CR>")

map("n", "<Space><CR>", ":Run<CR>")
map("n", "<Space>cp",   ":Run python<CR>")
map("n", "<Space>cl",   ":Run lua<CR>")
map("n", "<Space>cc",   ":Run julia<CR>")
map("n", "<Space>cj",   ":Run deno<CR>")
map("n", "<Space>ch",   ":Run ghci<CR>")
map("n", "<Space>cs",   ":Run pulsemixer<CR>")
map("n", "<Space>cm",   ":Run ncmpcpp<CR>")
map("n", "<Space>ct",   ":Run htop<CR>")
-- telescope
t = require "telescope.builtin"
map("n", "<Space>f", t.find_files)
map("n", "<Space>m", function()
    t.man_pages({sections = {"ALL"}})
end)
map("n", "<Space>h", t.help_tags)
map("n", "<Space>/", function()
    if not g.Grep_search then
        g.Grep_search = ""
    end
    g.Grep_search = vim.fn.input("grep: ", g.Grep_search)
    t.grep_string({
        glob_pattern = "!*.git*",
        additional_args = { "--hidden" },
        search = g.Grep_search,
    })
end)
-- others
map("n", "<Space>g", ":G<CR>")
map("n", "<Space>n", ":LfNoChangeCwd<CR>")
map("n", "<Tab>", ":bn<CR>")
map("n", "<S-Tab>", ":bp<CR>")
-- keep things in the middle
map("n", "<C-d>",    "<C-d>zz")
map("n", "<C-u>",    "<C-u>zz")
map("n", "n",        "nzzzv")
map("n", "N",        "Nzzzv")
-- }}}

-- autocmds {{{
filetype_settings = vim.api.nvim_create_augroup("FiletypeSettings", {})
vim.api.nvim_create_autocmd("FileType", {
    group    = filetype_settings,
    pattern  = { "python", "shell", "sh" },
    command  = "set formatoptions-=t"
})
vim.api.nvim_create_autocmd("FileType", {
    group    = filetype_settings,
    pattern  = { "qf", "fugitive", "git", "gitcommit", "help" },
    command  = "setlocal nofoldenable | nnoremap <buffer> q :bd<CR>"
})
vim.api.nvim_create_autocmd("Filetype", {
    group    = filetype_settings,
    pattern  = "rust",
    command  = "inoremap <buffer> ' '"
})
vim.api.nvim_create_autocmd("Filetype", {
    group    = filetype_settings,
    pattern  = "markdown",
    command  = "setlocal nofoldenable"
})
vim.api.nvim_create_autocmd("FileType", {
    group    = filetype_settings,
    pattern  = "man",
    command  = "setlocal nobuflisted"
})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group    = filetype_settings,
    pattern  = "*",
    callback = function()
        local buftype  = vim.api.nvim_buf_get_option(0, "buftype")
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        if (buftype == "") and (filetype ~= "gitcommit") then
            vim.cmd "setlocal nu rnu"
        else
            vim.cmd "setlocal nonu nornu"
        end
    end
})
-- }}}
