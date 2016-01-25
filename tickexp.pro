FUNCTION tickexp, axis, index, value 
;( =_=)++  =========================================================================
;
; NAME: 
;   TICKEXP
;
; PURPOSE:
;   This function is purposed to show the ticks in exponential format.
;
; ORIGINAL:
;   logticks_exp.pro by Paul van Delst, CIMSS/SSEC
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
; EXAMPLE:
;   idl> plot,findgen(1000),xtickformat='tickexp'
;
; HISTORY:
;   written, 25 January 2016, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2016-, All rights reserved by DooSoo Yoon.
;===================================================================================
; Determine the base-10 exponent 
exponent   = long( alog10( value ) ) 
; Construct the tickmark string based on the exponent 
tickmark = '10!E' + Strtrim( String( exponent ), 2 ) + '!N' 

Return, tickmark 
end
