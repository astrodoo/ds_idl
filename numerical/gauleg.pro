pro gauleg,x1,x2,x,w,n

; the integration code with Gaussian quadratures
; programmed by doosu, yoon
; 2006.04.12
;
; input :
; x1 for lower limit (integer)
; x2 for upper limit (integer)
; n for iteration number
;
; output :
; x[n] for abscissas
; w[n] for weights
;
; referenced by numerical receip for fortran77

x = fltarr(n) & w = fltarr(n)
eps = 3d-14

m = (n+1)/2
xm = 0.5d0*(x2+x1)
xl = 0.5d0*(x2-x1)

for i = 1, m do begin
    z = cos(3.141592654d0*(i-0.25d0)/(n+0.5d0))
;    print,i
    Cont1:

    p1 = 1.0d0
    p2 = 0.0d0

    for j = 1, n do begin
       p3 = p2
       p2 = p1
       p1 = ((2.0d0*j-1.0d0)*z*p2-(j-1.0d0)*p3)/j
    endfor

    pp = n*(z*p1-p2)/(z*z-1.0d0)
    z1 = z
    z = z1-p1/pp

    if (abs(z-z1) gt eps) then goto, Cont1

    x[i-1] = xm-xl*z
    x[n-i] = xm+xl*z
    w[i] = 2.0d0*xl/((1.0d0-z*z)*pp*pp)
    w[n-i] = w[i]
endfor
return
end
