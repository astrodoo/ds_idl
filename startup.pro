print, "START to DS Astronomy"
compile_opt IDL2   ; defint32, strictarr
device,decomposed=0
device, retain=2

!p.background = 255
!p.color = 0
!p.charsize=1.5
!p.charthick=1.5
!p.thick=2.
!x.thick=2. & !y.thick=2.

loadct,39,/sil

astrolib

; physical&astronomical constant
unit
