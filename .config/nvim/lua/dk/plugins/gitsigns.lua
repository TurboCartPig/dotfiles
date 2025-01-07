return {
    "lewis6991/gitsigns.nvim",
    config = function()
        local gitsigns = require "gitsigns"

        gitsigns.setup {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            diff_opts = {
                internal = vim.fn.has "win32" ~= 1,
            },
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 100,
            },
            current_line_blame_formatter = function(name, blame_info, opts)
                if blame_info.author == name then
                    blame_info.author = "You"
                end

                local text
                if blame_info.author == "Not Committed Yet" then
                    text = blame_info.author
                else
                    local date_time

                    if opts.relative_time then
                        date_time = require("gitsigns.util").get_relative_time(tonumber(blame_info["author_time"]))
                    else
                        date_time = os.date("%Y-%m-%d", tonumber(blame_info["author_time"]))
                    end

                    text = string.format("%s • %s • %s", blame_info.author, date_time, blame_info.summary)
                end

                return { { " " .. text, "GitSignsCurrentLineBlame" } }
            end,
        }
    end,
}
