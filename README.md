# GMT Climate — TerraClimate Climate Variable Mapping Scripts

A collection of over 80 GMT (Generic Mapping Tools) shell scripts for mapping gridded climate variables per country from the TerraClimate dataset. Each script renders one climate variable over a country, clipped to its national boundary, with contours, labels and full cartographic layout. The scripts have been used to generate climate map figures across the author's cartographic and environmental publications.

## Mapped climate variables

Maximum and minimum temperature (Tmax, Tmin), precipitation, Palmer Drought Severity Index (PDSI), soil moisture, potential and actual evapotranspiration (PET, AET), climatic water deficit, runoff, downward surface shortwave radiation (SRAD), snow-water equivalent (SWE), vapour pressure (VAP) and vapour pressure deficit (VPD), and wind speed.

## What the scripts do

Each script builds a complete climate map, typically chaining:

- grid clipping and subsetting (grdcut) over a study-area bounding box
- colour palette generation (makecpt, turbo scheme) scaled to the variable range
- a country mask extracted from the Digital Chart of the World (pscoast -E ... -M) and applied with psclip
- climate grid rendering with illumination (grdimage)
- isolines (grdcontour), coastlines, borders and rivers (pscoast)
- colour scale bars (psscale), grids, frames, scale bars and roses (psbasemap)
- rich place, hydronym, mountain and city annotations (pstext, psxy)
- GMT logo (logo) and data-source subtitle
- export to raster (psconvert) at high resolution

Maps use the American polyconic projection (JPoly) among others.

## Data source

TerraClimate: monthly high-resolution (1/24 degree, ~4 km) climate and water-balance grids (Abatzoglou et al.), input from WorldClim and CRU TS 4.0, distributed as NetCDF. Coastlines and national boundaries from GSHHG / DCW via GMT.

## File naming

Scripts follow GMT-...-XX_VAR[_year].sh, where XX is an ISO country code (e.g. MN = Mongolia, BR = Brazil, ET = Ethiopia, ZM = Zambia, PY = Paraguay, BW = Botswana, BF = Burkina Faso, GH = Ghana) and VAR is the climate variable (PDSI, Tmax, precip, soil, SRAD, etc.).

## Requirements

- GMT 6.x (Generic Mapping Tools): https://www.generic-mapping-tools.org
- A POSIX shell (bash/sh)
- The relevant TerraClimate NetCDF grid(s) available locally
- GDAL (optional) for grid statistics (gdalinfo)

## Usage

Place the required TerraClimate NetCDF grid in the working directory, adjust the -R region and -J projection at the top of the chosen script, then run:

    bash GMT-33-MN_PDSI.sh

The script writes a PostScript file and converts it to a raster image (JPG/PNG) via psconvert.

## Author and citation

Polina Lemenkova
ORCID: https://orcid.org/0000-0002-5759-1089

These scripts accompany figures in the author's cartographic and environmental papers; please cite the specific article a given map appears in. The full publication list is available via the ORCID record above.

## License

See the LICENSE file in this repository.
