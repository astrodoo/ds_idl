function interpol_cubic,xx,x0,fx0
;=================================================================================================
;                                   Cubic Spline Interpolation
;                                                                                       2010.10.21
;                                                                                      DooSoo Yoon
; Interpolating from cubic spline (Numerical Analysis, Brian Bradie, p393)
; Input)
;         xx:     x array for interpolating position
;         x0:     given x0 array
;         fx0:    fx array
;
; example)
;         idl> yy2 = div_diff(xx,x,coef0)
;=================================================================================================

nxx = n_elements(xx)
nx0 = n_elements(x0)
xj1 = [x0[1:nx0-1],0]

htmp = xj1-x0 & h = reform(htmp[0:nx0-2])

;coefficient  sj(x) = aj + bj(x-xj) + cj(x-xj)^2 + dj(x-xj)^3
a = dblarr(nx0)
b = dblarr(nx0)
c = dblarr(nx0)
d = dblarr(nx0)

a = fx0

;trigonal system (Numerical Analysis, Brian Bradie, Appendix B)
L = dblarr(nx0)
U = dblarr(nx0)
z = dblarr(nx0)

L[1] = 3.*h[0] + 2.*h[1] + h[0]*h[0]/h[1]          ; not-a-Knot Boundary Condition
U[1] = (h[1] - h[0]*h[0]/h[1]) / L[1]

for i=2,nx0-3 do begin
   L[i] = 2.*(h[i-1] + h[i]) - h[i-1]*U[i-1]
   U[i] = h[i] / L[i]
endfor
L[nx0-2] = 3.*h[nx0-2] + 2.*h[nx0-3] + h[nx0-2]*h[nx0-2]/h[nx0-3] - (h[nx0-3] - h[nx0-2]*h[nx0-2]/h[nx0-3])*U[nx0-3]


z[1] = (3./h[1]*(a[2]-a[1]) - 3./h[0]*(a[1]-a[0])) / L[1]
for i=2,nx0-2 do z[i] = ((3./h[i]*(a[i+1]-a[i]) - 3./h[i-1]*(a[i]-a[i-1])) - h[i-1]*z[i-1]) / L[i]

c[nx0-2] = z[nx0-2]
for i=nx0-3,1,-1 do c[i] = z[i] - U[i]*c[i+1]

c[0] = (1.+h[0]/h[1])*c[1] - h[0]/h[1]*c[2]
c[nx0-1] = -h[nx0-2]/h[nx0-3]*c[nx0-3] + (1.+h[nx0-2]/h[nx0-3])*c[nx0-2]

for i=0,nx0-2 do begin
   b[i] = (a[i+1] - a[i])/h[i] - (2.*c[i] + c[i+1])/3.*h[i]
   d[i] = (c[i+1] - c[i]) / 3./h[i]
endfor

; interpolating from calcuated coefficients
flag = where((xx lt x0[0]) or (xx gt x0[nx0-1]),count)
if (count ne 0) then begin
   print,"the range of x should be in ",x0[0],"    and",x0[nx0-1],"!!!"
   stop
endif

yy = fltarr(nxx)
for i=0,nxx-1 do begin
   sind_tmp = where(x0 gt xx[i]) & sind = sind_tmp[0] - 1
   hh = xx[i] - x0[sind]
   yy[i] = a[sind] + b[sind]*hh + c[sind]*hh*hh + d[sind]*hh*hh*hh
endfor  
return, yy

end
