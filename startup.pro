print, "START to DS Astronomy"
compile_opt IDL2   ; defint32, strictarr
device,decomposed=0
device, retain=2
!p.charsize=1.5
!p.charthick=1.5
!p.thick=2.
!x.thick=2. & !y.thick=2.

astrolib

; physical&astronomical constant
unit

;.comp /usr/local/rsi/idl/idl80/lib/astron/pro/legend.pro
