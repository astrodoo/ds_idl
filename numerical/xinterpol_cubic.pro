pro xinterpol_cubic

x = findgen(9)*100. + 300.
y = [0.024,0.035,0.046,0.058,0.067,0.083,0.097,0.111,0.125]

xx = findgen(1000)/999.*(1100.-300.) + 300.

yy = interpol_cubic(xx,x,y)

plot,xx,yy
oplot,x,y,psym=4

stop
end
