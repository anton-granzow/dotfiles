vim.cmd[[
set wildmenu
set wildmode=longest:lastused,full
if executable('fd') && executable('fzf')
    set findfunc=FdFind
endif

abbreviate f find
function! FdFind(cmdarg, cmdcomplete)
    return systemlist("fd --hidden . \| fzf --filter='" 
        \.. a:cmdarg .. "'")
endfunction
]]

