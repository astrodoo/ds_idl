forward_function diff

pro xrk4
;====================================================================
;               example code for Runge-Kutta 4th in IDL
;                                                          2009.10.26
;                                                         DooSoo Yoon
;
;   ex) original eq:     y    = 2.*x^3.
;       initial value:   y    = 0.
;       differentail eq: dydx = 6.*x^2.
;====================================================================
device, decomposed=0
;-------------------------------------------------------------------
; setting parameters
;-------------------------------------------------------------------
N = 1000                                      ; number of data
xmax = 10. & xmin=0.                          ; x-range
x = findgen(N)/float(N-1)*(xmax-xmin)+xmin    ; generate x-values
y = fltarr(N,1)                               ; result values

h = x[1]-x[0]                                 ; scale length             
;-------------------------------------------------------------------
; initial values
;-------------------------------------------------------------------
y[0,0]=0.                    
dydx = diff(x[0],y[0,*])
;-------------------------------------------------------------------
; running
;-------------------------------------------------------------------
for i=1, N-1 do begin
    y[i,*] = rk4(y[i-1,*], dydx, x[i], h, 'diff') ; derive y for next step using runge-kutta
    dydx = diff(x[i],y[i,*])                      ; update differential equations
endfor
;-------------------------------------------------------------------
; plotting
;-------------------------------------------------------------------
loadct,39
window,0
plot,x,y,psym=2,xtitle='x',ytitle='y'
oplot,x,2.*x^3,color=50        ; overplotting for original equation
stop
end
;-------------------------------------------------------------------
; differential equations
;-------------------------------------------------------------------
function diff, x, y
  return, [6.*x*x]             ; differential equations            
end
