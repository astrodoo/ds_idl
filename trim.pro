pro trim,fname,mult=mult,recover=recover
;( =_=)++  =========================================================================
;
; NAME: 
;   TRIM
;
; PURPOSE:
;   This routine is designed to trim files with some interval
;
; AUTHOR:
;   DOOSOO YOON
;   Department of Astronomy, UW-Madison
;   475 N. Charter St., Madison, WI 53705
;   Web: http://www.astro.wisc.edu/~yoon
;   E-mail: yoon@astro.wisc.edu
;
; CATEGORY:
;   Util
;
; PARAMS:
;   fname: in, required, type= string
;        the part of filename in files which are desired to be trimmed.
;
; KEYWORDS:
;   mult: in, required, type= integer, default= 5
;        interval of the remained file (rest of files moves to 'trim_files' folder)
;   recover: in, optional, type= boolean
;        if given, the trimmed files would be recovered
;
; EXAMPLE:
;   idl> trim,'hdfra',multi=2
;
; HISTORY:
;   written, 13 June 2012, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2012-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(fname) then fname='plt_'

if keyword_set(recover) then begin
   spawn,'mv trim_files/* .'
   stop
endif

if not keyword_set(mult) then mult=5

fnames = file_search('*'+fname+'*')

spawn,'mkdir tmp_jet'

find = indgen(n_elements(fnames))
fnames1 = fnames[where((find mod mult) ne 0)]

for i=0, n_elements(fnames1)-1 do begin
    print,'mv '+fnames1[i]+' trim_files/    (last: '+fnames[n_elements(fnames)-1]+')'
    spawn,'mv '+fnames1[i]+' trim_files/'
endfor

stop
end
