pro img2data, fname, scale=scale, true=true, xlim=xlim, ylim=ylim, xlog=xlog, ylog=ylog $
    , out=out, reproduce=reproduce
;( =_=)++  =========================================================================
;
; NAME: 
;   IMG2DATA
;
; PURPOSE:
;   Read image file for any type such as .png .jpg .gif,
;   and collect the data by mouse button
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
;   fname: in, required, type= string
;        objective file (.jpg, .png ...) including extention in file name.
;
; KEYWORDS:
;   scale: in, optional, type= float, default= 1.
;        Scale factor to displaying image 
;   true: in, optional, type= float, default= 1
;        true factor to displaying image (see tv command)
;   xlim/ylim: in, required, type fltarr [min,max]
;        range of the plot
;   xlog/ylog: in, optional, type= boolean, default= 0
;        if given, the axis is in logarithmic scale.
;   out: in, optional, type=string
;        save the collected data to .sav file
;   reproduce: in, optional, type=boolean
;        if given, it opens another window and reproduce the plot with collected data points.
;
; EXAMPLE:
;   idl> img2data, 'test1.png', xlim=[1e-6,1.], ylim=[1e-6,9.],/xlog,/ylog,/reproduce 
;
; HISTORY:
;   written, 30 March 2017, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2017-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(true) then true=1
if not keyword_set(scale) then scale=1.
if not keyword_set(imgwindow) then imgwindow=0

display,fname,scale=scale,true=true,/silent

print,'### clikc the left, bottom position of the axis ###'
cursor,x0,y0,/device,/down
plots,x0,y0,psym=4,symsize=3,color=cgColor('blue'),/dev

print,'### clikc the right, top   position of the axis ###'
cursor,x1,y1,/device,/down
plots,x1,y1,psym=4,symsize=3,color=cgColor('blue'),/dev

print,'Here are the position [x0,y0,x1,y1] of the plot (in unit of pixel): '
print, x0,y0,x1,y1
x0=float(x0) & x1=float(x1) & y0=float(y0) & y1=float(y1)

xdatsav = 0. & ydatsav = 0.

while 1 do begin

   cursor,xx,yy,/device,/down

   plots, [x0,x1],[yy,yy],/dev, color=cgColor('magenta')
   plots, [xx,xx],[y0,y1],/dev, color=cgColor('magenta')

   if (!mouse.button eq 4) then break     ; quit if right button of the mouse is pushed. 

   if not keyword_set(xlog) then begin
      xdat = (xx-x0)/(x1-x0)*(xlim[1]-xlim[0]) + xlim[0] 
   endif else begin
      xlimlg = alog10(xlim)
      xdat = 10.^((xx-x0)/(x1-x0)*(xlimlg[1]-xlimlg[0]) + xlimlg[0])
   endelse
   if not keyword_set(ylog) then begin
      ydat = (yy-y0)/(y1-y0)*(ylim[1]-ylim[0]) + ylim[0]
   endif else begin
      ylimlg = alog10(ylim)
      ydat = 10.^((yy-y0)/(y1-y0)*(ylimlg[1]-ylimlg[0]) + ylimlg[0])
   endelse

   print,xdat,ydat

   xdatsav = [xdatsav,xdat]
   ydatsav = [ydatsav,ydat]
endwhile

xdatsav = xdatsav[1:n_elements(xdatsav)-1]
ydatsav = ydatsav[1:n_elements(ydatsav)-1]

if keyword_set(out) then save,filename=out,xdatsav,ydatsav

if keyword_set(reproduce) then begin
   window,xs=!d.x_size, ys=!d.y_size

   if keyword_set(xlog) then strxlg = ',/xlog,xminor=9' else strxlg=''
   if keyword_set(ylog) then strylg = ',/ylog,yminor=9' else strylg=''

   strexe = execute('plot, xdatsav, ydatsav, psym=dsym(6,/fill), position=[x0,y0,x1,y1],/dev,/xst,/yst, xra=xlim, yra=ylim, charsize=2.5, symsize=1'+strxlg+strylg)

endif
stop
end
