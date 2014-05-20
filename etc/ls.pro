;+
; NAME:
;       DIR
;
; PURPOSE:
;       Simple procedure that can be executed within an interactive session of IDL to print
;       the filesystem contents of the current working directory to the output log.
;
; CATEGORY:
;       Utilities
;
; CALLING SEQUENCE:
;       dir
;
; INPUT PARAMETERS:
;       None.
;
; KEYWORD PARAMETERS:
;       None.
;
; OUTPUTS:
;       None.
;
; COMMON BLOCKS:
;       None.
;
; MODIFICATION HISTORY:
;       Written by: AEB, 4/03.
;-

PRO ls
COMPILE_OPT HIDDEN
;find all files, subfolders, and their attributes in the current working directory:
files=FILE_SEARCH(COUNT=count,/ISSUE_ACCESS_ERROR,/MARK_DIRECTORY,/MATCH_ALL_INITIAL_DOT)
;if no files are found then return:
if count EQ 0 then RETURN
;loop through each of the files and print-out a UNIX style listing similar to 'ls -la':
PRINT,''
for i=0,count-1 do begin
  ;obtain information about the current file:
  fileInfo=FILE_INFO(files[i])
  ;determine file type and permissions:
  if fileInfo.directory EQ 1 then text='d' else text='-'
  if fileInfo.read EQ 1 then text=text+'r' else text=text+'-'
  if fileInfo.write EQ 1 then text=text+'w' else text=text+'-'
  if fileInfo.execute EQ 1 then text=text+'x' else text=text+'-'
  ;determine file size in bytes:
  fileSize=STRTRIM(fileInfo.size,2)
  ;pad file size string with whitespace so columns line-up when printed with a monospace font:
  if (STRLEN(fileSize) LT 12) then begin
    whitespaceLength = 12 - STRLEN(fileSize)
    whitespace = STRING(BYTARR(whitespaceLength) + 32B)
    fileSize = fileSize + whitespace
  endif
  ;concatenate string and print:
  text=text+'     '+fileSize+'  '+STRTRIM(SYSTIME(0,fileInfo.mtime),2)+'     '+files[i]
  PRINT,text
endfor
PRINT,''
END
