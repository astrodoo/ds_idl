; $Id: image_cont.pro,v 1.11 2004/01/21 15:54:55 scottm Exp $
;
; Copyright (c) 1988-2004, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.

pro img_vel, a,u,v, WINDOW_SCALE = window_scale, ASPECT = aspect, $
	INTERP = interp,min = min, max = max, scaling=scaling, $
        random=random,color=color,position=position
;+
; NAME:
;	IMAGE_CONT
;
; PURPOSE:
;	Overlay an image and a contour plot.
;
; CATEGORY:
;	General graphics.
;
; CALLING SEQUENCE:
;	IMAGE_CONT, A
;
; INPUTS:
;	A:	The two-dimensional array to display.
;
; KEYWORD PARAMETERS:
; WINDOW_SCALE:	Set this keyword to scale the window size to the image size.
;		Otherwise, the image size is scaled to the window size.
;		This keyword is ignored when outputting to devices with 
;		scalable pixels (e.g., PostScript).
;
;	ASPECT:	Set this keyword to retain the image's aspect ratio.
;		Square pixels are assumed.  If WINDOW_SCALE is set, the 
;		aspect ratio is automatically retained.
;
;	INTERP:	If this keyword is set, bilinear interpolation is used if 
;		the image is resized.
;
; OUTPUTS:
;	No explicit outputs.
;
; COMMON BLOCKS:
;	None.
;
; SIDE EFFECTS:
;	The currently selected display is affected.
;
; RESTRICTIONS:
;	None.
;
; PROCEDURE:
;	If the device has scalable pixels, then the image is written over
;	the plot window.
;
; MODIFICATION HISTORY:
;	DMS, May, 1988.
;-
imin=min(a)
imax=max(a)
arr_len=0.5
if keyword_set(min) then imin=min
if keyword_set(max) then imax=max
on_error,2                      ;Return to caller if an error occurs
sz = size(a)			;Size of image
if sz[0] lt 2 then message, 'Parameter not 2D'
if keyword_set(position) then p=position

	;set window used by contour
contour,[[0,0],[1,1]],/nodata, xstyle=4, ystyle = 4,position=p,/norm

px = !x.window * !d.x_vsize	;Get size of window in device units
py = !y.window * !d.y_vsize
swx = px[1]-px[0]		;Size in x in device units
swy = py[1]-py[0]		;Size in Y
six = float(sz[1])		;Image sizes
siy = float(sz[2])
aspi = six / siy		;Image aspect ratio
aspw = swx / swy		;Window aspect ratio
f = aspi / aspw			;Ratio of aspect ratios

dosub = 0
loadct,13
if (!d.flags and 1) ne 0 then begin	;Scalable pixels?
  if keyword_set(aspect) then begin	;Retain aspect ratio?
				;Adjust window size
	if f ge 1.0 then swy = swy / f else swx = swx * f
	endif

  tv,bytscl(a,min=imin,max=imax),p[0],p[1],xsize = p[2]-p[0], ysize = p[3]-p[1], /norm
endif else begin	;Not scalable pixels	
   if keyword_set(window_scale) then begin ;Scale window to image?
	tvscl,bytscl(a,min=imin,max=imax),px[0],py[0]	;Output image
	swx = six		;Set window size from image
	swy = siy
        ; If image is larger than window, only contour portion
        ; that fits within the window.
        doSubx = (px[0]+swx) gt !d.x_size
        doSuby = (py[0]+swy) gt !d.y_size
        doSub = (doSubx || doSuby)
        if (doSub) then begin
            nsubx = doSubx ? !d.x_size-px[0] : swx
            nsuby = doSuby ? !d.y_size-py[0] : swy
            sub_u = u[0:nsubx-1,0:nsuby-1]
            sub_v = v[0:nsubx-1,0:nsuby-1]
        endif
    endif else begin		;Scale window
	if keyword_set(aspect) then begin
		if f ge 1.0 then swy = swy / f else swx = swx * f
		endif		;aspect
	tv,poly_2d(bytscl(a,min=imin,max=imax),$	;Have to resample image
		[[0,0],[six/swx,0]], [[0,siy/swy],[0,0]],$
		keyword_set(interp),swx,swy), $
		px[0],py[0]
	endelse			;window_scale
  endelse			;scalable pixels
loadct,0

mx = !d.n_colors-1		;Brightest color
colors = [mx,mx,mx,0,0,0]	;color vectors
if !d.name eq 'PS' then colors = mx - colors ;invert line colors for pstscrp

;Do the contour.
if (dosub) then begin
 if keyword_set(scaling) then arr_len=7/260.
 if not keyword_set(random) then $
 velovect2,sub_u,sub_v,/noerase, c_color =  colors ,length=arr_len ,position=position $
 else $
 vel2,sub_u,sub_v,nvec=random,/noerase,color=color,position=position
	
endif else begin
 if keyword_set(scaling) then arr_len=7/260.*10.
 if not keyword_set(random) then $
 velovect2,u,v,/noerase, c_color =  colors, length=arr_len ,position=position $
 else $
 vel2,u,v,nvec=random,/noerase,color=color,position=position
endelse
return
end
