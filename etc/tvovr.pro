PRO TVOVR, image, x, y, TRANS=trans
; Copyright (c) 2000, Oleg Kornilov, oleg.kornilov@mail.ru.
;+
; NAME:
;	TVOVR
; PURPOSE:
;	Overlaying true-color image over displayed image
; CALLING SEQUENCE:
;	TVOVR, image [, x, y]
; INPUTS:
;	image: image for overlay (TRUE=1)
;	x, y (optional): position to overlay
; KEYWORDS:
;	trans: transparency (0.0-1.0)
;-
IF NOT KEYWORD_SET(TRANS) THEN trans=0
IF N_PARAMS() NE 3 THEN BEGIN
	x=0   &   y=0
	ENDIF
ims=SIZE(image)
IF ((x GE !d.x_size) OR (y GE !d.y_size)) THEN RETURN
ims(2)=!d.x_size-x < ims(2)   &   ims(3)=!d.y_size-y < ims(3)
image=image(*, 0:ims(2)-1, 0:ims(3)-1)
image0=TVRD(x, y, ims(2), ims(3), TRUE=1)
sub=WHERE(image(0, *, *) OR image(1, *, *) OR image(2, *, *))*3
IF sub(0) NE -3  THEN  BEGIN
	image0(sub)=trans*image0(sub)+(1-trans)*image(sub)
	image0(sub+1)=trans*image0(sub+1)+(1-trans)*image(sub+1)
	image0(sub+2)=trans*image0(sub+2)+(1-trans)*image(sub+2)
	ENDIF
TV, image0, x, y, TRUE=1
END
