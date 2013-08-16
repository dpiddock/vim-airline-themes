" MIT license. Copyright (c) 2013 Bailey Ling.
" vim: ts=2 sts=2 sw=2 fdm=indent

function! airline#builder#new(active)
  let builder = {}
  let builder._sections = []
  let builder._active = a:active

  function! builder.split(gutter)
    call add(self._sections, ['|', a:gutter])
  endfunction

  function! builder.add_section(group, contents)
    call add(self._sections, [a:group, a:contents])
  endfunction

  function! builder.add_raw(text)
    call add(self._sections, ['_', a:text])
  endfunction

  function! builder._group(group)
    return '%#' . (self._active ? a:group : a:group.'_inactive') . '#'
  endfunction

  function! builder.build()
    let line = '%{airline#update_highlight()}'
    let side = 0
    let prev_group = ''
    for section in self._sections
      if section[0] == '|'
        let side = 1
        let line .= '%#'.prev_group.'#'.section[1]
        let prev_group = ''
        continue
      endif
      if section[0] == '_'
        let line .= section[1]
        continue
      endif

      if prev_group != ''
        let line .= side == 0
              \ ? self._group(airline#themes#exec_highlight_separator(section[0], prev_group))
              \ : self._group(airline#themes#exec_highlight_separator(prev_group, section[0]))
        let line .= side == 0
              \ ? self._active ? g:airline_left_sep : g:airline_left_alt_sep
              \ : self._active ? g:airline_right_sep : g:airline_right_alt_sep
      endif

      let line .= self._group(section[0]).section[1]
      let prev_group = section[0]
    endfor
    return line
  endfunction

  return builder
endfunction
