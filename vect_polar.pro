pro vect_polar,vr,vth,r,th,color=color $
              ,asize=asize,th0=th0,vmax=vmax
;( =_=)++  =========================================================================
;
; NAME: 
;   VECT_POLAR
;
; PURPOSE:
;   This routine is aimed to draw the velocity vector field in polar coordinate
;
; DEPENDENCE:
;   sample.pro for reducing the number of arrows
;
; AUTHOR:
;   DOOSOO YOON
;   Shanghai Astronomical Observatory
;   80 Nandan Rd, Shanghai 200030, China
;   Web: http://center.shao.ac.cn/~yoon
;   E-mail: yoon@shao.ac.cn
;
; CATEGORY:
;   Graphic
;
; PARAMS:
;   vr/vth: in, required, type= fltarr(:,:)
;        velocity components in r- or theta-direction
;   r/th: in, required, type= fltarr(:,:)
;        position components in r- or theta-direction 
;
; KEYWORDS:
;   color: in, optional, type= int, default= 0
;        color of the arrows
;   asize: in, optional, type= float, default= 0.6
;        size of the arrows
;   th0: in, optional, type= float, default=0
;        for the case that the theta coordinate is shifted for th0.
;   vmax: in, optional, type= float, default= max(sqrt(vr^2 + vth^2))
;        maximum velocity which is used for the normalization.
;
; EXAMPLE:
;   with given data set
;   idl> vector_polar, vr, vth, r, th
;
; HISTORY:
;   written, 29 June 2016, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2016-, All rights reserved by DooSoo Yoon.
;===================================================================================
sz   = size(vr,/dimension)

if not keyword_set(color) then color=0
if not keyword_set(opt) then opt = 3
if not keyword_set(asize) then asize=0.6
if not keyword_set(th0) then th0 = 0.

th = th + th0

if not keyword_set(vmax) then $
   vmax = max(sqrt(vr*vr + vth*vth))    ; for normalization

coordarray,r,th, xout=r2d, yout=th2d

x2d = r2d*cos(th2d) 
y2d = r2d*sin(th2d)

vx = vr*cos(th2d) - vth*sin(th2d)
vy = vr*sin(th2d) + vth*cos(th2d)

vxnorm = vx/vmax
vynorm = vy/vmax

arrx1 = x2d - vxnorm*asize
arrx2 = x2d + vxnorm*asize
arry1 = y2d - vynorm*asize
arry2 = y2d + vynorm*asize

for j=0,sz[1]-1 do $
    for i=0,sz[0]-1 do $
        if ((min([arrx1[i,j],arrx2[i,j]]) ge !x.crange[0]) and   $
            (max([arrx1[i,j],arrx2[i,j]]) le !x.crange[1]) and   $
            (min([arry1[i,j],arry2[i,j]]) ge !y.crange[0]) and   $
            (max([arry1[i,j],arry2[i,j]]) le !y.crange[1])) then $
          arrow,arrx1[i,j],arry1[i,j],arrx2[i,j],arry2[i,j],/data,color=color,hsize=-1./5,hthick=3.

end
