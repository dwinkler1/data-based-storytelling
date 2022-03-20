install_pkgs <- function(pkgs){
  pkg_type = switch(Sys.info()['sysname'], Linux = 'source', Darwin = 'mac.binary', Windows = 'win.binary')
  if(grepl('binary', pkg_type))(options(install.packages.compile.from.source = "never"))
  invisible(lapply(pkgs, \(pkg) install.packages(pkg, type = pkg_type)))
}

install_pkgs(c("tidyverse", "skimr"))

get_prjdir <- function(startdir = "~/Documents", prjdir = "Datascience_in_R"){
  subdirs <- list.dirs(path.expand(startdir), full.names = TRUE, recursive = TRUE)
  prjdir <- subdirs[stringr::str_detect(subdirs, prjdir)]
  dir <- prjdir[which.min(stringr::str_length(prjdir))]
  length(dir) == 0 && stop("Project not found!")
  message(dir)
  return(dir)
}
## Do not set a directory too low in the directory tree or this takes forever!
## For Windows: 'C:/Users/YOU/Folder'
## Use '~/Folder' if you want C:/Users/YOU/Documents/Folder
## To get to Downloads you can do '~/../Downloads'
wd <- get_prjdir('~/Documents')
setwd(wd)
getwd()
