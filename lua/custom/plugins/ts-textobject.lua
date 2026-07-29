return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	init = function()
		-- Disable entire built-in ftplugin mappings to avoid conflicts.
		-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
		vim.g.no_plugin_maps = true
	end,
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,
				-- You can choose the select mode (default is charwise 'v')
				--
				-- Can also be a function which gets passed a table with the keys
				-- * query_string: eg '@function.inner'
				-- * method: eg 'v' or 'o'
				-- and should return the mode ('v', 'V', or '<c-v>') or a table
				-- mapping query_strings to modes.
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
				-- If you set this to `true` (default is `false`) then any textobject is
				-- extended to include preceding or succeeding whitespace. Succeeding
				-- whitespace has priority in order to act similarly to eg the built-in
				-- `ap`.
				--
				-- Can also be a function which gets passed a table with the keys
				-- * query_string: eg '@function.inner'
				-- * selection_mode: eg 'v'
				-- and should return true of false
				include_surrounding_whitespace = false,
			},

			move = {
				set_jumps = true,
			},
		})

		local textobjects_select = require("nvim-treesitter-textobjects.select")
		local select_modes = { "x", "o" }

		vim.keymap.set(select_modes, "am", function()
			textobjects_select.select_textobject("@function.outer", "textobjects")
		end)
		vim.keymap.set(select_modes, "im", function()
			textobjects_select.select_textobject("@function.inner", "textobjects")
		end)
		vim.keymap.set(select_modes, "ac", function()
			textobjects_select.select_textobject("@class.outer", "textobjects")
		end)
		vim.keymap.set(select_modes, "ic", function()
			textobjects_select.select_textobject("@class.inner", "textobjects")
		end)
		-- You can also use captures from other query groups like `locals.scm`
		vim.keymap.set(select_modes, "as", function()
			textobjects_select.select_textobject("@local.scope", "locals")
		end)

		local textobjects_move = require("nvim-treesitter-textobjects.move")
		local move_modes = { "n", "x", "o" }
		vim.keymap.set(move_modes, "]m", function()
			textobjects_move.goto_next_start("@function.outer", "textobjects")
		end)
		vim.keymap.set(move_modes, "[m", function()
			textobjects_move.goto_previous_start("@function.outer", "textobjects")
		end)
		vim.keymap.set(move_modes, "]]", function()
			textobjects_move.goto_next_start("@class.outer", "textobjects")
		end)
		vim.keymap.set(move_modes, "[[", function()
			textobjects_move.goto_previous_start("@class.outer", "textobjects")
		end)
		-- You can also pass a list to group multiple queries.
		vim.keymap.set(move_modes, "]o", function()
			textobjects_move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
		end)
		-- You can also use captures from other query groups like `locals.scm` or `folds.scm`
		vim.keymap.set(move_modes, "]s", function()
			textobjects_move.goto_next_start("@local.scope", "locals")
		end)
		vim.keymap.set(move_modes, "]z", function()
			textobjects_move.goto_next_start("@fold", "folds")
		end)
	end,
}
