library(data.table)
charts <- fread("charts.csv")
features <- fread("trackfeatures.csv")
setkey(charts, region)

charts <- charts[region %in% c("global", "at") & day >= as.Date("2019-01-01") & day <= as.Date("2021-01-01")]
chartsf <- merge(charts, features[,-c("artistName", "trackName")], by = "trackID", all.x = TRUE, all.y = FALSE)
summary(chartsf)
fwrite(chartsf, "charts_global_at.csv")