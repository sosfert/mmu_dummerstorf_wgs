# Make LD decay figure
library(dplyr)
library(ggplot2)
library(stringr)

fls <- list.files(pattern = ".ld") # capture the r2 files produced previously with plink

dat <- lapply(fls, function(fl){
                d <- read.table(file.path(fl), header = TRUE, stringsAsFactors = FALSE) %>%
		                mutate(d, dist = BP_B - BP_A)})

names(dat) <- c("DUK","DUC","DU6","DU6P","DUhLB","FZTDU") #check order against fls

dat2 <- dat %>% bind_rows(.id = "line")

dat2$line <- factor(dat2$line, levels = c("DUK","DUC","DU6","DU6P","DUhLB","FZTDU"))

ggplot(data = dat2, aes(x=dist/1000, y=R2, color = line)) +
	geom_smooth(method = "auto") + xlab("Pairwise distance (Kb)") +
	ylab(expression(LD~(r^{2}))) + theme_bw()+
	theme(legend.title=element_blank(), plot.title = element_text(hjust = 0.5)) +
	ggtitle("Linkage Disequilibrium Decay (5Mb)") 


