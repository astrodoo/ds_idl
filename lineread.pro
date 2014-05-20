pro lineread, image, x=x, y=y, pos0, pos1, mouse=mouse, data=data, npoint=npoint $
            , no_window=no_window, lout=lout, value=value, _extra=extra
;( =_=)++  =========================================================================
;
; NAME: 
;   LINEREAD
;
; PURPOSE:
;   This routine is aimed to read the data along arbiturary lines on 2d image data.
;   Similar with intrinsic "profiles.pro"
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
;   image: in, required, type= fltarr(2)
;        objective image array
;   pos0(or pos1): in, required, type= fltarr(2)
;        starting(pos0) and end(pos1) points in data coordinate (if given x,y)
;        or in device coordinate
;
; KEYWORDS:
;   x(or y): in, optional, type= fltarr(1)
;        x(or y) coordinate
;   mouse: in, optional, type= boolean
;        choose starting and end points via mouse clicking
;   data: in, optional, type= boolean
;        if given, outcome will be in data coordinate.
;   npoint: in, required, type=integer, default= 500
;        number of points to be read
;   no_window, in, optional, type=boolean
;        if given, it will not draw the line on the image, simply generating outcomes.
;   lout: out, required, type= fltarr(1)
;        line coordinate
;   value: out, required, type= fltarr(1)
;        values read along the line
 
; EXAMPLE:
;   idl> img = dist(500)
;   idl> x=findgen(500) & y=findgen(500)
;   idl> tvcoord, img, x, y, /scale
;   idl> lineread, img, [10.,300.],[20.,400],x=x,y=y,lout=l,value=ld
;
; HISTORY:
;   written, 17 February 2014, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2014-, All rights reserved by DooSoo Yoon.
;===================================================================================
simg = size(image,/dimension)
xind = indgen(simg[0])
yind = indgen(simg[1])

if not keyword_set(npoint) then npoint=500 

pos0_dev = fltarr(2) & pos1_dev = fltarr(2)
if keyword_set(data) then begin
   pos0_dev[0] = interpol(xind,x,pos0[0])
   pos0_dev[1] = interpol(yind,y,pos0[1])
   pos1_dev[0] = interpol(xind,x,pos1[0])
   pos1_dev[1] = interpol(yind,y,pos1[1])
endif else begin
   if not keyword_set(x) then x = xind
   if not keyword_set(y) then y = yind

   if keyword_set(mouse) then begin
      cursor,x0,y0,/device,/down
      print,x0,y0
      pos0_dev = [x0,y0]
      cursor,x1,y1,/device,/down
      print,x1,y1
      pos1_dev = [x1,y1]
   endif else begin
      pos0_dev = pos0
      pos1_dev = pos1
   endelse
endelse

l = sqrt(total((pos1_dev-pos0_dev)*(pos1_dev-pos0_dev)))

lx = findgen(npoint)/float(npoint)*(pos1_dev[0]-pos0_dev[0]) + pos0_dev[0]
ly = findgen(npoint)/float(npoint)*(pos1_dev[1]-pos0_dev[1]) + pos0_dev[1]
ll = sqrt((lx-pos0_dev[0])^2.+(ly-pos0_dev[1])^2.)

if keyword_set(data) then begin
   lx_data = interpol(x,xind,lx)
   ly_data = interpol(y,yind,ly)
   ll_data = sqrt((lx_data-lx_data[0])^2. + (ly_data-ly_data[0])^2.)
   lout = ll_data
endif else lout=ll

intimg = interpolate(image,lx,ly)
value = intimg
if not keyword_set(no_window) then begin
   plots,lx,ly,/dev,_strict_extra=extra

   window,/free
   if keyword_set(data) then $
      plot,ll_data,intimg,xtitle='distance in data unit',ytitle='value' $
    else $
      plot,ll,intimg,xtitle='distance in device unit',ytitle='value'
endif

end
