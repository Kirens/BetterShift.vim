if exists("g:BetterShift_loaded")
  finish
endif
let g:BetterShift_loaded = 1

function BetterShift(type = "", dir = "", count = -1)
  let count = a:count == -1 ? s:count : a:count
  let dir = a:dir == "" ? s:dir : a:dir

  let visualpos = [getpos("'<"), getpos("'>")]
  let startpos = getpos("'[")
  let endpos = getpos("']")

  try
    let lenBefore = strwidth(getline(startpos[1]))

    let select = #{line: "'[V']", char: "`[v`]", block: "`[\<c-v>`]"}
    silent exe 'noautocmd keepjumps normal! ' .. get(select, a:type, "")
                                            \ .. count
                                            \ .. dir

    let diff = strwidth(getline(startpos[1])) - lenBefore
    let startpos[2] += diff " make cursor follow indent
    let endpos[2] += diff

    call setpos("'[", startpos)
    silent exe 'noautocmd keepjumps normal! `['
  finally
    call setpos("']", endpos)
    call setpos("'<", visualpos[0])
    call setpos("'>", visualpos[1])
  endtry

endfunction

let s:count = 1
let s:dir = '>'

function s:BetterShift_op(dir)
  let s:count = v:count1
  set opfunc=BetterShift
  return "\<esc>g@"
endfunction

nnoremap <expr> > (<SID>BetterShift_op('>'))
nmap >> >_
nnoremap <expr> < (<SID>BetterShift_op('<'))
nmap << <_
