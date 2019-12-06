# Effects of meditation on some pro-inflammatory genes
# Rick Scavetta

# Clear workspace
rm(list = ls())

# Load packages
library(tidyverse)
library(Hmisc) # for calculating 95% CI
library(broom) # to tidy up model outputs

# Import data
medi <- read.delim("Expression.txt")

# Gather & separate
medi %>% 
  as_tibble() %>% 
  gather(key, value) %>% 
  separate(key, c("treatment", "gene", "time"), "_") -> medi_t

# Summary stats:
medi_t %>% 
  na.omit() %>%
  # filter(!is.na(value)) %>% # another way to remove NAs
  group_by(treatment, gene, time) %>% 
  summarise(avg = mean(value),
            stdev = sd(value),
            n = n(),
            SEM = stdev/sqrt(n),
            lower95 = smean.cl.normal(value)[2],
            upper95 = smean.cl.normal(value)[3]) -> medi_summary


# plot means and the 95% CI:
ggplot(medi_summary, aes(as.numeric(time), avg, color = treatment)) +
  geom_pointrange(aes(ymin = lower95, ymax = upper95), position = position_dodge(0.3)) +
  geom_line() +
  scale_y_continuous(limits = c(0, 2.5), expand = c(0,0)) +
  scale_x_continuous(breaks = 1:2, 
                     label = c("8:00", "16:00"), 
                     limits = c(0.8, 2.2)) +
  labs(x = "Time of day", 
       y = "Average fold-change\ngene expression (95CI)",
       color = "Treatment type") +
  facet_grid(cols = vars(gene)) +
  theme_classic() +
  theme(axis.line.x = element_blank(),
        strip.background = element_rect(fill = "grey95", color = NA),
        panel.background = element_rect(fill = "grey95"))

# Single ANCOVA:
medi_t %>% 
  filter(gene == "RIPK2", !is.na(value)) %>% 
  lm(value ~ treatment + time, data = .) %>% 
  anova()

# or:
RIPK2_lm <- lm(value ~ treatment + time, data = medi_t[medi_t$gene == "RIPK2", !is.na(medi_t$value),])
anova(RIPK2_lm)

# Single to multiple ANCOVA:
# Use broom package
medi_t %>% 
  filter(!is.na(value)) %>% 
  group_by(gene) %>% 
  do(tidy(anova(lm(value ~ treatment + time, data = .))))





  
  
  
  
