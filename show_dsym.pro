pro show_dsym,symsize=symsize
;( =_=)++  =========================================================================
;
; NAME: 
;   SHOW_DSYM 
;
; PURPOSE:
;   Show the Symbols in dsym function (dsym.pro). 
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
; PARAMS:
;
; KEYWORDS:
;   symsize: in, required, type= int, default=3 
;          the size of the symbols
;
; EXAMPLE:
;
;   IDL> show_dsym
;
; HISTORY:
;   written, 18 November 2012, by DooSoo Yoon.
;   2014.03.05: modify some bug
;  
; COPYRIGHT:
;   Copyright 2012-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(symsize) then symsize=3

window,/free,xs=500,ys=500
x=indgen(6) & y=indgen(6)
plot,x,y,xticklen=0.5,yticklen=0.5,xgrid=1,ygrid=1,/nodata,/iso,xminor=1,yminor=1 $
    ,xtickformat='(a1)',ytickformat='(a1)', position=[0.05,0.02,0.95,0.92],/norm  $
    ,title='Symbols in dsym (0 - 20)',charthick=2, background=255,color=0

; theSymbols
theSymbol=indgen(21)
xpos = theSymbol mod 5 & ypos = 4 - (theSymbol / 5)   ; x & y positions

; plotting the symbols
tvlct,r,g,b,/get
for i=0, 20 do begin
   xyouts, xpos[i]+0.1, ypos[i]+0.8, strtrim(i,2), color=0
   plots, xpos[i]+0.5, ypos[i]+0.5,/data, psym=dsym(i,/fill),color=trp_color(fsc_color('blue'),alpha=0.3,/silent,/whitebg), symsize=symsize
   plots, xpos[i]+0.5, ypos[i]+0.5,/data, psym=dsym(i),color=fsc_color('blue'), symsize=symsize
endfor
tvlct,r,g,b
end
