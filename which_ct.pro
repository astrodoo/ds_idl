function which_ct, r,g,b
;( =_=)++  =========================================================================
;
; NAME: 
;   WHICH_CT
;
; PURPOSE:
;   This function is aimed to get color table number in current configuration or input
;   variables (r,g,b). 
;
; AUTHOR:
;   DOOSOO YOON
;   Department of Astronomy, UW-Madison
;   475 N. Charter St., Madison, WI 53705
;   Web: http://www.astro.wisc.edu/~yoon
;   E-mail: yoon@astro.wisc.edu
;
; CATEGORY:
;   Graphic
;
; RETURN:
;   type= int
;     the number of the color table.
;     if no match, it will return value of -1.  
;
; PARAMS:
;   r/g/b: in, optional, type= intarr(256) each
;          red, gree, blue colors in the color table
;
; KEYWORDS:
;
; EXAMPLE:
;   idl> current_CT = which_ct()
;
; HISTORY:
;   written, 13 November 2012, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2012-, All rights reserved by DooSoo Yoon.
;===================================================================================
if (n_elements(r) eq 0) then tvlct,r,g,b,/get

for i=0,74 do begin
   loadct,i,/sil
   tvlct,ri,gi,bi,/get

   if (array_equal(r,ri) and array_equal(g,gi) and array_equal(b,bi)) $
     then goto, Jump
endfor

i=-1

Jump:

return,i
end
