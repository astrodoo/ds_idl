pro png2gif,fname,animate=animate,out=out,dir=dir,sample=sample,step=step
;( =_=)++  =========================================================================
;
; NAME: 
;   PNG2GIF
;
; PURPOSE:
;   This routine is aimed to convert image files from png to gif format, as well as
;   to generate animated-gif file by combining the gif image files.
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
;   animate: in, optional, type= boolean
;        if given, animated-gif file will be generated.
;   out: in, optional, type= string, default= 'test'
;        the name of animated-gif without extension
;   dir: in, required, type= string, default= 'gifs'
;        the directory name for dumping gif files from png files.
;   sample: in, optional, type= int
;        the number of gif files from png files.
;        it should be less than the total number of png files.
;   step: in, requried, type= int, default= 1
;        the step of dumping gif from png files.
;
; EXAMPLE:
;   idl> png2gif,'JetSet_hdf5',step=2,/animate,out='wind' 
;
; HISTORY:
;   written, 01 January 2011, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2011-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(fname) then fname=''
if not keyword_set(out) then out='test'
if not keyword_set(dir) then dir='gifs'

spawn,'mkdir '+dir

fnames = file_search('*'+fname+'*.png')
nfiles = n_elements(fnames)

fnames2 = strarr(nfiles)
for i=0,nfiles-1 do fnames2[i] = strmid(fnames[i],0,strlen(fnames[i])-4)

if not keyword_set(step) then begin
   if keyword_set(sample) then begin
      if nfiles lt sample then begin
         print,'need more sample'
         stop
      endif 
      step = fix(nfiles/sample)
   endif else step=1
endif

print,'step is ',step
for i=0,nfiles-1,step do begin
    print,i+1,'   of',nfiles
    spawn,'convert '+fnames[i]+' '+dir+'/'+fnames2[i]+'.gif'
endfor

if keyword_set(animate) then $
   spawn,'gifsicle '+dir+'/*'+fname+'*'+' --loop --verbose --colors 256 -> '+out+'.gif'
end
