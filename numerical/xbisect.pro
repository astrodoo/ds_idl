function funcx,x
return, alog(1.+x) - cos(x)
end

pro xbisect
result=bisect('funcx',min=0.,max=1.,itmax=10)
stop
end
