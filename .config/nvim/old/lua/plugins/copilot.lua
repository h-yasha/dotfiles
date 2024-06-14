return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	build = ":Copilot auth",
	event = { "InsertEnter" },
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			debounce = 75,
			keymap = {
				accept = "<Tab>",
				accept_word = false,
				accept_line = false,
				next = "<A-]>",
				prev = "<A-[>",
				dismiss = "<esc>",
			},
		},
		filetypes = {
			help = false,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			svn = false,
			cvs = false,
		},
		copilot_node_command = "node",
		server_opts_overrides = {},
	},
}
