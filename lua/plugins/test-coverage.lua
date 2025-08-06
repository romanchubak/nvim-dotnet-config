return {
    "andythigpen/nvim-coverage",
    version = "*",
    config = function()
        require("coverage").setup({
            auto_reload = true,
            lang = {
                coverage_file = vim.fn.expand("~/AppData/Local/nvim-data/coverage/lcov.info")
            },
        })
        vim.keymap.set("n", "<leader>cl", function()
            local output_path = vim.fn.expand("~/AppData/Local/nvim-data/coverage/lcov.info")
            require("coverage").load_lcov(output_path)
            print("Coverage report loaded")
        end, { desc = "Load coverage report" })

        vim.keymap.set("n", "<leader>cs", function()
            require("coverage").summary()
        end, { desc = "Show coverage summary" })

        vim.keymap.set("n", "<leader>ct", function()
            require("coverage").toggle()
        end, { desc = "Toggle coverage on file" })

        -- coverlet .\toBase64.Tests\bin\Debug\net9.0\toBase64.Tests.dll --target "dotnet" --targetargs "test --no-build" --format lcov --output "./coverage/lcov.info"
        --

        vim.keymap.set("n", "<leader>tc", function()
            local constants = require("core.constants")
            local project = vim.fn.getreg(constants.ProjectRegister)
            local framework = vim.fn.getreg(constants.FrameworkRegister)
            local output_path = vim.fn.expand("~/AppData/Local/nvim-data/coverage/lcov.info")
            vim.fn.system({
                "coverlet",
                ".\\" .. project .. "\\bin\\Debug\\" .. framework .. "\\" .. project .. ".dll",
                "--target",
                "dotnet",
                "--targetargs",
                "test --no-build",
                "--format",
                "lcov",
                "--output",
                output_path,
            })
            print("Coverage generation finished")
        end, { desc = "Run Coverlet test coverage" })
    end,
}
