function bisect,func,min=min,max=max,tol=tol,itmax=itmax
;=================================================================================================
;                                      Bisection Method
;                                                                                       2010.10.04
;                                                                                      DooSoo Yoon
; Bisection algorithm for root finding
; Depend on) sign.pro
; Input)
;         func: function name
;         min : minimum in range
;         max : maximum in range
;         tol : tolerance              (default = 1.d-5)
;         itmax: maximum iterations    (default = 1000)
;
; example)
;         idl> a = bisect('funcx',min=0.1,max=1.,tol=1.d-4,itmax=1000) 
;=================================================================================================
if not keyword_set(tol) then tol=1.d-5
if not keyword_set(itmax) then itmax=1000

print,'----- Bisection Metohd -----'
print,'min= ',min,'  max=',max
print,'tol= ',tol,'  itmax=',itmax

a = min & b = max
fa = call_function(func,a)
fb = call_function(func,b)

sfa = sign(fa)
sfb = sign(fb)
if (sfa*sfb ge 0) then begin
   print,'no root in this range'
   stop
end 

flag=0
n=0
while ((n le itmax) and (flag eq 0)) do begin
   n += 1
   p = ( a + b ) / 2.
   if ((b-a) lt 2.*tol) then flag = 1
   sfp = sign(call_function(func,p))
   if (sfa*sfp lt 0) then b = p $
     else begin
        a = p
        sfa = sfp
   endelse
;print,n,p,abs(!pi-p), (max-min)/2.^n
endwhile
return, p
end

