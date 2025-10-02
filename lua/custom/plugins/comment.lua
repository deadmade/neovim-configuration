return { 
    { 
        'numToStr/Comment.nvim', 
        name = "comment.nvim", 
        enabled = require('nixCatsUtils').enableForCategory("core-plugins"),
        opts = {} 
    },
    -- Highlight todo, notes, etc in comments
    { 
        'folke/todo-comments.nvim', 
        enabled = require('nixCatsUtils').enableForCategory("core-plugins"),
        event = 'VimEnter', 
        dependencies = { 'nvim-lua/plenary.nvim' }, 
        opts = { signs = false } 
    }
}
