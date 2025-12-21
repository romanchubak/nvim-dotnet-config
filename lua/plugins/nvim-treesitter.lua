return
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()

            require('nvim-treesitter')
                .install({
                    "lua",
                    "javascript",
                    "html",
                    "c_sharp",
                    "bicep"
                }):wait(300000) -- wait max. 5 minutes
        vim.api.nvim_create_autocmd('FileType', {
            pattern = {
                    "lua",
                    "javascript",
                    "html",
                    "c_sharp",
                    "bicep"
            },
            callback = function()
              -- syntax highlighting, provided by Neovim
              vim.treesitter.start()
              -- folds, provided by Neovim
              vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
              --vim.wo.foldmethod = 'expr'
              -- indentation, provided by nvim-treesitter
              vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
          })
        end
    }

