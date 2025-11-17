-- ~/.config/nvim/lua/simple_harpoon.lua
local M = {}

-- Configuration
local marks_file = vim.fn.stdpath('data') .. '/simple_harpoon_marks'

-- Helper function to read marks from file
local function read_marks()
    local file = io.open(marks_file, 'r')
    if not file then
        return {}
    end
    
    local marks = {}
    for line in file:lines() do
        if line ~= "" then
            table.insert(marks, line)
        end
    end
    file:close()
    return marks
end

-- Helper function to write marks to file
local function write_marks(marks)
    local file = io.open(marks_file, 'w')
    if not file then
        vim.notify("Error: Could not open marks file for writing", vim.log.levels.ERROR)
        return
    end
    
    for _, mark in ipairs(marks) do
        file:write(mark .. '\n')
    end
    file:close()
end

-- Add current file to marks
function M.add_file()
    local current_file = vim.fn.expand('%:p')
    if current_file == "" then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
    end
    
    local marks = read_marks()
    
    -- Check if file is already marked
    for i, mark in ipairs(marks) do
        if mark == current_file then
            vim.notify("File already marked at position " .. i, vim.log.levels.INFO)
            return
        end
    end
    
    -- Add file to marks
    table.insert(marks, current_file)
    write_marks(marks)
    vim.notify("Added file to marks at position " .. #marks, vim.log.levels.INFO)
end

-- Jump to file at given index
function M.jump_to_file(index)
    local marks = read_marks()
    
    if #marks == 0 then
        vim.notify("No files marked", vim.log.levels.WARN)
        return
    end
    
    if index < 1 or index > #marks then
        vim.notify("Invalid mark index: " .. index .. " (available: 1-" .. #marks .. ")", vim.log.levels.WARN)
        return
    end
    
    local file_path = marks[index]
    if vim.fn.filereadable(file_path) == 1 then
        vim.cmd('edit ' .. vim.fn.fnameescape(file_path))
        vim.notify("Jumped to mark " .. index .. ": " .. vim.fn.fnamemodify(file_path, ':t'), vim.log.levels.INFO)
    else
        vim.notify("File not found: " .. file_path, vim.log.levels.ERROR)
    end
end

-- Open marks file for editing
function M.edit_marks()
    vim.cmd('edit ' .. vim.fn.fnameescape(marks_file))
    vim.notify("Editing marks file - save to update marks", vim.log.levels.INFO)
end

-- Get current marks (utility function)
function M.list_marks()
    local marks = read_marks()
    if #marks == 0 then
        vim.notify("No files marked", vim.log.levels.INFO)
        return
    end
    
    print("Current marks:")
    for i, mark in ipairs(marks) do
        print(i .. ": " .. vim.fn.fnamemodify(mark, ':~'))
    end
end

function M.select_mark()
    local marks = read_marks()
    
    if #marks == 0 then
        vim.notify("No files marked", vim.log.levels.WARN)
        return
    end
    
    -- Create display items with index and filename
    local items = {}
    for i, mark in ipairs(marks) do
        local display_name = string.format("[%d] %s", i, vim.fn.fnamemodify(mark, ':~'))
        table.insert(items, {
            display = display_name,
            path = mark,
            index = i
        })
    end
    
    vim.ui.select(items, {
        prompt = 'Select file to jump to:',
        format_item = function(item)
            return item.display
        end,
    }, function(choice)
        if choice then
            if vim.fn.filereadable(choice.path) == 1 then
                vim.cmd('edit ' .. vim.fn.fnameescape(choice.path))
                vim.notify("Jumped to mark " .. choice.index .. ": " .. vim.fn.fnamemodify(choice.path, ':t'), vim.log.levels.INFO)
            else
                vim.notify("File not found: " .. choice.path, vim.log.levels.ERROR)
            end
        end
    end)
end

return M

