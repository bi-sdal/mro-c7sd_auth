library(tigris)

options(tigris_use_cache=TRUE)

print(sprintf('CRAN: %s', getOption('repos')))
print(sprintf('tigris_use_cache: %s', getOption('tigris_use_cache')))

tryCatch({
    va <- tigris::states('51')
}, error = function(err){
    stop(sprintf("
tigris::states function failed.
Here is the `getOption` for the tigris_use_cache variable: %s",
getOption('tigris_use_cache')))
    quit(save = "no", status = 1, runLast = TRUE)
})
