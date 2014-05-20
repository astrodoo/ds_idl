; Name
;  READ_HDF
;
; Purpose
;  Read a free-format HDF file data and attributes into IDL structures.
;
; Calling Sequence
;  read_hdf,file,[data,attribute =]
;  ex) read_hdf,'what.hdf',what,attri=info
;
; INPUT
;  File : Name of HDF data file. scalar STRING (Neccesary argument)
;
; OUTPUTS
;  data : IDL Structure to contains array of data(float). Following the name sequence such as
;         data.dset1, data.dset2, data.dset3...
;
; Keyword
;  attribute : IDL Structure to contains array of attributes(string). Following the name sequence
;              same as data structure.
;  silent : Normally, this procedure print attributes to Terminal. If silent keyword set, then attributes
;           disappear.
;
; Written by Chang-Goo Kim, Dec. 2005
;
pro read_hdf,file,data,attribute=attribute,silent=silent,dataind=dataind

ti=systime(/sec)

;make a executive string for define the suitable structure
exeattr='attribute={'
exestr='data={'

;check a file format
if not keyword_set(silent) then begin
if hdf_ishdf(file) then print, '--OK! HDF file--' else print,'--It is not an HDF file--'
endif

;open an HDF file
hid=hdf_sd_start(file)

;read the number of datasets and attributes
hdf_sd_fileinfo, hid, n_dsets, n_atts

;read the grobal attributes
if n_atts ne 0 then begin
gattr='-- Global Attribute --'
exeattr=exeattr+'gattr:strarr(n_elements(gattr)),'
for i=0, n_atts-1 do begin
    hdf_sd_attrinfo, hid, i, name=n,data=d
    gattr=[gattr,n+' = '+d]
endfor
if not keyword_set(silent) then forprint,gattr,textout=1,/silent
endif

if not keyword_set(dataind) then dataind=indgen(n_dsets)+1
NN=n_elements(dataind)
if n_dsets ne 0 then begin
for l=0, NN-1 do begin
i=dataind[l]-1
;select the dataset for each i(zerobased index)
    sid=hdf_sd_select(hid, i)
    hdf_sd_getinfo, sid, name=name, natts=natts, dims=dim

;convert the dimension from integer array to string
    ndim=n_elements(dim)
    sdim='('
    for k=0,ndim-1 do begin
        sdim=sdim+strtrim(string(dim[k]),2)
        if k ne ndim-1 then sdim=sdim+',' else sdim=sdim+')'
    endfor

    dattr='<Data set '+strtrim(string(i+1),2)+' : '+name+'>'
    dattr=[dattr,'dimension = '+sdim]

;read the dataset attributes
    for j=0, natts-1 do begin
       hdf_sd_attrinfo, sid, j, name=n, data=d
       dattr=[dattr,n+' = '+d]
    endfor

    if not keyword_set(silent) then forprint,dattr,textout=1,/silent
;read data and attributes and put them to another variable
    exedset='hdf_sd_getdata,sid,dset'+strtrim(string(i+1),2)
    tmp=execute(exedset)

    exedattr='dattr'+strtrim(string(i+1),2)+'=dattr'
    tmp=execute(exedattr)

;make a executive string for define the suitable structure
    exestr=exestr+'dset'+strtrim(string(i+1),2)+':fltarr'+sdim+','
    exeattr=exeattr+'dset'+strtrim(string(i+1),2)+':strarr(n_elements(dattr'+strtrim(string(i+1),2)+')),'

    hdf_sd_endaccess, sid
endfor
endif

hdf_sd_end, hid

exestr=strmid(exestr,0,strlen(exestr)-1)+'}'
exeattr=strmid(exeattr,0,strlen(exeattr)-1)+'}'

;create data & attributes structure
tmp=execute(exestr)
tmp=execute(exeattr)
;put each data & attributes to each structure
if n_atts ne 0 then attribute.gattr=gattr
if n_dsets ne 0 then begin
for l=0,NN-1 do begin
    i=dataind[l]-1
    tmp=execute('data.dset'+strtrim(string(i+1),2)+'=dset'+strtrim(string(i+1),2))
    tmp=execute('attribute.dset'+strtrim(string(i+1),2)+'=dattr'+strtrim(string(i+1),2))
endfor
endif

te=systime(/sec)
;print,te-ti


end
