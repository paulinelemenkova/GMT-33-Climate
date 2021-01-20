#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO 15 arc sec global data set (here: Ethiopia)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=1c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,0,dimgray \
    FONT_LABEL=7p,0,dimgray \
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# Extract a subset of ETOPO1m for the study area
gmt grdcut TerraClimate_aet_2018.nc -R33/48/3/15 -Get_aet.nc
gdalinfo -stats et_aet.nc
#  Minimum=0.000, Maximum=126.000

# Make color palette
gmt makecpt -Cinferno.cpt -V -T1/126/5 -Ic > myocean.cpt
# gmt makecpt --help
#-Ic
# elevation etopo1 world elevation dem1 dem2 dem3

ps=ET_AET.ps
# Make background transparent image
gmt grdimage et_aet.nc -Cmyocean.cpt -R33/48/3/15 -JM6.5i -I+a15+ne0.75 -Xc -P -K > $ps
    
# Add isolines
gmt grdcontour et_aet.nc -R -J -C20 -A20 -Wthinner,white -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinner,blue -Na -N1/thickest,red -W0.1p -Df -O -K >> $ps
    
# Add color legend
gmt psscale -Dg31.5/3+w13.3c/0.15i+v+o0.0/0i+ml -R -J -Cmyocean.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
    -Bg10f5a10+l"Colors: 'turbo' Google's Improved Rainbow Colormap [C=RGB, 1/126/5]" \
    -I0.2 -By+lmm -O -K >> $ps
    
# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=wESN \
    --FORMAT_GEO_MAP=ddd:mm:ss \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_LABEL=7p,25,black \
    --FONT_TITLE=16p,13,black \
    -Bpxg2f0.5a2 -Bpyg2f2a2 -Bsxg1 -Bsyg1 \
    -B+t"AET (Actual Evapotranspiration) in Ethiopia (2018)" -O -K >> $ps
    
# Add scalebar, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx14.5c/-1.2c+c10+w300k+l"Mercator projection. Scale (km)"+f \
    -UBL/-10p/-40p -O -K >> $ps

# Add GMT logo
gmt logo -Dx7.0/-2.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.1c -Y8.0c -N -O \
    -F+f11p,13,black+jLB >> $ps << EOF
0.0 9.0 Dataset: TerraClimate. Input Data WorldClim, CRUTS4.0. Spatial resolution: 4 km (1/24\232)
EOF

# Convert to image file using GhostScript
gmt psconvert ET_AET.ps -A0.5c -E720 -Tj -Z
