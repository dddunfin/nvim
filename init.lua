local opt = vim.opt

-- 显示绝对行号
opt.number = true

-- 设置行号区域的最小宽度（让代码左侧留出一点呼吸空间）
opt.numberwidth = 4

-- 始终显示侧边栏列（防止在你保存或报错时屏幕左右抖动）
opt.signcolumn = "yes"

-- 显示相对行号
opt.relativenumber = true

-- Tab 占据的空格数
opt.tabstop = 2

-- 每一级自动缩进的空格数
opt.shiftwidth = 2

-- 将 Tab 键转换为空格
opt.expandtab = true

-- 开启真彩色支持
opt.termguicolors = true

-- 高亮显示当前光标所在的行
opt.cursorline = true

-- 滚动时光标下方保留的行数
opt.scrolloff = 8

-- 开启剪贴板共享
opt.clipboard = "unnamedplus"

-- 将空格键设为 Leader 键
vim.g.mapleader = " "

-- Shift + h 跳转到行首第一个非空字符
vim.keymap.set({'n', 'v'}, 'H', '^', { desc = '跳转到行首非空字符' })

-- Shift + l 跳转到行尾最后一个非空字符
vim.keymap.set({'n', 'v'}, 'L', 'g_', { desc = '跳转到行尾非空字符' })

-- Alt + hjkl 在窗口之间快速切换
-- (这样你就不用按 Ctrl+w 再按方向键了)
vim.keymap.set('n', '<A-h>', '<C-w>h', { desc = '向左切换窗口' })
vim.keymap.set('n', '<A-j>', '<C-w>j', { desc = '向下切换窗口' })
vim.keymap.set('n', '<A-k>', '<C-w>k', { desc = '向上切换窗口' })
vim.keymap.set('n', '<A-l>', '<C-w>l', { desc = '向右切换窗口' })

-- 设置插件存放的物理路径
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 如果找不到 lazy.nvim 则从 GitHub 克隆
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end

-- 将 lazy.nvim 加入搜索路径
vim.opt.rtp:prepend(lazypath)

-- 插件安装配置区
require("lazy").setup({
    -- 主题
    {
        "EdenEast/nightfox.nvim",
        priority = 1000, -- 主题插件需要高优先级，确保它在其他插件之前加载
        config = function()
            -- 在这里设置你喜欢的子主题，Nightfox 有多个变体：
            -- nightfox (暗蓝), nordfox (北欧风), dayfox (明亮), 
            -- terafox (暗绿), carbonfox (碳黑), duskfox (暮色)
            vim.cmd("colorscheme carbonfox") -- 推荐 carbonfox 或 duskfox，非常专业
        end,
    },
    
    -- 状态
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                options = {
                    -- 彻底禁用图标，消除乱码根源
                    icons_enabled = false,
                    -- 自动匹配你刚才设定的 tokyonight moon 配方
                    theme = 'auto',
                    -- 使用纯文本符号，看起来非常干练
                    component_separators = { left = '|', right = '|' },
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    -- A区：当前模式 (Normal/Insert等)
                    lualine_a = { 'mode' },
                    
                    -- B区：Git 分支名称
                    lualine_b = { 'branch' },
                    
                    -- C区：文件名（设置为显示相对路径，且带有修改状态标记）
                    lualine_c = {
                        {
                            'filename',
                            path = 0, -- 0: 只显示名字, 1: 相对路径, 2: 绝对路径
                            file_status = true, -- 如果文件被修改，会显示 [+]
                        }
                    },
                    
                    -- X区：搜索进度与诊断信息
                    lualine_x = {
                        -- 搜索结果计数 (例如 1/10)
                        'searchcount',
                        -- 代码诊断 (把图标换成纯文字 E/W/I/H)
                        {
                            'diagnostics',
                            -- 代码诊断符号：E=错误(Error), W=警告(Warn), I=信息(Info), H=提示(Hint)
                            symbols = { error = 'E: ', warn = 'W: ', info = 'I: ', hint = 'H: ' },
                        }
                    },
                    
                    -- Y区：文件阅读进度 (百分比)
                    lualine_y = { 'progress' },
                    
                    -- Z区：光标位置 (行:列)
                    lualine_z = { 'location' }
                }
            })
        end
    },
    
    -- Treesitter 语法高亮
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local status_ok, configs = pcall(require, "nvim-treesitter.configs")
            if not status_ok then
                return -- 如果还没准备好，先不执行下面的 setup
            end
    
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                -- 确保安装了你常用的语言高亮
                ensure_installed = { 
                    "lua", "vim", "vimdoc", "query", 
                    "javascript", "typescript", 
                    "html", "css",
                    "vue", "sass", "scss"
                },
                -- 启用同步安装
                sync_install = false,
                -- 自动安装新语言（当你打开一个新类型文件时）
                auto_install = true,
                -- 核心功能：高亮
                highlight = {
                    enable = true,
                    -- 建议设为 false 除非你觉得默认高亮太乱
                    additional_vim_regex_highlighting = false,
                },
                -- 自动缩进功能
                indent = { enable = true },
            })
        end
    },

    -- 模糊查找工具 (Telescope)
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local telescope = require('telescope')

            telescope.setup({
                defaults = {
                    -- 在这里添加忽略列表
                    file_ignore_patterns = {
                        "node_modules", -- 过滤整个文件夹
                        "%.git/",      -- 过滤 Windows 路径下的 .git
                        "dist",
                        "build",
                    },
                    -- 确保搜索结果看起来整洁
                    path_display = { "truncate" },
                    -- 核心修改：显式禁用图标显示
                    use_less = true,
                    set_env = { ["COLORTERM"] = "truecolor" },
                    -- 很多时候乱码来自 devicons，如果不装那个插件，有些 picker 会显示方块
                    path_display = { "truncate" },
                },
                pickers = {
                    find_files = {
                        -- 明确告诉 find_files 不要显示 devicons
                        disable_devicons = true,
                    },
                    live_grep = {
                        disable_devicons = true,
                    },
                    buffers = {
                        disable_devicons = true,
                    },
                }
            })

            local builtin = require('telescope.builtin')
            -- 设置快捷键
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '查找文件' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '全文搜索内容' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '查找已打开的缓冲区' })
        end
    },

    {
        "nvim-tree/nvim-tree.lua",
        -- 注意：如果你没装 Nerd Font，记得在 setup 里关掉图标
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, 
        config = function()
            -- === 第一步：把这段函数写在 config 内部的最开头 ===
            local function my_on_attach(bufnr)
                local api = require("nvim-tree.api")
                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- 1. 加载默认键位
                api.config.mappings.default_on_attach(bufnr)

                -- 2. 绑定快捷键（解决你说的 Ctrl+v 报错问题）
                vim.keymap.set('n', '<C-v>', api.node.open.vertical,   opts('垂直分屏打开'))
                vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('水平分屏打开'))

                -- 3. 额外绑定 v 和 s，这样不按 Ctrl 也能分屏
                vim.keymap.set('n', 'v', api.node.open.vertical,   opts('垂直分屏打开'))
                vim.keymap.set('n', 's', api.node.open.horizontal, opts('水平分屏打开'))
            end

            require("nvim-tree").setup({
                on_attach = my_on_attach,
                -- 新增 view 配置来调整宽度
                view = {
                    -- 修改这里：根据屏幕总宽度动态计算
                    width = function()
                        local screen_w = vim.opt.columns:get()
                        -- 设置最小 30 列，最大占总宽度的 25%
                        return math.max(30, math.floor(screen_w * 0.25))
                    end,
                    side = "left", -- 默认在左侧
                },
                filters = {
                    -- 1. 设为 false，目录树就不会隐藏 .git 等点文件夹了
                    dotfiles = false, 
                    -- 2. 设为 false，即使 .gitignore 里写了 node_modules，目录树也会显示它
                    git_ignored = false,
                    -- 3. 自定义过滤：确保这里没有写 "node_modules"
                    custom = {},
                },
                -- 针对你之前的“乱码”问题，这里选择不显示图标
                renderer = {
                    highlight_git = true,
                    icons = {
                        show = { file = false, folder = false, git = false },
                        -- 核心修改：明确指定文件夹折叠/展开的纯文本符号，防止出现方块
                        glyphs = {
                            folder = {
                                arrow_closed = "+", -- 文件夹折叠时显示 +
                                arrow_open = "-",   -- 文件夹打开时显示 -
                                default = "",
                                open = "",
                                empty = "",
                                empty_open = "",
                                symlink = "",
                                symlink_open = "",
                            },
                        },
                    }
                },
                -- 自动同步工作目录
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                update_focused_file = { enable = true, update_root = true },
            })
            -- 快捷键：空格 + e 开关目录树
            vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
        end
    },

    -- 括号和引号自动补全
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter", -- 只有进入插入模式时才加载，节省启动时间
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true, -- 如果你装了 Treesitter，它会更智能（比如不在字符串里补全）
                disable_filetype = { "TelescopePrompt" }, -- 在搜索框里禁用，避免干扰
            })
            
            -- 如果你想让它和你的 nvim-cmp 补全引擎配合
            -- 比如：选中一个函数补全后，自动加上一对括号
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            -- 1. 初始化 Mason
            require("mason").setup({
                ui = { icons = { package_installed = "v", package_pending = "->", package_uninstalled = "x" } }
            })

            -- 2. 修正后的服务器列表
            -- 注意：如果 volar 报错，尝试改成 vue-language-server 或暂时移除测试
            local servers = { "ts_ls", "html", "cssls", "emmet_ls", "lua_ls" }

            require("mason-lspconfig").setup({
                ensure_installed = servers,
            })

            -- 3. 【新架构核心】绕过旧插件，直接使用内建配置
            -- 这里的逻辑是：如果 LSP 已经由 Mason 安装，直接启用它
            for _, server_name in ipairs(servers) do
                -- Neovim 0.11+ 的内建启用方式，完全不会触发弃用警告
                vim.lsp.enable(server_name)
            end

            -- 在 nvim-lspconfig 的 config 函数内添加：
            
            -- [[ LSP 快捷键：代码跳转 ]]
            -- gd: 跳转到定义 (Go Definition)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '跳转到定义' })
            
            -- gr: 查找引用 (Go References) - 会在下方显示哪些地方用了这个函数
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = '查找引用' })
            
            -- K: 显示悬浮文档 (查看函数参数和说明)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = '显示文档说明' })
            
            -- <leader>rn: 重命名 (Rename) 变量或函数名
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '重命名' })

            -- [[ 跳转进出功能 ]]
            -- 进：使用上面定义的 'gd'
            -- 出：使用 Ctrl + o (回到上一个光标位置，即使跨文件也生效)
            -- 进：使用 Ctrl + i (前进到下一个位置)
            -- 这个是 Vim 默认自带的，但非常有必要记住。

            -- 4. 纯文字报错样式设置
            vim.diagnostic.config({
                virtual_text = { prefix = '>>' },
                signs = true,
                underline = true,
                update_in_insert = false,
            })

            -- 设置纯字母标识
            local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end
        end
    },

    -- [[ 自动补全引擎 ]]
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- 核心：提供来自 LSP 的代码补全和自动导入
            "hrsh7th/cmp-buffer",   -- 辅助：当前文件内容补全
            "hrsh7th/cmp-path",     -- 辅助：路径补全
            "L3MON4D3/LuaSnip",     -- 必选：代码片段引擎
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args) require('luasnip').lsp_expand(args.body) end,
                },
                -- 快捷键设置
                mapping = cmp.mapping.preset.insert({
                    ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Tab 键选中补全并自动导入
                    ['<C-Space>'] = cmp.mapping.complete(),             -- Ctrl+Space 强制弹出补全
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),            -- 向上翻阅文档
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),             -- 向下翻阅文档
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' }, -- 优先级 1: LSP (包含自动导入)
                    { name = 'path' },     -- 优先级 2: 路径
                    { name = 'buffer' },   -- 优先级 3: 单词
                }),
                -- 纯文字风格，不显示乱码图标
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.kind = string.format("[%s]", vim_item.kind)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            buffer = "[Buf]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end
                }
            })
        end
    },
})