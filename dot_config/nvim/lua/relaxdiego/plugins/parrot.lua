return {
    "frankroeder/parrot.nvim",
    version = "v1.2.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "ibhagwan/fzf-lua",
    },
    event = "VeryLazy",
    config = function()
        require("parrot").setup {
            providers = {
                anthropic = {
                    api_key = { "op", "read", "op://api-keys/anthropic/credential", "--no-newline" },
                },
                openai = {
                    api_key = { "op", "read", "op://api-keys/openai/credential", "--no-newline" },
                },
                xai = {
                    api_key = { "op", "read", "op://api-keys/xai/credential", "--no-newline" },
                },
            },
            system_prompt = {
                command = [[
                You are an AI specializing in software development
                tasks, including code editing, completion, and debugging. Your
                responses should strictly pertain to the code provided. Please ensure
                that your reply is solely focused on the code snippet in question.
                ]],
                chat = [[
                You are a versatile AI assistant with capabilities
                extending to general knowledge and coding support. When engaging
                with users, please adhere to the following guidelines to ensure
                the highest quality of interaction:

                - Admit when unsure by saying 'I don't know.'
                - Ask for clarification when needed.
                - Use first principles thinking to analyze queries.
                - Start with the big picture, then focus on details.
                - Apply the Socratic method to enhance understanding.
                - Include all necessary code in your responses.
                - Stay calm and confident with each task.

                When providing code blocks:
                - Use single blank lines (single newline character) between logical sections
                - Do not add extra whitespace characters after newlines
                - Maintain proper indentation for code readability
                ]],
            },
            chat_user_prefix = "## User:",
            llm_prefix = "## AI:",
            chat_conceal_model_params = false,
            command_auto_select_response = false, -- Don't select command output
            user_input_ui = "buffer",
            enable_spinner = true,
            spinner_type = "dots",
            hooks = {
                Complete = function(prt, params)
                    local template = [[
                    I have the following code from {{filename}}:

                    ```{{filetype}}
                    {{selection}}
                    ```

                    Please finish the code above carefully and logically.
                    Respond just with the snippet of code that should be inserted."
                    ]]
                    local model_obj = prt.get_model "command"
                    prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
                end,
                CompleteFullContext = function(prt, params)
                    local template = [[
                    I have the following code from {{filename}}:

                    ```{{filetype}}
                    {{filecontent}}
                    ```

                    Please look at the following section specifically:
                    ```{{filetype}}
                    {{selection}}
                    ```

                    Please finish the code above carefully and logically.
                    Respond just with the snippet of code that should be inserted.
                    ]]
                    local model_obj = prt.get_model "command"
                    prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
                end,
                CompleteMultiContext = function(prt, params)
                    local template = [[
                    I have the following code from {{filename}} and other realted files:

                    ```{{filetype}}
                    {{multifilecontent}}
                    ```

                    Please look at the following section specifically:
                    ```{{filetype}}
                    {{selection}}
                    ```

                    Please finish the code above carefully and logically.
                    Respond just with the snippet of code that should be inserted.
                    ]]
                    local model_obj = prt.get_model "command"
                    prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
                end,
                Explain = function(prt, params)
                    local template = [[
                    Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
                    Break down the code's functionality, purpose, and key components.
                    The goal is to help the reader understand what the code does and how it works.

                    ```{{filetype}}
                    {{selection}}
                    ```

                    Use the markdown format with codeblocks and inline code.
                    Explanation of the code above:
                    ]]
                    local model = prt.get_model "command"
                    prt.logger.info("Explaining selection with model: " .. model.name)
                    prt.Prompt(params, prt.ui.Target.vnew, model, nil, template)
                end,
                FixBugs = function(prt, params)
                    local template = [[
                    You are an expert in {{filetype}}.
                    Fix bugs in the below code from {{filename}} carefully and logically:
                    Your task is to analyze the provided {{filetype}} code snippet, identify
                    any bugs or errors present, and provide a corrected version of the code
                    that resolves these issues. Explain the problems you found in the
                    original code and how your fixes address them. The corrected code should
                    be functional, efficient, and adhere to best practices in
                    {{filetype}} programming.

                    ```{{filetype}}
                    {{selection}}
                    ```

                    Fixed code:
                    ]]
                    local model_obj = prt.get_model "command"
                    prt.logger.info("Fixing bugs in selection with model: " .. model_obj.name)
                    prt.Prompt(params, prt.ui.Target.vnew, model_obj, nil, template)
                end,
                Optimize = function(prt, params)
                    local template = [[
                    You are an expert in {{filetype}}.
                    Your task is to analyze the provided {{filetype}} code snippet and
                    suggest improvements to optimize its performance. Identify areas
                    where the code can be made more efficient, faster, or less
                    resource-intensive. Provide specific suggestions for optimization,
                    along with explanations of how these changes can enhance the code's
                    performance. The optimized code should maintain the same functionality
                    as the original code while demonstrating improved efficiency.

                    ```{{filetype}}
                    {{selection}}
                    ```

                    Optimized code:
                    ]]
                    local model_obj = prt.get_model "command"
                    prt.logger.info("Optimizing selection with model: " .. model_obj.name)
                    prt.Prompt(params, prt.ui.Target.vnew, model_obj, nil, template)
                end,
                UnitTests = function(prt, params)
                    local template = [[
                    I have the following code from {{filename}}:

                    ```{{filetype}}
                    {{selection}}
                    ```

                    Please respond by writing table driven unit tests for the code above.
                    ]]
                    local model_obj = prt.get_model "command"
                    prt.logger.info("Creating unit tests for selection with model: " .. model_obj.name)
                    prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
                end,
                Debug = function(prt, params)
                    local template = [[
                    I want you to act as {{filetype}} expert.
                    Review the following code, carefully examine it, and report potential
                    bugs and edge cases alongside solutions to resolve them.
                    Keep your explanation short and to the point:

                    ```{{filetype}}
                    {{selection}}
                    ```
                    ]]
                    local model_obj = prt.get_model "command"
                    prt.logger.info("Debugging selection with model: " .. model_obj.name)
                    prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
                end,
                CommitMsg = function(prt, params)
                    local futils = require "parrot.file_utils"
                    if futils.find_git_root() == "" then
                        prt.logger.warning "Not in a git repository"
                        return
                    else
                        local template = [[
                        I want you to act as a commit message generator. I will provide you
                        with information about the task and the prefix for the task code, and
                        I would like you to generate an appropriate commit message using the
                        conventional commit format. Do not write any explanations or other
                        words, just reply with the commit message.
                        Start with a short headline as summary but then list the individual
                        changes in more detail.

                        Here are the changes that should be considered by this message:
                        ]] .. vim.fn.system "git diff --no-color --no-ext-diff --staged"
                        local model_obj = prt.get_model "command"
                        prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
                    end
                end,
                SpellCheck = function(prt, params)
                    local chat_prompt = [[
                    Your task is to take the text provided and rewrite it into a clear,
                    grammatically correct version while preserving the original meaning
                    as closely as possible. Correct any spelling mistakes, punctuation
                    errors, verb tense issues, word choice problems, and other
                    grammatical mistakes.
                    ]]
                    prt.ChatNew(params, chat_prompt)
                end,
                CodeConsultant = function(prt, params)
                    local chat_prompt = [[
                    Your task is to analyze the provided {{filetype}} code and suggest
                    improvements to optimize its performance. Identify areas where the
                    code can be made more efficient, faster, or less resource-intensive.
                    Provide specific suggestions for optimization, along with explanations
                    of how these changes can enhance the code's performance. The optimized
                    code should maintain the same functionality as the original code while
                    demonstrating improved efficiency.

                    Here is the code
                    ```{{filetype}}
                    {{filecontent}}
                    ```
                    ]]
                    prt.ChatNew(params, chat_prompt)
                end,
                ProofReader = function(prt, params)
                    local chat_prompt = [[
                    I want you to act as a proofreader. I will provide you with texts and
                    I would like you to review them for any spelling, grammar, or
                    punctuation errors. Once you have finished reviewing the text,
                    provide me with any necessary corrections or suggestions to improve the
                    text. Highlight the corrected fragments (if any) using markdown backticks.

                    When you have done that subsequently provide me with a slightly better
                    version of the text, but keep close to the original text.

                    Finally provide me with an ideal version of the text.

                    Whenever I provide you with text, you reply in this format directly:

                    ## Corrected text:

                    {corrected text, or say "NO_CORRECTIONS_NEEDED" instead if there are no corrections made}

                    ## Slightly better text

                    {slightly better text}

                    ## Ideal text

                    {ideal text}
                    ]]
                    prt.ChatNew(params, chat_prompt)
                end,
            },
        }
    end,
    keys = {
        {
            "fb",
            ":PrtFixBugs<CR>",
            mode = { "n", "v", "x" },
            desc = "Fix bugs in selection",
            silent = true,
        },
        {
            "fc",
            ":PrtChatNew<CR>",
            mode = { "n", "v", "x" },
            desc = "Chat with AI",
            silent = true,
        },
        {
            "fd",
            ":PrtChatDelete<CR>",
            mode = { "n", "v", "x" },
            desc = "Delete current chat",
            silent = true,
        },
        {
            "ff",
            ":PrtChatFinder<CR>",
            mode = { "n", "v", "x" },
            desc = "Find previous chat",
            silent = true,
        },
        {
            "fs",
            ":PrtChatPaste<CR>",
            mode = { "v", "x" },
            desc = "Send selection to chat",
            silent = true,
        },
        {
            "fi",
            ":PrtImplement<CR>",
            mode = { "n", "v", "x" },
            desc = "Implement selected comments",
            silent = true,
        },
        {
            "fr",
            ":PrtRewrite<CR>",
            mode = { "n", "v", "x" },
            desc = "Rewrite inline",
            silent = true,
        },
        {
            "fm",
            ":PrtModel<CR>",
            mode = { "n", "v", "x" },
            desc = "Choose a model in current provider",
            silent = true,
        },
        {
            "fp",
            ":PrtProvider<CR>",
            mode = { "n", "v", "x" },
            desc = "Choose a provider",
            silent = true,
        },
        {
            "fx",
            ":PrtCompleteFullContext<CR>",
            mode = { "n", "v", "x" },
            desc = "Complete with full file context",
        },
        {
            "fz",
            function()
                vim.api.nvim_feedkeys(":Prt", 'n', false)
                vim.defer_fn(function()
                    require('cmp').complete()
                end, 10)
            end,
            mode = { "n", "v", "x" },
            desc = "Run a Parrot command"
        },
    },
}
