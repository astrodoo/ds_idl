function posnorm,position,nx=nx,ny=ny
;( =_=)++  =========================================================================
;
; NAME: 
;   POSNORM
;
; PURPOSE:
;   This function is purposed to convert the position format from device to normal. 
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
;   type= fltarr(4)
;      the position - [x0,y0,x1,y1] in normal coordinate 
; PARAMS:
;   position: in, required, type= fltarr(4)
;           the position - [x0,y0,x1,y1] in device coordinate
;
; KEYWORDS:
;   nx: in, required, type= int, default=!d.x_size
;   ny: in, required, type= int, default=!d.y_size
;
; EXAMPLE:
;   idl> mkeps,'test.eps',xsize=20.
;   idl> contour, Flux, x, y, position = posnorm([100,400,300,700],nx=400,ny=700)
;   idl> epsfree
;  or 
;   idl> contour, Flux, x, y, position = posnorm([100,400,300,700],nx=400,ny=700)
;
; HISTORY:
;   written, 26 August 2010, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2010-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(nx) then nx=!d.x_size
if not keyword_set(ny) then ny=!d.y_size

pos = float(position)
nxx = float(nx) & nyy = float(ny)

posnorm = [pos[0]/nxx,pos[1]/nyy,pos[2]/nxx,pos[3]/nyy]
return,posnorm
end

