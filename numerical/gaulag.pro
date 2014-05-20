pro gaulag, x,w,n,alf

; the integration code with Gaussian quadratures
; programmed by doosu, yoon
; 2006.04.12
;
; input :
; n for iteration number
; alf for multiplication of x
;
; output :
; x[n] for abscissas
; w[n] for weights
;
; referenced by numerical receip for fortran77

eps = 3d-14 & maxit = 10

x = dblarr(n) & w = dblarr(n)

for i=1,n do begin
    if (i eq 1) then begin
       z = (1.+alf)*(3.+.92*alf)/(1.+2.4*n+1.8*alf)
    endif else if (i eq 2) then begin
       z = z+(15.+6.25*alf)/(1.+.9*alf+2.5*n)
    endif else begin
       ai = i-2
       z = z + ((1.+2.55*ai)/(1.9*ai)+1.26*ai*alf/ $
               (1.+3.5*ai))*(z-x[i-3])/(1.+.3*alf)
    endelse

    for its=1,maxit do begin
       p1 = 1d0
       p2 = 0d0

       for j=1,n do begin
         p3 = p2
         p2 = p1
         p1 = ((2*j-1+alf-z)*p2-(j-1+alf)*p3)/j
       endfor

       pp = (n*p1-(n+alf)*p2)/z
       z1 = z
       z = z1-p1/pp
       if (abs(z-z1) le eps) then goto, Jump
    endfor

    Jump:
    x[i-1] = z
    w[i-1] = -exp(lngamma(double(alf+n)) - lngamma(double(n)))/(pp*n*p2)
endfor
return
end
