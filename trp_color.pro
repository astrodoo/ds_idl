function trp_color,color,alpha=alpha,whitebg=whitebg,blackbg=blackbg,triple=triple $
         ,silent=silent
;( =_=)++  =========================================================================
;
; NAME: 
;   TRP_COLOR
;
; PURPOSE:
;   This function is used to assign the color blending with background, which mimics
;   transparent effect.
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
;   type= int
;     it will return the number of color table index after overlaid the designated 
;     color on the index.  
;
; PARAMS:
;   color: in, required, type= int or intarr(1,3)
;        color to be aimed to change its transparency.
;        default type is int, but when triple option is given, the type can be 
;        changed to intarr(1,3).
;
; KEYWORDS:
;   alpha: in, required, type= float, default=0.5
;        coloar would be blended by
;        background*(1-alpha) + color*alpha
;   whitebg: in, optional, type= boolean
;        blending with white color [255,255,255]
;   blackbg: in, optional, type= boolean
;        blending with white color [0,0,0]
;   triple:  in, optional, type= boolean
;        if given, the data type of the color would be intarr(1,3) that indicate
;        r,g,b, colors in true color system.    
;   silent:  in, optional, type= boolean
;        no message will be printed.
;
; EXAMPLE:
;
;   IDL> loadct,39
;   IDL> !p.background = trp_color(50,alpha=0.2,/whitebg)
;   IDL> window,0
;
; HISTORY:
;   written, 13 November 2012, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2012-, All rights reserved by DooSoo Yoon.
;===================================================================================

if (n_elements(alpha) eq 0) then alpha=0.5

tvlct,r,g,b,/get
case 1 of 
   n_elements(whitebg): begin
                          if not keyword_set(silent) then $
                             print,'blending w/ white background color'
                          bg=[255,255,255]
                        end
   n_elements(blackbg): begin
                          if not keyword_set(silent) then $
                             print,'blending w/ black background color'
                          bg=[0,0,0]
                        end
   else: begin
           if not keyword_set(silent) then $
              print,'blending w/ current background color'
           bgInd = !p.background
           bg=[r[bgInd],g[bgInd],b[bgInd]]
         end
endcase

if keyword_set(triple) then begin
   color    = reform(color)
   orgColor = [color[0],color[1],color[2]] 
   result_color = 77
endif else begin
   orgColor = [r[color],g[color],b[color]]
   result_color = color
endelse

; blending the color with background color
trpColor = bg*(1.-alpha) + orgColor*alpha

tvlct,trpColor[0],trpColor[1],trpColor[2],result_color 
return, result_color
end
