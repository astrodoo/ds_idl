function today,opt
;( =_=)++  =========================================================================
;
; NAME: 
;   today
;
; PURPOSE:
;   This routine is aimed to get string of date in the format of "YYMMDD"
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
;   opt: in, optional, type= string, default=''
;        optional string behind the timestamp
;
; EXAMPLE:
;   idl> tt = today('_1')
;
; HISTORY:
;   written, 27 August 2014, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2014-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(opt) then opt=''

date_in = cgtimestamp(10)

mm = strmid(date_in,1,2)
dd = strmid(date_in,3,2)
yy = strmid(date_in,7,2)

date_out = yy+mm+dd+opt

return, date_out
end
