local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  return
end
require'nvim-treesitter.configs'.setup {
  context_commentstring = {
    enable = true,
    config = {
      -- lua = { __default = '-- %s', __multiline = '--[[ %s ]]' },
    }
  }
}

comment.setup {
  pre_hook = function(ctx)
    local U = require "Comment.utils"

    -- Determine the location where to calculate commentstring from
    local location = nil
    if ctx.ctype == U.ctype.blockwise then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require("ts_context_commentstring.utils").get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring {
      -- Determine whether to use linewise or blockwise commentstring
      key = ctx.ctype == U.ctype.linewise and "__default" or "__multiline",
      location = location,
    }
  end,
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = 'cml',
        ---Block-comment toggle keymap
        block = 'cmb',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = 'cm',
        ---Block-comment keymap
        block = 'cb',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = 'cmO',
        ---Add comment on the line below
        below = 'cmo',
        ---Add comment at the end of line
        eol = 'cmA',
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
    },
    ---Function to call before (un)comment
    --[[ pre_hook = nil, ]]
    ---Function to call after (un)comment
    post_hook = nil,
}


-- local status_ok_2, ft = pcall(require, "Comment.ft")
-- if not status_ok_2 then
--   return
-- end

