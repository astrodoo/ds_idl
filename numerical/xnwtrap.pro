function funcx,x
return, exp(-x) - x
end

function dfuncx,x
return, -exp(-x) - 1. 
end

pro xnwtrap
a=0 & b=1.
x = findgen(1001)/1000.*(b-a) + a
!p.background=255 & !p.color=0
loadct,39,/sil
window,0
plot,x,funcx(x),/xst,xtitle='x',ytitle='f(x)',title='Figure 6',yst=2,/noerase
oplot,!x.crange,[0.,0.],line=2.
x0 = 0.2
plots,[x0,funcx(x0)],psym=4,symsize=2.
result=nwtrap('funcx','dfuncx',x0=x0,itmax=6)
x1 = 0.540199 
x2 = 0.567011
x3 = 0.567143
plots,[x1,funcx(x1)],psym=4,symsize=2.
plots,[x2,funcx(x2)],psym=4,symsize=2.
plots,[x3,funcx(x3)],psym=4,symsize=2.


stop
end
