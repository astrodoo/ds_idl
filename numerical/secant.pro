function secant,func,x0=x0,x1=x1,tol=tol,itmax=itmax
;=================================================================================================
;                                      Secant Method
;                                                                                       2010.10.04
;                                                                                      DooSoo Yoon
; Secant algorithm for root finding
; Input)
;         func : function name
;         x0   : initial guess
;         x1   : second initial guess
;         tol  : tolerance              (default = 1.d-5)
;         itmax: maximum iterations    (default = 1000)
;
; example)
;         idl> a = secant('funcx',x0=1.,x1=2.,tol=1.d-4,itmax=1000) 
;=================================================================================================
if not keyword_set(tol) then tol=1.d-10
if not keyword_set(itmax) then itmax=1000
smalln = 1.e-20
print,'----- Secant Metohd -----'
print,'tol= ',tol,'  itmax=',itmax
print,'x0=  ',x0, '  x1=   ',x1

flag=0
n=1
p0=x0
p1=x1 & p=x1
while ((n le itmax) and (flag eq 0)) do begin
   n += 1
   f0 = call_function(func,p0)
   f1 = call_function(func,p1)
   df = (f1 - f0) / (p1 - p0)
   if (df eq 0) then begin
      flag = 1
      Dp = p - p1
      p  = p1
   endif else begin
      p = p1 - f1 / df 
      Dp = p - p1
      p0 = p1
      p1 = p
   endelse
;   relerr = abs(Dp)/(abs(p)+smalln)
;   if (relerr lt tol) then flag = 1
   if (abs(Dp) lt tol) then flag = 1

;print,n,p,abs(p-double(!pi))
endwhile
return, p
end

