## This file downloads and sources the PROCESS macro v4.2 by Andrew F. Hayes
temp <- tempfile()
download.file("https://www.afhayes.com/public/processv42.zip",temp)
files <- unzip(temp, list = TRUE)
fname <- files$Name[endsWith(files$Name, "process.R")]
source(unz(temp, fname))
unlink(temp)