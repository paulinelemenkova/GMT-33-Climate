#!/bin/sh
# Purpose: Climate maps (Burkina Faso). Data source: https://climate.northwestknowledge.net/TERRACLIMATE/index_directDownloads.php
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

exec bash

# Extract a subset of ETOPO1m for the study area
gmt grdcut TerraClimate_tmin_2020.nc -R-6/3/9/15.5 -Gbf_tim2020.nc
gdalinfo -stats bf_tim2020.nc
# actual_range={11.69999980926514,21.19999885559082}

# Make color palette
gmt makecpt -Cjet.cpt -V -T11/22 > pauline.cpt

ps=BF_Tmin_2020.ps
# Make background transparent image
gmt grdimage bf_tim2020.nc -Cpauline.cpt -R-6/3/9/15.5 -JM6.5i -I+a15+ne0.75 -Xc -t20 -P -K > $ps
    
# Add isolines
gmt grdcontour bf_tim2020.nc -R -J -C1 -A1 -Wthicker,blue -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinner,blue -Na -N1/thickest,white -W0.1p -Df -O -K >> $ps
    
# Add color legend
gmt psscale -Dg-6.0/8.5+w16.0c/0.15i+h+o0.3/0i+ml+e -R -J -Cpauline.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
    -Bg1f0.1a1 \
    -I0.2 -By+l"T\232 C" -O -K >> $ps
    
# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpxg2f1a1 -Bpyg2f1a1 -Bsxg2 -Bsyg1 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --FONT_LABEL=8p,25,black \
    --FONT_TITLE=14p,19,black \
    -B+t"Tmin (minimum temperature) in Burkina Faso (2020)" -O -K >> $ps

# Add scalebar, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx14.2c/-2.2c+c10+w250k+l"Mercator projection. Scale (km)"+f \
    -UBL/0p/-65p -O -K >> $ps

# Texts

# Add GMT logo
gmt logo -Dx7.5/-2.9+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.0c -N -O \
    -F+f10p,0,black+jLB >> $ps << EOF
1.0 10.4 Dataset: TerraClimate. Input Data WorldClim, CRUTS4.0. Spatial resolution: 4 km (1/24\232)
EOF

# Convert to image file using GhostScript
gmt psconvert BF_Tmin_2020.ps -A0.5c -E720 -Tj -Z
