pro vect_2d, vx, vy, x, y, sample=sample, asize=asize $
           , vmax=vmax, coord2d=coord2d, _extra=extra
;( =_=)++  =========================================================================
;
; NAME: 
;   VECT_2D
;
; PURPOSE:
;   Drawing the vector field with vx & vy and the coordinate of x & y 
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
;   vx/vy: in, required, type= fltarr(2)
;        velocity in x/y direction. Combine two components and generate the vector
;        of total velocity.
;   x/y: in, required, type= fltarr(1)
;        x/y coordinate.
;
; KEYWORDS:
;   sample: in, required, type= integer, default= 20
;        sampling the number of the vector field.
;        total number of each components is determined by Nx/sample, therefore
;        higher value of sample implies poor resolution.
;   asize: in, required, type= float, default= 1.
;        the size of the arrow head
;   vmax: in, required, type= float, default= max(sqrt(vx^2+vy^2))
;
; EXAMPLE:
;   idl> x=findgen(500) & y=findgen(500)
;   idl> vx=dist(500) & vy=dist(500) 
;   idl> window,0,xs=500,ys=500
;   idl> plot,x,y,/nodata,position=[0.,0.,1.,1.],/normal
;   idl> tvscl,vx
;   idl> vect_2d,vx,vy,x,y
;
; HISTORY:
;   written, 01 January 2009, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2009-, All rights reserved by DooSoo Yoon.
;===================================================================================
;if not keyword_set(sample) then sample=20
if not keyword_set(asize) then asize=1.

sz = size(vx,/dimension)

sztot = sz[0]*sz[1]

if not keyword_set(coord2d) then  $
   coordarray,x,y,xout=x2d,yout=y2d $
 else begin
   x2d = x
   y2d = y
endelse

if keyword_set(sample) then begin
   if (sample ge sztot) then goto, Jump
   arrind_tot = lindgen(sztot)
   mult = sztot/sample
   arrind = where((arrind_tot mod mult) eq 0)
   
   narr = n_elements(arrind)
   vx2 = vx[arrind]
   vy2 = vy[arrind]
   x2  = x2d[arrind]
   y2  = y2d[arrind]
endif else begin
Jump:
   narr = sztot
   vx2 = vx
   vy2 = vy
   x2  = x2d
   y2  = y2d
endelse 

if not keyword_set(vmax) then vmax = max(sqrt(vx2*vx2 + vy2*vy2))

dx2 = (x2[2]-x2[1])/2.

xx1 = fltarr(narr)
xx2 = fltarr(narr)
yy1 = fltarr(narr)
yy2 = fltarr(narr)

vv   = sqrt(vx2*vx2 + vy2*vy2)
fact = vv/vmax
factind = where(fact ge 1.)
if (factind[0] ne -1) then fact[factind] = 1.

for i=0L, narr-1L do begin
    if (vv[i] ne 0) then begin
       xx1[i] = x2[i] - vx2[i]/vv[i]*fact[i]*dx2*asize
       xx2[i] = x2[i] + vx2[i]/vv[i]*fact[i]*dx2*asize
       yy1[i] = y2[i] - vy2[i]/vv[i]*fact[i]*dx2*asize
       yy2[i] = y2[i] + vy2[i]/vv[i]*fact[i]*dx2*asize
    endif else begin
       xx1[i] = x2[i]
       xx2[i] = x2[i]
       yy1[i] = y2[i]
       yy2[i] = y2[i]
    endelse
endfor

inDomain_ind = where(((xx1<xx2) ge !x.crange[0]) and ((xx1>xx2) le !x.crange[1])  $
                 and ((yy1<yy2) ge !y.crange[0]) and ((yy1>yy2) le !y.crange[1]))
xx1 = xx1(inDomain_ind)
xx2 = xx2(inDomain_ind)
yy1 = yy1(inDomain_ind)
yy2 = yy2(inDomain_ind)

arrow,xx1,yy1,xx2,yy2,/data,color=color,hsize=-1./5,hthick=3.,_strict_extra=extra

end
