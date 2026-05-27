return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeOpen", "NvimTreeClose" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeFocus<cr>", desc = "Focus file tree" },
    },
    opts = function()
      return require("config.plugins.nvim_tree").opts()
    end,
    config = function(_, opts)
      require("config.plugins.nvim_tree").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({ previewer = false })
        end,
        desc = "Find files",
      },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    },
    config = function()
      require("config.plugins.telescope").setup()
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>a",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon add",
      },
      {
        "<leader>h",
        function()
          local h = require("harpoon")
          h.ui:toggle_quick_menu(h:list())
        end,
        desc = "Harpoon menu",
      },
      {
        "<leader>1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon 1",
      },
      {
        "<leader>2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon 2",
      },
    },
    opts = {},
  },

  { "folke/persistence.nvim", event = "BufReadPre", opts = {} },
}
