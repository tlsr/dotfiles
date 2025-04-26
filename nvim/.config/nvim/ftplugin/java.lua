local home = os.getenv('HOME')
local jdtls = require('jdtls')

-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
local root_markers = { 'gradlew', 'mvnw', '.git' }
local root_dir = require('jdtls.setup').find_root(root_markers)
-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local bundles = {
  vim.fn.glob(
  '/home/spiderj/Library/javaDebug/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.53.1.jar'),
}


vim.list_extend(bundles,
  vim.split(vim.fn.glob("/home/spiderj/Library/javaTestDebug/vscode-java-test/server/*.jar", 1), "\n"))

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


function nnoremap(rhs, lhs, desc)
  -- bufopts.desc = desc
  vim.keymap.set("n", rhs, lhs, bufopts)
end

-- The on_attach function is used to set key maps after the language server
-- attaches to the current buffer
local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
end

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
--
local config = {
  capabilities = capabilities,
  on_attach = on_attach,
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    'java',     -- or '/path/to/java17_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. home .. '/.local/share/eclipse/lombok.jar',
    -- 💀
    '-jar', '/home/spiderj/Library/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version


    -- 💀
    '-configuration', '/home/spiderj/Library/jdtls/config_linux',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.


    -- 💀
    -- See `data directory configuration` section in the README
    '-data', workspace_folder,
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  --
  -- vim.fs.root requires Neovim 0.10.
  -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
  root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "com.nixsolutions.javatgbot.google.bot.constants.GoogleConstants",
          "com.nixsolutions.javatgbot.util.GoogleCardsAssertions",
          "com.nixsolutions.javatgbot.util.Actions",
          "org.mockito.Mockito.*"
        }
      },
      format = {
        settings = {
          -- Use Google Java style guidelines for formatting
          -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
          -- and place it in the ~/.local/share/eclipse directory
          --url = "/home/spiderj/.local/share/eclipse/nix.xml",
          url = "/home/spiderj/.local/share/eclipse/NIX_latest.xml",
          -- profile = "GoogleStyle",
        },
      },
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
}

-- Needed for debugging
-- TODO after enabling this keymaps in on on_attach funvtion stop working
--config["on_attach"] = function(client, bufnr)
--    jdtls.setup_dap({ hotcodereplace = "auto" })
--    -- require("jdtls.dap").setup_dap_main_class_configs()
--end

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
