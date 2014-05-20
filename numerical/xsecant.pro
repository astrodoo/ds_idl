function funcx,x
return, exp(-x) - x
end

pro xsecant
a=0 & b=1.
x = findgen(1001)/1000.*(b-a) + a
!p.background=255 & !p.color=0
loadct,39,/sil
window,0
plot,x,funcx(x),/xst,xtitle='x',ytitle='f(x)',title='Figure 9',yst=2,/noerase
oplot,!x.crange,[0.,0.],line=2.
x0=0.d0
x1=1.d0
plots,[x0,funcx(x0)],psym=4,symsize=2.
plots,[x1,funcx(x1)],psym=4,symsize=2.

result=secant('funcx',x0=x0,x1=x1,itmax=6)
x2 = 0.612700
x3 = 0.563838
x4 = 0.567170
plots,[x2,funcx(x2)],psym=4,symsize=2.
plots,[x3,funcx(x3)],psym=4,symsize=2.
plots,[x4,funcx(x4)],psym=4,symsize=2.


stop
end
