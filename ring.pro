function ring, xcenter, ycenter, radius, npoint=npoint, ra=ra, th=th, eccentric=eccentric $
        ,major_th=major_th
;( =_=)++  =========================================================================
;
; NAME: 
;   RING
;
; PURPOSE:
;   This function is purposed to get the x,y coordinates around circle in given xc,yc
;   and radius of it.  
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
;   type= fltarr(2, npoints) 
;      [0, npoint] -> x coordinates
;      [1, npoint] -> y coordinates
;
; PARAMS:
;   xcenter: in, required, type= float
;          x coordinate for center of the circle or ellipse
;   ycenter: in, required, type= float
;          y coordinate for center of the circle or ellispe
;   radius: in, required, type= float
;          the radius of the circle, or major length of the ellipse
;
; KEYWORDS:
;   npoint: in, required, type= int, default= 200
;          the number of the points (x,y) generating circle
;   ra: in, optional, type= boolean 
;          in case of RA/DEC domain.
;   th: in, optional, type= fltarr(2)
;          [th0,th1] in unit of radian  
;          in case you want to draw the part of the circle. 
;   eccentric: in, optional, type= float
;          eccentricity to draw ellipse  (r = a*(1-e)/(1+cos(th)))
;   major_th: in, optional, type= float  (degree)
;          in case of given 'eccentric' kewyord, it chooses the initiative angle of
;          the major axis
;        
; EXAMPLE:
;   idl> plots, ring(10,20,40),/data, color=30
; 
;  to draw ellipse
;   idl> plots, ring(10,20,40,eccentric=0.5,major_th=45.),/data
;
; HISTORY:
;   written, 01 January 2010, by DooSoo Yoon.
;   2012.11.15 - clean up
;   2012.11.28 - add the options (th, eccentric, major_th)
;  
; COPYRIGHT:
;   Copyright 2010-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(npoint) then npoint=200

if not keyword_set(th) then th=[0.,2.*!pi]
points = ( (th[1]-th[0]) / float(npoint-1))*findgen(npoint) + th[0]

if keyword_set(eccentric) then begin
   if not keyword_set(major_th) then major_th=0.
   major = radius
   major_th = major_th * !dtor
   radius = major*(1.-eccentric^2.)/(1.+eccentric*cos(points))
endif

if keyword_set(ra) then x = xcenter + radius*cos(points) / cos(ycenter*!pi/180.) $
 else begin
   if keyword_set(eccentric) then begin
      x = xcenter + major*eccentric*cos(major_th) + radius*cos(points+major_th)
      y = ycenter + major*eccentric*sin(major_th) + radius*sin(points+major_th)
   endif else begin 
      x = xcenter + radius*cos(points) 
      y = ycenter + radius*sin(points)
   endelse
endelse

return, transpose([[x],[y]])
end
