FUNCTION ticknegexp, axis, index, value 
;( =_=)++  =========================================================================
;
; NAME: 
;   TICKNEGEXP
;
; PURPOSE:
;   This function is purposed to show the ticks for exponential form combined with 
;   negative values. Particularly related with 'polar_contour.pro' procedure when
;   it is used with logarithmic scale.
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
; EXAMPLE:
;   idl> plot,findgen(1000),xtickformat='negtickexp'
;   
;   see the example routine below.
;
; HISTORY:
;   written, 30 August 2016, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2016-, All rights reserved by DooSoo Yoon.
;===================================================================================
; values becomes to the exponent in base-10 
; the negative sign will be attached in the exponential form
sign = sign(value)
exponent = abs(long(value))
; Construct the tickmark string based on the exponent 
tickmark = '10!E' + Strtrim( String( exponent ), 2 ) + '!N' 

negtickind = where(sign eq -1)

if (negtickind ne -1) then $
   tickmark[negtickind] = '-'+tickmark[negtickind]

Return, tickmark 
end


;====================================================================================
pro xnegtickexp

r = findgen(500)^3.+10.     
th = findgen(500)/500.*2.*!pi  
a = dist(500)                                          

window,0

; note that the value of xticks should be n-1, where n is the number of elements in xtickv
polar_contour,a,th,alog10(r),/iso,/fill,nlevels=254,xst=5,yst=5
axis,xaxis=0,/xst,xtickformat='ticknegexp',xtickv=[-7,-5,-3,-1,1,3,5,7],xticks=7         
axis,xaxis=1,/xst,xtickformat='(a1)',xtickv=[-7,-5,-3,-1,1,3,5,7],xticks=7         

axis,yaxis=0,/yst,ytickformat='ticknegexp',ytickv=[-7,-5,-3,-1,1,3,5,7],yticks=7         
axis,yaxis=1,/yst,ytickformat='(a1)',ytickv=[-7,-5,-3,-1,1,3,5,7],yticks=7         

end
