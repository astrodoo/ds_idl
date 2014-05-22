pro coordarray, x, y, z, xout=xout, yout=yout, zout=zout
;( =_=)++  =========================================================================
;
; NAME: 
;   COORDARRAY
;
; PURPOSE:
;   This routine is purposed to generate 2-d (or 3-d) coordinate array from each 1-d 
;   coordinate data.
;
; AUTHOR:
;   DOOSOO YOON
;   Department of Astronomy, UW-Madison
;   475 N. Charter St., Madison, WI 53705
;   Web: http://www.astro.wisc.edu/~yoon
;   E-mail: yoon@astro.wisc.edu
;
; CATEGORY:
;   Util
;
; PARAMS:
;   x,y(,z) : in, required, type= fltarr(1)
;        1-d coordinate data for each direction
;
; KEYWORDS:
;   xout,yout(,zout) : out, required, type= fltarr(nx,ny) or fltarr(nx,ny,nz)
;        the coordinate which is extended to 2-d or 3-d.
;
; EXAMPLE:
;   idl> x = findgen(100) & y = findgen(200) & z = findgen(300)
;   idl> coordarray,x,y,z,xout=x3d,yout=y3d,zout=z3d
;
; HISTORY:
;   written, 22 May 2014, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2014-, All rights reserved by DooSoo Yoon.
;===================================================================================
if (n_elements(z) eq 0) then dim = 2 else dim = 3

nx = n_elements(x) & ny = n_elements(y)
if (dim eq 2) then begin
   xout = x # replicate(1.,ny)
   yout = replicate(1.,nx) # y
endif else if (dim eq 3) then begin
   nz = n_elements(z)
   
   xx = x # replicate(1.,ny)
   xxx = replicate({xx:fltarr(nx,ny)},nz)
   xxx.xx = xx
   xout = xxx.xx

   yy = replicate(1.,nx) # y
   yyy = replicate({yy:fltarr(nx,ny)},nz)
   yyy.yy = yy
   yout = yyy.yy

   zz = z # replicate(1.,ny)
   zzz = replicate({zz:fltarr(nz,ny)},nx)
   zzz.zz = zz & z3d = zzz.zz
   zout = transpose(z3d)
endif

end
