# Cost of living vs Grad. Student Salary
# Anaalyzed by Connor S. Murray
# csm6hg@virginia.edu
# 11.8.2022

# Libraries
library(data.table)
library(foreach)
library(tidyverse)
library(viridis)
library(ggrepel)

# Working directory
setwd("C:/Users/Conno/Desktop/gitmaster/Grad-student-wages")

# Metadata
dt <- data.table(read.csv("Data/stipends.csv"))
colnames(dt)[1:7] <- c("id", "univ", "depart", 
                       "wage", "col", "year", "program_year")

# Filter to last few years
dt2 <- dt[year %in% c("2022-2023", "2021-2022", "2020-2021", "2019-2020")]

# Filter to Biology
dt3 <- data.table(dt2 %>%
  filter(depart %like% "Biolog" | 
         depart %like% "biolog") %>% 
  select(univ, depart, wage, col) %>% 
  mutate(wage=as.numeric(gsub("\\$", "", as.factor(gsub(",", "", wage)))),
         col=as.numeric(col)) %>% 
  mutate(cost=col*wage))

# Filter extremes - probably errors
dt3 <- dt3[cost<50000][wage<50000 & wage>20000]

# Summarize by school
dt4 <- na.omit(data.table(dt3 %>% 
  group_by(univ) %>% 
  summarize(mean.cost=mean(cost, na.rm = T),
            mean.wage=mean(wage, na.rm = T)) %>% 
  mutate(col=mean.wage/mean.cost)))

# Plot wage vs COL
wage_cost <- {dt4[!univ %like% "University of Virginia"] %>% 
  ggplot(.,
        aes(x=mean.cost,
            y=mean.wage,
            color=col,
            label=univ)) +
  geom_smooth(method = "lm", 
              linetype=2, 
              size=2, 
              color="steelblue",
              se = F) +
  geom_point(size=6) +
  scale_color_viridis(option="magma") +
  geom_label_repel(data = dt4[univ %like% "University of Virginia"],
             color="Red", size=8) +
  theme_bw() +
  labs(x="Cost of living",
       y="Grad. Student Salary",
       color="Cost of Living Index") +
  theme(axis.text.x = element_text(face="bold", size=18),
        axis.text.y = element_text(face="bold", size=18),
        axis.title.x = element_text(face="bold", size=20),
        axis.title.y = element_text(face="bold", size=20),
        text = element_text(face = "bold", size=22),
        axis.title = element_text(face="bold", size=20))
}

# Wage / COL %
col_bar <- {dt4 %>% 
  ggplot(.,
         aes(x=col*100,
             y=reorder(univ, col),
             fill=univ,
             label=paste(floor(col*100), "%", sep=""))) +
  #geom_col() +
  xlim(c(65,137)) +
  geom_label() +
  scale_fill_manual(values = c("University of Virginia (UVA)"="Red")) +
  theme_classic() +
  labs(x="Cost of living covered by salary (%)",
       y="") +
  theme(axis.text.x = element_text(face="bold", size=18),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.x = element_text(face="bold", size=20),
        axis.title.y = element_text(face="bold", size=20),
        legend.position = "none",
        text = element_text(face = "bold", size=22),
        axis.title = element_text(face="bold", size=20))}

# Hist wage/col
hist_col <- {dt4 %>% 
    ggplot(.,
           aes(x=col*100)) +
    geom_histogram(bins=50) +
    xlim(c(65,130)) +
    geom_vline(data = dt4[univ=="University of Virginia (UVA)"], 
               aes(xintercept=col*100),
               color="red", size=2) +
    theme_classic() +
    labs(x="Cost of living covered by salary (%)",
         y="Number of Grad. Programs") +
    theme(axis.text.x = element_text(face="bold", size=18),
          axis.text.y = element_text(face="bold", size=18),
          axis.title.x = element_text(face="bold", size=20),
          axis.title.y = element_text(face="bold", size=20),
          legend.position = "none",
          text = element_text(face = "bold", size=22),
          axis.title = element_text(face="bold", size=20))}

# Boxplot wage/col
box_col_2 <- {dt4 %>% 
    ggplot(.,
           aes(x=col*100,
               y=1)) +
    geom_boxplot() +
    geom_point(data = dt4[univ=="University of Virginia (UVA)"],
               color="red", size=10) +
    theme_classic() +
    labs(x="Cost of living covered by salary (%)",
         y="") +
    theme(axis.text.x = element_text(face="bold", size=18),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          axis.title.x = element_text(face="bold", size=20),
          axis.title.y = element_text(face="bold", size=20),
          legend.position = "none",
          text = element_text(face = "bold", size=22),
          axis.title = element_text(face="bold", size=20))}
