While there are a lot of things I would do differently if I were setting up this data for a production model that we depend on daily to have data easily accessible and ready for analysis, in this scenario, this simple model does the trick.  The main point obviously is to extract the receipt item data from the receipt records so that we can access both grains, depending on the question we're trying to answer.

Some of the things I might do differently in a production model are:
- Include a date dimension table so that time periods are easy to analyze.
- If the brand data were actually incomplete and there were no other source, I would want to parse through some of the description fields to get brand data and get it as complete as possible like that.
- I might break down the different underlying data sources (whatever the primary is versus user submitted and MetaBrite legacy data) or at least have a view where I could coalcesce some of these fields so that in the event the primary is empty, we can rely on another source.  Breaking the description fiels out would also give us a more true to definition fact table, containing only numerical data and foreign keys rather than including the qualiftative data.
- I also might break out some of the low cardinality fields and create a junk dimension table.

I would probably want to get a better idea of how this data fits into the big picture, where it comes from, cadence, etc. before making any final decisions but hopefully this gives you an idea of how I would approach this.

Thank you!
