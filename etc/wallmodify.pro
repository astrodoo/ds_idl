pro wallmodify

openr,lun1,'wallmodify.dat',/get_lun

;default values
col = 'yellow'
sz  = 2
tk  = 2
lspace = 25
xpos = 200
ypos = 400

line=''
conf = 1
body = 0
bline=''
while not EOF(lun1) do begin
   readf,lun1,line
   if (strmatch(line, '# content*')) then conf=0
   if (strmid(line,0,1) ne '#') then begin  ;comment
      if (conf) then begin    ; configuration
         lsplit = strtrim(strsplit(line,'=',/extract),2)
         if (lsplit[0] eq 'color') then col = lsplit[1] $
          else if (lsplit[0] eq 'size') then sz = float(lsplit[1]) $
          else if (lsplit[0] eq 'thick') then tk = float(lsplit[1])$
          else if (lsplit[0] eq 'lspace') then lspace = float(lsplit[1])$
          else if (lsplit[0] eq 'xpos') then xp = float(lsplit[1]) $
          else if (lsplit[0] eq 'ypos') then yp = float(lsplit[1]) 
      endif else begin
         if (strmatch(line,'body_begin*')) then begin
            body=1 
            goto, Jump1
         endif else if (strmatch(line,'body_end*')) then body=0 
         if ~(body) then begin
            lsplit = strtrim(strsplit(line,'=',/extract),2)
            if (lsplit[0] eq 'title') then title=lsplit[1]
         endif else begin
            bline = [bline,line]
         endelse
Jump1:
      endelse
   endif
endwhile
free_lun,lun1
bline = bline[1:*]

print,'color  = ',col
print,'size   = ',sz
print,'thick  = ',tk
print,'lspace = ',lspace
print,'xpos   = ',xp
print,'ypos   = ',yp

; read image
dir = '~/Pictures/wallpapers/'
read_jpeg,dir+'wall_origin.jpg',img

imgsz = size(img,/dimension)
window,xs=imgsz[1],ys=imgsz[2],/pixmap
tv,img,/true

; writing title
xyouts,xp,yp,/dev,title+'   ('+today()+')',color=fsc_color(col),charthick=tk*1.5,charsize=sz*1.5

; writig body
for i=0,n_elements(bline)-1 do xyouts, xp, yp-lspace*(i+1),/dev,'* '+bline[i],color=fsc_color(col),charthick=tk,charsize=sz

; save image to 'wall.jpg'
write_jpeg,dir+'wall.jpg',tvrd(/true),/true

stop
end

pro mktemplate
openw,lun1,'wallmodify.dat',/get_lun
printf,lun1,'# configuration and content for wallmodify.pro'
printf,lun1,'# configuration'
printf,lun1,'color  = yellow'
printf,lun1,'size   = 2.'
printf,lun1,'thick  = 2.'
printf,lun1,'lspace = 25.'
printf,lun1,'xpos   = 700'
printf,lun1,'ypos   = 1000'
printf,lun1,' '
printf,lun1,'# content'
printf,lun1,'title = Todo'
printf,lun1,'body_begin'
printf,lun1,'Hey!!!!!'
printf,lun1,'Yo!!!!'
printf,lun1,'body_end'
free_lun,lun1
stop
end

