# Chicago

A demographic and socioeconomic profile of Chicago,
replicating the one displayed on
[Census Reporter](https://censusreporter.org/profiles/16000US1714000-chicago-il/).
Notably that portal uses ACS 1 year estimates, while 5 year estimates for
2021 are available and generally considered more reliable.


## Data

See the `data` directory for more information on obtaining data for this
project. I will not distribute data with this repository.


## Analysis

See the `src` directory for the source code used here.


## Issues and Notes

The continuous data for when a respondent moved into their current housing unit
is not publicly available, so I cannot recreate that table/chart.

I do not presently understand how to replicate *Number of housing units*,
or perhaps more accurately I don't understand how this quantity differs from
*Number of households* in any meaningful, Census-related way.

Something is wrong with the official profile's tabulation of house values.
(See *Value of owner-occupied housing units*).
The easiest way to demonstrate this is to look at the top bucket.
The *Over $1M* item's total is 14,010.
Following the link to Table B25075, however, reveals that 14,010 is the total
for just *$1,000,000 to $1,499,999*.
Potentially this is a matter of topcoding policy differing between the two
backends?

The pandemic caused a few rapid changes to demography.
It took me a while to convince myself that my recreation was not in error.
The most notable table is *Means of transportation*, especially as seen in the
*Worked at home* item.
But other Census Reporter tables corroborate my numbers.

