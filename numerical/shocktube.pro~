pro shocktube
;===================================================================
;             Analytic Sod Shock Tube solution (Adaibatic)
;
;                                                         2007.02.14
;                                                         Doosu,Yoon
;===================================================================
device,decomposed=0
device,retain=2

resol = 200   ; resolution of the test
x = dblarr(resol) & d = dblarr(resol) & u = dblarr(resol)
p = dblarr(resol) & a = dblarr(resol) & e = dblarr(resol)

common param,r
r=1.4d0       ; equation of state 

t   = 0.245d0 ; time for the solution 
;--------------------------------------------------------------------
; initial condition
;--------------------------------------------------------------------
; initial location
xl  = 0.d0
xr  = 1.d0
xhf = (xr + xl)/2.d0

; left region (high pressure)
p4 = 1.d0
d4 = 1.d0
u4 = 0.d0

; right region (low pressure)
p1 = 0.1d0
d1 = 0.125d0
u1 = 0.d0

; adiabatic soundspeed
a1 = sqrt(r*p1/d1)
a4 = sqrt(r*p4/d4)

print,'time = ',t
print,'left quantity         :',p4,d4,u4,a4 
print,'right quantity        :',p1,d1,u1,a1
 
;--------------------------------------------------------------------
; preshock quantity (region 2)
;--------------------------------------------------------------------
preshock, p1,u1,a1,p4,u4,a4,p2,d2,u2,a2,S
print,'pre-shock quantity    :',p2,d2,u2,a2

;--------------------------------------------------------------------
; contact discontinuity quantity (region3)
;--------------------------------------------------------------------
contact, p2,u2,p4,d4,p3,d3,u3,a3
print,'contact discontinuity :',p3,d3,u3,a3

;--------------------------------------------------------------------
; position of waves
;--------------------------------------------------------------------
positions, xhf,u3,a3,u4,a4,S,t,xhead,xtail,xcd,xsh
print,xl,xhead,xtail,xcd,xsh,xr

;--------------------------------------------------------------------
;computing solution as the position separately
;--------------------------------------------------------------------
dx=(xr-xl)/double(resol-1)

for i=0,resol-1 do x[i]=xl+dx*i

for i=0,resol-1 do begin
    if (x[i] lt xhead) then begin
       p[i]=p4
       d[i]=d4
       u[i]=u4
       a[i]=a4
       e[i]=1.d0/(r-1.d0)*p4/d4
     endif else if (x[i] lt xtail) then begin
       u[i]=2.d0/(r+1.d0)*((x[i]-xhf)/t+(r-1.d0)/2.d0*u4+a4)
       a[i]=u[i]-(x[i]-xhf)/t
       p[i]=p4*(a[i]/a4)^(2.d0*r/(r-1.d0))
       d[i]=r*p[i]/(a[i]^2.d0)
       e[i]=1.d0/(r-1.d0)*p[i]/d[i]
     endif else if (x[i] lt xcd) then begin
       p[i]=p3
       d[i]=d3
       u[i]=u3
       a[i]=a3
       e[i]=1.d0/(r-1.d0)*p3/d3
     endif else if (x[i] lt xsh) then begin
       p[i]=p2
       d[i]=d2
       u[i]=u2
       a[i]=a2
       e[i]=1.d0/(r-1.d0)*p2/d2
     endif else begin
       p[i]=p1
       d[i]=d1
       u[i]=u1
       a[i]=a1
       e[i]=1.d0/(r-1.d0)*p1/d1
     endelse
endfor
;--------------------------------------------------------------------
; Plot data
;--------------------------------------------------------------------
loadct,0
!p.background=255 & !p.color=0
!x.thick=2 & !y.thick=2
!p.charsize=1.5 & !p.charthick=1.5
!p.thick=2
xt = 'x'
window,0
yt0 = 'density'
plot,x,d,yst=2,xtitle=xt,ytitle=yt0
xyouts,0.8,0.96,/norm,'time = '+string(t,format='(f5.3)')
window,1
yt1 = 'pressure'
plot,x,p,yst=2,xtitle=xt,ytitle=yt1
xyouts,0.8,0.96,/norm,'time = '+string(t,format='(f5.3)')
window,2
yt2 = 'energy'
plot,x,e,yst=2,xtitle=xt,ytitle=yt2
xyouts,0.8,0.96,/norm,'time = '+string(t,format='(f5.3)')
window,3
yt3 = 'velocity'
plot,x,u,yst=2,xtitle=xt,ytitle=yt3
xyouts,0.8,0.96,/norm,'time = '+string(t,format='(f5.3)')
window,4
yt4 = 'soundspeed'
plot,x,a,yst=2,xtitle=xt,ytitle=yt4
xyouts,0.8,0.96,/norm,'time = '+string(t,format='(f5.3)')
;--------------------------------------------------------------------
; End of the Program
;--------------------------------------------------------------------
stop
end


;--------------------------------------------------------------------
; Functions
;--------------------------------------------------------------------
; fucntion (Finding p2 value with secant method) 
;--------------------------------------------------------------------
function func,p1,p2,p4,u1,u4,a1,a4
common param
temp1=sqrt((r+1.d0)/(2.d0*r)*(p2/p1-1.d0)+1.d0)
temp2=1.d0+(r-1.d0)/(2.d0*a4)*(u4-u1-a1/r*(p2/p1-1.d0)/temp1)
re_func=p4*temp2^(2.d0*r/(r-1.d0))-p2
return,re_func
end
;--------------------------------------------------------------------
; secant method
;--------------------------------------------------------------------
function sec,func,p20,p21,p1,p4,u1,u4,a1,a4
common param
MAXIT=30
eps=1.d-8

fl=func(p1,p20,p4,u1,u4,a1,a4)    ; initial large guess
fs=func(p1,p21,p4,u1,u4,a1,a4)    ; initial small guess

if (abs(fl) lt abs(fs)) then begin
   re_sec=p20
   pl=p21
   swap=fl
   fl=fs
   fs=swap
endif else begin
   pl=p20
   re_sec=p21
endelse
for j=1,MAXIT do begin
    dp=(pl-re_sec)*fs/(fs-fl)
    pl=re_sec
    fl=fs
    re_sec=re_sec+dp
    fs=func(p1,re_sec,p4,u1,u4,a1,a4)
    if ((abs(dp) lt eps) or (fs eq 0)) then return,re_sec
endfor
stop,'secant exceed maximum iterations'
end 


;--------------------------------------------------------------------
; Subroutines
;--------------------------------------------------------------------
; preshock quantity
;--------------------------------------------------------------------
pro preshock, p1,u1,a1,p4,u4,a4,p2,d2,u2,a2,S
common param 
;solve the pre-shock pressure by secant method
;initial guess
p20 = 0.7*p4
p21 = 0.05*p4
p2  = sec(func,p20,p21,p1,p4,u1,u4,a1,a4)

;compute pre-shock quantity
a2=a1*sqrt(p2/p1*((r+1.d0)/(r-1.d0)+p2/p1)/(1.d0+(r+1.d0)/(r-1.d0) $
   *p2/p1))
temp=sqrt((r+1.d0)/(2.d0*r)*(p2/p1-1.d0)+1.d0)
u2=u1+a1/r*(p2/p1-1.d0)/temp
d2=r*p2/(a2^2.d0)
S=u1+a1*temp   ; shock speed
end 
;--------------------------------------------------------------------
; Contact discontinuity
;--------------------------------------------------------------------
pro contact, p2,u2,p4,d4,p3,d3,u3,a3
common param 
p3=p2
u3=u2
d3=d4*(p3/p4)^(1.d0/r)
a3=sqrt(r*p3/d3)
end
;--------------------------------------------------------------------
; Position of waves
;--------------------------------------------------------------------
pro positions, xhf,u3,a3,u4,a4,S,t,xhead,xtail,xcd,xsh
common param
xsh=xhf+S*t
xcd=xhf+u3*t
xtail=xhf+(u3-a3)*t
xhead=xhf+(u4-a4)*t
end

