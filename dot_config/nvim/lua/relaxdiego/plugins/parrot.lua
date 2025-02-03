local default_system_prompt = [[
As a senior staff systems and software engineer, you are endowed with deep expertise in:
- Software Design and Architecture: Proficient in creating scalable, robust system designs.
- Development: Skilled in writing clean, efficient code across multiple programming languages.
- Deployment and Administration: Experienced in deploying applications, managing systems, and ensuring operational excellence.
- DevOps Practices: Mastery in integrating development with operations, including CI/CD, automation, and infrastructure as code.

Your role also encompasses:
- Code Editing: Providing precise modifications to enhance code functionality and readability.
- Code Completion: Suggesting logical continuations or implementations based on partial code snippets.
- Debugging: Identifying and resolving issues within the code, offering explanations and solutions.

Guidelines for Response:
- Focus Exclusively on the Provided Code Snippet: Your analysis, suggestions, and edits must be strictly relevant to the code segment presented.
- Detail-Oriented: Offer comprehensive explanations for each change or recommendation, including why it improves the code.
- Language-Specific Best Practices: Apply best practices relevant to the programming language of the snippet.
- Avoid Assumptions: Do not extrapolate beyond the snippet unless explicitly asked. If context is missing that would affect your advice, point this out.
]]

return {
    "frankroeder/parrot.nvim",
    version = "v1.2.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "ibhagwan/fzf-lua",
    },
    event = "VeryLazy",
    config = function()
        require("parrot").setup({
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
                command = default_system_prompt,
                chat = default_system_prompt,
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

                    Output Requirements:
                    - Please finish the code above carefully and logically.
                    - Provide only the snippet of code that should be appended.
                    - Do not include any explanations, comments, or analysis.
                    - Do not use markdown codeblock delimiters in your response.
                    ]]
                    local model_obj = prt.get_model("command")
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

                    Output Requirements:
                    - Please finish the code above carefully and logically.
                    - Provide only the snippet of code that should be appended.
                    - Do not include any explanations, comments, or analysis.
                    - Do not use markdown codeblock delimiters in your response.
                    ]]
                    local model_obj = prt.get_model("command")
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

                    Output Requirements:
                    - Please finish the code above carefully and logically.
                    - Provide only the snippet of code that should be appended.
                    - Do not include any explanations, comments, or analysis.
                    - Do not use markdown codeblock delimiters in your response.
                    ]]
                    local model_obj = prt.get_model("command")
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
                    local model = prt.get_model("command")
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
                    local model_obj = prt.get_model("command")
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
                    local model_obj = prt.get_model("command")
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
                    local model_obj = prt.get_model("command")
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
                    local model_obj = prt.get_model("command")
                    prt.logger.info("Debugging selection with model: " .. model_obj.name)
                    prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
                end,
                CommitMsg = function(prt, params)
                    local futils = require("parrot.file_utils")
                    if futils.find_git_root() == "" then
                        prt.logger.warning("Not in a git repository")
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
                        ]] .. vim.fn.system("git diff --no-color --no-ext-diff --staged")
                        local model_obj = prt.get_model("command")
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
                Document = function(prt, params)
                    local template = [[
                    You are an expert in {{filetype}}. Your task is to document
                    the provided {{filetype}} code using comments, adhering to
                    the language’s documentation best practices. If the code is
                    a function, include detailed documentation for its
                    parameters and return values (if any). Focus solely on
                    documenting the code’s purpose, inputs, side effects, and
                    outputs—do not explain how the code works internally.

                    Here is the code:
                    ```{{filetype}}
                    {{selection}}
                    ```

                    Output Requirements:
                    - Provide only the documentation comments that should be prepended to the code.
                    - Do not include any trailing empty lines.
                    - Do not use markdown codeblock delimiters in your response.
                    ]]
                    local model_obj = prt.get_model("command")
                    prt.Prompt(params, prt.ui.Target.prepend, model_obj, nil, template)
                end,
            },
        })
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
            "fcc",
            ":PrtComplete<CR>",
            mode = { "n", "v", "x" },
            desc = "Selected code",
        },
        {
            "fcf",
            ":PrtCompleteFullContext<CR>",
            mode = { "n", "v", "x" },
            desc = "With full file context",
        },
        {
            "fcm",
            ":PrtCompleteMultiContext<CR>",
            mode = { "n", "v", "x" },
            desc = "With context of all open buffers",
        },
        {
            "fd",
            ":PrtChatDelete<CR>",
            mode = { "n", "v", "x" },
            desc = "Delete current chat",
            silent = true,
        },
        {
            "fh",
            ":PrtChatFinder<CR>",
            mode = { "n", "v", "x" },
            desc = "Search chat history",
            silent = true,
        },
        {
            "ff",
            function()
                vim.api.nvim_feedkeys(":Prt", "n", false)
                vim.defer_fn(function()
                    require("cmp").complete()
                end, 10)
            end,
            mode = { "n", "v", "x" },
            desc = "Run a Parrot command",
        },
        {
            "fi",
            ":PrtImplement<CR>",
            mode = { "n", "v", "x" },
            desc = "Implement selected comments",
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
            "fn",
            ":PrtChatNew<CR>",
            mode = { "n", "v", "x" },
            desc = "New chat",
            silent = true,
        },
        {
            "fo",
            ":PrtDocument<CR>",
            mode = { "n", "v", "x" },
            desc = "Document the selected code",
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
            "fr",
            ":PrtRewrite<CR>",
            mode = { "n", "v", "x" },
            desc = "Rewrite inline",
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
            "fy",
            function()
                if vim.bo.filetype ~= "markdown" then
                    vim.notify("This command only works in markdown files", vim.log.levels.WARN)
                    return
                end

                local current_pos = vim.fn.getcurpos()

                -- Initialize treesitter parser
                local parser = vim.treesitter.get_parser(0, "markdown")
                local tree = parser:parse()[1]
                local root = tree:root()

                -- Get the node at cursor position
                local current_node = root:named_descendant_for_range(
                    current_pos[2] - 1,
                    current_pos[3] - 1,
                    current_pos[2] - 1,
                    current_pos[3] - 1
                )

                -- First, check if we're inside a code block
                local target_block = current_node
                while target_block and target_block:type() ~= "fenced_code_block" do
                    target_block = target_block:parent()
                end

                -- If we're not inside a block, find the preceding one
                if not target_block then
                    -- Get all code blocks in the buffer
                    local code_blocks = {}

                    -- Recursive function to traverse the tree
                    local function collect_code_blocks(node)
                        if node:type() == "fenced_code_block" then
                            local start_row = node:range()
                            if start_row < (current_pos[2] - 1) then
                                table.insert(code_blocks, node)
                            end
                        end

                        for child in node:iter_children() do
                            collect_code_blocks(child)
                        end
                    end

                    -- Start the recursive traversal from root
                    collect_code_blocks(root)

                    -- Get the last block before cursor
                    target_block = code_blocks[#code_blocks]
                end

                -- Handle case where no block was found
                if not target_block then
                    vim.notify("No code block found", vim.log.levels.WARN)
                    return
                end

                -- Get the block range and content
                local start_row, _, end_row, _ = target_block:range()
                local content_start = start_row + 2 -- Skip the opening delimiter
                local content_end = end_row - 1     -- Subtract 1 to exclude the closing delimiter

                if content_end < content_start then
                    vim.notify("Invalid code block", vim.log.levels.WARN)
                    return
                end

                -- Yank the content
                vim.cmd(string.format("silent %d,%dy", content_start, content_end))

                -- Restore cursor position and notify
                vim.fn.setpos(".", current_pos)
                vim.notify("Code block yanked", vim.log.levels.INFO)
            end,
            mode = { "n", "v", "x" },
            desc = "Yank the preceding code block",
        },
    },
}
