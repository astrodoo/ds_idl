pro snapshot,fname,frame=frame,low=low,inverse=inverse,whitebg=whitebg,ps=ps
;( =_=)++  =========================================================================
;
; NAME: 
;   SNAPSHOT
;
; PURPOSE:
;   This routine is designed to extract images from window and save to png file or 
;   eps file. 
;
; DEPENDENCE:
;   mkeps (mkeps.pro) routine for starting up the post script. 
;   epsfree (epsfree.pro) routine for wraping up the post script.
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
;        the output file name without extension. The default extension is set to
;        be '.png', and if '/ps' option is given, the extension will be set to '.eps' 
;
; KEYWORDS:
;   frame: in, optional, type= integer, default= current window
;        the number of window frame to be extracted.
;   low: in, optional, type= boolean
;        if given, the image will be extracted with lower size by B-W color.
;   inverse: in, optional, type= boolean
;        if given, the color of the image will be inversed.
;   whitebg: in, optional, type= boolean
;        if given, black and white colors will be swapped.
;   ps: in, optional, type= boolean
;        if given, the image will be extracted into '.eps' file, not '.png' file.
;
; EXAMPLE:
;   idl> snapshot,'test',/whitebg
;  or
;   idl> snapshot,'test',/ps 
;
; HISTORY:
;   written, 02 August 2006, by DooSoo Yoon.
;   2006.08.09 - add inverse option
;   2007.05.01 - add inverse option for color
;            - add white background option
;            - substract color option (default is color extract)
;             and add the low option (black&white color is optional) 
;   2010.07.12 - add the option that alert the exsited files
;   2012.11.14 - clean up the code and add the ps option
;
;  
; COPYRIGHT:
;   Copyright 2006-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(fname) then fname='test'
if (n_elements(frame) eq 0) then frame=!d.window

if keyword_set(ps) then begin 
   ext='.eps'
   goto, Jump2 
endif else ext='.png'

; checking for the previously exist files to avoid overwriting unintentionally;
; only for .png file since .eps file would be checked in 'mkeps' routine.
chk=''
Jump1:
tmp = file_search(fname+ext)
if (tmp ne '') then begin
   read,fname+ext+' is exist, choose whether overwrite,rename,cancel (o/r/c)? ',chk
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

Jump2:
; draw 
wset,frame

xs=!d.x_size & ys=!d.y_size
if keyword_set(low) then begin           ;black & white extract
   image0=tvrd(true=0)
   if keyword_set(inverse) then begin
      image0=255-image0
      window,/free,/pixmap,xs=xs,ys=ys
      tv,image0
      image0=tvrd(true=0)
   endif
   if keyword_set(ps) then begin 
      tvlct,r0,g0,b0,/get
      loadct,0,/sil
      mkeps,fname
      tv,image0,true=0
      epsfree
   endif else write_png, fname+'.png', image0
endif else begin                         ;color extract
   image1 = tvrd(true=1)
   if keyword_set(inverse) then begin
      image1=255-image1
      window,/free,/pixmap,xs=xs,ys=ys
      tv,image1,true=1
      image1=tvrd(true=1)
   endif
   if keyword_set(whitebg) then begin
      s = size(image1)
; if total(image1[*,i,j]) is 0 or 255, then it would be converted to 255 - image1[*,i,j]
      totColor = total(image1,1)
; extend from 2D to 3D array
      ttC_tmp = replicate({totC:totColor},3)
      ttC = transpose(ttC_tmp.totC,[2,0,1])
      image1[where((ttC eq 0) or (ttC eq 255*3))] = 255 - image1[where((ttC eq 0) or (ttC eq 255*3))]
      window,/free,/pixmap,xs=xs,ys=ys
      tv,image1,true=1
      image1=tvrd(true=1)
   endif
   if keyword_set(ps) then begin 
; in order to describe true color image in post script, color table should be re-ordered 
; as 'tvlct,indgen(256),indgen(256),indgen(256)', and it is same with 'loadct,0'
      tvlct,r0,g0,b0,/get
      tvlct,indgen(256),indgen(256),indgen(256)
      mkeps,fname
      tv,image1,true=1
      epsfree
   endif else write_png, fname+'.png', image1
endelse

; restore original color table
if keyword_set(ps) then tvlct,r0,g0,b0

end
