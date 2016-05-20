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

ss = size(vx,/dimension)

if keyword_set(sample) then begin
   nx = long(float(ss[0])/float(sample)) 
   ny = long(float(ss[1])/float(sample))

   vx2 = congrid(vx,nx,ny,/center)
   vy2 = congrid(vy,nx,ny,/center)
   if keyword_set(coord2d) then begin
      x2 = congrid(x,nx,ny,/center)
      y2 = congrid(y,nx,ny,/center)
   endif else begin
      x2  = congrid(x,nx,/center)
      y2  = congrid(y,ny,/center)
   endelse
endif else begin
   nx = ss[0]
   ny = ss[1]
   
   vx2 = vx
   vy2 = vy
   x2  = x
   y2  = y
endelse 

if not keyword_set(vmax) then vmax = max(sqrt(vx2*vx2 + vy2*vy2))

dx2 = (x2[2]-x2[1])/2.

xx1 = fltarr(nx*ny)
xx2 = fltarr(nx*ny)
yy1 = fltarr(nx*ny)
yy2 = fltarr(nx*ny)

vv   = sqrt(vx2*vx2 + vy2*vy2)
fact = vv/vmax
factind = where(fact ge 1.)
if (factind[0] ne -1) then fact[factind] = 1.

for j=0,ny-1 do begin
    for i=0,nx-1 do begin
        if (vv[i,j] ne 0) then begin
           if keyword_set(coord2d) then begin
              xx1[i+j*nx] = x2[i,j] - vx2[i,j]/vv[i,j]*fact[i,j]*dx2*asize
              xx2[i+j*nx] = x2[i,j] + vx2[i,j]/vv[i,j]*fact[i,j]*dx2*asize
              yy1[i+j*nx] = y2[i,j] - vy2[i,j]/vv[i,j]*fact[i,j]*dx2*asize
              yy2[i+j*nx] = y2[i,j] + vy2[i,j]/vv[i,j]*fact[i,j]*dx2*asize
           endif else begin
              xx1[i+j*nx] = x2[i] - vx2[i,j]/vv[i,j]*fact[i,j]*dx2*asize
              xx2[i+j*nx] = x2[i] + vx2[i,j]/vv[i,j]*fact[i,j]*dx2*asize
              yy1[i+j*nx] = y2[j] - vy2[i,j]/vv[i,j]*fact[i,j]*dx2*asize
              yy2[i+j*nx] = y2[j] + vy2[i,j]/vv[i,j]*fact[i,j]*dx2*asize
           endelse 
        endif else begin
           if keyword_set(coord2d) then begin
              xx1[i+j*nx] = x2[i,j]
              xx2[i+j*nx] = x2[i,j]
              yy1[i+j*nx] = y2[i,j]
              yy2[i+j*nx] = y2[i,j]
           endif else begin
              xx1[i+j*nx] = x2[i]
              xx2[i+j*nx] = x2[i]
              yy1[i+j*nx] = y2[j]
              yy2[i+j*nx] = y2[j]
           endelse
        endelse
    endfor
endfor

inDomain_ind = where(((xx1<xx2) ge !x.crange[0]) and ((xx1>xx2) le !x.crange[1])  $
                 and ((yy1<yy2) ge !y.crange[0]) and ((yy1>yy2) le !y.crange[1]))
xx1 = xx1(inDomain_ind)
xx2 = xx2(inDomain_ind)
yy1 = yy1(inDomain_ind)
yy2 = yy2(inDomain_ind)

arrow,xx1,yy1,xx2,yy2,/data,color=color,hsize=-1./5,hthick=3.,_strict_extra=extra

end
