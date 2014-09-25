pro save_append,filename=filename,var1,var2,var3,var4,var5,var6,var7,var8,var9,var10 $
               ,var11,var12,var13,var14,var15
;( =_=)++  =========================================================================
;
; NAME: 
;   SAVE_APPEND
;
; PURPOSE:
;   This routine is aimed to save variable onto already existed save file.
;
; AUTHOR:
;   DOOSOO YOON
;   Department of Astronomy, UW-Madison
;   475 N. Charter St., Madison, WI 53705
;   Web: http://www.astro.wisc.edu/~yoon
;   E-mail: yoon@astro.wisc.edu
;
; CATEGORY:
;   util
;
; PARAMS:
;   var1[,var2,var3 ... var15]: in, required, type= anything
;        variables to be saved
;
; KEYWORDS:
;   filename: in, required, type= string
;        the name of objective file.
;
; EXAMPLE:
;   idl> save_append,filename='tmp.sav',(aa=10),(bb=findgen(10))
;
; HISTORY:
;   written, 17 February 2014, by DooSoo Yoon.
;   2014.02.24: modify some bugs
;   2014.09.25: overwrite the new data into old data if the variable name already exists
;  
; COPYRIGHT:
;   Copyright 2014-, All rights reserved by DooSoo Yoon.
;===================================================================================
dfile = file_search(filename)

n_var = n_params()
if (n_params() eq 0) then begin
   print,'we have no variable to save.'
   stop
end

;lev = routine_names(/level)
;vlev = lev-1
;vnames = routine_names(variable=vlev)
;vnames = scope_varname(level=-1)
;print,vnames

vnames_dummy = scope_varname(var1,var2,var3,var4,var5,var6,var7,var8,var9,var10 $
                            ,var11,var12,var13,var14,var15, level=-1)
vnames = vnames_dummy[where(vnames_dummy ne '')]

print,'saving variables: ',vnames

vnameStr1 = ''
for i=0,n_var-1 do begin
   strexec = execute(vnames[i]+'=var'+strtrim(i+1,2))
   if (i ne 0) then vnameStr1 += ','
   vnameStr1 += vnames[i] 
endfor

if (dfile eq '') then begin
  print, 'write data on new file to'+filename
  strexec=execute('save,filename=filename,'+vnameStr1)
endif else begin
  sObj = obj_new('IDL_Savefile',dfile)
  vnames_old = sObj -> names()
  obj_destroy,sObj

  print,'old variables: ',vnames_old
;  dummy1 = routine_names(variables=0)
;  dummy1 = scope_varname(level=0)

  for i=0,n_var-1 do strexec = execute(vnames[i]+'_dummy ='+vnames[i])      ; overwrite new data into old data if the variable name exists
  restore,filename=filename
  for i=0,n_var-1 do strexec = execute(vnames[i]+'='+vnames[i]+'_dummy')
;  dummy2 = routine_names(variables=0)
;  dummy2 = scope_varname(level=0)

  vnameStr2 = ''
  for i=0,n_elements(vnames_old)-1 do vnameStr2 += ','+vnames_old[i]

  strexec=execute('save,filename=filename,'+vnameStr1+vnameStr2)
endelse

end
