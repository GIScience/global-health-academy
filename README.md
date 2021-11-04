# Global Health Academy Heidelberg 2021

<!-- badges: start -->

[![LICENSE](https://img.shields.io/github/license/GIScience/ohsome-r)](LICENSE.md)

<!-- badges: end -->



This repository includes resources used for the GIS workshop at the Global Health Academy Heidelberg 2021. The workshop will introduce some fundamental concepts of how to work with spatial data by using Covid-19 data for Germany using R and RStudio as the analysis environment. We will cover different possibilities for spatial visualization, measures to identify spatial clusters and will sneak into the definition of spatial neighbourhood definitions and the consideration of spatial regression analysis in presence of spatial auto-correlation. Hands on exercise are part of the workshop. Experience in using R/RStudio will be beneficial but not mandatory as general concepts are transferable to other analysis environments.

Workshop materials for the [Global Health Academy](https://global-health-academy.de/).

See here the course details: [Introduction GIS Tools /spatial epidemiology](https://global-health-academy.de/programme/).

## Dev Setup

This R project uses [renv](https://rstudio.github.io/renv/index.html) for package/library management.

Clone the repository

```bash
$ git clone https://github.com/GIScience/global-health-academy.git
```

Manually open the folder as project from within Rstudio or just execute:

```bash
$ cd global-health-academy
$ rstudio
```

Renv will be automatically recognized by R. To locally restore the packages/libraries form renv.lock file execute:

```r
renv::restore()
```

