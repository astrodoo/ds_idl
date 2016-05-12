pro mkeps,fname, xsize=xsize, ysize=ysize, _extra=extra
;( =_=)++  =========================================================================
;
; NAME: 
;   MKEPS
;
; PURPOSE:
;   This routine is purposed to establish the EPS configuration when it starts. 
;
; RELEVANCE:
;   routine epsfree (epsfree.pro) for finishing the EPS configuration.
;   function posnorm (posnorm.pro) for chaning the format of the coordinate from 
;   device to normal. 
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
;   fname: in, required, type= string, default= 'test'
;        output file name without extension
;
; KEYWORDS:
;   xsize: in, requred, type= float, default= 20.
;        the x-size of the phost scrip in unit of cm.
;   ysize: in, requred, type= float, default= 20.*!d.y_size/!d.x_size
;        the y-size of the phost scrip in unit of cm.
;   _extra: in, optional
;        extra keywords for 'device' command
;
; EXAMPLE:
;   idl> mkeps,'test.eps',xsize=20.
;   idl> contour, Flux, x, y, position = posnorm([100,400,300,700],nx=400,ny=700)
;   idl> epsfree
;
; HISTORY:
;   written, 26 August 2010, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2010-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(fname) then fname='test'
if not keyword_set(xsize) then xsize=20.
;if not keyword_set(ysize) then ysize=xsize*!d.y_size/!d.x_size
if not keyword_set(ysize) then ysize=xsize*6./8.

common mydev, mydevice, myPlot

; checking for the previously exist files to avoid overwriting unintentionally
chk=''
Jump1:
tmp = file_search(fname+'.eps')
if (tmp ne '') then begin
   read,fname+'.eps is exist, choose whether overwrite,rename,cancel (o/r/c)? ',chk
   case chk of
        'o' : break
        'r' : begin
              read, 'rename: ',out
              goto, Jump1
              end
        'c' : stop
       else : goto, Jump1
   endcase
endif

mydevice = !d.name
myPlot   = !p
set_plot,'ps'
device,filename=fname+'.eps',/color,bits_per_pixel=8,/encapsulated $
      ,xsize=xsize,ysize=ysize,_strict_extra=extra
end
