function funcx,x
return, alog(1.+x) - cos(x)
end

pro xflspos

result=flspos('funcx',min=0.,max=1.,itmax=10)

x = findgen(1001)/1000.

plot,x,funcx(x),/xst,/yst,xtitle='x',ytitle='f(x)',title='Figure 4'
oplot,!x.crange,[0.,0.],line=2.
oplot,[0.8674,0.8674],!y.crange,line=2
oplot,[0.8842,0.8842],!y.crange,line=2
oplot,[0.8845,0.8845],!y.crange,line=2
stop
end
