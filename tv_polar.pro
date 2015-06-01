pro tv_polar,imgIN,radiusIN,thetaIN,xout=xout,yout=yout,imgout=imgout,no_window=no_window,resol=resol $
    ,no_roff=no_roff,maxr=maxr,position=position,th0=th0,scale=scale, extrapol=extrapol
;( =_=)++  =========================================================================
;
; NAME: 
;   TV_POLAR
;
; PURPOSE:
;   Given the 2D image data in circular coordinate(r,theta), tv the image.
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
;   imgIN: in, required, type= fltarr(2)
;      2D image data array in circular coordinate (r, theta).
;   radiusIN: in, required, type= fltarr(1)
;      radius coordinate. This should be over the zero.
;   thetaIN: in, required, type=fltarr(1)
;      theta coordinate.
;
; KEYWORDS:
;   xout/yout: out, optional, type= fltarr(resol)
;      output (x/y)-grid values in the dimension of resol
;   imgout: out, optional, type= fltarr(resol,resol)
;      output image converted to cartesian uniform grid
;   resol: in, required, type= int, default= n_elements(radius)*2
;      the resolution of the transformed tv-image into [resol x resol]
;   no_roff: in, optional, type= boolean
;      If given, inner boundary will be filled with the adjescent color.
;      By default, it will be shown in zero value beyond the inner boundary.
;   maxr: in, optionl, type= float
;      maximum radius, in case of zooming the circle with specific radius.
;   position: in, optional, type= fltarr(2)
;      The position, of tv-image in device coordinate [x,y]
;   th0: in, required, type= float, default= 0.
;      Starting theta position in radian unit.
;   scale: in, optional, type= boolean
;      auto-scale or not
;   no_window: in, optional, type= boolean
;      no tv-ing to window for the purpose of getting image out without show-off
;
; EXAMPLE:
;   idl> a=dist(500)
;   idl> r=findgen(500)/500.*10.+0.1 & th=findgen(500)/500.*2.*!pi
;   idl> window,0,xs=500,ys=500 
;   idl> tv_polar,bytscl(a,max=300,min=100),r,th,/no_roff,xout=xgrid,yout=ygrid
;
; HISTORY:
;   written, 13 February 2009, by DooSoo Yoon.
;   2012.11.25 - Cleaned up 
;   2014.01.28 - modify
;  
; COPYRIGHT:
;   Copyright 2009-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(resol) then resol = n_elements(radiusIN)
if keyword_set(th0) then theta = theta + th0 else th0 = 0.

n1=n_elements(radiusIN)
n2=n_elements(thetaIN)

img = imgIN
radius = radiusIN
theta = thetaIN

; in case that the theta is not whole circle (0~2pi), 
; add dummy theta array in theta & image.
dth = theta[1]-theta[0]
if (theta[n2-1]+2*dth-th0 lt 2.*!pi) then begin
   print, 'make extra theta (current theta < 2 pi)'
   th2 = 2.*!pi + th0 - theta[n2-1] 
   nth_empty = ceil(th2/dth)
   th_empty = findgen(nth_empty)/float(nth_empty)*th2 + theta[n2-1] + dth 

   n22 = n2 + nth_empty
   theta = [theta,th_empty]
   img2 = replicate(0,n1,n22)
   img2[*,0:n2-1] = img & img = img2
   n2 = n22
endif

; convert to retangular coordinate from polar coordinate
x=fltarr(n1,n2)
y=fltarr(n1,n2)
tmp_img=fltarr(n1,n2)
;tmp_i=indgen(n1)#replicate(1,n2)
tmp_r=radius#replicate(1,n2)
;tmp_j=replicate(1,n1)#indgen(n2)
tmp_th=replicate(1,n1)#theta
;x[tmp_i+n1*tmp_j]=tmp_r*cos(tmp_th)
;y[tmp_i+n1*tmp_j]=tmp_r*sin(tmp_th)
;tmp_img[tmp_i+n1*tmp_j]=img
x=tmp_r*cos(tmp_th)
y=tmp_r*sin(tmp_th)
tmp_img=img

; zoom out the image with range 0 ~ maxr
if keyword_set(maxr) then begin
   ind_in=where((abs(x) lt maxr) and (abs(y) lt maxr))
   x2=x[ind_in]
   y2=y[ind_in]
   tmp_img2=tmp_img[ind_in]
endif else begin
   x2=x
   y2=y
   tmp_img2=tmp_img
endelse

; generate triangles and interpolate each values to uniform grids
miss=min(tmp_img2) 

triangulate, x2, y2, tr, boundary

if keyword_set(extrapol) then $
   pol_img=trigrid(x2, y2, tmp_img2, tr, xgrid=xout, ygrid=yout, nx=resol, ny=resol,extrapolate=boundary,/quintic) $
 else pol_img=trigrid(x2, y2, tmp_img2, tr, xgrid=xout, ygrid=yout, nx=resol, ny=resol, missing=miss)

; fill with black circle to indicate inner boundary
if not keyword_set(no_roff) then begin
   r_off=min(radius)-(radius[1]-radius[0])/2.
   if (r_off lt 0) then begin
      print,'inner offset radius is below zero!!'
      stop
   endif
   x_tmp=findgen(resol)/float(resol)*(max(x2)-min(x2))+min(x2)
   y_tmp=findgen(resol)/float(resol)*(max(y2)-min(y2))+min(y2)
   crd_xy=fltarr(2,long(resol)*long(resol))
   xx=x_tmp#replicate(1,resol)
   yy=replicate(1,resol)#y_tmp
   crd_xy[0,*]=xx
   crd_xy[1,*]=yy
   pol_img[where(sqrt(crd_xy[0,*]^2+crd_xy[1,*]^2) le r_off)] = miss
endif

if keyword_set(position) then $
   optstr = ','+strtrim(position[0],1)+','+strtrim(position[1],1)+',/device' $
 else optstr = ''

imgout=pol_img
if not keyword_set(no_window) then begin
; draw tv image
  if keyword_set(scale) then exestr = execute('tvscl,pol_img'+optstr) $
    else exestr = execute('tv,pol_img'+optstr)
endif

end
