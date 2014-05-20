pro unit,help=help
;( =_=)++  =========================================================================
;
; NAME: 
;   UNIT
;
; PURPOSE:
;   To summon the physical constants by using defined system variables 
;
; AUTHOR:
;   DOOSOO YOON
;   Department of Astronomy, UW-Madison
;   475 N. Charter St., Madison, WI 53705
;   Web: http://www.astro.wisc.edu/~yoon
;   E-mail: yoon@astro.wisc.edu
;
; CATEGORY:
;   Utility
;
; PARAMS:
;
; KEYWORDS:
;   help: in, optional, type=boolean
;        describing the overall physical constants in values and units
;
; EXAMPLE:
;   idl> unit
;   idl> unit,/help
;   idl> print, !unit.h 
;
; HISTORY:
;   written, 02 November 2007, by DooSoo Yoon.
;  
; COPYRIGHT:
;   Copyright 2007-, All rights reserved by DooSoo Yoon.
;===================================================================================
runstr='unit={'

;physical constant
runstr=runstr+'g:6.67259d-8 ,'      ; gravitational constant[dyne cm^2 g^-2]
runstr=runstr+'g1:4.298 ,'          ; gravitational constant[M_sol^-1 pc^2 km^2 s^-2 kpc^-1]
runstr=runstr+'c:2.99792458d10 ,'   ; speed of light[cm s-1]
runstr=runstr+'h:6.6260755d-27 ,'   ; planck's constant[erg s] 
runstr=runstr+'hb:1.0545727d-27 ,'  ; reduced planck's constant / 2pi [erg s] 
runstr=runstr+'k:1.380658d-16 ,'    ; boltzmann's constant[erg K^-1]
runstr=runstr+'sigma:5.67051d-5 ,'  ; stefan-boltzmann constant[erg cm^-2 s^-1 K^-4]
runstr=runstr+'mp:1.6726231d-24 ,'  ; proton mass[g]
runstr=runstr+'mn:1.674929d-24 ,'   ; neutron mass[g]
runstr=runstr+'me:9.1093897d-28 ,'  ; electron mass[g]
runstr=runstr+'mh:1.673534d-24 ,'   ; hydrogen mass[g]
runstr=runstr+'amu:1.6605402d-24 ,' ; atomic mass unit[g]
runstr=runstr+'e:4.803206d-10 ,'    ; electric charge[esu]
runstr=runstr+'ev:1.60217733d-12 ,' ; electron volt[erg]
runstr=runstr+'Na:6.0221367d23 ,'   ; avogadro's number[mole^-1]
runstr=runstr+'a0:5.29177249d-9 ,'  ; bohr radius[cm]
runstr=runstr+'re:2.81794092d-13 ,' ; classical electron radius[cm]
runstr=runstr+'rh:1.09677585d5 ,'   ; rydberg constant [cm^-1]
runstr=runstr+'Tcs:6.652d-25 ,'     ; Thomson Cross section [cm^2]

;astronomical constant
runstr=runstr+'msun:1.989d33 ,'     ; solar mass[g]
runstr=runstr+'lsun:3.826d33 ,'     ; solar luminosity[erg s^-1]
runstr=runstr+'rsun:6.9599d10 ,'    ; solar radius[cm]
runstr=runstr+'Tsun:5770d0 ,'       ; solar effective temperature[K]
runstr=runstr+'mearth:5.974d27 ,'   ; earth mass[g]
runstr=runstr+'rearth:6.378d8 ,'    ; earth radius[cm]
runstr=runstr+'ly:9.4605d17  ,'     ; light year[cm]
runstr=runstr+'pc:3.0857d18 ,'      ; parsec[cm]
runstr=runstr+'au:1.4960d13 ,'      ; astronomical unit[cm]
runstr=runstr+'Jy:1.d-23 ,'         ; Jansky unit [ergs cm^-2 s^-1 Hz^-1]
runstr=runstr+'year:3.15360e7}'     ; year [s]

tmp=execute(runstr)

;registration to system variables
defsysv,'!unit',unit,1

;showing the dimension and property
if keyword_set(help) then begin
   comment = ['[dyne cm^2 g^-2]                 gravitational constant'       $
             ,'[M_sol^-1 pc^2 km^2 s^-2 kpc^-1] gravitational constant   '    $
             ,'[cm s-1]                         speed of light'               $ 
             ,'[erg s]                          planck constant'              $ 
             ,'[erg s]                          reduced planck constant /2pi' $ 
             ,'[erg K^-1]                       boltzmann constant'           $
             ,'[erg cm^-2 s^-1 K^-4]            stefan-boltzmann constant'    $
             ,'[g]                              proton mass'                  $
             ,'[g]                              neutron mass'                 $
             ,'[g]                              electron mass'                $
             ,'[g]                              hydrogen mass'                $
             ,'[g]                              atomic mass unit'             $
             ,'[esu]                            electric charge'              $
             ,'[erg]                            electron volt'                $
             ,'[mole^-1]                        avogadro number'              $
             ,'[cm]                             bohr radius'                  $
             ,'[cm]                             classical electron radius'    $
             ,'[cm^-1]                          rydberg constant'             $
             ,'[cm^2]                           Thomson Cross Section'        $
             ,'[g]                              solar mass'                   $
             ,'[erg s^-1]                       solar luminosity'             $
             ,'[cm]                             solar radius'                 $
             ,'[K]                              solar effective temperature'  $
             ,'[g]                              earth mass'                   $
             ,'[cm]                             earth radius'                 $
             ,'[cm]                             light year'                   $
             ,'[cm]                             parsec'                       $
             ,'[cm]                             astronomical unit'            $
             ,'[ergs cm^-2 s^-1 Hz^-1]          Jansky unit'                  $
             ,'[s]                              year']

   if (n_tags(unit) ne n_elements(comment)) then print,'comments not matched!!!' $
      else begin
      unit_name    = tag_names(unit)
      unit_value   = fltarr(n_tags(unit))
      unit_comment = ' ' + strtrim(comment,1)
      for i=0,n_tags(unit)-1 do unit_value[i] = unit.(i)
      forprint,unit_name,unit_value,unit_comment $
              ,format='(a7,e12.4,a)'
   endelse 
endif
end
