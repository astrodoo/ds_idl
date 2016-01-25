pro wallresize,fname,original=original

img_org = read_image(fname)
fname2 = strmid(fname,0,strlen(fname)-4)

imgsz = size(img_org,/dimension)
print,'original image size: ',strtrim(imgsz[1],2),' x ',strtrim(imgsz[2],2)
scrsz = get_screen_size()
print,'screen size        : ',strtrim(fix(scrsz[0]),2),' x ',strtrim(fix(scrsz[1]),2)
scr_rat = scrsz[1]/scrsz[0]  ; screen y/x

if not keyword_set(original) then begin
   xzoom = 1000.
   img2 = congrid(img_org,3,xzoom,xzoom*float(imgsz[2])/float(imgsz[1]))
   img2sz = size(img2,/dimension)
   window,0,xs=img2sz[1],ys=img2sz[2]
   tv,img2,/true
endif else begin
   swindow,xs=imgsz[1],ys=imgsz[2]
   tv,img_org,/true
endelse

cursor,x1,y1,/dev,/down
cursor,x2,y2,/dev,/down

xmin = min([x1,x2]) & xmax = max([x1,x2])
ymin = min([y1,y2]) & ymax = max([y1,y2])

xx = [xmin,xmax,xmax,xmin,xmin]
yy = [ymin,ymin,ymax,ymax,ymin]

xmin = float(xmin) & ymax = float(ymax)
xmin = float(xmin) & ymax = float(ymax)

tvlct,r,g,b,/get
plots,xx,yy,/dev,color=fsc_color('cyan'),thick=5
tvlct,r,g,b

;select_rat = (ymax-ymin)/(xmax-xmin)

ymax2 = ymin + scr_rat*(xmax-xmin)
yy2 = [ymin,ymin,ymax2,ymax2,ymin]

if ((not keyword_set(original) and (ymax2 gt img2sz[1])) or $
    (keyword_set(original) and (ymax2 gt imgsz[1]))) then begin
   print,'error due to out of range in y upper bound in modified figure'
   stop
end

tvlct,r,g,b,/get
plots,xx,yy2,/dev,color=fsc_color('magenta'),thick=5
tvlct,r,g,b

if not keyword_set(original) then begin
   xmin_fin = fix(xmin*float(imgsz[1])/float(img2sz[1]))
   xmax_fin = fix(xmax*float(imgsz[1])/float(img2sz[1]))
   ymin_fin = fix(ymin*float(imgsz[2])/float(img2sz[2]))
   ymax_fin = fix(ymax2*float(imgsz[2])/float(img2sz[2]))
endif else begin
   xmin_fin = fix(xmin)
   xmax_fin = fix(xmax)
   ymin_fin = fix(ymin)
   ymax_fin = fix(ymax)
endelse

img_clip = img_org[*,xmin_fin:xmax_fin,ymin_fin:ymax_fin]

img_resz = congrid(img_clip,3,scrsz[0],scrsz[1])

window,1,xs=scrsz[0],ys=scrsz[1],/pixmap
tv,img_resz,/true

snapshot,fname2+'_'+strtrim(fix(scrsz[0]),2)+'_'+strtrim(fix(scrsz[1]),2)

stop
end
