forward_function funct1

pro xddeabm

nth = 5
th = findgen(nth)/float(nth-1)*!pi/2.

integ = fltarr(nth)

th0=th[0] & integ0=0.
for i=0, nth-1 do begin
    print,th0,integ0,th[i],format='(f,f,f)'
    ddeabm, 'funct1', th0, integ0, th[i]
    integ[i] = integ0
endfor

window,0

plot,th,sin(th), yst=2   ; analytic solution
oplot,th,integ, psym=4

stop
end

function funct1, th, int
   return, cos(th)
end
