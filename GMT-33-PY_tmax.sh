#!/bin/sh
# #!/bin/sh
# Purpose: Climate datasets https://climate.northwestknowledge.net/TERRACLIMATE/index_directDownloads.php (here: Paraguay)
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

# Extract subset of img file in Mercator or Geographic format
gmt grdcut TerraClimate_tmax_2020.nc -R297/306/-28/-19 -Gpy_tmax.nc
gdalinfo -stats py_tmax.nc
# Minimum=29.300, Maximum=37.600, Mean=34.228, StdDev=1.890
gmt makecpt -Cwysiwyg -T30/38 > pauline.cpt
#gmt makecpt -Cjet -T30/38 > pauline.cpt
#gmt makecpt -Csky-33 -T0/4.6 -Ic > pauline.cpt
# gmt makecpt --help


#####################################################################
# create mask of vector layer from the DCW of country's polygon
gmt pscoast -R297/306/-28/-19 -Dh -M -EPY > Paraguay.txt
#####################################################################

ps=PY_tmax.ps
# Make background transparent image
gmt grdimage py_tmax.nc -Cpauline.cpt -R297/306/-28/-19 -JM6.0i -I+a15+ne0.75 -t70 -Xc -P -K > $ps
    
#####################################################################
# CLIPPING
# 1. Start: clip the map by mask to only include country

gmt psclip -R297/306/-28/-19 -JM6.0i Paraguay.txt -O -K >> $ps

# 2. create map within mask
# Add raster image
gmt grdimage py_tmax.nc -Cpauline.cpt -R297/306/-28/-19 -JM6.0i -I+a15+ne0.75 -Xc -P -O -K >> $ps
# Add isolines
gmt grdcontour py_tmax.nc -R -J -C1 -A2 -Wthin,white -O -K >> $ps
# Add coastlines, borders, rivers
gmt pscoast -R -J \
    -Ia/thinner,blue -Na -N1/thicker,tomato -W0.1p -Df -O -K >> $ps
#gmt pscoast -R -J \
    -Ia/thinner,blue -Na -W0.1p -Df -O -K >> $ps

# 3: Undo the clipping
gmt psclip -C -O -K >> $ps
#####################################################################
    
# Add color legend -T0.790/2.360
gmt psscale -Dg297/-28.6+w15.2c/0.4c+h+o0.0/0i+ml+e -R -J -Cpauline.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
    -Bg1f0.1a1+l"Colormap 'wysiwyg', 20 well-separated RGB colors (-T30/38)" \
    -I0.2 -By+l"T\232, Celcius" -O -K >> $ps
    
# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpx1f1a2 -Bpyg1f1a2 -Bsxg1 -Bsyg1 \
    --MAP_TITLE_OFFSET=1.0c \
    --FONT_TITLE=14p,0,black \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    -B+t"Tmax (maximal temperature) in Paraguay (2020)" -O -K >> $ps
    
# Add scalebar, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=10p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx12.7c/-2.3c+c50+w200k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-65p -O -K >> $ps

# Texts
# countries -R297/306/-28/-19
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,19,black+jLB >> $ps << EOF
297.3 -19.3 B O L I V I A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,25,black+jLB -Gwhite@50 >> $ps << EOF
303.5 -21.5 B R A Z I L
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,25,black+jLB >> $ps << EOF
299.2 -26.5 A R G E N T I N A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f16p,27,white+jLB >> $ps << EOF
299.5 -22.9 P A R A G U A Y
EOF
# geography
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,22,BURLYWOOD4+jLB+a-310 >> $ps << EOF
299.0 -25.0 G R A N   C H A C O
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,22,khaki1+jLB >> $ps << EOF
297.9 -21.5 C H A C O  B O R E A L
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,22,BURLYWOOD4+jLB >> $ps << EOF
299.8 -25.0 C H A C O
299.6 -25.3 C E N T R A L
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,22,BURLYWOOD4+jLB >> $ps << EOF
299.2 -25.9 C H A C O  A S T R A L
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,17,yellow+jLB >> $ps << EOF
303.0 -24.8 O R I E N T A L
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,22,white+jLB >> $ps << EOF
304.7 -25.6 PARANA
304.7 -25.8 PLATEAU
EOF

# mountains
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,23,darkbrown+jLB+a-70 >> $ps << EOF
304.1 -22.5 Cordillera
303.9 -22.5 de Amambay
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,23,darkbrown+jLB >> $ps << EOF
304.5 -24.2 Cordillera
304.5 -24.35 de Mbaracay
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,23,darkbrown+jLB+a-320 >> $ps << EOF
304.1 -26.7 Cordillera de
304.3 -26.8 San Rafael
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,23,darkbrown+jLB+a-70 >> $ps << EOF
304.20 -25.0 Cordillera de
304.10 -25.2 Caaguazú
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,23,white+jLB+a-325 >> $ps << EOF
299.05 -20.7 Léon Hill
EOF

# rivers
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-15 >> $ps << EOF
301.3 -23.2 Verde
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-10 >> $ps << EOF
300.9 -23.65 Negro
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,CADETBLUE1+jLB+a-63 >> $ps << EOF
302.2 -23.1 Paraguay
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,CADETBLUE1+jLB+a-3 >> $ps << EOF
301.7 -27.2 Paraná
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-0 >> $ps << EOF
302.3 -23.0 Aquidaban
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,CADETBLUE1+jLB+a-355 >> $ps << EOF
302.7 -23.45 Ypané
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,DARKSLATEGRAY1+jLB >> $ps << EOF
298.3 -20.2 Lake
298.3 -20.4 Trinidad
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-307 >> $ps << EOF
301.75 -26.2 Paraguay
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-38 >> $ps << EOF
298.2 -23.4 Pilcomayo
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-30 >> $ps << EOF
300.45 -24.55 Pilcomayo
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-5 >> $ps << EOF
302.4 -22.1 Apa
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,CADETBLUE1+jLB+a-355 >> $ps << EOF
303.1 -24.05 Jejuí Guazú
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,23,CADETBLUE1+jLB+a-332 >> $ps << EOF
301.9 -26.53 Tebicuary
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,23,blue1+jLB+a-35 >> $ps << EOF
302.85 -26.52 Tebicuary
EOF

# cities
gmt pstext -R -J -N -O -K \
-F+f12p,22,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
302.47 -25.3 Asunción
EOF
gmt psxy -R -J -Sc -W0.5p -Gred -O -K << EOF >> $ps
302.37 -25.3 0.25c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,21,black+jLB+a-0 -Gwhite@60 >> $ps << EOF
302.67 -23.6 Concepción
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
302.57 -23.4 0.20c
EOF

# Add GMT logo
gmt logo -Dx6.5/-3.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y8.3c -N -O \
    -F+f11p,21,black+jLB >> $ps << EOF
1.2 13.6 Dataset: TerraClimate. Input Data WorldClim, CRUTS4.0. Spatial resolution: 4 km (1/24\232)
EOF

# Convert to image file using GhostScript
gmt psconvert PY_tmax.ps -A0.5c -E720 -Tj -Z
