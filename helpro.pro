pro helpro, proname, nline=nline
;( =_=)++  =========================================================================
;
; NAME: 
;   HELPRO
;
; PURPOSE:
;   This routine is supposed to read head part of the designated procedure to 
;   help users to figure out what the routine is.
;
; DEPENDENCE:
;   which_routine.pro  
;   in the package of GBTIDL  (http://gbtidl.nrao.edu/)   
;
; AUTHOR:
;   DOOSOO YOON
;   Department of Astronomy, UW-Madison
;   475 N. Charter St., Madison, WI 53705
;   Web: http://www.astro.wisc.edu/~yoon
;   E-mail: yoon@astro.wisc.edu
;
; CATEGORY:
;   Graphic
;
; PARAMS:
;   proname: in, required, type= string
;        procedure name 
;
; KEYWORDS:
;   nline: in, required, type= integer, default= 50
;        the number of lines to be read
;
; EXAMPLE:
;   idl> helpro,"readcol.pro", nline=30
;
; HISTORY:
;   written, 5 May 2014, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2014-, All rights reserved by DooSoo Yoon.
;===================================================================================
if not keyword_set(nline) then nline=50
resolved = which_routine(proname, unresolved=unresolved)

if n_elements(resolved) eq 1 then begin
    if strlen(resolved) gt 0 then begin
        print, 'Currently-Compiled Module '+strupcase(proname)+' in File:'
        print, resolved, format='(A,%"\N")'
        spawn, "head -n "+strtrim(nline,2)+" "+resolved
    endif else print, strupcase(proname), format='("Module ",A," Not Compiled.",%"\N")'
endif else begin
    if n_elements(resolved) eq 2 then begin
        print, 'Identically-named modules have been compiled as'+$
               ' a procedure and a function!'
        print, 'The Currently-Compiled modules '+strupcase(proname)+' are in these files'
        print, 'Procedure: ', resolved[0]
        print, ' Function: ', resolved[1]
    endif else begin
        message,'Unexpected error, this should never happen'
    endelse
endelse

if strlen(resolved[0]) eq 0 and strlen(unresolved[0]) eq 0 then begin
    message, proname + '.pro not found on IDL !path.', /INFO
    return
endif

if strlen(unresolved[0]) gt 0 then begin
    ; PRINT THE REMAINING ROUTINES...
    print, 'Other Files Containing Module '+strupcase(proname)+' in IDL !path:'
    print, transpose(unresolved)
    spawn, "head -n "+strtrim(nline,2)+" "+unresolved
endif

end
