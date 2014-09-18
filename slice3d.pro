pro slice3d, image,xy=xy,yz=yz,xz=xz,noinfo=noinfo,limits=limits,_extra=extra
;( =_=)++  =========================================================================
;
; NAME: 
;   SLICE3D
;
; PURPOSE:
;   Analogous to profiles.pro, which is a intrinsic routine, this routine shows
;   a structure of 3-dimensional data interactively by mouse scroll.  
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
;   image: in, required, type= fltarr(3)
;         3-dimensional dataset
;
; KEYWORDS:
;   xy, yz, xz: in, required for one of them, type= boolean
;         the plane of the slice in the image you can hover
;         (this image should be up before running this routine)
;   noinfo: in, optional, type= boolean, default= 0
;         if given, it shows no information such as x, y coordinates
;   limits: in, optional, type= fltarr(2), default= not given
;         limits[0] = minimum value & limits[1] = maximum value
;         if not given, it will be scaled by minimum & maximum of sliced output (auto scaling). 
;   extra: for any extensions of text in information.
;
; EXAMPLE:
;   idl> file=FILEPATH('head.dat', SUBDIR=['examples', 'data'])  
;   idl> OPENR, UNIT, file, /GET_LUN 
;   idl> data = BYTARR(80, 100, 57, /NOZERO) 
;   idl> READU, UNIT, data 
;   idl> CLOSE, UNIT 
;   idl> multi=7
;   idl> data = rebin(data,80*multi,100*multi,57*multi)
;   idl> window,xs=80*multi, ys=57*multi
;   idl> tvscl,data[*,100*multi/2,*]
;
;   idl> slice3d,data,/xz
;
; HISTORY:
;   written, 21 May 2013, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2013-, All rights reserved by DooSoo Yoon.
;===================================================================================
if keyword_set(limits) then begin
   minv = limits[0] & maxv = limits[1]
endif

s = size(image,/dimension)

org_img = tvrd(true=1)
orig_w = !d.window
nx = s[0]
ny = s[1]
nz = s[2]

print,'Left mouse button to toggle between rows and columns.'
print,'Right mouse button to Exit.'

flag = 0
case 1 of 

n_elements(xy): begin 
      nwx1 = nx
      nwx2 = ny
      nwy1 = (nwy2 = nz)
      oldx = nx & oldy = ny
      tt1  = 'xz (horizontal)' & tt2 = 'yz (vertical)'
      target1 = '[*,y,*]' & target2 = '[x,*,*]'
      leg1 = 'x: ' & leg2 = 'y: '
      nwln1 = '[x,x],[0,!d.y_size]' 
      nwln2 = '[y,y],[0,!d.y_size]'
      flag+=1
    end
n_elements(yz): begin 
      nwx1 = (nwx2 = nx)
      nwy1 = ny
      nwy2 = nz
      oldx = ny & oldy = nz
      tt1  = 'xy (horizontal)' & tt2 = 'xz (vertical)'
      target1 = '[*,*,y]' & target2 = '[*,x,*]'
      leg1 = 'y: ' & leg2 = 'z: '
      nwln1 = '[0,!d.x_size],[x,x]'
      nwln2 = '[0,!d.x_size],[y,y]'
      flag+=1
    end
n_elements(xz): begin 
      nwx1 = nx
      nwy1 = ny
      nwx2 = ny
      nwy2 = nz
      oldx = nx & oldy = nz
      tt1  = 'xy (horizontal)' & tt2 = 'yz (vertical)'
      target1 = '[*,*,y]' & target2 = '[x,*,*]'
      leg1 = 'x: ' & leg2 = 'z: '
      nwln1 = '[x,x],[0,!d.y_size]'
      nwln2 = '[0,!d.x_size],[y,y]'
      flag+=1
    end
else: begin
      print,'One of ''xy,yz,zx'' option should be selected for currently displayed image'
      stop
    end
endcase

if (flag ge 2) then begin
   print,'Only one of ''xy,yz,zx'' should be selected.'
   stop
endif

window,/free ,xs=nwx1, ys=nwy1,title='slice3d  '+ tt1 
new_w = !d.window
old_mode = 0				;Mode = 0 for rows, 1 for cols
;old_font = !p.font			;Use hdw font
;!p.font = 0
mode = 0

while 1 do begin
   wset,orig_w		;Image window
   cursor,x,y,2,/dev	;Read position
   tv,org_img,true=1

 
   if (!mouse.button eq 1) then begin
      mode = 1-mode	;Toggle mode
      repeat cursor,x,y,0,/dev until !mouse.button eq 0
   endif
  
   if mode then $
      plots,[x,x],[0,!d.y_size],/dev,line=2 $
    else $
      plots,[0,!d.x_size],[y,y],/dev,line=2 

   if not keyword_set(noinfo) then begin
      xyouts,10,oldy-20,/dev,leg1+strtrim(x,2),charsize=2,_strict_extra=extra
      xyouts,10,oldy-40,/dev,leg2+strtrim(y,2),charsize=2,_strict_extra=extra
   endif

;   print,x,y
   device, window_state = ws
   wins = where(ws ne 0)
   if ((where(wins eq new_w))[0] ge 0) then wset, new_w else return

   if (!mouse.button eq 4) then begin		;Quit
      wset,orig_w
;      wdelete, new_w
      print,'new display window number is: ', new_w
;      !p.font = old_font
      return
   endif
   if (mode ne old_mode) then begin
      old_mode = mode
      if mode then begin
         wdelete, new_w 
         window, /free,xs=nwx2, ys=nwy2,title='slicer3d  '+ tt2 
         new_d = !d.window
       endif else begin
         wdelete, new_w
         window, /free,xs=nwx1, ys=nwy1,title='slicer3d  '+ tt1 
         new_d = !d.window
       endelse
    endif 

    if mode then begin
       if not keyword_set(limits) then begin
          print,'hello'
          exetxt3 = execute('minv = min(image'+target2+')')
          exetxt4 = execute('maxv = max(image'+target2+')')
       endif
       exetxt  = execute('tv,bytscl(image'+target2+', min=minv, max=maxv)') 
    endif else begin 
       if not keyword_set(limits) then begin
          print,'hello'
          exetxt3 = execute('minv = min(image'+target1+')')
          exetxt4 = execute('maxv = max(image'+target1+')')
       endif
       exetxt = execute('tv,bytscl(image'+target1+', min=minv, max=maxv)')
    endelse

    if not keyword_set(noinfo) then $
       if mode then begin
          exetxt2 = execute('plots,'+nwln2+',/dev,line=2')
          xyouts,10,nwy2-20,/dev,leg2+strtrim(y,2),charsize=2,_strict_extra=extra
       endif else begin
          exetxt2 = execute('plots,'+nwln1+',/dev,line=2')
          xyouts,10,nwy1-20,/dev,leg1+strtrim(x,2),charsize=2,_strict_extra=extra
       endelse
endwhile
end

pro mkdata     ; generate data set for the purpose of test 
file=FILEPATH('head.dat', SUBDIR=['examples', 'data']) 
 
; Open the data file: 
OPENR, UNIT, file, /GET_LUN 
 
; Create an array to hold the data: 
data = BYTARR(80, 100, 57, /NOZERO) 
 
; Read the data into the array: 
READU, UNIT, data 
 
; Close the data file: 
CLOSE, UNIT 

multi=7
data = rebin(data,80*multi,100*multi,57*multi)
stop
end
