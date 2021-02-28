#!/bin/sh
# Purpose: Climate datasets https://climate.northwestknowledge.net/TERRACLIMATE/index_directDownloads.php (here: Botswana)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=1c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinner,white \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,0,dimgray \
    FONT_LABEL=7p,0,dimgray \
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

gmt set MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinner,white

# Extract a subset of ETOPO1m for the study area
gmt grdcut TerraClimate_tmin_2018.nc -R19.5/29.5/-27/-17.5 -Gbw_tim.nc
gdalinfo -stats bw_tim.nc
#  Minimum=11.900, Maximum=22.400, Mean=19.050, StdDev=1.728

# Make color palette
gmt makecpt -Cwysiwyg.cpt -V -T11.9/22.4 > pauline.cpt
# gmt makecpt --help
#-Ic
# elevation etopo1 world elevation dem1 dem2 dem3

ps=BW_Tmin.ps
# Make background transparent image
gmt grdimage bw_tim.nc -Cpauline.cpt -R19.5/29.5/-27/-17.5 -JM6.5i -I+a15+ne0.75 -Xc -P -K > $ps
    
# Add isolines
gmt grdcontour bw_tim.nc -R -J -C1 -A10 -Wthin,white -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinner,blue -Na -N1/thickest,darkbrown -W0.1p -Df -O -K >> $ps
    
# Add color legend
gmt psscale -Dg19.3/-27.7+w16.5c/0.15i+h+o0.3/0i+ml+e -R -J -Cpauline.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
    -Bg11f0.1a1+l"Colormap: 'GMT wysiwyg' gradient [-T11.9/22.4, 0 to 20, mixed, RGB, 20 segments]" \
    -I0.2 -By+l"T\232, Celcius" -O -K >> $ps
    
# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpxg2f0.5a1 -Bpyg2f0.5a1 -Bsxg1 -Bsyg1 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --FONT_LABEL=8p,25,black \
    --FONT_TITLE=16p,19,black \
    -B+t"Tmin (minimum temperature) in Botswana (2018)" -O -K >> $ps

# Add scalebar, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx14.5c/-2.4c+c10+w200k+l"Mercator projection. Scale (km)"+f \
    -UBL/-10p/-70p -O -K >> $ps

# Texts
# Cities
gmt pstext -R -J -N -O -K \
-F+f13p,0,black+jLB -Gwhite@60 >> $ps << EOF
25.0 -24.57 Gaborone
EOF
gmt psxy -R -J -Ss -W0.5p -Ggreen1 -O -K << EOF >> $ps
25.91 -24.65 0.30c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB >> $ps << EOF
27.56 -21.12 Francistown
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
27.51 -21.17 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB >> $ps << EOF
25.72 -25.16 Lobatse
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
25.67 -25.21 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB >> $ps << EOF
26.27 -20.51 Sowa
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
26.22 -20.56 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB >> $ps << EOF
25.4 -21.26 Orapa
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
25.37 -21.33 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB >> $ps << EOF
24.1 -24.66 Jwaneng
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
24.60 -24.72 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB >> $ps << EOF
27.89 -21.92 Selebi-Phikwe
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
27.84 -21.98 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB >> $ps << EOF
24.45 -20.99 Rakops
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
24.41 -21.04 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB >> $ps << EOF
22.78 -20.49 Sehithwa
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
22.72 -20.47 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@50 >> $ps << EOF
26.23 -20.16 Nata
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
26.18 -20.21 0.20c
EOF
# countries
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,white+jLB >> $ps << EOF
19.7 -20.0 N A M I B I A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,white+jLB >> $ps << EOF
20.5 -17.7 A N G O L A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,white+jLB >> $ps << EOF
25.5 -17.7 Z A M B I A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,white+jLB >> $ps << EOF
23.5 -26.6 S O U T H   A F R I C A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,white+jLB >> $ps << EOF
27.1 -19.5 Z I M B A B W E
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f15p,19,white+jLB >> $ps << EOF
22.5 -22.0 B  O  T  S  W  A  N  A
EOF
#
gmt pstext -R -J -N -O -K \
-F+f15p,20,salmon4+jLB >> $ps << EOF
21.2 -23.8 K A L A H A R I
21.2 -24.9 D E S E R T
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,blue2+jLB >> $ps << EOF
24.5 -20.45 Makgadikgadi
24.6 -20.62 (salt pans)
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,23,blue2+jLB >> $ps << EOF
22.3 -19.50 Okavango
22.6 -19.67 Delta
22.4 -19.84 (grassland)
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,blue2+jLB+a-45 >> $ps << EOF
22.1 -18.45 Okavango
EOF
gmt pstext -R -J -N -O -K \
-F+f13p,23,darkolivegreen4+jLB >> $ps << EOF
23.9 -18.6 Chobe
23.5 -18.9 National Park
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,blue2+jLB+a-320 >> $ps << EOF
26.1 -24.37 Ngotwane
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,23,blue2+jLB+a-318 >> $ps << EOF
26.3 -24.57 Marico
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,23,blue2+jLB+a-320 -Gwhite@60 >> $ps << EOF
27.2 -23.4 Crocodile River
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,23,blue2+jLB+a-345 -Gwhite@60 >> $ps << EOF
28.2 -22.57 (Limpopo)
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,23,blue2+jLB+a-350 >> $ps << EOF
22.5 -22.40 Okwa
EOF

# Add GMT logo
gmt logo -Dx7.3/-3.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y11.7c -N -O \
    -F+f10p,0,black+jLB >> $ps << EOF
0.8 9.0 Dataset: TerraClimate. Input Data WorldClim, CRUTS4.0. Spatial resolution: 4 km (1/24\232)
EOF

# Convert to image file using GhostScript
gmt psconvert BW_Tmin.ps -A0.5c -E720 -Tj -Z
