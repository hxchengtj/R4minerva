
dt <- read.table("/sc/orga/projects/haok01a/chengh04/StarNet/data/merge_4_result/file4dup/sample_dup_split.txt",
                 header = TRUE, sep = "\t", check.names = FALSE, as.is = TRUE)

dt.name.1 <- dt$name.1
dt.sample.name <- dt$sample.name
dt.names <- unique(dt.name.1)
num <- length(dt.names)

sample_dup_part1 <- NULL

for(i in 1:num){
  idx <- which(dt.name.1 == dt.names[i])
  len <- length(idx)
  if(len > 1){
    for(j in 1:len){
      if((j+1) <= len){
        for (k in (j+1):len) {
          samples <- c(dt.sample.name[idx[j]], dt.sample.name[idx[k]])
          sample_dup_part1 <- rbind(sample_dup_part1, samples)
        }
      }
    }
  }
}

sample_dup_part1


