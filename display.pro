pro display, fname, scale=scale, silent=silent, true=true
;( =_=)++  =========================================================================
;
; NAME: 
;   DISPLAY
;
; PURPOSE:
;   Read image file for any type such as .png .jpg .gif ... and display on window
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
;   silent: in, optional, type= boolean, default= false
;        Whether it shows the information of the image.
;
; EXAMPLE:
;   idl> display,'test.png',scale=0.5,true=1
;
; HISTORY:
;   written, 27 September 2013, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2013-, All rights reserved by DooSoo Yoon.
;===================================================================================
qry = Query_image(fname,info)
if not keyword_set(silent) then begin
   help, info,/structure
endif

if not keyword_set(true) then true=1
if not keyword_set(scale) then scale=1.

window,xsize=info.dimensions[0]*scale,ysize=info.dimensions[1]*scale,/free 
if (info.has_palette) then begin
   tvlct,r_org,g_org,b_org,/get
   img = read_image(fname, rr, gg, bb)
   img2 = congrid(img, info.dimensions[0]*scale, info.dimensions[1]*scale)
   device, decomposed=0
   tvlct,rr,gg,bb
   tv,img2
   tvlct,r_org,g_org,b_org
endif else begin
   img = read_image(fname)
   case true of
     1: img2 = congrid(img,info.channels, info.dimensions[0]*scale, info.dimensions[1]*scale)
     2: img2 = congrid(img,info.dimensions[0]*scale, info.channels, info.dimensions[1]*scale)
     3: img2 = congrid(img,info.dimensions[0]*scale, info.dimensions[1]*scale, info.channels)
     else: begin 
            print,'true number should be one of 1,2,3.'
            stop
          end
   endcase
   tv,img2,true=true
endelse
end
