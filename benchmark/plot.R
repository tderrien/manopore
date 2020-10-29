print("Start R")

library(ggplot2)
if (!requireNamespace("reshape", quietly = TRUE))
    install.packages("reshape", repos="http://cran.irsn.fr/", quiet = TRUE)
if (!requireNamespace("Hmisc", quietly = TRUE))
    install.packages("Hmisc", repos="http://cran.irsn.fr/", quiet = TRUE)
library(reshape)
dat=read.table("mean_qscore_template_pass.txt", h=T)

# format the data
meltData <- melt(dat)


# plot
# pdf("mean_qscore_template_pass.pdf")
# ggplot(meltData, aes(x=guppy_version, y= mean_qscore_template)) +geom_boxplot(notch=T) +
# facet_wrap(sample_id~.) +
# geom_jitter(data=meltData[sample(nrow(meltData), 2000), ], aes(color=guppy_version), width = 0.25, alpha=0.85)
# dev.off()

pdf("mean_qscore_template_pass_violin.pdf")
ggplot(meltData, aes(x=guppy_version, y= value, fill=guppy_version)) +geom_violin() +
facet_wrap(sample_id~.) +
  geom_boxplot(width = 0.15, outlier.shape = NA, fill='#FFFFFF') +
    theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.title = element_text(face="bold")) +
    labs(y = "Quality Phred Score", fill = "Guppy version")

dev.off()
