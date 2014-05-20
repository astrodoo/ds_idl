pro show_fsc
;( =_=)++  =========================================================================
;
; NAME: 
;   SHOW_FSC
;
; PURPOSE:
;   This routine is designed to show colors and its names in fsc_color procedure.
;
; DEPENDENCE:
;   routine fsc_color (fsc_color.pro) is required.
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
;
; EXAMPLE:
;   idl> show_fsc 
;
; HISTORY:
;   written, 25 March 2010, by DooSoo Yoon.
;   2012.07.17 - add lightTextc
;
; COPYRIGHT:
;   Copyright 2010-, All rights reserved by DooSoo Yoon.
;===================================================================================
device,decomposed=0
loadct,0,/sil

xbl = 90
ybl = 50
tmarg  = 50

col = fsc_color(/allcolors)
coln = reform(fsc_color(/names))
nx = 15
ny = ceil(float(n_elements(col))/float(nx))

textc = replicate(0,n_elements(col))

lightTextc = ['SLATEGRAY','DARKGRAY','CHARCOAL','BLACK','BLUE','NAVY','OLIVE','DARKGREEN','SADDLEBROWN' $
             ,'FIREBRICK','DARKRED','BROWN','MEDIUMORCHID','DARKORCHID','BLUEVIOLET','PURPLE','SLATEBLUE' $
             ,'DARKSLATEBLUE','BLK5','BLK6','BLK7','BLK8','GRN6','GRN7','GRN8','BLU5','BLU6','BLU7','BLU8' $
             ,'ORG6','ORG7','ORG8','RED6','RED7','RED8','PUR6','PUR7','PUR8','PBG6','PBG7','PBG8','YGB6' $
             ,'YGB7','YGB8','RYB1','RYB8','TG1','TG7','TG8','OPPOSITE']
for i=0,n_elements(lightTextc)-1 do textc[where(coln eq lightTextc[i])] = fsc_color('yellow')

!p.background=255
window,/free,xs=xbl*nx,ys=tmarg+ybl*ny

for i=0,n_elements(col)-1 do begin

    xp = (i mod nx) * xbl
    yp = ybl*ny - i/nx*ybl - ybl

    polyfill,[xp,xp+xbl,xp+xbl,xp],[yp,yp,yp+ybl,yp+ybl],color=col[i],/device

    if keyword_set(strlen(coln[i]) ge 10) then $
       xyouts,xp,yp+ybl/3.,/device,coln[i],color=textc[i],charsize=1. $
     else $
       xyouts,xp,yp+ybl/3.,/device,coln[i],color=textc[i],charsize=1.2
endfor

xyouts, xbl*nx/2-40, ybl*ny+15,/device, 'FSC_COLOR Table',color=0,charthick=2.
end
