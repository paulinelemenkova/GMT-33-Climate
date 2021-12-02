#!/bin/sh
# Purpose: Climate datasets https://climate.northwestknowledge.net/TERRACLIMATE/index_directDownloads.php (here: Ethiopia)
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
gmt grdcut TerraClimate_ws_2018.nc -R33/48/3/15 -Get_ws.nc
gdalinfo -stats et_ws.nc
# Minimum=0.100, Maximum=6.100

# Make color palette
gmt makecpt -Cviridis.cpt -V -T0.1/6.1/0.1 -Ic > myocean.cpt
# gmt makecpt --help
# elevation etopo1 world elevation dem1 dem2 dem3

ps=ET_ws.ps
# Make background transparent image
gmt grdimage et_ws.nc -Cmyocean.cpt -R33/48/3/15 -JM6.5i -I+a15+ne0.75 -Xc -P -K > $ps
    
# Add isolines
gmt grdcontour et_ws.nc -R -J -C0.5 -A1 -Wthinner,black -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinner,blue -Na -N1/thickest,red -W0.1p -Df -O -K >> $ps
    
# Add color legend
gmt psscale -Dg31.7/3+w13.3c/0.15i+v+o0.0/0i+ml -R -J -Cmyocean.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
    --MAP_LABEL_OFFSET=0.2c \
    --MAP_ANNOT_OFFSET=0.2c \
    -Bg0.5f0.1a0.5+l"Colormap 'viridis' Option D from matplotlib [0.1/6.1/0.1, C=RGB]" \
    -I0.2 -By+l"m/s" -O -K >> $ps
    
# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=wESN \
    --FORMAT_GEO_MAP=ddd:mm:ss \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_LABEL=7p,25,black \
    --FONT_TITLE=16p,13,black \
    -Bpxg50f1a2 -Bpyg20f2a2 -Bsxg50 -Bsyg20 \
    -B+t"WS (Wind speed): Ethiopia (2018)" -O -K >> $ps
    
# Add scalebar, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=9p,0,black \
    --FONT_ANNOT_PRIMARY=9p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Tdx1.3c/11.5c+w0.5i+f2+l+o0.15i \
    -Lx14.5c/-1.2c+c10+w300k+l"Mercator projection. Scale (km)"+f \
    -UBL/-10p/-35p -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,royalblue4+jLB >> $ps << EOF
41.5 14.3 Red Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,royalblue4+jLB+a-345 >> $ps << EOF
45.5 11.8 Gulf of Aden
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,blue2+jLB+a-60 >> $ps << EOF
42.9 13.4 Bab-el-Mandeb
EOF

# Cities
gmt pstext -R -J -N -O -K \
-F+f11p,13,black+jLB -Gwhite@40 >> $ps << EOF
37.4 9.3 Addis Ababa
EOF
gmt psxy -R -J -Ss -W0.5p -Gwhite -O -K << EOF >> $ps
38.4 9.1 0.30c
EOF

# Add GMT logo
gmt logo -Dx7.0/-2.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.1c -Y8.0c -N -O \
    -F+f11p,13,black+jLB >> $ps << EOF
0.0 9.0 Dataset: TerraClimate. Input Data WorldClim, CRUTS4.0. Spatial resolution: 4 km (1/24\232)
EOF

# Convert to image file using GhostScript
gmt psconvert ET_ws.ps -A0.5c -E720 -Tj -Z
