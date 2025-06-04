-- Test file for Neovim configuration
local function test_function()
    print("Hello, Neovim!")
    
    -- Test formatting
    local table = { a = 1, b = 2, c = 3 }
    
    -- Test linting
    local unused_variable = "this should trigger a warning"
    
    return table
end

test_function()
