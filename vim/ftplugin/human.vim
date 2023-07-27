" If a line happens to start with a % symbol, don't treat that as a bullet:
setlocal comments-=:%

setlocal comments+=fb:»,fb:•

" TODO  Report the bug that the -1 is needed, cos the chevron is 2 characters.

" TODO  Report the doc bug which doesn't say indent adjusters work with f:
" comments, even though they apparently do!
setlocal infercase
setlocal formatoptions-=l formatoptions+=t2

setlocal spell
