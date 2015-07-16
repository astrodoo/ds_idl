pro swindow, xsize=xsize, ysize=ysize, x_scr=x_scr, y_scr=y_scr, index=index, _extra=extra
;( =_=)++  =========================================================================
;
; NAME: 
;   SWINDOW
;
; PURPOSE:
;   This routine is aimed to make a scroll-enabled window
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
; KEYWORDS:
;   xsize/ysize: in, required, type= integer, default= (xsize=800),(ysize=600)
;        Total x/y size of the window
;   x_scr/y_scr: in, requried, type= integer, defaull= min[x(y)size, screen x(y)size]
;        scroll x/y size
;   index: out, optional, type=string
;        print out the window_index
;
; EXAMPLE:
;   idl> swindow, xsize=2000, ysize=2000, x_scr=1000, y_scr=1000, index=index
;   idl> plot,findgen(100)
;   idl> snapshot,'tmp'
;
; HISTORY:
;   written, 26 February 2015, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2015-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(xsize) then xsize=800
if not keyword_set(ysize) then ysize=600

screen = get_screen_size()
xoff=200 & yoff=200
if not keyword_set(x_scr) then x_scr=min([xsize,screen[0]-xoff])
if not keyword_set(y_scr) then y_scr=min([ysize,screen[1]-yoff])

;-------  Make Scrolling window  ----------------
wBase = widget_base()
wDraw = widget_draw(wBase,xs=xsize,ys=ysize,x_scr=x_scr,y_scr=y_scr,_strict_extra=extra)
widget_control, wBase, /real
widget_control, wDraw, get_value=ind
widget_control, wDraw, tlb_set_title='Scr_Window '+strtrim(ind,2)

end

