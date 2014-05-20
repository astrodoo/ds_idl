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
;          x coordinate for center of the circle
;   ycenter: in, required, type= float
;          y coordinate for center of the circle
;   radius: in, required, type= float
;          the radius of the circle
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
;   major_th: in, optional, type= float
;          in case of given 'eccentric' kewyord, it choose the initiative angle of
;          the major axis
;        
; EXAMPLE:
;   idl> plots, ring(10,20,40),/data, color=30
; 
;  to draw ellipse
;   idl> plots, ring(10,20,40,eccentric=0.5,major_th=!pi/2.),/data
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
   radius = radius*(1.-eccentric^2.)/(1.+eccentric*cos(points-major_th))
endif

if not keyword_set(ra) then $
   x = xcenter + radius * cos(points) $
 else $
   x = xcenter + radius * cos(points) / cos(ycenter * !pi/180.)

y = ycenter + radius * sin(points)

return, transpose([[x],[y]])
end
