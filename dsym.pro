function dsym, theSymbol, thick=thick, color=color, fill=fill
;( =_=)++  =========================================================================
;
; NAME: 
;   DSYM   
;
; PURPOSE:
;   This function is aimed to describe a number of the symbols in graphic routine
;   such as plot or oplot by using usersym configuration.  
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
; RETURN:
;   type= int, default= 8
;     The return value is typically 8 implying the usage of 'usersym'. The variety 
;     of the sym shape will be drawn by usersym in the fucntion.
;
; PARAMS:
;   theSymbol: in. required, type= int
;     the number of the symbol you wish to use(0 ~ 20)
;       0  : No symbol.
;       1  : Plus sign.
;       2  : Asterisk.
;       3  : Dot (period).
;       4  : Diamond.
;       5  : Upward triangle.
;       6  : Square.
;       7  : X.
;       8  : Circle.
;       9  : Downward triangle.
;      10  : Rightfacing triangle.
;      11  : Leftfacing triangle.
;      12  : Big cross.
;      13  : Circle with plus.
;      14  : Circle with X.
;      15  : 4 point Star.
;      16  : 5 point Star.
;      17  : Down arrow.
;      18  : Up arrow.
;      19  : Left arrow.
;      20  : Right arrow. 
;
; KEYWORDS:
;   thick: in, required, type= float, default= 1 or !p.thick
;     thickness of the symbol
;   color: in, optional, type= float
;     color of the symbol
;   fill: in, optional, type= boolean
;     if given, the symbol will be filled. 
;
; EXAMPLE:
;
;   IDL> plot, findgen(10), psym=dsym(16,color=fsc_color('blue'),/fill) 
;
; HISTORY:
;   written, 17 November 2012, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2012-, All rights reserved by DooSoo Yoon.
;===================================================================================
on_error, 2

; Error checking.
if (n_elements(theSymbol) eq 0) then return, 0 
if (n_elements(thick) eq 0) then thick = (!p.thick eq 0)?1 : !p.thick
if not keyword_set(fill) then fill = 0
if (theSymbol lt 0) or (theSymbol gt 20) then message, 'Symbol number out of range [0~20].'

theSymbol = fix(theSymbol)

; Use user defined symbol by default.
result = 8

case theSymbol of
   0  : result = 0    ; No symbol.
   1  : begin         ; plus sign. 
          xx=[1, -1, 0, 0, 0]
          yy=[0, 0, 0, -1, 1] 
          fill=0
        end
   2  : result = 2    ; Asterisk.
   3  : result = 3    ; Dot (period).
   4  : begin         ; diamond.
          xx=[0,1,0,-1,0]
          yy=[1,0,-1,0,1]
        end
   5  : begin         ; upward triangle.
          xx=[-1,0,1,-1]
          yy=[-1,1,-1,-1]
        end
   6  : begin         ; square.
          xx=[-1,1,1,-1,-1]
          yy=[1,1,-1,-1,1]
        end
   7  : result = 7    ; X.
   8  : begin         ; circle.
          phi = findgen(36) * (!pi * 2 / 36.)
          phi = [ phi, phi(0) ]
          xx=cos(phi)
          yy=sin(phi)
        end
   9  : begin          ; downward facing triangle
          xx=[-1,0,1,-1] 
          yy=[1,-1,1,1]
        end
  10  : begin          ; rightfacing triangle.
          xx=[-1,1,-1,-1]
          yy=[1,0,-1,1]
        end
  11  : begin          ; leftfacing triangle.
          xx=[1,-1,1,1]
          yy=[1,0,-1,1]
        end
  12  : begin          ; Big cross.
          xx=[1,0.3,0.3,-0.3,-0.3,-1,-1,-0.3,-0.3,0.3,0.3,1,1]
          yy=[0.3,0.3,1,1,0.3,0.3,-0.3,-0.3,-1,-1,-0.3,-0.3,0.3]
        end
  13  : begin          ; Circle with plus.
          xx=[1,.866,.707,.500,0,-.500,-.707,-.866,-1,-.866,-.707,-.500,0,.500,.707,.866,1,-1,0,0,0]
          yy=[0,.500,.707,.866,1,.866,.707,.500,0,-.500,-.707,-.866,-1,-.866,-.707,-.500,0,0,0,1,-1]
          fill=0
        end
  14  : begin          ; Circle with X.
          xx=[1,.866,.707,.500,0,-.500,-.707,-.866,-1,-.866,-.707,-.500,0,.500,.707,.866,1,.866,.707,-.707,0,.707,-.707]
          yy=[0,.500,.707,.866,1,.866,.707,.500,0,-.500,-.707,-.866,-1,-.866,-.707,-.500,0,.500,.707,-.707,0,-.707,.707]
          fill=0
        end
  15  : begin          ; 4 point Star.
          xx=[-1,-.33,0,.33,1,.33,0,-.33,-1]
          yy=[0,.33,1,.33,0,-.33,-1,-.33,0]
        end
  16  : begin          ; 5 point Star
          ang = (360. / 10 * findgen(11) + 90) / !radeg  
          r = ang*0
          r[2*indgen(6)] = 1.
          cp5 = cos(!pi/5.)
          r1 = 2. * cp5 - 1. / cp5
          r[2*indgen(5)+1] = r1
          r = r / sqrt(!pi/4.) * 2. / (1.+r1)
          xx = r * cos(ang)   &   yy = r * sin(ang)
        end
  17  : begin          ; down arrow 
          xx=[0,0,.5,0,-.5]
          yy=[0,-2,-1.4,-2,-1.4]
          fill=0
        end
  18  : begin          ; up arrow
          xx=[0,0,.5,0,-.5]
          yy=[0,2,1.4,2,1.4]
          fill=0
        end
  19  : begin          ; left arrow
          xx=[0,-2,-1.4,-2,-1.4]
          yy=[0, 0, 0.5, 0, -.5]
          fill=0
        end
  20  : begin          ; right arrow
          xx=[0,2,1.4,2,1.4]
          yy=[0,0,0.5,0,-.5]
          fill=0
        end
endcase

if (result eq 8) then begin
   if keyword_set(color) then $ 
      usersym, xx, yy, thick=thick, color=color, fill=fill $
    else $
      usersym, xx, yy, thick=thick, fill=fill
endif 

   return, result
end 
