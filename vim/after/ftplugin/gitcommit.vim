" Human text, so format in the usual way:
runtime! ftplugin/human.vim

" git log indents commit messages by 5 characters, so wrap them to still fit:
set textwidth=74

" Wrap comments separately from other text, so that the # lines at the end
" don't get mixed in with the commit message:
setlocal formatoptions+=q 

" Define a shortcut for the diff command defined in the system file-type
" plug-in:
map <buffer> <LocalLeader>d :DiffGitCached -w<Enter>
