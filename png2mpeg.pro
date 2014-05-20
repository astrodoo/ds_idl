pro png2mpeg, fname, speed=speed, out=out
;( =_=)++  =========================================================================
;
; NAME: 
;   PNG2MPEG
;
; PURPOSE:
;   This routine is aimed to generate mpeg movie clip by combining the png image files. 
;
; DEPENDENCE:
;   Exclusive command 'convert', component of Imagemagick, is required to change
;   the type of images from .png to .gif
;   Exclusive command 'gifsicle', component of Imagemagick, is requried to combine
;   all the gif files into animated-gif file.
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
;        any parts of the objective file name to read.
;        for instance, if you want to read 'JetSet_hdf5_*.png' files
;        fname can be set as 'JetSet_hdf5'
;
; KEYWORDS:
;   speed: in, required, type= int, default= 1
;        extending movie time by putting multiple image files additionally.
;   out: in, required, type= string, default= 'test'
;        the name of output .mpeg file.
;
; EXAMPLE:
;   idl> png2mpeg,'JetSet_hdf5',speed=2
;
; HISTORY:
;   written, 01 January 2011, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2011-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(fname) then fname=''
if not keyword_set(out) then out='test'
if not keyword_set(speed) then speed=1 else speed=fix(speed)

fnames = file_search('*'+fname+'*.png')
nfiles = n_elements(fnames)

img = read_png(fnames[0])
imgsz = size(img)

print,'writing to mpeg...'
mpegfname='mv_'+out+'.mpeg'
mpegid=mpeg_open([imgsz[2],imgsz[3]],quality=100)
for i=0,nfiles-1 do begin
    img = read_png(fnames[i])
    for j=0,speed-1 do $
        mpeg_put,mpegid,/color,image=img,frame=i*speed+j,/order
endfor
mpeg_save,mpegid,filename=mpegfname

end

