library(tigris)

tryCatch({
    tigris::states('51')
}, error = function(err){
    quit(save = "no", status = 1, runLast = TRUE)
})
