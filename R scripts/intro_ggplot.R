#---------------------------------------------
#-  Introduction to cool plots with ggplot  --
#---------------------------------------------


# Created by: Daniel Ottmann

# December 2018
###########################################################

###########################################################


# Set workinf directory:
setwd("your working directory")

# Load packages: 
library(tidyverse) # Contains ggplot and other useful packages



# ggplot is a package that enables great flexibility of plots
# It may take a some time at the beginning to understand the way of
# ggplot coding, but once you get it, you will find it very easy and logic

# ggplot has many examples in it's website that you may find useful:
browseURL("https://ggplot2.tidyverse.org/index.html")

# The community of R suers have build up upon ggplot to create a whole ecosystem:
browseURL("http://www.ggplot2-exts.org/gallery/")



# There are different ways to code ggplot.

# The basic structure is this:


#   ggplot(data = <data>) + 
#     <geom_function>(mapping = aes(<mappings>),
#                     stat = <stat>, position = <position>)


# What the hell does that mean?
# Lets put a simple example:

# Create a data frame:
x <- 1:100
y <- c(runif(50, 10, 50), runif(50, 40, 80)) 
z <- c(rep(c("a", "b"), c(50, 50)))
year <- c(rep(c(2015, 2016, 2017, 2018), c(25, 25, 25, 25)))
  
df <- data.frame(y, x, z, year)


# And now plot it out:
p <- ggplot(data = df) +
  geom_point(mapping = aes(x = x, y = y))
p


# "stat" and "position" are not used here
# In fact, you will only use them ocasionally

# Let's code the same in a more functional way:
ggplot(data = df, aes(x = x, y = y)) +
  geom_point()


# And now add some colour:
p <- ggplot(data = df, aes(x = x, y = y)) +
  geom_point(aes(colour = z))
p


# You can add anythnig you want with + at any time:
p <- ggplot(data = df, aes(x = x, y = y))
p

p <- p + geom_point(aes(colour = z))
p

p + geom_hline(yintercept = 50) + 
  geom_vline(xintercept = 25)


# We can have diferent panels based on one factor:
p + facet_wrap(~ year)


# Or on 2 factors:
p +facet_grid(z ~ year)


# You can tune the plot as much as you want.
# Here are a few examples on the background:
p + geom_point() +
  facet_grid(z ~ year) +
  theme_bw()

p + geom_point() +
  facet_grid(z ~ year) +
  theme_dark()

p + geom_point() +
  facet_grid(z ~ year) +
  theme_light()



# And you can save the object "p" very easily:
png(filename = "my_plot.png")
p
dev.off()

# That's allright, but we can specify size and resolution of the plot:
png(filename = "plots/my_plot.png", width = 15, height = 10, units = "cm", res = 200)
p
dev.off()



# What if you want to overlay serveral plots?
p <- ggplot(data = df, aes(x = z, y = y)) +   # Not how we changed x for z (factor) here
  geom_boxplot(aes(fill = z)) +               # Colored factor variables will show up as clearly different colours
  geom_point(aes(colour = y))                 # While continnuous variables will do so in a colored gradient 
p

   
# Remember you can keep adding more and more layers:                 
p + geom_jitter(colour = year)
p + geom_label(aes(label = x))


# OK! That last thing was a bit confusing...


# Lets go stpe by step, exploring the types of plots we can do:

###############################################################


##################
# geom_point()

head(mtcars)
nrow(mtcars)


# Basic plot:
p <- ggplot(mtcars, aes(wt, mpg))
p + geom_point()

# Add aesthetic mappings:
p + geom_point(aes(colour = factor(cyl)))

p + geom_point(aes(shape = factor(cyl)))

p + geom_point(aes(size = qsec))


# Set aesthetic to a fixed value:
p + geom_point(colour = "red", size = 3)


# Varying alpha is useful for large datasets

head(diamonds)
nrow(diamonds)

d <- ggplot(diamonds, aes(carat, price))
d + geom_point(alpha = 1/10)

d + geom_point(alpha = 1/100)


# For shapes that have a border (like 21), you can colour the inside and
# outside separately. Use the stroke aesthetic to modify the width of the
# border
p + geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)

# You can create interesting shapes by layering multiple points of
# different sizes
p <- ggplot(mtcars, aes(mpg, wt, shape = factor(cyl)))
p + geom_point(aes(colour = factor(cyl)), size = 4) +
  geom_point(colour = "grey90", size = 1.5)

p + geom_point(colour = "black", size = 4.5) +
  geom_point(colour = "pink", size = 4) +
  geom_point(aes(shape = factor(cyl)))

############################


############################
# geom_histogram()

# Basic histogram:
ggplot(df, aes(y)) +
  geom_histogram()

# Using diamond data:
ggplot(diamonds, aes(carat)) +
  geom_histogram()

# Define binwidth:
ggplot(diamonds, aes(carat)) +
  geom_histogram(binwidth = 0.01)

# Defnie number of bins:
ggplot(diamonds, aes(carat)) +
  geom_histogram(bins = 200)

# Rather than stacking histograms, it's easier to compare frequency polygons
ggplot(df, aes(y, fill = z)) +
  geom_histogram()

ggplot(diamonds, aes(price, fill = cut)) +
  geom_histogram(binwidth = 500)


# Using a frequencyplot:
ggplot(diamonds, aes(price, colour = cut)) +
  geom_freqpoly(binwidth = 500)




############################


############################
# geom_bar()

# geom_bar is designed to make it easy to create bar charts that show
# counts (or sums of weights)

# Code basic plot: number of cars in each class:
mpg

g <- ggplot(mpg, aes(class))


# Add geometry:
g + geom_bar()


# Total engine displacement of each class
g + geom_bar(aes(weight = displ))


# Bar charts are automatically stacked when multiple bars are placed
# at the same location. The order of the fill is designed to match
# the legend
g + geom_bar(aes(fill = drv))


# What if you want them next to each other, instead of on top of each other?
g + geom_bar(aes(fill = drv), position = "dodge")
             
             

# If you need to flip the order (because you've flipped the plot)
# call position_stack() explicitly:
g + geom_bar(aes(fill = drv), position = position_stack(reverse = TRUE)) +
  coord_flip() +
  theme(legend.position = "top")


# To show a speciffic value (e.g. means), you need geom_col()
df <- data.frame(trial = c("a", "b", "c"), mean = c(2.3, 1.9, 3.2), se = c(.4, .1, .6))
df$se_high <- df$mean + df$se
df$se_low <- df$mean - df$se
df

ggplot(df, aes(trial, mean)) +
  geom_col() + 
  geom_errorbar(aes(ymin = se_low, ymax = se_high))



# You can also use geom_bar() with continuous data, in which case
# it will show counts at unique locations
df <- data.frame(x = rep(c(2.9, 3.1, 4.5), c(5, 10, 4)))
df

ggplot(df, aes(x)) +
  geom_bar()




############################


############################
# geom_boxplot() , geom_violin() & geom_jitter()

# We already saw these at the beginning
# Say we have data that overlaps a lot:
df <- data.frame(x = rep(c("a", "b"), c(1000, 1000)), y = c(rnorm(1000, 90, 10), rnorm(1000, 110, 20)))
head(df)


# You can't really see much in a dotplot:
p <- ggplot(data = df, aes (x, y))
p + geom_point()


# This is why boxplots and other similar plots exist:
p + geom_boxplot()
p + geom_violin()


# But you may want to have an idea of how many dots yuo have:
p + geom_jitter()


# You can put this on top of one of the others:
p + geom_boxplot() +
  geom_jitter(alpha = 1/10)


# ENOUGH FOR TODAY
#########################################################

# But don't stop the show here!!

# There are lots of options for ggplot.

# Check out the website to find out more:
browseURL("https://ggplot2.tidyverse.org/reference/index.html")
