pro trim,fname,mult=mult,recover=recover
;=============================================================================
;                             trim the data
;                                                                   2012.06.13
;                                                                  DooSoo Yoon
;=============================================================================
if not keyword_set(fname) then fname='plt_'

if keyword_set(recover) then begin
   spawn,'mv tmp_jet/* .'
   stop
endif

if not keyword_set(mult) then mult=5

fnames = file_search('*'+fname+'*')

spawn,'mkdir tmp_jet'

find = indgen(n_elements(fnames))
fnames1 = fnames[where((find mod mult) ne 0)]

for i=0, n_elements(fnames1)-1 do begin
    print,'mv '+fnames1[i]+' tmp_jet/    (last: '+fnames[n_elements(fnames)-1]+')'
    spawn,'mv '+fnames1[i]+' tmp_jet/'
endfor

stop
end
