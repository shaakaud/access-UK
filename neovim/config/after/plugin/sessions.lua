require("sessions").setup({
    events = { "BufEnter" },
    session_filepath = vim.fn.stdpath("data") .. "/sessions",
    absolute = true,
})
