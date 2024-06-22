--[[

# Nvim Lint
Linting

https://github.com/mfussenegger/nvim-lint

--]]

return {
    {
        'mfussenegger/nvim-lint',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            local lint = require 'lint'
            lint.linters_by_ft = {
                python = { 'flake8' },
                rust = { 'rust_analyzer' },
                javascript = { 'eslint' },
                markdown = { 'vale' },
                text = { 'vale' },
            }

            table.insert(lint.linters.flake8.args, 1, '--config') -- Add path to global config file for flake8
            table.insert(lint.linters.flake8.args, 2, vim.fn.expand '~/.config/flake8')

            table.insert(lint.linters.vale.args, 1, '--config') -- Add path to global config file for flake8
            table.insert(lint.linters.vale.args, 2, vim.fn.expand '~/.config/vale/.vale.ini')

            -- Create autocommand which carries out the actual linting on the specified events.
            local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
            vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
                group = lint_augroup,
                callback = function()
                    require('lint').try_lint()
                end,
            })
        end,
    },
}
