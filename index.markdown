Baby names
==========

Data
----

[baby-names.csv](baby-names.csv) contains the top 1000 girl and boy baby names from 1880 to 2009.  This data was aggregated from the data made available from the [social security administration](http://www.ssa.gov/OACT/babynames/).  If you want to recreate it yourself, run the files `1-download.r`, `2-parse.rb` and `3-clean.r` in order.  You will need both R and ruby.

Percent of names in top 1000
----------------------------

![Percent of baby names in top 1000](images/ofall.png)

Since the 1960's the percentage of babies with names in the top 1000 has been shrinking, to it's current level of 80% of boys and 67% of girls.

Last letters
-------------

Stimulated by the discussion on [Andrew Gelman's blog](http://www.stat.columbia.edu/~cook/movabletype/archives/2009/05/where_all_boys.html) (prompted by an old post of the [baby name wizard blog](http://www.babynamewizard.com/archives/2007/7/where-all-boys-end-up-nowadays)) here are plots showing the distribution of last letter of names, 1880-2008.

![Distribution of last letter of baby names](images/last-letter.png)
