pro show_ct, ct, all=all
;( =_=)++  =========================================================================
;
; NAME: 
;   SHOW_CT
;
; PURPOSE:
;   This routine is purposed to show color table in a brief and quick way.
;
; DEPENDENCE:
;   which_ct.pro for finding current color table.   
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
;   ct: in, optional, type= int (must be in 0~74 for IDL ver 8.2)
;       color table which is designated to be shown.
;       if not given, color table in current figuration would be read.
;
; KEYWORDS:
;   all: in, optional, type= boolean
;       it shows all of the color tables in the window [0~74].
;
; EXAMPLE:
;   idl> show_ct 
;  or 
;   idl> show_ct, 39
;  or
;   idl> show_ct, all
;
; HISTORY:
;   written, 30 August 2006, by DooSoo Yoon.
;   2012.11.13 - cleaned up
;  
; COPYRIGHT:
;   Copyright 2006-, All rights reserved by DooSoo Yoon.
;===================================================================================
device, decomposed=0
device, retain=2

orgBg = !p.background
tvlct,r0,g0,b0,/get
loadct,0,/sil,get_names=names
tvlct,r0,g0,b0

if keyword_set(all) then goto, All

if (n_elements(ct) eq 0) then begin 
   current_ct = which_ct()
   if (current_ct eq -1) then title='no matched color table' $
   else begin 
      loadct,current_ct,/sil
      title='Color Table '+strtrim(string(current_ct),2)+' ('+names[current_ct]+')'
   endelse
   r1=r0 & g1=g0 & b1=b0
endif else begin
   if ((ct le -1) or (ct gt 74)) then begin
      print,'You should select color table number in 0~74 at least for IDL ver 8.2'
      goto, Finish
   endif 
   loadct,ct,/sil
   tvlct,r1,g1,b1,/get
   title='Color Table '+strtrim(string(ct),2)+' ('+names[ct]+')'
endelse

; generate color table box (512 X 256)
tb1 = indgen(256) & tb1 = rebin(tb1,512)
tmp_tb = replicate({xtb:tb1},100)
tb=tmp_tb.xtb

;draw a color table
!p.background=fsc_color('white')
window,30,xs=550,ys=150
tvlct,r1,g1,b1
tvscl, tb, 20,0,/device
plot,tb,xr=[0,255],position=[19,0,533,100],/dev,color=fsc_color('black'),/noerase $
    ,/nodata, xticklen=0.2, /xminor,xst=9,/yticks,/yminor,ytickformat='(a1)'
axis,xaxis=1,xr=[0,255],/xst,xticklen=0.2,color=fsc_color('black'),/xminor
xyouts,150,130,title,color=fsc_color('black'), $
       charsize=2,charthick=1.5,/device
Goto, Finish

;---------------------------------------------------------------------------------------------------
; if option 'all' is given,

All:
nct=75
ncol=3 & nrow=ceil(float(nct)/ncol)
thick=35 
xgap=30
xc0=10 & y0=30
; generate color table box (256 X 20)
tb1 = indgen(256); & tb1 = rebin(tb1,512)
tmp_tb = replicate({xtb:tb1},thick)
tb=tmp_tb.xtb

!p.background=fsc_color('white')
xsz=(256+xgap)*ncol+xc0 & ysz=thick*nrow+y0+70
window,31,xs=xsz,ys=ysz
for i=0,nct-1 do begin
   col = i/nrow & row = nrow - (i mod nrow)-1
   if (row eq 0) then opt = "" else opt = ",xtickformat='(a1)'"
   loadct,i,/sil
   tvscl,tb,col*(256+xgap)+xc0,row*thick+y0,/device
   strexe= execute("plot,tb,xr=[0,255]"+ $
       ",position=[col*(256+xgap)+xc0-1,row*thick+y0,col*(256+xgap)+256+xc0+1,(row+1)*thick+y0]"+ $ 
       ",/dev,color=fsc_color('black'),/noerase,/nodata, xticklen=0.2,/xminor,/xst"+ $
       ",/yticks,/yminor,ytickformat='(a1)'"+opt)
   xyouts,!p.clip[2]+5,!p.clip[1]+10,/dev,strtrim(i,2),color=fsc_color('black')
   if (row eq (nrow-1)) then axis,xaxis=1,xr=[0,255],/xst,xticklen=0.2,color=fsc_color('black'),/xminor
endfor
xyouts, xsz/2-150, ysz-30, 'All Color Tables [0-74]',/dev,color=fsc_color('black'),charsize=3

Finish:
tvlct,r0,g0,b0
!p.background=orgBg
end
