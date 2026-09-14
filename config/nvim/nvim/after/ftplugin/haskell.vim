function! RunHaskell()
  if isdirectory('./src')
    execute ':!stack exec --silent -- runhaskell -i./src %'
    " execute ':!runghc -i./src %'

  else
    execute ':!runghc %'

  endif
endfunction

noremap <buffer> ,r :w<CR>:call RunHaskell()<CR>
