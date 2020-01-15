hdata <- read.delim("/Users/erjulioaguiar/Documents/Dataset-health/set-a/140099.txt",sep=",");
tm <- hdata$Time;
val <- as.integer(hdata$Value);
col <- hdata$Parameter;

val <- c(tm,)

df <- data.frame(t(val));

colnames(df) <- col;
df['']
