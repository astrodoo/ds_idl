pro epsfree
;( =_=)++  =========================================================================
;
; NAME: 
;   EPSFREE
;
; PURPOSE:
;   This routine is purposed to finish the opened EPS configuration and recover 
;   original setting.
;
; RELEVANCE:
;   routine mkeps (mkeps.pro) for establishing the EPS configuration.
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
;
; KEYWORDS:
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
common mydev, mydevice, myPlot
device,/close
set_plot,mydevice
!p = myPlot
end
