#!/bin/sh
# Purpose: Climate datasets https://climate.northwestknowledge.net/TERRACLIMATE/index_directDownloads.php (here: Ghana)
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
#gmt grdcut TerraClimate_PDSI_2018.nc -R-4/2/4/12 -Ggh_pdsi.nc
gmt grdcut TerraClimate_PDSI_1983.nc -R-4/2/4/12 -Ggh_pdsi.nc
gdalinfo -stats gh_pdsi.nc
# Minimum=-18.700, Maximum=9.500, Mean=-8.398, StdDev=7.181

# Make color palette
gmt makecpt -Cturbo.cpt -V -T-10/2/0.5 > myocean.cpt
# gmt makecpt --help
# elevation etopo1 world elevation dem1 dem2 dem3

ps=GH_PDSI_1983.ps
# Make background transparent image
gmt grdimage gh_pdsi.nc -Cmyocean.cpt -R-4/2/4/12 -JM5.0i -I+a15+ne0.75 -Xc -P -K > $ps
    
# Add isolines
gmt grdcontour gh_pdsi.nc -R -J -C0.5 -A1 -Wthin,brown -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinner,blue -Na -N1/thickest,white -W0.1p -Df -O -K >> $ps
    
# Add color legend
gmt psscale -Dg-4/3.4+w12.0c/0.15i+h+o0.3/0i+ml+e -R -J -Cmyocean.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
    --MAP_LABEL_OFFSET=0.2c \
    --MAP_ANNOT_OFFSET=0.2c \
    -Bg2f0.1a1+l"Colormap 'turbo' Google's Improved Rainbow Colormap [-18.7/9.5/0.4, C=RGB]" \
    -I0.2 -By+l"PDSI value" -O -K >> $ps
    
# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpxg2f1a0.5 -Bpyg2f1a1 -Bsxg2 -Bsyg1 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_LABEL=7p,25,black \
    --FONT_TITLE=16p,13,black \
    -B+t"PDSI (Palmer Drought Severity Index) in Ghana (1983)" -O -K >> $ps
    
# Add scalebar, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx11.0c/-2.4c+c10+w100k+l"Mercator projection. Scale (km)"+f \
    -UBL/0p/-70p -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB >> $ps << EOF
0.5 4.5 Gulf of Guinea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB >> $ps << EOF
-3.5 4.5 Atlantic Ocean
EOF
# COUNTRIES
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,25,black+jLB -Gwhite@60 >> $ps << EOF
-1.9 7.3 G   H   A   N   A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,black+jLB -Gwhite@60 >> $ps << EOF
0.8 6.5 T O G O
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,black+jLB -Gwhite@60 >> $ps << EOF
-3.6 8.5 IVORY
-3.6 8.1 COAST
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,black+jLB+a-270 -Gwhite@60 >> $ps << EOF
1.9 7.2 BENIN
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,black+jLB -Gwhite@60 >> $ps << EOF
-3.5 11.5 B  U  R  K  I  N  A      F  A  S  O
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,white+jLB+a-280 >> $ps << EOF
0.2 6.7 Lake Volta
EOF
# Cities
gmt pstext -R -J -N -O -K \
-F+f11p,13,white+jLB >> $ps << EOF
-0.2 5.4 Accra
EOF
gmt psxy -R -J -Ss -W0.5p -Gwhite -O -K << EOF >> $ps
-0.1 5.6 0.30c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-1.0 10.6 Bolgatanga
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-0.5 10.5 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-1.0 5.2 Cape Coast
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-1.1 5.2 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-1.1 5.0 Elmina
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-1.2 5.1 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-0.1 6.0 Koforidua
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-0.2 6.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-1.3 6.4 Kumasi
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-1.4 6.4 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-1.3 6.1 Obuasi
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-1.4 6.1 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-1.8 4.7 Sekondi-
-1.8 4.5 Takoradi
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-1.5 5.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,white+jLB >> $ps << EOF
-1.0 9.3 Tamale
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
-0.5 9.2 0.20c
EOF

# Add GMT logo
gmt logo -Dx5.0/-3.1+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.1c -Y11.1c -N -O \
    -F+f11p,21,black+jLB >> $ps << EOF
0.5 10.0 Dataset: TerraClimate (WorldClim, CRUTS4.0). Spatial resolution: 4 km (1/24\232)
EOF

# Convert to image file using GhostScript
gmt psconvert GH_PDSI_1983.ps -A0.5c -E720 -Tj -Z
