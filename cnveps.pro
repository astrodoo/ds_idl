pro cnveps,objname,outname=outname,jpg=jpg,png=png
;( =_=)++  =========================================================================
;
; NAME: 
;   CNVEPS
;
; PURPOSE:
;   This routine is aimed to change the type of picture between eps and jpg/png.
;
; DEPENDENCE:
;   Exclusive command 'gs', ghost script, is necessary to convert EPS into jpg/png.
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
;   objname: in, required, type= string
;        objective file (.eps, .jpg, .png) including extention in file name.
;   outname: in, required, type= string, default=same as objective name 
;        output file without extension.
;
; KEYWORDS:
;   jpg or png: in, optional, type= boolean, default= jpg format is preferred. 
;        In case of changing from EPS into jpg/png.
;
; EXAMPLE:
;   idl> cnveps,'test.eps',/png,outname='abc'
;   idl> cnveps,'test.png',outname='testtt'
;
; HISTORY:
;   written, 15 February 2010, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2010-, All rights reserved by DooSoo Yoon.
;===================================================================================
org_fmt = strmid(objname,3,4,/reverse)
if (org_fmt eq 'jpeg') then n_fmt = 5 else n_fmt=4
org_name = strmid(objname,0,strlen(objname)-n_fmt)
if not keyword_set(outname) then outname = org_name
if (not keyword_set(jpg)) and (not keyword_set(png)) then png = 1

chk = ''
case org_fmt of
   '.png' : img_from = read_png(objname)
   '.jpg' : read_jpeg,objname,img_from,true=1
   'jpeg' : read_jpeg,objname,img_from,true=1
   '.eps' : begin
              if keyword_set(png) then out = outname+'.png' $
                else if keyword_set(jpg) then out = outname+'.jpg'

; checking for the previously exist files to avoid overwriting unintentionally
              Jump1:
              tmp = file_search(out)
              if (tmp ne '') then begin
                 read,out+' is exist, choose whether overwrite,rename,cancel (o/r/c)?',chk
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
; convert EPS -> PNG or Jpeg via "gs" command
              if keyword_set(png) then begin
                 spawn,'gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -dGraphicsAlphaBits=4 -dEPSCrop -sOutputFile='+out+' '+objname
                 stop 
              endif else if keyword_set(jpg) then begin
                 spawn,'gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=jpeg -dEPSCrop -sOutputFile='+out+' '+objname
                 stop
              endif else begin
                 print,'Something wrong!!'
                 stop
              endelse
           end
  else   : print,'You should input files in eps,jpg,png'
endcase

out = outname+'.eps'
; checking for the previously exist files to avoid overwriting unintentionally
Jump2:
tmp = file_search(out)
if (tmp ne '') then begin
   read,out+' is exist, choose whether overwrite,rename,cancel (o/r/c)?',chk
   case chk of
      'o' : break 
      'r' : begin
              read, 'rename: ',out
              goto, Jump2
            end
      'c' : stop
     else : goto, Jump2
   endcase
endif

; convert Jpeg,PNG -> EPS
mydevice = !D.NAME
ss = size(img_from)
nx = ss[2] & ny = ss[3]
set_plot,'PS'
device,/color,filename=out,/encapsulated,bits_per_pixel=8,xsize=20.,ysize=20.*ny/nx
tvlct,r0,g0,b0,/get
tvlct,indgen(256),indgen(256),indgen(256)
tv,img_from,true=1
device,/close
set_plot,mydevice
tvlct,r0,g0,b0
stop
end
