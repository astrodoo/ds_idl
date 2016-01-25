Function tickphi, axis, index, value
;( =_=)++  =========================================================================
;
; NAME: 
;   TICKPHI
;
; PURPOSE:
;   This function is purposed to show the ticks in radian format.
;
; ORIGINAL:
;   code from Dr. Shanghoon Oh
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
; EXAMPLE:
;   idl> x=findgen(1000)/1000.*2.*!pi
;   idl> plot,x,sin(x),xtickformat='tickphi'
;
; HISTORY:
;   written, 31 July 2007, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2007-, All rights reserved by DooSoo Yoon.
;===================================================================================
num  = value / (!DPI)
flag = round(num*100)/25
;print,value, flag

piS = "!7" +  String("160B) + "!X"

if (flag ge 0) then sign = "" $
               else sign = "-"
flag = abs(flag)
if ((flag mod 2) eq 1) then begin
   denom = '4'
   numer = strtrim(flag,1)
endif else if ((flag mod 4) eq 2) then begin
   denom = '2'
   numer = strtrim(flag/2,1)
endif else begin
   numer = strtrim(flag/4,1)
   if (numer eq '1') then numer = ''
endelse

if ((flag mod 4) eq 0) then begin 
   tick = sign+numer+piS
   if (numer eq '0') then tick = '0'    
endif else $                       
   tick = sign+"!S!A"+numer+"!R"+"!S"+textoidl("-")+"!A"+"!R!B"$
          +denom+"!N"+piS
return,tick
end
