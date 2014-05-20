function nwtrap,func,dfunc,x0=x0,tol=tol,itmax=itmax
;=================================================================================================
;                                      Newton-Rapson Method
;                                                                                       2010.10.04
;                                                                                      DooSoo Yoon
; Newton-Rapson algorithm for root finding
; Input)
;         func : function name
;         dfunc: derivative function name
;         x0   : initial guess
;         tol  : tolerance              (default = 1.d-5)
;         itmax: maximum iterations    (default = 1000)
;
; example)
;         idl> a = nwtrap('funcx','dfuncx',x0=1.,tol=1.d-4,itmax=1000) 
;=================================================================================================
if not keyword_set(tol) then tol=1.d-10
if not keyword_set(itmax) then itmax=1000
smalln = 1.e-20
print,'----- Newton Rapson Metohd -----'
print,'tol= ',tol,'  itmax=',itmax
print,'x0=  ',x0

flag=0
n=0
pold=x0
p=pold+1.
while ((n le itmax) and (flag eq 0)) do begin
   n += 1
   f  = call_function(func,pold)
   df = call_function(dfunc,pold)
   if (df eq 0) then begin
      flag = 1
      Dp = p - pold
      p  = pold
   endif else begin
      p = pold - f / df 
      Dp = p - pold
   endelse
   relerr = abs(Dp)/(abs(p)+smalln)
   if (relerr lt tol) then flag = 1
;print,n,p,abs(p-double(!pi))
   pold = p
endwhile
return, p
end

