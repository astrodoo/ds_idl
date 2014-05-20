pro xinterpol_nwt
; depend on)
; interpol_nwt.pro  &  div_diff.pro

xmax = 10.
xmin = 1.
nx = 10
smpx = findgen(nx)/float(nx)*(xmax - xmin) + xmin
smpfx = smpx^3.-5.*smpx^2.+50.


interpol_nwt,smpx,smpfx,coef0=coef0,coeff=coeff

nxx = 1000
xx = findgen(nxx)/float(nxx)*(xmax - xmin) + xmin

;using coeff
yy = poly(xx,coeff)

;using coef0  (-> divided difference form)
; yyy = a0 + a1(x-x0) + a2(x-x0)(x-x1) + ... + an(x-x0)...(x-x_(n-1))
yyy = div_diff(xx,smpx,coef0)

window,0
plot,xx,yy,xst=2,xtitle='x',ytitle='interpolating polynomial'
oplot,xx,yyy
oplot,smpx,smpfx,psym=4
stop
end
