pro interpol_nwt,x,fx0,coeff=coeff,coef0=coef0
;=================================================================================================
;                           Newton form of the interpolating polynomial
;                                                                                       2010.10.17
;                                                                                      DooSoo Yoon
; Interpolating from divided differences and Newtorn form (Numerical Analysis, Brian Bradie, p363)
; Input)
;         x:     x array (the size of array should be 2 or more)
;         fx:    fx array
; Output)
;         coef0: a0,a1,a2,...,an where y = a0 + a1*(x-x0) + a2*(x-x0)(x-x1) + ... + an*(x-x0)...(x-x_(n-1))
;         coeff: b0,b1,b2,...,bn where y = b0 + b1*x + b2*x^2 + b3*x^3 + ... + bn*x^n
;
; example)
;         idl> x = [1.,2.,4.]
;         idl> fx = [3.,2.,5.]
;         idl> interpol_nwt,x,fx,coeff=coeff,coef0=coef0
;         idl> xx = [0.7,1.2,1.4,1.7,2.1,2.6.3.6,4.3]
;         idl> yy = poly(xx,coeff)
;         idl> yy2 = div_diff(xx,x,coef0)
;=================================================================================================
nx = n_elements(x)
if (nx ne n_elements(fx0)) then begin
   print,'It should be same size in x and fx!!'
   stop
endif else if (nx le 1) then begin
   print,'The number of elements should be over 1!!'
   stop
endif

coeff = fltarr(nx) & coef0 = fltarr(nx)

fx = fx0
x1 = x & x2 = x

coef0[0] = fx[0]

; construct divided difference matrix
for i=1,nx-1 do begin
   for j=0,nx-i-1 do begin
      fx[j] = (fx[j+1] - fx[j]) / (x2[j+1] - x1[j]) 
      x2[j] = x2[j+1]  
   endfor
   coef0[i] = fx[0]
endfor

; calculate coefficient for polynomials
xx = -x
coeff = coef0

for i = 1, nx-1 do coeff[0] += coef0[i]*product(xx[0:i-1])

for i=1,nx-2 do begin
   coeff[i] += total(xx[0:i]) * coef0[i+1]
   for j=i+2,nx-1 do begin
      xterm = 0.
      for k=0,j-1 do $
         if (k+j-i-1 lt j) then xterm += product(xx[k:k+j-i-1]) $
                       else xterm += product(xx[k:j-1])*product(xx[0:k-i-1])
      coeff[i] += xterm * coef0[j]
   endfor
endfor
end
