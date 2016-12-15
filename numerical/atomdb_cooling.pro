pro atomdb_cooling,mkdata=mkdata,showline=showline

; draw cooling function from atomdb
; depend on atomdb data sets (apec_line.fits & apec_coco.fits) and atomdb_idl package
; it requires to run
; > @init_atomdb_idl


if keyword_set(mkdata) then begin

atomdb=getenv('ATOMDB')
if (n_elements(line) eq 0) then $
  read_linelist,atomdb+'/apec_line.fits',line,Tl,nl,lambdal
if (n_elements(coco) eq 0) then $
  read_coco,atomdb+'/apec_coco.fits',coco,Tc,nc,lambdac

lambdatot = lambdal + lambdac
cool = {Cooling, line:line, Tl:Tl, nl:nl, lambdal:lambdal,  $
                 Tc:Tc, nc:nc, lambdac:lambdac,  $
                 lambdatot:lambdatot}
save,file='atomdb_cooling.sav',cool
endif else restore,file='atomdb_cooling.sav'

;o7_r_apec  = extract_line(line, 1, s, 1, 7, t_o7_r,/actual)


pltx0=100. & plty0=70.
pltxs=600. & pltys=500.
winxs=pltx0+pltxs+20 & winys=plty0+pltys+110

mkeps,'atomdb_cooling',xs=20.,ys=20.*winys/winxs
plot,cool.Tl,cool.lambdatot,thick=3,yrange=[1.e-24,1.e-21],/xlog,/ylog,xtitle='Temperature (K)' $
    ,ytitle=textoidl('\Lambda (erg cm^{3} s^{-1})') $;,title='Cooling function in CIE (from atomdb data)' 
    ,xstyle=9,position=posnorm([pltx0,plty0,pltx0+pltxs,plty0+pltys],nx=winxs,ny=winys),/norm
oplot,cool.Tl,cool.lambdal,linestyle=1,thick=3
oplot,cool.Tc,cool.lambdac,linestyle=2,thick=3

keV = cool.Tl*!unit.k/!unit.ev/1.e3

axis,xaxis=1,/xst,xrange=[kev[0],kev[n_elements(kev)-1]],/xlog,xtickformat='tickexp';,xtitle='Energy range [keV]'
xyouts,0.42,(plty0+pltys+40)/winys,/norm,'Energy range (keV)'

legend,['Total','Line','Continuum'],line=[0,1,2],color=0,box=0,/top,/right

xyouts,0.25,(plty0+pltys+80)/winys,/norm,'Cooling function in CIE (from atomdb data)' 

epsfree
stop
end

pro atomdb_cooling_comp

; compare cooling functions from atomdb and Sutherland & Dopita (1997)
; depend on atomdb data sets (apec_line.fits & apec_coco.fits) and atomdb_idl package, and cooling curve table (m-00.cie) for Sutherland curve.
; it requires to run
; > @init_atomdb_idl


atomdb = '~/atomdb_v3.0.6'
if (n_elements(line) eq 0) then $
  read_linelist,atomdb+'/apec_line.fits',line,Tl,nl,lambdal
if (n_elements(coco) eq 0) then $
  read_coco,atomdb+'/apec_coco.fits',coco,Tc,nc,lambdac

; read old version (v2.0.2)
;atomdb_old = '~/heasoft-6.19/spectral/modelData'
atomdb_old = '~/atomdb_v2.0.2'
if (n_elements(line2) eq 0) then $
  read_linelist,atomdb_old+'/apec_line.fits',line2,Tl2,nl2,lambdal2
if (n_elements(coco2) eq 0) then $
  read_coco,atomdb_old+'/apec_coco.fits',coco2,Tc2,nc2,lambdac2

sdcool_dir = '/home/astrodoo/Sutherland_CoolCurve/'
readcol, sdcool_dir+'m-00.cie',Tlgsd, lambdalgsd, format='(f,x,x,x,x,f,x,x,x,x,x,x)'
Tsd = 10.^Tlgsd
lambdasd = 10.^lambdalgsd

loadct,39,/sil
mkeps,'atomdb_cooling_comp',xs=20.,ys=20.*6./8.
plot,Tl2,lambdal2+lambdac2,thick=3,yrange=[1.e-24,3.e-21],/xlog,/ylog,xtitle='Temperature (K)',/yst $
    ,ytitle=textoidl('\Lambda (erg cm^{3} s^{-1})'),title='Cooling function in CIE (from atomdb data)'
oplot,Tl2,lambdal2,linestyle=1,thick=3
oplot,Tc2,lambdac2,linestyle=2,thick=3

oplot,Tl,lambdal+lambdac,thick=3, color=50
oplot,Tl,lambdal,linestyle=1,thick=3, color=50
oplot,Tc,lambdac,linestyle=2,thick=3, color=50

oplot,Tsd,lambdasd,thick=3, color=254

legend,['v2.0.2','v3.0.6','Sutherland+97','Total','Line','Continuum'],line=[-1,-1,-1,0,1,2],psym=[-3,-3,-3,-3,-3,-3] $
    ,color=[0,50,254,0,0,0],textcolor=[0,50,254,0,0,0],box=0,/top,/right,charsize=1.3

epsfree
stop
end
