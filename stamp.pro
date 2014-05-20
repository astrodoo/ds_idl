pro stamp,comment,right=right,left=left,top=top,bottom=bottom,charsize=charsize $
         ,xmargin=xmargin, ymargin=ymargin,_extra=extra
;( =_=)++  =========================================================================
;
; NAME: 
;   STAMP
;
; PURPOSE:
;   Briefly put an stamp on the window or the ps script. 
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
;   comment: in, optional, type= string
;        contens you'd like to describe on the plot.
;
; KEYWORDS:
;   right/top: in, optional, type= boolean
;        the position of the stamp. By default, the position is set to be
;        left & bottome. If either or both options is given, the position will 
;        be changed into right and/or top.
;   (x,y)margin: in, required, type= float, default= 0.
;        x,y margins in the 'Normal' coordinate system 
;
; EXAMPLE:
;   idl> stamp, 'a.pro',/right,/top 
;
; HISTORY:
;   written, 19 June 2010, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2010-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(comment) then comment=''
; default is left & bottom
if not keyword_set(xmargin) then xmargin=0.
if not keyword_set(ymargin) then ymargin=0.
if not keyword_set(charsize) then charsize=1

;read system time
ctime = systime(0)

str = comment+' '+ctime 

ll = strlen(str)
posx1 = 0.03
posx2 = max([0., 1.-ll*0.008*charsize])
posy1 = 0.03
posy2 = 0.97

if keyword_set(right) then posx = posx2 $
                      else posx = posx1
if keyword_set(top)   then posy = posy2 $
                      else posy = posy1

xyouts,posx+xmargin,posy+ymargin,/norm,str,charsize=charsize,_strict_extra=extra
end
