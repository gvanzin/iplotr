## utils needed from qtlcharts
# getPlotSize, getScreenSize, setScreenSize, group2numeric, add2chartOpts,
# convert_map, convert4iplotcorr, convert_curves, convert_scat, grabarg
##

getPlotSize <- function(aspectRatio) {
  ## qtlcharts:::getPlotSize
  screensize <- getScreenSize()
  if (screensize$height * aspectRatio <= screensize$width) 
    return(list(height = screensize$height, width = screensize$height * 
                  aspectRatio))
  list(height = screensize$width/aspectRatio, width = screensize$width)
}

getScreenSize <- function() {
  ## qtlcharts:::getScreenSize
  screensize <- getOption("qtlchartsScreenSize")
  if (is.null(screensize)) {
    setScreenSize()
    screensize <- getOption("qtlchartsScreenSize")
  }
  screensize
}

setScreenSize <- function(size = c("normal", "small", "large"), height, width) {
  ## qtlcharts:::setScreenSize
  if (!missing(height) && !is.null(height) && !is.na(height) && 
      height > 0 && !missing(width) && !is.null(width) && !is.na(width) && 
      width > 0) 
    screensize <- list(height = height, width = width)
  else {
    size <- match.arg(size)
    screensize <- switch(size, small = list(height = 600, 
                                            width = 900), normal = list(height = 700, width = 1000), 
                         large = list(height = 1200, width = 1600))
  }
  message("Set screen size to height=", screensize$height, 
          " x width=", screensize$width)
  options(qtlchartsScreenSize = screensize)
}

group2numeric <- function(group) {
  ## qtlcharts:::group2numeric
  if (is.factor(group)) 
    return(as.numeric(group))
  match(group, sort(unique(group)))
}

add2chartOpts <- function(chartOpts, ...) {
  ## qtlcharts:::add2chartOpts
  dots <- list(...)
  for (newarg in names(dots)) {
    if (!(newarg %in% names(chartOpts))) 
      chartOpts <- c(chartOpts, dots[newarg])
  }
  chartOpts
}

convert_map <- function(map) {
  ## qtlcharts:::convert_map
  chrnames <- names(map)
  map <- lapply(map, unclass)
  map <- lapply(map, function(a) lapply(a, jsonlite::unbox))
  mnames <- unlist(lapply(map, names))
  names(mnames) <- NULL
  list(chr = chrnames, map = map, markernames = mnames)
}

convert4iplotcorr <- function(dat, group, rows, cols, reorder = FALSE, corr,
                              corr_was_presubset = FALSE, scatterplots = TRUE) {
  ## qtlcharts:::convert4iplotcorr
  indID <- rownames(dat)
  if (is.null(indID)) 
    indID <- paste(1:nrow(dat))
  variables <- colnames(dat)
  if (is.null(variables)) 
    variable <- paste0("var", 1:ncol(dat))
  if (missing(group) || is.null(group)) 
    group <- rep(1, nrow(dat))
  if (nrow(dat) != length(group)) 
    stop("nrow(dat) != length(group)")
  if (!is.null(names(group)) && !all(names(group) == indID)) 
    stop("names(group) != rownames(dat)")
  if (!corr_was_presubset) {
    if (ncol(dat) != nrow(corr) || ncol(dat) != ncol(corr)) 
      stop("corr matrix should be ", ncol(dat), " x ", ncol(dat))
    if (reorder) {
      ord <- stats::hclust(stats::dist(corr), method = "average")$order
      variables <- variables[ord]
      dat <- dat[, ord]
      reconstructColumnSelection <- function(ord, cols) {
        cols.logical <- rep(FALSE, length(ord))
        cols.logical[cols] <- TRUE
        which(cols.logical[ord])
      }
      rows <- reconstructColumnSelection(ord, rows)
      cols <- reconstructColumnSelection(ord, cols)
      corr <- corr[ord, ord]
    }
    corr <- corr[rows, cols]
  }
  dimnames(corr) <- dimnames(dat) <- NULL
  names(group) <- NULL
  if (scatterplots) 
    output <- list(indID = indID, var = variables, corr = corr, 
                   rows = rows - 1, cols = cols - 1, dat = t(dat), group = group, 
                   scatterplots = scatterplots)
  else output <- list(indID = indID, var = variables, corr = corr, 
                      rows = rows - 1, cols = cols - 1, scatterplots = scatterplots)
  output
}

convert_curves <- function(times, curvedata, group, indID) {
  ## qtlcharts:::convert_curves
  list(x = times, data = curvedata, group = group, indID = indID)
}

convert_scat <- function(scatdata, group, indID) {
  ## qtlcharts:::convert_scat
  if (is.null(scatdata)) 
    return(NULL)
  list(data = scatdata, group = group, indID = indID)
}

grabarg <- function(arguments, argname, default)
  ## qtlcharts:::grabarg
  ifelse(argname %in% names(arguments), arguments[[argname]], default)
