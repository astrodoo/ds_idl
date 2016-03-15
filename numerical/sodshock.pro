forward_function func, sec
pro sodshock, dl=dl, pl=pl, ul=ul, dr=dr, pr=pr, ur=ur, gam=gam, time=time, resol=resol $
            , xrange=xrange, verbose=verbose, result=result
;( =_=)++  =========================================================================
;
; NAME: 
;   SODSHOCK
;
; PURPOSE:
;   This routine is aimed to calculate analytical solution for sod shocktube test 
;   in adiabatic case.
;
; AUTHOR:
;   DOOSOO YOON
;   Shanghai Astronomical Observatory
;   80 Nandan Rd, Shanghai 200030
;   Web: http://center.shao.ac.cn/yoon
;   E-mail: yoon@shao.ac.cn
;
; CATEGORY:
;   Analysis
;
; KEYWORDS:
;   [d,p,u]/[l,r]: in, required, type= dblarr, default= test values
;        density(d), pressure(p), velocity(u) at left(l) & right(r) side.
;        The density of the left side is higher than that of the right side for general setting.
;   gam: in, required, type= float, default=1.66667
;        adiabatic index of gas
;   time: in, required, type= float, default= test value
;        desired time for the result
;   resol: in, required, type= integer, default= 200
;        resolution of the grid
;   xrange: in, required, type= dblarr(2), default=[0.d0,1.d0]
;        size of the tube [xmin,xmax]
;   verbose: in, optional, type= boolean, default= 0
;        print out the detailed information
;   result: out, optional, type= structure
;        save the result in the form of structure
;        result = {d, p, u, e, cs, x, time}
;
; EXAMPLE:
;   idl> sodshock, pl=1., dl=1., ul=0., pr=0.1, dr=0.125, ur=0., gam=5./3., time=0.245, xrange=[0.,1.],result=result
;   idl> plot,result.x,result.d
;
; HISTORY:
;   written, 14 February 2007, by DooSoo Yoon.
;   updated, 15 March    2016, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2007-, All rights reserved by DooSoo Yoon.
;===================================================================================
common param, gam1

if not keyword_set(resol) then resol = 200    ; resolution of the test

x = dblarr(resol) & d = dblarr(resol) & u = dblarr(resol)
p = dblarr(resol) & cs = dblarr(resol) & e = dblarr(resol)

result={x:dblarr(resol),d:dblarr(resol),u:dblarr(resol) $
       ,p:dblarr(resol),cs:dblarr(resol),e:dblarr(resol),time:0.}

if not keyword_set(gam) then gam=1.66667d0     ; adiabatic index of gas
gam1 = gam
if (n_elements(time) eq 0) then time = 0.245d0   ; desired time
if not keyword_set(xrange) then xrange=[0.d0,1.d0] ; scale of the box

xhf = (xrange[1] + xrange[0])/2.d0             ; half distance

; left region (high pressure)
if not keyword_set(pl) then pl = 1.d0
if not keyword_set(dl) then dl = 1.d0
if not keyword_set(ul) then ul = 0.d0
csl = sqrt(gam*pl/dl)

; right region (low pressure)
if not keyword_set(pr) then pr = 0.1d0
if not keyword_set(dr) then dr = 0.125d0
if not keyword_set(ur) then ur = 0.d0
csr = sqrt(gam*pr/dr)

if keyword_set(verbose) then begin
   print,'time = ',time
   print,format='(a35,4(x,f6.4))','left quantity         (p,d,u,cs):',pl,dl,ul,csl 
   print,format='(a35,4(x,f6.4))','right quantity        (p,d,u,cs):',pr,dr,ur,csr
endif
;--------------------------------------------------------------------
; preshock quantity (region4 below)
;--------------------------------------------------------------------
preshock, pr,ur,csr,pl,ul,csl,ppre,dpre,upre,cspre,vsh
if keyword_set(verbose) then $
   print,format='(a35,4(x,f6.4))','pre-shock quantity    (p,d,u,cs):',ppre,dpre,upre,cspre

;--------------------------------------------------------------------
; contact discontinuity quantity (region3 below)
;--------------------------------------------------------------------
contact, ppre,upre,pl,dl,pcd,dcd,ucd,cscd
if keyword_set(verbose) then $
   print,format='(a35,4(x,f6.4))','contact discontinuity (p,d,u,cs):',pcd,dcd,ucd,cscd

;--------------------------------------------------------------------
; position of waves
;--------------------------------------------------------------------
positions, xhf,ucd,cscd,ul,csl,vsh,time,xhead,xtail,xcd,xsh
if keyword_set(verbose) then $
   print,format='(a35,6(x,f6.4))','xl,xhead,xtail,xcd,xsh,xr       :',xrange[0],xhead,xtail,xcd,xsh,xrange[1]

;--------------------------------------------------------------------
;computing solution as the position separately
;--------------------------------------------------------------------
x = dindgen(resol)/double(resol-1)*(xrange[1]-xrange[0]) + xrange[0]

reg1 = where(x lt xhead,                    count1)
reg2 = where((x ge xhead) and (x lt xtail), count2)
reg3 = where((x ge xtail) and (x lt xcd),   count3)
reg4 = where((x ge xcd) and (x lt xsh),     count4)
reg5 = where(x ge xsh,                      count5)

if (count1 ne 0) then begin
   p[reg1] = pl
   d[reg1] = dl
   u[reg1] = ul
   cs[reg1]= csl
   e[reg1] = 1.d0/(gam-1.d0)*pl/dl
endif
if (count2 ne 0) then begin
   u[reg2] = 2.d0/(gam+1.d0)*((x[reg2]-xhf)/time+(gam-1.d0)/2.d0*ul+csl)
   cs[reg2]= u[reg2]-(x[reg2]-xhf)/time
   p[reg2] = pl*(cs[reg2]/csl)^(2.d0*gam/(gam-1.d0))
   d[reg2] = gam*p[reg2]/(cs[reg2]^2.d0)
   e[reg2] = 1.d0/(gam-1.d0)*p[reg2]/d[reg2]
endif
if (count3 ne 0) then begin
   p[reg3] = pcd
   d[reg3] = dcd
   u[reg3] = ucd
   cs[reg3]= cscd
   e[reg3] = 1.d0/(gam-1.d0)*pcd/dcd
endif
if (count4 ne 0) then begin
   p[reg4] = ppre
   d[reg4] = dpre
   u[reg4] = upre
   cs[reg4]= cspre
   e[reg4] = 1.d0/(gam-1.d0)*ppre/dpre
endif
if (count5 ne 0) then begin
   p[reg5] = pr
   d[reg5] = dr
   u[reg5] = ur
   cs[reg5]= csr
   e[reg5] = 1.d0/(gam-1.d0)*pr/dr
endif

; output
result.d = d & result.p = p & result.u = u 
result.cs=cs & result.e = e & result.x = x
result.time = time

end

;--------------------------------------------------------------------
; Subroutines
;--------------------------------------------------------------------
; preshock quantity
;--------------------------------------------------------------------
pro preshock, pr,ur,csr,pl,ul,csl,ppre,dpre,upre,cspre,vsh
common param, gam1
;solve the pre-shock pressure by secant method
;initial guess
ppre0 = 0.7*pl
ppre1 = 0.05*pl
ppre  = sec(func,ppre0,ppre1,pr,pl,ur,ul,csr,csl)

;compute pre-shock quantity
cspre=csr*sqrt(ppre/pr*((gam1+1.d0)/(gam1-1.d0)+ppre/pr)/(1.d0+(gam1+1.d0)/(gam1-1.d0) $
   *ppre/pr))
temp=sqrt((gam1+1.d0)/(2.d0*gam1)*(ppre/pr-1.d0)+1.d0)
upre=ur+csr/gam1*(ppre/pr-1.d0)/temp
dpre=gam1*ppre/(cspre^2.d0)
vsh=ur+csr*temp   ; shock speed
end 
;--------------------------------------------------------------------
; Contact discontinuity
;--------------------------------------------------------------------
pro contact, ppre,upre,pl,dl,pcd,dcd,ucd,cscd
common param, gam1 
pcd=ppre
ucd=upre
dcd=dl*(pcd/pl)^(1.d0/gam1)
cscd=sqrt(gam1*pcd/dcd)
end
;--------------------------------------------------------------------
; Position of waves
;--------------------------------------------------------------------
pro positions, xhf,ucd,cscd,ul,csl,vsh,time,xhead,xtail,xcd,xsh
xsh=xhf+vsh*time
xcd=xhf+ucd*time
xtail=xhf+(ucd-cscd)*time
xhead=xhf+(ul-csl)*time
end

;--------------------------------------------------------------------
; Functions
;--------------------------------------------------------------------
; fucntion (Finding ppre value with secant method) 
;--------------------------------------------------------------------
function func,pr,ppre,pl,ur,ul,csr,csl
common param, gam1
temp1=sqrt((gam1+1.d0)/(2.d0*gam1)*(ppre/pr-1.d0)+1.d0)
temp2=1.d0+(gam1-1.d0)/(2.d0*csl)*(ul-ur-csr/gam1*(ppre/pr-1.d0)/temp1)
re_func=pl*temp2^(2.d0*gam1/(gam1-1.d0))-ppre
return,re_func
end
;--------------------------------------------------------------------
; secant method
;--------------------------------------------------------------------
function sec,func,ppre0,ppre1,pr,pl,ur,ul,csr,csl
MAXIT=30
eps=1.d-8

fl=func(pr,ppre0,pl,ur,ul,csr,csl)    ; initial large guess
fs=func(pr,ppre1,pl,ur,ul,csr,csl)    ; initial small guess

if (abs(fl) lt abs(fs)) then begin
   re_sec=ppre0
   ppl=ppre1
   swap=fl
   fl=fs
   fs=swap
endif else begin
   ppl=ppre0
   re_sec=ppre1
endelse
for j=1,MAXIT do begin
    dp=(ppl-re_sec)*fs/(fs-fl)
    ppl=re_sec
    fl=fs
    re_sec=re_sec+dp
    fs=func(pr,re_sec,pl,ur,ul,csr,csl)
    if ((abs(dp) lt eps) or (fs eq 0)) then return,re_sec
endfor
stop,'secant exceed maximum iterations'
end 
