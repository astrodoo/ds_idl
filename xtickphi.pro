Function XTICKPHI, axis, index, value
;===============================================================================================
;                               express xtick for pi format
;        
;                                                                                     2007.07.31
;                                                                                    DooSoo Yoon
;
; original procedure : XTICK_PHI.pro [from Sanghoon,Oh]
;
; notice)
;    narrowest interval is !DPI/4.
;    xrange should be format of !pi
;
; example)
;    idl> x=findgen(100)/100.*4.*!pi-2.*!pi
;    idl> plot,x,sin(x),xtickformat='xtickphi',xtickinterval=!DPI/4.,xr=[-2.*!pi,2.*!pi],/xst 
;
; Modified)
;=========================================================================

num  = value / (!DPI)
flag = round(num*100)/25
;print,value, flag

piS = "!7" +  String("160B) + "!X"

if (flag ge 0) then sign = "" $
               else sign = "-"
flag = abs(flag)
if ((flag mod 2) eq 1) then begin
   denom = '4'
   numer = strtrim(flag,1)
endif else if ((flag mod 4) eq 2) then begin
   denom = '2'
   numer = strtrim(flag/2,1)
endif else begin
   numer = strtrim(flag/4,1)
   if (numer eq '1') then numer = ''
endelse

if ((flag mod 4) eq 0) then begin 
   tick = sign+numer+piS
   if (numer eq '0') then tick = '0'    
endif else $                       
   tick = sign+"!S!A"+numer+"!R"+"!S"+textoidl("-")+"!A"+"!R!B"$
          +denom+"!N"+piS
return,tick
end
