read_paje_trace <- function(file) {
  df <- read.csv(file, header=TRUE, strip.white=TRUE)
  df
}

prepare_trace <- function(df) {
  df$DisplayState <- df$Name
  df$RessourceId <- paste(df$MPIRank,sprintf("%02d",df$WorkerId),sep="_")
  df
}

print_trace <- function(df,size_geom=2) {
  ggplot(df, aes(x=StartTime,xend=EndTime, y=factor(RessourceId), yend=factor(RessourceId), color=DisplayState)) + theme_bw() + geom_segment(size=size_geom)
}

print_trace_process <-function(df,size_geom=2) {
  ggplot(df, aes(x=StartTime,xend=EndTime, y=factor(MPIRank), yend=factor(MPIRank), color=DisplayState)) + theme_bw() + geom_segment(size=size_geom)
}

#useful functions
get_total_duration_by_type <- function(df) {
  tmp=aggregate(Duration ~ Name, df, sum)
  tmp[order(-tmp$Duration),]
}