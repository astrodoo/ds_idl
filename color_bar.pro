pro color_bar,position=position,lim=lim $
    ,ct=ct,right=right,left=left,up=up,down=down $
    ,bartitle=bartitle,titlegap=titlegap $
    ,device=device,normal=normal $
    ,dual_lim=dual_lim, dual_title=dual_title, dual_gap=dual_gap, log=log $
    ,minor=minor, color=color $
    ,bthick=bthick,nlevels=nlevels,_extra=extra
;( =_=)++  =========================================================================
;
; NAME: 
;   COLOR_BAR
;
; PURPOSE:
;   This routine is designated to draw coloar bar around plot or contour or image
;   files.
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
;   lim: in, required, type= fltarr(2); [low,high]
;        low and high limits of the color bar
;   position: in, required, type= fltarr(4); [x0,y0,x1,y1]
;        position of the bar. As default, it would be written as device coordinate.
;        If not given, position would be establised by one of (r/l/u/d) positions.
;   ct: in, optional, type= int
;       color table 
;   right/left/up/down: in, optional, type= boolean, default= up is on.
;       position of the color bar. All of directions in writing titles and tick numbers
;       would be determined by this keyword.
;   bartitle: in, optional, type= string
;       title of the bar
;   titlegap: in, optional, type= float, default= 0.01
;       the gap between bar and title.
;   device/normal: in, optional, type= boolean, default= device is on.
;       the way of positioning. Among the coordinate system in IDL, 'data' type is 
;       neglected in this procedure.
;   dual_lim: in, optional, type= fltarr(2); [low,high]
;       limit values for dual diagnostics
;   dual_title: in, optional, type= string
;       title for dual diagnostics
;   dual_gap: in, optional, type= float
;       the gap between the bar and dual title.
;   log: in, optional, type= boolean, default= 0
;       indicating the log scale.
;   minor: in, optional, type= boolean, default= 0
;       drawing a minor thick
;   color: in, optional, type= int, default= 255 - !p.background
;       color of the title and tick in the bar
;   bthick: in, optional, type= float, default=0.03 (normalized value)
;       Ungiven "Position" option, it describes the normalized value of thickness in bar.
;   nlevels: in, optional, type= int, default=NONE
;       the number of levels in discrete color bar
;
; EXAMPLE:
;   IDL> a=dist(300)
;   IDL> minv=min(a)
;   IDL> maxv=max(a)
;   IDL> levs=findgen(50)/50.*(maxv-minv)+minv
;   IDL> contour,a,/fill,position=[0.1,0.1,0.7,0.9],/norm,lev=levs
;   IDL> color_bar,lim=[minv,maxv],/right
;
;or more sophisticatedly,
;
;   IDL> color_bar,lim=[minv,maxv],/right, position=[0.8,0.1,0.84,0.9],/norm, &
;        dual_lim=[1.,5.],bartitle='lim1',dual_title='lim2',titlegap=0.07,dual_gap=0.04
;
;
; HISTORY:
;   written, 17 March 2007, by DooSoo Yoon.
;   2007.03.19 - added option whitebg & solve returning previous ct
;                by using tvlct
;   2007.07.29 - change vertical option to right option
;              - add bar title option
;              - add up,left,down which the postion of ticklabel and
;                bar title
;   2007.08.29 - solve the lower limit bug at the whitebg case
;   2010.08.25 - add the option for 'dev' or 'norm' in order to use eps
;   2010.10.19 - add the option for dual configuration - 'dual_lim, dual_title,
;                                                         dual_gap'
;   2012.09.04 - modify the bug (keep the 'nvalue' over 2)
;              - add the option for log, minor
;              - remove whitebg option & add color option 
;   2012.11.12 - remove alone option & clean up the code
;   2013.04.16 - add the "bthick" option for setting thickness of the bar without position value
;   2013.10.15 - add "nlevels" option for establishing discrete color bar
;
; COPYRIGHT:
;   Copyright 2007-, All rights reserved by DooSoo Yoon.
;===================================================================================
if (not keyword_set(right)) and (not keyword_set(left)) and $
   (not keyword_set(up)) and (not keyword_set(down)) then up = 1
if not keyword_set(position) then begin
   xcl0 = float(!p.clip[0])/!d.x_size & xcl1 = float(!p.clip[2])/!d.x_size
   ycl0 = float(!p.clip[1])/!d.y_size & ycl1 = float(!p.clip[3])/!d.y_size
   bgap = 0.01 
   if not keyword_set(btihck) then bthick = 0.03
   device=0 & normal=1

   case 1 of 
      n_elements(up)    : position=[xcl0,ycl1+bgap,xcl1,ycl1+bgap+bthick]
      n_elements(down)  : position=[xcl0,ycl0-bgap-bthick,xcl1,ycl0-bgap]
      n_elements(right) : position=[xcl1+bgap,ycl0,xcl1+bgap+bthick,ycl1]
      n_elements(left)  : position=[xcl0-bgap-bthick,ycl0,xcl0-bgap,ycl1]
   endcase
endif
if not keyword_set(titlegap) then titlegap=0.01
if not keyword_set(dual_gap) then dual_gap=titlegap
if (not keyword_set(device)) and (not keyword_set(normal)) then device = 1
if not keyword_set(color) then color=255-!p.background

;------------------------------------------------------------------------------
; Generates the ramp that will show the colors.
;------------------------------------------------------------------------------
xsize=position[2]-position[0]
ysize=position[3]-position[1]
if keyword_set(normal) then begin
   xsize = fix(xsize*100.)
   ysize = fix(ysize*100.)
endif

if (keyword_set(right)) or (keyword_set(left)) then begin 
   value=ysize & nvalue=xsize
endif else begin
   value=xsize & nvalue=ysize
endelse

if keyword_set(log) then lim = alog10(lim)

; shift the tick values in discrete color_bar
if ((keyword_set(nlevels)) and (lim[0] ge 1)) then lim[0] = lim[0] - 1

aux=lim(0)+(lim(1)-lim(0))*findgen(value)/float(value)

if (nvalue le 2) then nvalue=2
aux2=rebin(aux,value,nvalue)

;------------------------------------------------------------------------------
; contour levels 
;------------------------------------------------------------------------------
if keyword_set(nlevels) then nlev=nlevels else nlev=300

tmplevs=(findgen(nlev)+1)/float(nlev)*(lim[1]-lim[0]) + lim[0]

levs = fltarr(nlev+2)
levs[0] = min(tmplevs) - (tmplevs[1]-tmplevs[0])*100.
levs[1:nlev] = tmplevs[*]
levs[nlev+1] = max(tmplevs) + (tmplevs[nlev-1]-tmplevs[nlev-2])*100.

;------------------------------------------------------------------------------
; construct the bar
;------------------------------------------------------------------------------
if (n_elements(ct) ne 0) then loadct,ct,/sil
lim1 = lim & lim2 = lim
if keyword_set(right) or keyword_set(left) then begin
   aux2 = rotate(aux2,1)
   xx   = findgen(nvalue)
   yy   = aux
   axisp = 'y'
   if keyword_set(right) then begin
      opt1 = ''
      if keyword_set(dual_lim) then begin
         opt2 = ''
         lim2 = dual_lim 
      endif else opt2 = ',ytickformat="(a1)"'
      pp   = '2' & pp2   = '0'
      sign = '+' & sign2 = '-'
   endif else begin
      if keyword_set(dual_lim) then begin 
         opt1 = ''
         lim1 = dual_lim 
      endif else opt1 = ',ytickformat="(a1)"'
      opt2 = ''
      pp   = '0' & pp2   = '2'
      sign = '-' & sign2 = '+'
   endelse
   if keyword_set(bartitle) then begin
      bb = execute('posttx = float(position['+pp+'])'+ sign +'titlegap')
      postty = float(position[1] + position[3])/2.
      orient = 90.
   endif
   if keyword_set(dual_title) then begin
      bb2 = execute('posttx2 = float(position['+pp2+'])'+ sign2 +'dual_gap')
      postty2 = float(position[1] + position[3])/2.
      orient = 90.
   endif
endif else if keyword_set(up) or keyword_set(down) then begin
   xx = aux
   yy = findgen(nvalue)
   axisp = 'x'
   if keyword_set(up) then begin
      opt1 = ''
      if keyword_set(dual_lim) then begin 
         opt2 = ''
         lim2 = dual_lim 
      endif else opt2 = ',xtickformat="(a1)"'
      pp   = '3' & pp2   = '1'
      sign = '+' & sign2 = '-'
   endif else begin
      if keyword_set(dual_lim) then begin
         opt1 = '' 
         lim1 = dual_lim
      endif else opt1 = ',xtickformat="(a1)"'
      opt2 = ''
      pp   = '1' & pp2   = '3'
      sign = '-' & sign2 = '+'
   endelse
   if keyword_set(bartitle) then begin
      posttx = float(position[0] + position[2])/2.
      bb = execute('postty = float(position['+pp+'])'+ sign +'titlegap')
      orient = 0.
   endif
   if keyword_set(dual_title) then begin
      posttx2 = float(position[0] + position[2])/2.
      bb2 = execute('postty2 = float(position['+pp2+'])'+ sign2 +'dual_gap')
      orient = 0.
   endif
endif
;------------------------------------------------------------------------------
; contour the bar
;------------------------------------------------------------------------------
if keyword_set(device) then contopt = ',/dev' $
  else if keyword_set(normal) then contopt = ',/norm'

;
if keyword_set(log) then begin
  cc = execute('contour,10^aux2,xx,10^yy,ystyle=5,xstyle=5,/fill,pos=position'+contopt $
       +',levels=10^levs,/noerase,/ylog') 
  if keyword_set(nlevels) then $
  cc2 = execute('contour,10^aux2,xx,10^yy,ystyle=5,xstyle=5,pos=position'+contopt $
       +',levels=10^levs,/noerase,/ylog') 

  optlog = ',/'+axisp+'log'
  optrg  ='10^'
endif else begin
  cc = execute('contour,aux2,xx,yy,ystyle=5,xstyle=5,/fill,pos=position'+contopt+',levels=levs,/noerase') 
  if keyword_set(nlevels) then $
  cc2 = execute('contour,aux2,xx,yy,ystyle=5,xstyle=5,pos=position'+contopt+',levels=levs,/noerase') 

  optlog = ''
  optrg  = ''
endelse

if keyword_set(minor) then ticklength='0.29' else ticklength='0.3'
if keyword_set(nlevels) then ticklength='0'
;------------------------------------------------------------------------------
; build the axis & title
;------------------------------------------------------------------------------
tvlct,r,g,b,/get
tvlct,255,255,255,255
tvlct,0,0,0,0
drawaxis1 = 'axis,'+axisp+'axis=1,'+axisp+'range='+optrg+'lim1,'+axisp+'style=1,'
drawaxis1 = drawaxis1 +axisp+'ticklen='+ticklength+',_EXTRA=extra,color=color'+opt1 + optlog
a1 = execute(drawaxis1)
drawaxis2 = 'axis,'+axisp+'axis=0,'+axisp+'range='+optrg+'lim2,'+axisp+'style=1,'
drawaxis2 = drawaxis2 +axisp+'ticklen='+ticklength+',_EXTRA=extra,color=color'+opt2 + optlog
a2 = execute(drawaxis2)
if keyword_set(bartitle) then $
   dd = execute('xyouts,posttx,postty'+contopt+',bartitle,alignment=0.5,orientation=orient,color=color,_EXTRA=extra')
if keyword_set(dual_title) then $
   dd2 = execute('xyouts,posttx2,postty2'+contopt+',dual_title,alignment=0.5,orientation=orient,color=color,_EXTRA=extra')
tvlct,r,g,b
end
