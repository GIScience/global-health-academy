# Head ---------------------------------
# purpose: Functions to create bivariate maps
# author: Marcel, based on a first implementation by Jakub Nowosad https://github.com/r-tmap/tmap/issues/183#issuecomment-670554921
#
#
#1 Libraries ---------------------------------
library(classInt)
library(lattice)
library(latticeExtra)
library(tmap)
library(grid)
library(gridExtra)
#2 Functions ---------------------------------
add_new_var = function(x, var1, var2, nbins, ival.method) {
  ival1 <- classIntervals(c(x[[var1]]),
                          n = nbins,
                          style = ival.method)
  ival2 <- classIntervals(c(x[[var2]]),
                          n = nbins,
                          style = ival.method)


  ival1$brks <- round(ival1$brks, 2)

  ival2$brks <- round(ival2$brks, 2)


  if (ival1$brks[2] < 1) {
    if (ival1$brks[3] < 1) {
      ival1$brks[2] <- 1
      ival1$brks[3] <- 2
    } else {
      ival1$brks[2] <- 1
    }
  }



  if (ival2$brks[2] < 1) {
    if (ival2$brks[3] < 1) {
      ival2$brks[2] <- 1
      ival2$brks[3] <- 2
    } else {
      ival2$brks[2] <- 1
    }
  }

  class1 = suppressWarnings(findCols(ival1))

  class2 = suppressWarnings(findCols(ival2))

  x$new_class = class1 + nbins * (class2 - 1)
  return(x)
}


legend_creator = function(x,
                          col.regions,
                          classesX,
                          classesY,
                          xlab,
                          ylab,
                          nbins,
                          fontsize,
                          ival.method) {
  # x <- dataset
  # classesX <- "pop"
  # classesY<- "hospital"
  # ival.method="quantile"
  # nbins<-3
  # fontsize <- 1
  # col.regions <- stevens.pinkgreen(9)

  classesX = classIntervals(c(x[[classesX]]),
                            n = 3,
                            style = ival.method)



  classesY = classIntervals(c(x[[classesY]]),
                            n = 3,
                            style = ival.method)



  if (classesX$brks[2] < 1) {
    if (classesX$brks[3] < 1) {
      classesX$brks[2] <- 1
      classesX$brks[3] <- 2
    } else {
      classesX$brks[2] <- 1
    }
  }



  if (classesY$brks[2] < 1) {
    if (classesY$brks[3] < 1) {
      classesY$brks[2] <- 1
      classesY$brks[3] <- 2
    } else {
      classesY$brks[2] <- 1
    }
  }

  classesX <- round(classesX$brks, 2)
  classesY <- round(classesY$brks, 2)

  amounts <- as.data.frame(table(x$new_class))
  df <-
    data.frame(
      expand.grid(
        x1 =  seq(
          from = 1,
          to = 3,
          length.out = 3
        ),
        y1 = seq(
          from = 1,
          to = 3,
          length.out = 3
        )
      ),
      value = seq(
        from = 1,
        to = 9,
        length.out = 9
      ),
      source =  amounts$Freq
    )


  bilegend <-
    levelplot(
      value ~ x1 + y1,
      data = df,
      axes = FALSE,
      col.regions = col.regions,
      xlab = xlab,
      ylab = ylab,
      cuts = 8,
      colorkey = FALSE,
      scales = list(
        x = list(
          at = c(.5, 1.5, 2.5, 3.5),
          labels = classesX,
          cex = fontsize
        ),
        y = list(
          at = c(.5, 1.5, 2.5, 3.5),
          labels = classesY,
          cex = fontsize
        ),
        tck = c(1, 0)
      )
    ) +
    xyplot(
      y1 ~ x1,
      data = df,
      panel = function(y, x, ...) {
        ltext(
          x = x,
          y = y,
          labels = df$source,
          cex = 1,
          font = 2,
          fontfamily = "HersheySans"
        )
      }
    )



  bilegend
}


create_bivar_map <-
  function(dataset,
           x,
           y,
           x_label,
           y_label,
           crs_prj,
           col.rmp,
           ival.method,
           fntsize,
           vp) {
    dataset = add_new_var(
      dataset,
      var1 = x,
      var2 = y,
      nbins = 3,
      ival.method
    )

    bilegend = legend_creator(
      dataset,
      col.rmp,
      classesX = x,
      classesY = y,
      xlab = x_label,
      ylab = y_label,
      nbins = 3,
      fontsize = fntsize,
      ival.method
    )

    bimap = tm_shape(dataset, projection = crs_prj) +
      tm_fill(
        "new_class",
        style = "cat",
        border.col = NA,
        palette = col.rmp
      ) +
      tm_layout(legend.show = FALSE,
                frame = F) +
      tm_graticules(lwd = 0.5) +
      #tm_shape(hex.ssa.countries) +
      #tm_borders(lwd = .25, col = "grey15") +
      #tm_shape(hex.ssa.states) +
      #tm_borders(lwd = .75, col = "grey50") +
      tm_layout(frame = F)

    #png("fig/01/biv_hrsl_buildings.png", width=16, height=16, res=600, units="cm")
    #svg("fig/svg/biv_hrsl_buildings.svg", width=16, height=16, pointsize=7)

    grid.newpage()
    print(bimap)
    vp.2 = vp
    pushViewport(vp.2)
    print(bilegend, newpage = FALSE)

    #gc()

  }
