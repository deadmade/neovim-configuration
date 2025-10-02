return {
    'rhysd/conflict-marker.vim',
    enabled = require('nixCatsUtils').enableForCategory("core-plugins"),
    event = 'BufRead', -- Load only when opening a file
    cond = function()
        return vim.fn.isdirectory(vim.fn.getcwd() .. '/.git') == 1
      end,

} -- Highlight conflict markers in git files