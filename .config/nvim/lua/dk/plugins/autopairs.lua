return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
        disable_filetype = { "TelescopePrompt", "lisp", "lisp_vlime", "clojure", "fennel" },
        check_ts = true,
    },
    config = true,
}
