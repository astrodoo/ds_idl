pro tvcoord, img, x, y, position=position, axes=axes, psx=psx , scale=scale, _extra=extra, imgsize=imgsize, true=true
;( =_=)++  =========================================================================
;
; NAME: 
;   TVCOORD
;
; PURPOSE:
;   tv with coordinate system 
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
;   img: in, required, type= fltarr(2)
;      2 dimensional image data to be drawn
;   x/y: in, required, type= fltarr(1)
;      1 dimensional coordinate data in x & y
;
;
; KEYWORDS:
;   position: in, optional, type= fltarr(2) (unit: pixel in 'X', normal in 'PS')
;      position, [x0,y0], for tv-ed image in device coordinate
;      if the plotting device is 'PS' not 'X', it will be automtically off.
;   axes: in, optional, type= boolean
;      if given, the axes around the tv image will be plotted. Only when "PS" is on.
;   psx: in, optional, type= float (unit: normal)
;      if !d.name = 'PS' (postscript), this keyword indicates the width of x size 
;   scale: in, optional, type= boolean
;      if given, automatically scaled like 'tvscl'
;   imgsize: in, required, type= float, default= 0.8 (normalized value). Only when both "axes" & "PS" options is on.
;      the relative size of the image to entire window size 
;   true: in, optional, one of (0,1,2,3), default=0
;      the option 'true' in tv 
;      
; EXAMPLE:
;   idl> img=dist(500)
;   idl> x=findgen(500)/500. & y=findgen(500)/500.
;   idl> window,0,xs=500,ys=500
;   idl> tvcoord,img,x,y
;  or in postscript
;   idl> mkeps, 'test'
;   idl> tvcoord,img,x,y,/on,psx=18.,position=[0.2,0.1]
;   idl> epsfree
;
; HISTORY:
;   written, 20 November 2012, by DooSoo Yoon.
;   2012.12.12: adding psx option to tv the figure with certain width(cm)
;               now we can use 'on' option & position option also in 'PS' device
;   2013.04.16: adding imgsize option to setup the relative size of the image 
;               when the 'on' option is activated in 'PS' device
;   2013.09.24: fix the bug associating with position
;  
; COPYRIGHT:
;   Copyright 2012-, All rights reserved by DooSoo Yoon.
;===================================================================================

if not keyword_set(position) then begin 
   if keyword_set(axes) then begin
      if keyword_set(!d.name eq 'PS') then position=[0.1,0.1] $
        else position=[100.,100.] 
   endif else position=[0.,0.]
endif

if not keyword_set(true) then true=0

if not keyword_set(imgsize) then imgsize = 0.8

sz = size(img,/dimension)

case true of 
  0: begin
      xsz=sz[0] & ysz=sz[1]
     end
  1: begin
      xsz=sz[1] & ysz=sz[2]
     end
  2: begin
      xsz=sz[0] & ysz=sz[2]
     end
  3: begin
      xsz=sz[0] & ysz=sz[1]
     end
  else: begin
         print,'illegal true value'
        end
endcase

if keyword_set(!d.name eq 'PS') then begin
   xsize = !d.x_size/!d.x_px_cm
   ysize = !d.y_size/!d.y_px_cm
   if not keyword_set(psx) then $
      psx = n_elements(axes) ? imgsize : 1.

   psy=psx*float(ysz)/xsz *xsize/ysize

   print,'psx, psy [normal] = ',psx,psy

   if (psy gt 1.) then print,"the image is over the whole canvas!"
endif

if ((xsz ne n_elements(x)) or (ysz ne n_elements(y))) then $
   message, 'image size should be equivalent with the size of x & y'

if (!d.name eq 'X') then begin
   plot,x,y,/xst,/yst,/nodata,xrange=[min(x),max(x)],yrange=[min(y),max(y)] $
       ,position=[position[0],position[1],position[0]+xsz-1,position[1]+ysz-1],/dev, xtickformat='(a1)', ytickformat='(a1)',/noerase

   if keyword_set(scale) then tv,bytscl(img,max=max(img),min=min(img)),position[0],position[1],true=true $
      else tv,img,position[0],position[1],true=true

   if keyword_set(axes) then plot,x,y,/xst,/yst,/noerase,/nodata, xrange=[min(x),max(x)],yrange=[min(y),max(y)] $
       ,position=[position[0],position[1],position[0]+xsz-1,position[1]+ysz-1],/dev,_strict_extra=extra
endif else if (!d.name eq 'PS') then begin
   plot,x,y,/xst,/yst,/nodata, xrange=[min(x),max(x)],yrange=[min(y),max(y)] $
       ,position=[position[0],position[1],position[0]+psx,position[1]+psy],/norm $
       ,xtickformat='(a1)', ytickformat='(a1)',/noerase

   if keyword_set(scale) then tv,bytscl(img,max=max(img),min(img)),position[0]*xsize,position[1]*ysize $
                                ,/centimeter,xsize=psx*xsize,ysize=psy*ysize,true=true $
      else tv,img,position[0]*xsize,position[1]*ysize,/centimeter,xsize=psx*xsize,ysize=psy*ysize,true=true

   if keyword_set(axes) then plot,x,y,/xst,/yst,/nodata,/noerase, xrange=[min(x),max(x)],yrange=[min(y),max(y)]  $
       ,position=[position[0],position[1],position[0]+psx,position[1]+psy],/norm $
       ,_strict_extra=extra
endif
end
