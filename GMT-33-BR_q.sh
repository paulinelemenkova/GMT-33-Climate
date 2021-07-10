#!/bin/sh
# Purpose: Climate datasets https://climate.northwestknowledge.net/TERRACLIMATE/index_directDownloads.php (here: Brazil, 2020)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert
# http://soliton.vm.bytemark.co.uk/pub/cpt-city/ncl/tn/StepSeq25.png.index.html

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

# Extract a subset for the study area
gmt grdcut TerraClimate_q_2020.nc -R285/328/-35/6 -Gbr_runoff.nc
gdalinfo -stats br_runoff.nc
# Minimum=0.000, Maximum=2370.300, Mean=58.163, StdDev=82.988

# Make color palette
gmt makecpt -Cjet -V -T0/350 > pauline.cpt

ps=BR_runoff.ps
# Make background transparent image
gmt grdimage br_runoff.nc -Cpauline.cpt -R285/328/-35/6 -JM6i -I+a15+ne0.75 -Xc -P -K > $ps
    
# Add isolines
# gmt grdcontour br_runoff.nc -R -J -C1.0 -A4.0 -Wthinner,white -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinner,blue -Na -N1/thick,darkorchid3 -W0.1p -Df -O -K >> $ps
    
# Add color legend
gmt psscale -Dg285/-37.5+w15.2c/0.4c+h+o0.0/0i+ml -R -J -Cpauline.cpt \
    --FONT_LABEL=8p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
    -Bg25f5a50+l"Colormap: 'jet' by GMT [Dark to light blue, white, yellow and red, C=RGB]" \
    -I0.2 -By+l"mm" -O -K >> $ps
    
# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=WEsN \
    --FORMAT_GEO_MAP=ddd:mm:ssF \
    -Bpx4f2a4 -Bpyg4f2a4 -Bsxg4 -Bsyg2 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=8p,0,black \
    --FONT_LABEL=8p,25,black \
    --FONT_TITLE=16p,19,black \
    -B+t"Runoff in Brazil (2020)" -O -K >> $ps

# Add scalebar, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=10p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx12.7c/-2.3c+c50+w700k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-65p -O -K >> $ps

# Texts -R285/328/-35/6
# Cities
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
313.67 -23.85 São Paulo
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
313.37 -23.55 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
317.09 -22.91 Rio de Janeiro
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
316.79 -22.91 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
316.37 -20.0 Belo Horizonte
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
316.07 -19.91 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
325.40 -8.05 Recife
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
325.10 -8.05 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
312.52 -15.79 Brasília
EOF
gmt psxy -R -J -Sc -W0.5p -Gred -O -K << EOF >> $ps
312.12 -15.79 0.25c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
309.07 -30.03 Porto Alegre
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
308.77 -30.03 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
321.83 -12.97 Salvador,
321.83 -13.77 Bahia
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
321.53 -12.97 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
321.77 -3.73 Fortaleza
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
321.47 -3.73 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
311.05 -25.42 Curitiba
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
310.75 -25.42 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
311.05 -17.0 Goiânia
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
310.75 -16.67 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
311.8 -1.5 Belém
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
311.5 -1.45 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,white+jLB+a-0 >> $ps << EOF
300.18 -4.1 Manaus
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
299.98 -3.1 0.20c
EOF

# Water
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,26,blue1+jLB >> $ps << EOF
285.5 -22.0 Pacific
285.5 -24.0 Ocean
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,26,blue1+jLB >> $ps << EOF
320 -28.0 Atlantic
320 -30.0 Ocean
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,26,blue1+jLB >> $ps << EOF
314 4.0 Atlantic
314 2.0 Ocean
EOF

# rivers -R285/328/-35/6
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,white+jLB+a-25 >> $ps << EOF
293.0 -3.2 Amazonas
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB+a-345 >> $ps << EOF
305 -2.0 Amazonas
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB+a-45 >> $ps << EOF
296.5 -1.2 Negro
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB+a-290 >> $ps << EOF
306 -12.0 Xingu
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB+a-288 >> $ps << EOF
308.0 -14.0 Araguaia
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB+a-280 >> $ps << EOF
311.0 -12.0 Tocantins
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,white+jLB+a-275 >> $ps << EOF
317.5 -13.0 São
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,26,white+jLB+a-331 >> $ps << EOF
317.5 -11.3 Francisco
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB+a-300 >> $ps << EOF
308.5 -22.0 Parana
EOF

# Texts -R285/328/-35/6
# countries
gmt pstext -R -J -N -O -K \
-F+jTL+f17p,25,darkorchid3+jLB >> $ps << EOF
300.20 -7.0 B     R     A     Z     I     L
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,darkorchid3+jLB >> $ps << EOF
292.50 -18.1 B O L I V I A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,darkorchid3+jLB >> $ps << EOF
292.30 -30.1 A R G E N T I N A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,darkorchid3+jLB+a-45 >> $ps << EOF
300.0 -22.0 PARAGUAY
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,white+jLB >> $ps << EOF
302.0 -33.0 URUGUAY
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,25,darkorchid3+jLB >> $ps << EOF
286 -13.0 P E R U
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,darkorchid3+jLB >> $ps << EOF
289.5 -24.0 CHILE
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,darkorchid3+jLB >> $ps << EOF
285 3.0 C O L O M B I A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,darkorchid3+jLB >> $ps << EOF
292.5 5.0 VENEZUELA
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,darkorchid3+jLB+a-75 >> $ps << EOF
300.5 5.6 GUYANA
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,25,darkorchid3+jLB+a-75 >> $ps << EOF
303 5.8 SURINAME
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,25,darkorchid3+jLB >> $ps << EOF
306 5.0 FRENCH
306 4.0 GUIANA
EOF

#
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,25,lightcyan+jLB >> $ps << EOF
293.0 -5.7 A m a z o n
294.0 -7.2 B a s i n
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,moccasin+jLB+a-310 >> $ps << EOF
307.0 -19.5 Brazilian Highlands
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,25,moccasin+jLB+a-285 >> $ps << EOF
316.37 -19.5 Espinhaço Mountains
EOF

# Add GMT logo
gmt logo -Dx6.2/-3.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y7.0c -N -O \
    -F+f10p,0,black+jLB >> $ps << EOF
0.0 13.6 Dataset: TerraClimate (2020). Input Data WorldClim, CRUTS4.0. Spatial resolution: 4 km (1/24\232)
EOF

# Convert to image file using GhostScript
gmt psconvert BR_runoff.ps -A0.5c -E720 -Tj -Z
