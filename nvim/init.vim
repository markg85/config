call plug#begin('~/.config/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'plasticboy/vim-markdown'
Plug 'altercation/vim-colors-solarized'
Plug 'ChaiScript/vim-chaiscript'
Plug 'ChaiScript/vim-cpp'
Plug 'Mizuchi/STL-Syntax'
Plug 'kien/rainbow_parentheses.vim'
Plug 'arecarn/crunch.vim'
Plug 'tpope/vim-liquid'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'NLKNguyen/papercolor-theme'
"Plug 'Shougo/deoplete.nvim'
"Plug 'zchee/deoplete-clang', { 'for': 'cpp' }
Plug 'PeterRincker/vim-argumentative'
Plug 'pangloss/vim-javascript'

" Plug 'valloric/youcompleteme'

" Plug 'nathanaelkane/vim-indent-guides'

call plug#end()

let g:doxygen_enhanced_color=1
let g:load_doxygen_syntax=1

set expandtab
set shiftwidth=2
set lcs=trail:·,tab:»·
set list
set cursorline
set number

let g:gitgutter_sign_column_always = 1

let g:ycm_confirm_extra_conf = 0


let g:airline_powerline_fonts=1
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

set background=dark
"set background=dark
let g:gruvbox_contrast_light="hard"
let g:gruvbox_italic=1
let g:gruvbox_invert_signs=0
let g:gruvbox_improved_strings=0
let g:gruvbox_improved_warnings=1
let g:gruvbox_contrast_dark="hard"
colorscheme gruvbox

"set t_Co=256
"colorscheme PaperColor
"let g:airline_theme='PaperColor'

"let g:solarized_termcolors = 256
"colorscheme solarized

let g:vim_markdown_frontmatter = 1
let g:vim_markdown_folding_disabled = 1


let g:vim_indent_guides_start_level = 2


set laststatus=2

autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

au VimEnter * RainbowParenthesesActivate
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" au Syntax * RainbowParenthesesLoadChevrons

" ================ Turn Off Swap Files ==============
set noswapfile
set nobackup
set nowb


" Display tabs and trailing spaces visually
set list listchars=trail:·,tab:┊\ ,extends:>,precedes:<,nbsp:·

set nowrap       "Don't wrap lines


" ================ Completion =======================

set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set completeopt-=preview    "no scratch window

" deoplete options
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#omni_patterns = {}
let g:deoplete#omni#input_patterns = {}
let g:deoplete#auto_completion_start_length = 1
let g:deoplete#sources = {}
let g:deoplete#sources._ = []
let g:neopairs#enable = 1
let g:deoplete#file#enable_buffer_path = 1

" Let <Tab> also do completion
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

"close the preview window after completion is done.
autocmd CompleteDone * pclose!


" deoplete-clang opions
let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
let g:deoplete#sources#clang#clang_header ="/usr/include/clang/"
let g:deoplete#sources#clang#std#cpp = 'c++14'

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" == .VUE files highlight as HTML
au BufReadPost *.vue set syntax=html
