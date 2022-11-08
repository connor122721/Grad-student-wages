# Cost of living vs Grad. Student Salary
# 11.8.2022

# Libraries
library(data.table)
library(foreach)
library(tidyverse)
library(ggrepel)

# Working directory
setwd("C:/Users/Conno/Desktop/gitmaster/Grad-student-wages")

# Metadata
dt <- data.table(read.csv("GradStipends.csv"))

# Plot wage vs COL
dt[!X=="UVA"] %>% 
  ggplot(.,
        aes(x=as.numeric(COL),
            y=as.numeric(Stipend),
            label=X)) +
  geom_smooth(method = "lm", 
              linetype=2, 
              size=2, 
              color="steelblue",
              se = F) +
  geom_label_repel(size=6) +
  geom_label(data = dt[X=="UVA"], color="Red", size=10) +
  theme_classic() +
  labs(x="Cost of living",
       y="Grad. Student Salary") +
  theme(axis.text.x = element_text(face="bold", size=18),
        axis.text.y = element_text(face="bold", size=18),
        axis.title.x = element_text(face="bold", size=20),
        axis.title.y = element_text(face="bold", size=20),
        text = element_text(face = "bold", size=22),
        axis.title = element_text(face="bold", size=20))

# Prop. COL covered by wage
dt2 <- data.table(dt %>% 
  mutate(prop=as.numeric(Stipend/COL)))

# Wage / COL %
dt2 %>% 
  ggplot(.,
         aes(x=prop*100,
             y=reorder(X, prop),
             fill=X,
             label=paste(floor(prop*100), "%", sep=""))) +
  #xlim(c(70,110)) +
  geom_label(size=10) +
  scale_fill_manual(values = c("UVA"="Red")) +
  theme_classic() +
  labs(x="Cost of living covered by salary (%)",
       y="") +
  theme(axis.text.x = element_text(face="bold", size=18),
        axis.text.y = element_text(face="bold", size=18),
        axis.title.x = element_text(face="bold", size=20),
        axis.title.y = element_text(face="bold", size=20),
        legend.position = "none",
        text = element_text(face = "bold", size=22),
        axis.title = element_text(face="bold", size=20))
