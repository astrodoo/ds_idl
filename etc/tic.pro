; :Examples:
;    Here is how to use this program::
;       IDL> .rn tic
;       IDL> tic
;       IDL> p = Plot(cgDemodata(1))
;       IDL> toc
;       
;    in routines,
;
;       resolve_routine,'tic',/compile_full_file
;       tic
;       for i = 1, 100 do print,'hey',i
;       toc
;
; :Author:
;    FANNING SOFTWARE CONSULTING::
;       David W. Fanning 
;       1645 Sheely Drive
;       Fort Collins, CO 80526 USA
;       Phone: 970-221-0438
;       E-mail: david@idlcoyote.com
;       Coyote's Guide to IDL Programming: http://www.idlcoyote.com
; 
; :Modified: 
;     Doosoo Yoon @ 03 March 2016
;
; :History:
;     Change History::
;        Written, 10 January 2013 by David W. Fanning.
;
; :Copyright:
;     Copyright (c) 2013, Fanning Software Consulting, Inc.
;-
PRO toc, ELAPSED_TIME=elapsed_time, silent=silent
   COMMON _fsc_clock$time, start_time
   elapsed_time = Systime(1) - start_time
   if not keyword_set(silent) then $
      Print, 'Elapsed Time: ', elapsed_time, Format='(A15, x, F0.6)'
END

PRO tic
   COMMON _fsc_clock$time, start_time
   start_time = Systime(1)
END
