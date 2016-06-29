function sample, arr, factor=factor, order=order
;( =_=)++  =========================================================================
;
; NAME: 
;   SAMPLE
;
; PURPOSE:
;   This function is purposed to reduce the array divided by the factor (i.e., sampling)
;
; AUTHOR:
;   DOOSOO YOON
;   Shanghai Astronomical Observatory
;   80 Nandan Rd, Shanghai 200030, China
;   Web: http://center.shao.ac.cn/~yoon
;   E-mail: yoon@shao.ac.cn
;
; CATEGORY:
;   Utility
;
; RETURN:
;   type= array() 
;
; PARAMS:
;   array: in, required, type= array (1D/2D/3D)
;          array input
;
; KEYWORDS:
;   factor: in, required, type= int or intarr(1/2/3), default= 2
;          sampling factor
;          if given as a form of integer, the size of the array would be reduced by the factor.
;          if the type is intarr(1/2/3), then the array will be downsized by the factor 
;          (1/2/3) of each array direction. 
;   order: in, optional, type= int, default=0
;          combined with integer type of the factor parameter, 
;          the factor will be applied in 
;          0: all direction
;          1: 1st direction
;          2: 2nd direction
;          3: 3rd direction
;        
; EXAMPLE:
;   idl> a = findgen(10,10,10)
;   idl> b = sample(a,factor=2)
;   
;   or,
;   idl> b = sample(a,factor=[2,5,2])
;
;   or,
;   idl> b = sample(a,factor=2,order=2)
;
; HISTORY:
;   written, 29 June 2016, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2016-, All rights reserved by DooSoo Yoon.
;===================================================================================

if not keyword_set(factor) then factor = 2
if not keyword_set(order) then order = 0

sz = size(arr)
dimarr = sz[0]

szfactor = (size(factor))[0]

ind1 = indgen(sz[1])
if (szfactor) then fact1 = factor[0] $
   else if ((order eq 0) or (order eq 1)) then fact1 = factor $
   else fact1 = 1
smp_ind1 = where((ind1 mod fact1) eq 0)
nsmp1 = n_elements(smp_ind1)

if (dimarr ge 2) then begin
   ind2 = indgen(sz[2]) 
   if (szfactor) then fact2 = factor[1] $
      else if ((order eq 0) or (order eq 2)) then fact2 = factor $
      else fact2 = 1
   smp_ind2 = where((ind2 mod fact2) eq 0)
   nsmp2 = n_elements(smp_ind2)
endif

if (dimarr eq 3) then begin
   ind3 = indgen(sz[3])
   if (szfactor) then fact3 = factor[2] $
      else if ((order eq 0) or (order eq 3)) then fact3 = factor $
      else fact3 = 1
   smp_ind3 = where((ind3 mod fact3) eq 0)
   nsmp3 = n_elements(smp_ind3)
endif

case dimarr of
     1: smparr = arr[smp_ind1]
     2: begin
          smparr = replicate(arr[0], nsmp1, nsmp2)

          for j=0,nsmp2-1 do $
              for i=0,nsmp1-1 do $
              smparr[i,j] = arr[smp_ind1[i],smp_ind2[j]]
        end
     3: begin
          smparr = replicate(arr[0], nsmp1, nsmp2, nsmp3)
          
          for k=0,nsmp3-1 do $
              for j=0,nsmp2-1 do $
                  for i=0,nsmp1-1 do $
                      smparr[i,j,k] = arr[smp_ind1[i],smp_ind2[j],smp_ind3[k]]
        end
  else: begin
          print,'the maximum dimension of the array is 3'
          stop
        end
endcase

return, smparr

end
