function func,x
return,exp(x)
end

pro xgauleg

nx=5000
x1=1.
x2=5.
gauleg,x1,x2,x,w,nx

int=0
for i=0,nx-1 do int += w[i]*func(x[i])

real = exp(x2)-exp(x1)

print,"integrated: ",int
print,"real: ",real

stop
end
