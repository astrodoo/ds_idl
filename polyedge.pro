pro polyedge,x,y,device=device,normal=normal,data=data,color=color,alpha=alpha,transparent=transparent
;( =_=)++  =========================================================================
;
; NAME: 
;   POLYEDGE
;
; PURPOSE:
;   This routine is mainly aimed to draw polyfill with edge line.
;   Also, this can draw the transparent polyfill into the plot (or tv, contour images), 
;   of which the window mode is "window" not "ps"
;
; DEPENDENCE:
;   trp_color.pro
;
;
; AUTHOR:
;   DOOSOO YOON
;   Shanghai Astronomical Observatory (SHAO)
;   80 Nandan Rd., Shanghai 200030, China
;   Web: http://center.shao.ac.cn/~yoon
;   E-mail: yoon@shao.ac.cn
;
; CATEGORY:
;   Graphic
;
; PARAMS:
;   x,y: in, required, type= fltarr
;        the x, y coordinates where the polyfill cover
;
; KEYWORDS:
;   device,normal,data: in, required, type= Boolean (default: device=1)
;        the type of the coordinates 
;   color: in, required, type= inteager 
;        color of the polyfill & edge line
;   alpha: in, required, type= float (0~1) (default: 0.3)
;        the factor of dilution for the color in polyfill
;        In case of using w/ transparent option, this indicates the level of transparency.
;   transparent: in, optional, type= Boolean
;        indicates if the polyfill is transparent or not. 
;        only works when the window mode is "window" not "ps"
;
; EXAMPLE:
;   idl> polyedge,x,y,/data,color=fsc_color('blue'),alpha=0.2,/transparent
;   or, 
;   see below test procedures
;
; HISTORY:
;   written, 19 January 2016, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2016-, All rights reserved by DooSoo Yoon.
;===================================================================================

case 1 of 
   n_elements(device): opt=',/device'
   n_elements(normal): opt=',/normal'
   n_elements(data):   opt=',/data'
   else: opt=',/device'
endcase

if not keyword_set(alpha) then alpha=0.3

if keyword_set(transparent) then begin 
   img_org = tvrd(/true)
   colorstr = 'trp_color('+strtrim(color,2)+')'
endif else colorstr = 'trp_color('+strtrim(color,2)+',alpha='+strtrim(alpha,2)+',/silent)'

tvlct,r,g,b,/get
exe1 = execute('polyfill,x,y'+opt+',color='+colorstr)

if keyword_set(transparent) then begin
   img_poly = tvrd(/true)

   img_final = alpha*img_poly + (1.-alpha)*img_org
   tv,img_final,/true
endif   

tvlct,r,g,b
if (opt=',/data') then oplot,x,y,color=color $
   else exe2 = execute('plots,x,y'+opt+',color='+strtrim(color,2)) 

end


;----------------------------------------------------------------------------------
; test sets
pro test1
device,decomposed=0
loadct,39,/sil
x=findgen(100)/100.
y=findgen(100)/100.

!p.background=255 & !p.color=0
window,0
plot,x,y,/xst,/yst

x1=0.2 & x2=0.5
y1=0.1 & y2=0.7

polyedge,[x1,x2,x2,x1,x1],[y1,y1,y2,y2,y1],/data,color=fsc_color('blue') ;,/transparent

stop
end

pro test2
device,decomposed=0
loadct,39,/sil

nx=600
x=findgen(nx)/100.
y=findgen(nx)/100.

img = dist(nx)

!p.background=255 & !p.color=0
loadct,0,/sil
window,0,xs=800,ys=800
tvcoord,img,x,y,/axes,color=0

x1=1. & x2=3.
y1=1. & y2=4.

polyedge,[x1,x2,x2,x1,x1],[y1,y1,y2,y2,y1],/data,color=fsc_color('yellow'),/transparent

stop
end


pro test3
device,decomposed=0
loadct,39,/sil

nx=600
x=findgen(nx)/100.
y=findgen(nx)/100.

img = dist(nx)

;!p.background=255 & !p.color=0
loadct,0,/sil
;window,0,xs=800,ys=800

x1=1. & x2=3.
y1=1. & y2=4.

; original image + edge line
mkeps,'test_org',xs=20,ys=20.
tvcoord,img,x,y,/axes,color=0
tvlct,r,g,b,/get
oplot,[x1,x2,x2,x1,x1],[y1,y1,y2,y2,y1],color=fsc_color('yellow'),thick=5
epsfree

; polyfill image + edge line
mkeps,'test_poly',xs=20,ys=20.
tvlct,r,g,b
tvcoord,img,x,y,/axes,color=0
polyfill,[x1,x2,x2,x1,x1],[y1,y1,y2,y2,y1],/data,color=fsc_color('yellow')
oplot,[x1,x2,x2,x1,x1],[y1,y1,y2,y2,y1],color=fsc_color('yellow'),thick=5
epsfree

cnveps,'test_org.eps',/png
cnveps,'test_poly.eps',/png

img_org = read_png('test_org.png')
img_poly = read_png('test_poly.png')

alpha=0.3

img_final = alpha*img_poly + (1.-alpha)*img_org

; drawing the results
mkeps,'test_final',xs=20.,ys=20.
tvlct,r,g,b
tv,img_final,/true
epsfree

imgsz = size(img_org,/dimension)
window,xs=imgsz[1],ys=imgsz[2]
tv,img_final,/true

stop
end



