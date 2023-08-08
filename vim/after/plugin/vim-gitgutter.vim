" after/plugin/vim-gitgutter.vim
"
" Customize the GitGutter highlight colours to something I find less jarring.


" Have the sign column be a pale yellow:
highlight      SignColumn                  guibg=#FFF6DD

" When there's a sign, have that be in black but changing the background colour
" of the line to a different (pastel-ish) colour for each type of change:
highlight      GitGutterAdd    guifg=black guibg=#DDFFCC
highlight      GitGutterChange guifg=black guibg=#DDCCFF
highlight      GitGutterDelete guifg=black guibg=#FFCCCC
highlight link GitGutterChangeDelete GitGutterChange
