" syntax on
" filetype plugin on
" filetype indent on

" Some Linux distributions set filetype in /etc/vimrc.
" Clear filetype flags before changing runtimepath to force Vim to reload them.
"
" autocmd FileType go autocmd BufWritePre *.go Fmt
autocmd FileType go autocmd BufWritePre <buffer> Fmt
if exists("g:did_load_filetypes")
  filetype off
  filetype plugin indent off
endif
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

" set taglist
let Tlist_Ctags_Cmd='/usr/local/bin/ctags'

set ai
set nobackup
""set backupdir=~/.vimbackup
set nocompatible
set backspace=2
set mouse=
set noswapfile

"set t_Co=256
colorscheme desert

set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4

" expand tab to spaces
set expandtab

set autoindent
set smartindent
set cindent
set nu

set hlsearch
set incsearch

" status line
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P

"set completeopt
set completeopt=longest,menu
set cpt=.,w,b,u

set tags+=~/src/common/.tags
set tags+=~/src/poppy/.tags

let &termencoding=&fileencoding
" auto encoding detecting
set fileencodings=utf-8,cp936,big5,gb18030,ucs

" hilight characters over 100 columns
" match DiffAdd '\%>100v.*'

" pair config
inoremap {<CR> {<CR>}<ESC>k$a<CR>
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap ' ''<ESC>i
inoremap " ""<ESC>i
inoremap \" \"\"<ESC>i

"map ,n <ESC>onamespace common<CR>{<ESC>
"map ,m <ESC>o} // namespace common<ESC>
map ,n :bn<CR>
map ,p :bp<CR>
" F2 to save files
map <F2> :w!<CR>

" jump to previous building error
map <F3> :cp<CR>

" jump to next building error
map <F4> :cn<CR>

map <F5> :A<CR>

"map <F6> :Tlist<CR>

" show one file!
" let Tlist_Show_One_File = 1 
let Tlist_Show_One_File = 0 

" for go lang
map <F6> :TagbarToggle<CR>
let g:tagbar_left = 1
let g:tagbar_width = 30
let s:tlist_def_go_settings = 'go;f:func;v:var;t:type'
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

map <F7> :NERDTreeToggle<CR>
let g:NERDTreeWinPos = "right"
let g:NERDTreeWinSize = 25
" map <F7> :e .<CR>
" map <F8> <ESC>\be
map <F8> :JavaImpSilent<CR> :JIS<CR>

let g:JavaImpPaths = "/Users/wliu/Setup/spark-1.0.0/lib_managed/lib"
let g:JavaImpDataDir = $HOME

map <F10> :Dox<CR>

" F11 toggle paste mode
set pastetoggle=<F11>

" produce tags
map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

augroup filetype
    autocmd! BufRead,BufNewFile *.proto set filetype=proto
    autocmd! BufRead,BufNewFile *.thrift set filetype=thrift
    autocmd! BufRead,BufNewFile *.pump set filetype=pump
    autocmd! BufRead,BufNewFile BUILD set filetype=blade
augroup end

" When editing a file, always jump to the last cursor position
autocmd BufReadPost * nested
            \ if line("'\"") > 0 && line ("'\"") <= line("$") |
            \ exe "normal g'\"" |
            \ endif

" auto find project root to use gf
function! AutoSetPath()
    let project_root = FindProjectRootDir()
    if project_root != ""
        exec "setlocal path+=" . project_root
    endif
endfunction

autocmd FileType {c,cpp} nested call AutoSetPath()


" locate project dir by BLADE_ROOT file
function! FindProjectRootDir()
    let rootfile = findfile("BLADE_ROOT", ".;")
    " in project root dir
    if rootfile == "BLADE_ROOT"
        return ""
    endif
    return substitute(rootfile, "/BLADE_ROOT$", "", "")
endfunction

" integrate blade into vim
function! Blade(...)
    let l:old_makeprg = &makeprg
    setlocal makeprg=blade
    execute "make " . join(a:000)
    let &makeprg=old_makeprg
endfunction

command! -complete=dir -nargs=* Blade call Blade('<args>')

" integrate cpplint into vim
function! CppLint(...)
    let l:args = join(a:000)
    if l:args == ""
        let l:args = expand("%")
        if l:args == ""
            let l:args = '*'
        endif
    endif
    let l:old_makeprg = &makeprg
    setlocal makeprg=cpplint.py
    execute "make " . l:args
    let &makeprg=old_makeprg
endfunction

command! -complete=file -nargs=* CppLint call CppLint('<args>')

" integrate pychecker into vim
function! PyCheck(...)
    let l:old_makeprg = &makeprg
    setlocal makeprg=pychecker
    execute "make -q " . join(a:000)
    let &makeprg=old_makeprg
endfunction

command! -complete=file -nargs=* PyCheck call PyCheck('<args>')

