return {
    -- The plugin manager itself. lazy.nvim appends an *unpinned* spec for
    -- itself (lua/lazy/core/plugin.lua), so without this file `Lazy sync`
    -- quietly drags it to the latest main. plugins.lua reads the commit below
    -- to land a fresh clone on the same revision.
    "folke/lazy.nvim",
    commit = "de0a911", -- v9.25.0
}
