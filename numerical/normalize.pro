function normalize, x
; normalize the vetor (1 dimension array).

sum = sqrt(total(x*x))
if (sum ne 0) then return, x/sum else return, x
end

