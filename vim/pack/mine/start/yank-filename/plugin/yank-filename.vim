vim9script

# yank-filename
#
# Vim plugin for yanking the current file's filename to the X selection

def Yank()
  var filename = expand('%')
  @* = filename
  echo filename .. ' copied to X selection'
enddef

# Use gy by default, if a different mapping hasn't already been defined:
if !hasmapto('<Plug>Yankfilename;')
  nmap <unique> gy <Plug>Yankfilename;
endif
nnoremap <unique> <script> <Plug>Yankfilename; :call <SID>Yank()<Enter>
