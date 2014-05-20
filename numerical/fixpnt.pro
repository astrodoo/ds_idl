function fixpnt,func,x0=x0,tol=tol,itmax=itmax
;=================================================================================================
;                                  Fixed Point Iterations Method
;                                                                                       2010.10.04
;                                                                                      DooSoo Yoon
; Fixed point iterations algorithm for root finding
; Input)
;         func : function name
;         x0   : initial guess
;         tol  : tolerance              (default = 1.d-5)
;         itmax: maximum iterations    (default = 1000)
;
; example)
;         idl> a = fixpnt('funcx',x0=1.,tol=1.d-4,itmax=1000) 
;=================================================================================================
if not keyword_set(tol) then tol=1.d-10
if not keyword_set(itmax) then itmax=1000
smalln = 1.e-20
print,'----- fixed point Metohd -----'
print,'tol= ',tol,'  itmax=',itmax
print,'x0=  ',x0

flag=0
n=0
pold=x0
p=x0+1.
while ((n le itmax) and (flag eq 0)) do begin
   n += 1
   f = call_function(func,pold)
   p = f
   if (abs(p-pold) lt tol) then flag=1 
;print,n,p,abs(0.7390851332 - p),format='(i,"   ",f12.10,"   ",f12.10)'
   pold = p
endwhile
return, p
end

