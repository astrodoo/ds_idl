function rot_3d, data, rotaxis=rotaxis, degree=degree, _extra=extra
;( =_=)++  =========================================================================
;
; NAME: 
;   ROT_3D
;
; PURPOSE:      
;   This fucntion is purposed to rotate 3-d array by using intrinsic rot fuction.
;
; AUTHOR:
;   DOOSOO YOON
;   Department of Astronomy, UW-Madison
;   475 N. Charter St., Madison, WI 53705
;   Web: http://www.astro.wisc.edu/~yoon
;   E-mail: yoon@astro.wisc.edu
;
; CATEGORY:
;   Array
;
; PARAMS:
;   data: in, required, type= fltarr(3)
;        objective data array. It should be 3 dimension.
;
; KEYWORDS:
;   rotaxis: in, required, type= int(1 or 2 or 3), default= 1 
;        rotational axis
;   degree: in, required, type=float
;        rotating degree in clockwise direction.
;
; EXAMPLE:
;   idl> a= findgen(300,200,400)
;   idl> b= rot_3d(a,rotaxis=1,degree=30.)
;
; HISTORY:
;   written, 03 December 2013, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2013-, All rights reserved by DooSoo Yoon.
;===================================================================================
print,"start rotating of 3-d array"

sd = size(data)
if (sd[0] ne 3) then begin
  print, "The data should be 3-dimension"
  stop
endif else print, "the dimension of the data: ", sd[1], sd[2], sd[3]

if not keyword_set(rotaxis) then rotaxis=1

rotdata = fltarr(sd[1],sd[2],sd[3])
minv = min(data) / 100.

case rotaxis of 
   1: for i=0,sd[rotaxis]-1 do rotdata[i,*,*] = rot(reform(data[i,*,*],sd[2],sd[3]),degree, missing=minv,_strict_extra=extra)
   2: for i=0,sd[rotaxis]-1 do rotdata[*,i,*] = rot(reform(data[*,i,*],sd[1],sd[3]),degree, missing=minv,_strict_extra=extra)
   3: for i=0,sd[rotaxis]-1 do rotdata[*,*,i] = rot(reform(data[*,*,i],sd[1],sd[2]),degree, missing=minv,_strict_extra=extra)
   else: print, "no match of rotation axis"
endcase

return, rotdata
end
