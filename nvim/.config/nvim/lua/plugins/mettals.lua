local map = vim.keymap.set
local fn = vim.fn


return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "j-hui/fidget.nvim",
        opts = {},
      },
      {
        "mfussenegger/nvim-dap",
        config = function(self, opts)
          -- Debug settings if you're using nvim-dap
          local dap = require("dap")
          dap.configurations.java = {
            {
              type = "java",
              request = "launch",
              name = "Launch Java Program",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
          }

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Run with tmf args",
              metals = {
                runType = "run",
                args = { "-forceDisconnectedCache", "-u", "sysadmin1", "-p", "sysadmin", "-f", "tmf", "-t", "stark" },
              }
            },
            {
              type = "scala",
              request = "launch",
              name = "Run TMFInstall",
              metals = {
                runType = "run",
                args = {
                  "--rebuildDb",
                  "--outputDir","/home/spiderj/dev/tmf_2/cloudtmf/temp/tmf_install_logs",
                  "--outputJsonFileName","tmfBuild.json",
                  "--logFileName","tmfInstall.log",
                  "--consoleFilesDir", "/home/spiderj/dev/tmf_2/cloudtmf/wspt_tmf/src/test/resources/com/wingspan/platform/test/files",
                  "--loaderFilesDir", "/home/spiderj/dev/tmf_2/cloudtmf/wspt_tmf_install/install/loader",
                  "--appScriptDir", "/home/spiderj/dev/tmf_2/cloudtmf/wspt_tmf_install/install/pgsql",
                  "--reportingScriptDir", "/home/spiderj/dev/tmf_2/cloudtmf/wspt_tmf_install/install/reporting/pgsql",
                  "--platformScriptDir", "/home/spiderj/dev/tmf_2/platform/wspt_platform/target/scala-2.13/install-classes",
                },
              }
            },
            {
              type = "scala",
              request = "launch",
              name = "Run with platform args",
              metals = {
                runType = "run",
                args = { "-forceDisconnectedCache", "-u", "sysadmin1", "-p", "sysadmin", "-f", "wspt_test", "-t", "wingspan" },
              }
            },
            {
              type= "scala",
              name= "Debug Tomcat",
              preLaunchTask= "sbt: jvm-debug", 
              request= "attach",
              buildTarget= "cloudtmf",
              hostName= "localhost",
              port= 5015
            },
          }
        end
      },
    },
    ft = { "scala", "sbt", "java" },
    --    ft = { "scala", "sbt"},
    opts = function()
      local metals_config = require("metals").bare_config()

      -- Example of settings
      metals_config.settings = {
        showImplicitArguments = true,
        --disableColorOutput = true,
        testUserInterface = "Test Explorer",
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }
      -- testing root dir
      metals_config.root_patterns = { "build.sbt", "build.sc", "build.gradle", "pom.xml", ".scala-build", "bleep.yaml", ".git", "marker.tmf" } 
      -- end testing root dir

      -- *READ THIS*
      -- I *highly* recommend setting statusBarProvider to either "off" or "on"
      --
      -- "off" will enable LSP progress notifications by Metals and you'll need
      -- to ensure you have a plugin like fidget.nvim installed to handle them.
      --
      -- "on" will enable the custom Metals status extension and you *have* to have
      -- a have settings to capture this in your statusline or else you'll not see
      -- any messages from metals. There is more info in the help docs about this
      metals_config.init_options.statusBarProvider = "off"

      -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()

        -- all workspace errors
        map("n", "<leader>ae", function()
          vim.diagnostic.setqflist({ severity = "E" })
        end)

        -- all workspace warnings
        map("n", "<leader>aw", function()
          vim.diagnostic.setqflist({ severity = "W" })
        end)

        -- buffer diagnostics only
        map("n", "<leader>d", vim.diagnostic.setloclist)

        map("n", "[c", function()
          vim.diagnostic.goto_prev({ wrap = false })
        end)

        map("n", "]c", function()
          vim.diagnostic.goto_next({ wrap = false })
        end)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
      -- temp fix for quickPick not showing classes
--      local handlers = require("metals.handlers")
--      local original_quickPick = handlers["metals/quickPick"]
--
--      handlers["metals/quickPick"] = function(_, result)
--        -- your code before
--        local ids = {}
--        local labs = {}
--        for i, item in pairs(result.items) do
--          table.insert(ids, item.id)
--          table.insert(labs, i .. " - " .. item.label)
--        end
--
--        local function show_labels_in_floating_window(labels)
--          -- Create a new scratch buffer
--          local buf = vim.api.nvim_create_buf(false, true) -- no listed, scratch buffer
--
--          -- Set buffer lines to labels content
--          vim.api.nvim_buf_set_lines(buf, 0, -1, false, labels)
--
--          -- Calculate window size
--          local width = 400
--          local height = #labels
--
--          -- Calculate center position
--          local ui = vim.api.nvim_list_uis()[1]
--          local row = math.floor((ui.height - height) / 2)
--          local col = math.floor((ui.width - width) / 2)
--
--          -- Window options
--          local opts = {
--            style = "minimal",
--            relative = "editor",
--            width = width,
--            height = height,
--            row = row,
--            col = col,
--            border = "rounded",
--          }
--
--          -- Create floating window
--          local win = vim.api.nvim_open_win(buf, true, opts)
--
--          -- Optional: set some buffer/window options
--          vim.api.nvim_buf_set_option(buf, "modifiable", false)
--          vim.api.nvim_win_set_option(win, "cursorline", true)
--          return win
--        end
--        local win = show_labels_in_floating_window(labs)
--        local res = original_quickPick(_, result)
--        vim.api.nvim_win_close(win, true)
--        return res
--      end
      -- end of temp fix

      -- experiments with root dir
      local Path = require("plenary.path")

      --- Checks to see if the default or passed in patterns for a root file are
      --- found or not for the given target level.
      local has_pattern = function(patterns, target)
        for _, pattern in ipairs(patterns) do
          local what_we_are_looking_for = Path:new(target, pattern)
          if what_we_are_looking_for:exists() then
            return pattern
          end
        end
      end


      local find_root_dir = function(patterns, startpath, maxParentSearch)
        print("find_root_dir")
        local path = Path:new(startpath)
        -- First parent index in which we found a target file
        local firstFoundIdx = nil
        local ret = nil
        local found = nil

       -- for i, parent in ipairs(path:parents()) do
       --   -- Exit loop before checking anything if we've exceeded the search limits
       --   if (firstFoundIdx and (i - firstFoundIdx > maxParentSearch)) or parent == "/" then
       --     print(ret)
       --     return ret
       --   end

       --   local pattern = has_pattern(patterns, parent)

       --   -- We add an extra guard here that if there is a pattern and we've already found one
       --   -- we make sure it's the same as the found one. For example we don't want to detect a
       --   -- .scala-build nested and then look one deeper and see a .git and incorrectly mark .git
       --   -- as the root.
       --   if (pattern and not found) or (pattern and found == pattern) then
       --     -- Mark the first parent that was found, so we can exit the loop when we've exhausted our search limits
       --     if not firstFoundIdx then
       --       found = pattern
       --       firstFoundIdx = i
       --     end
       --     -- (over)write the return value with the highest parent found
       --     ret = parent
       --   end
       -- end
       -- -- In case we went through the entire loop (e.g. if maxParentSearch is really high)
       -- print(ret)
       -- return ret
        return "/home/spiderj/dev/tmf_2/cloudtmf"
      end

     -- metals_config.find_root_dir = find_root_dir     -- Attach find_root_dir to config


      -- end of experiments with root dir
    end
  }
}
