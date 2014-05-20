pro vect_polar,vr,vth1,r,th,color=color,nsmp=nsmp,overplot=overplot $
              ,asize=asize,rotframe=rotframe,opt=opt
;===========================================================================
;              Drawing the velocity field at polar coordinate
;      
;                                                                 2007.09.01
;                                                                 Doosu,Yoon
;
;  input parameter
;     vr,vth,r,th : velocity and position
;  option
;     color    : color of arrows                          (default=0)
;     nsmp     : number of sample                         (default=1000)
;     overplot : oerplot with previous contour
;                without this option, it draws another window(0)
;     hsize    : size of arrows                           (default=0.6)
;     opt      : (1 : randomly distribution)              (default=3)
;                (2 : polar_uniformly distribution)
;                (3 : rect_uniformly distribution)
;
;  Modified : 
;===========================================================================
s    = size(vr)
rend = r[s[1]-1]

if not keyword_set(color) then color=0
if not keyword_set(opt) then opt = 3
if not keyword_set(overplot) then begin
   loadct,0,/sil
   window,0,xs=800,ys=800
;   plot,[-rend,rend],[-rend,rend],/iso,/nodata,/xst,/yst
   plot,[-!x.crange,!x.crange],[-!y.crange,!y.crange],/iso,/nodata,/xst,/yst
   color=255
endif
if not keyword_set(asize) then asize=0.6

vth = fltarr(s[1],s[2])
if not keyword_set(rotframe) then rotframe=0
for i=0,s[1]-1 do vth[i,*] = vth1[i,*] - r[i]*rotframe
vmax = max(sqrt(vr*vr + vth*vth))    ; for normalization

if not keyword_set(nsmp)  then nsmp=1000
;---------------------------------------------------------------------------
; choose the samples randomly (opt=1)
;---------------------------------------------------------------------------
if (opt eq 1) then begin
smprind  = fltarr(nsmp)
smpthind = fltarr(nsmp)
smpvr    = fltarr(nsmp)
smpvth   = fltarr(nsmp)
seed1 = 1001L & seed2 = 1002L
tmpr  = sqrt(randomu(seed1,nsmp))*(rend-r[0])+r[0]
tmpth = randomu(seed2,nsmp)*(th[s[2]-1]-th[0])+th[0]
for t=0,nsmp-1 do begin
    for i=0,s[1]-1 do begin
        if (r[i] ge tmpr[t]) then begin
           smprind[t] = i
           break
        endif
    endfor
    for j=0,s[2]-1 do begin
        if (th[j] ge tmpth[t]) then begin
           smpthind[t] = j
           break
        endif
    endfor
    smpvr[t]  = vr[smprind[t],smpthind[t]]
    smpvth[t] = vth[smprind[t],smpthind[t]]
endfor
smpr  = r[smprind]
smpth = th[smpthind]
endif  ; opt = 1 case
;---------------------------------------------------------------------------
; choose the samples polar_uniformly (opt=2)
;---------------------------------------------------------------------------
if (opt eq 2) then begin
nsmpr    = long(sqrt(nsmp)) & nsmpth = long(sqrt(nsmp))
nsmp     = nsmpr*nsmpth
smpr     = fltarr(nsmp)     & smpth = fltarr(nsmp)
smprind  = fltarr(nsmpr)
smpthind = fltarr(nsmpth)
smpvr    = fltarr(nsmp)
smpvth   = fltarr(nsmp)

tmpr  = findgen(nsmpr)/float(nsmpr)*(rend-r[0])+r[0]
tmpth = findgen(nsmpth)/float(nsmpth)*(th[s[2]-1]-th[0])+th[0]

for t=0,nsmpr-1 do begin
    for i=0,s[1]-1 do begin
        if (r[i] ge tmpr[t]) then begin
           smprind[t] = i
           break
        endif
    endfor
endfor
for t=0,nsmpth-1 do begin
    for j=0,s[2]-1 do begin
        if (th[j] ge tmpth[t]) then begin
           smpthind[t] = j
           break
        endif
    endfor
endfor
for j=0,nsmpth-1 do begin
    smpr[nsmpr*j:nsmpr*(j+1)-1]  = r[smprind]
    smpth[nsmpr*j:nsmpr*(j+1)-1] = th[smpthind[j]]
    for i=0,nsmpr-1 do begin
        smpvr[j*nsmpr+i]  = vr[smprind[i],smpthind[j]]
        smpvth[j*nsmpr+i] = vth[smprind[i],smpthind[j]]
    endfor
endfor
endif  ; opt = 2 case
;---------------------------------------------------------------------------
; choose the samples rect_uniformly (opt=3)
;---------------------------------------------------------------------------
if (opt eq 3) then begin
nsmpx = long(sqrt(nsmp)) & nsmpy = long(sqrt(nsmp))
nsmp  = nsmpx*nsmpy

tmpx  = findgen(nsmpx)/float(nsmpx)*2.*rend-rend
tmpy  = findgen(nsmpy)/float(nsmpy)*2.*rend-rend

;construct tmppos array with structure 
;rth = r and th value, inout = (0:outer region of rend, 1:iner region of rend)
tmppos = replicate({rth:fltarr(2), inout:0},nsmp)
for j=0,nsmpy-1 do begin                
    for i=0,nsmpx-1 do begin            
        tmppos[j*nsmpx+i].rth[*]=cv_coord(from_rect=[tmpx[i],tmpy[j]],/to_polar) 
        if (tmppos[j*nsmpx+i].rth[1] ge rend) then tmppos[j*nsmpx+i].inout=1  
        if (tmppos[j*nsmpx+i].rth[1] ge abs(!x.crange[1])) then tmppos[j*nsmpx+i].inout=1  
    endfor 
endfor     
tmpr  = tmppos[where(tmppos.inout eq 0)].rth[1]
tmpth = tmppos[where(tmppos.inout eq 0)].rth[0]
; revise tmpth range to (-pi/2 ~ 3/2pi)
tmpth[where((tmpth lt -0.5*!pi) and (tmpth ge -!pi))] = $
     tmpth[where((tmpth lt -0.5*!pi) and (tmpth ge -!pi))] + 2.*!pi   

nsmp     = n_elements(tmpr)
smpr     = fltarr(nsmp) & smpth = fltarr(nsmp)
smprind  = fltarr(nsmp)
smpthind = fltarr(nsmp)
smpvr    = fltarr(nsmp)
smpvth   = fltarr(nsmp)

for t=0,nsmp-1 do begin
    for i=0,s[1]-1 do begin
        if (r[i] ge tmpr[t]) then begin
           smprind[t] = i
           break
        endif
    endfor
    for j=0,s[2]-1 do begin
        if (th[j] ge tmpth[t]) then begin
           smpthind[t] = j
           break
        endif
    endfor
    smpvr[t]  = vr[smprind[t],smpthind[t]]
    smpvth[t] = vth[smprind[t],smpthind[t]]
endfor
smpr  = r[smprind]
smpth = th[smpthind]
endif  ; opt = 3 case
;---------------------------------------------------------------------------
; polar -> rectangular coord and obtain start&end positions of arrows
;---------------------------------------------------------------------------
pos = fltarr(nsmp,2)
vx  = fltarr(nsmp)
vy  = fltarr(nsmp)
x1  = fltarr(nsmp) & x2 = fltarr(nsmp)
y1  = fltarr(nsmp) & y2 = fltarr(nsmp)
for i = 0,nsmp-1L do begin
    theta     = smpth[i]
    pos[i,*]  = cv_coord(from_polar=[theta,smpr[i]],/to_rect)
    vx[i]     = smpvr[i]*cos(theta)-smpvth[i]*sin(theta)
    vy[i]     = smpvr[i]*sin(theta)+smpvth[i]*cos(theta)
    vx[i]     = vx[i]/vmax*asize
    vy[i]     = vy[i]/vmax*asize
    x1[i]     = pos[i,0] - vx[i]/2.
    x2[i]     = pos[i,0] + vx[i]/2.
    y1[i]     = pos[i,1] - vy[i]/2.
    y2[i]     = pos[i,1] + vy[i]/2.
endfor

;---------------------------------------------------------------------------
; draw arrows
;---------------------------------------------------------------------------
arrow,x1,y1,x2,y2,/data,color=color,hsize=-1./5,hthick=3.
end
