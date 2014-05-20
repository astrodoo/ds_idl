function div_diff,xx,smpx,coeff
;=================================================================================================
;                                    Divided differences 
;                                                                                       2010.10.17
;                                                                                      DooSoo Yoon
; Given coefficient from interpolating by Newton Form (Numerical Analysis, Brian Bradie, p363)
; results = a0 + a1*(x-x0) + a2*(x-x0)(x-x1) + ... + an*(x-x0)(x-x1)...(x-x_(n-1))
; depend on)
;         interpol_nwt.pro
; Input)
;         x:     x array (the size of array should be 2 or more)
;         coeff: a0,a1,a2,...,an where y = a0 + a1*(x-x0) + a2*(x-x0)(x-x1) + ... + an*(x-x0)...(x-x_(n-1))
;
; example)
;         idl> x = [1.,2.,4.]
;         idl> fx = [3.,2.,5.]
;         idl> interpol_nwt,x,fx,coeff=coeff,coef0=coef0
;         idl> xx = [0.7,1.2,1.4,1.7,2.1,2.6,3.6,4.3]
;         idl> yy = div_diff(xx,x,coef0)
;         idl> yyy = poly(xx,coeff)
;=================================================================================================
nx = n_elements(smpx)
nc = n_elements(coeff)
if (nx lt (nc-1)) then begin
   print,"nx should be larger than n_coeff-1"
   stop
endif

nxx = n_elements(xx)
result = replicate(coeff[0],nxx)
term   = replicate(1.,nxx)
for i=1,nc-1 do begin
   term = term*(xx - smpx[i-1])
   result += term * coeff[i]
endfor

return, result
end
