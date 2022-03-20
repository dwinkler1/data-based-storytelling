## Initialize renv project and install packages
if(!("renv" %in% installed.packages())) install.packages("renv")
renv::restore();msg <- tryCatch(
  {suppressMessages(lapply(c("01-data_io.R", "02-data_prep.R", "03-merging_data.R", "04-reshaping.R", "05-summarizing.R"), source))},
  error = {\(cond){message("Some error occured! Get help!\nError:");return(cond)}},
  finally = {rm(list = ls())}
);if(length(msg) > 2){message("Everything worked!")}else{message(msg)};rm(msg);.rs.api.restartSession()
