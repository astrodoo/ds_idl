pro ex_particle_trace

; Restore u, v, x, and y variables containing wind data
RESTORE, FILEPATH('globalwinds.dat', $
   SUBDIR=['examples','data'])

; Build a data array from the wind data.
data = FLTARR(2, 128, 64)
data[0, *, *] = u
data[1, *, *] = v

; Define starting points for the streamlines
seeds = [60, 40]

; Calculate the vertext and connectivity data for the
; streamline paths
PARTICLE_TRACE, data, seeds, verts, conn, MAX_ITERATIONS=1000

; Plot the underlying vector field
VELOVECT, u, v, x, y, COLOR='AAAAAA'x

; Overplot the streamlines
i = 0
sz = SIZE(verts, /STRUCTURE)
WHILE (i LT sz.dimensions[1]) DO BEGIN
   nverts = conn[i]
   PLOTS, x[verts[0, conn[i+1:i+nverts]]], $
      y[verts[1, conn[i+1:i+nverts]]], $
      COLOR='0000FF'x, THICK=2
   i += nverts + 1
ENDWHILE
END
