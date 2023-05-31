# SQL-Project_Analysis-on-Indian-Census

-- Finding state-wise male and female population

Popoulation=females+males	-eq(1)
sex ratio=females/males		-eq(2)
Using equations 1&2
males=population-females -> (females/sex ratio)=population-females -> (f(1+sr))/sr=p ->
females=(population*sex ratio)/(sex ratio +1) -----------------------------------------------No. of females
males=popuation-females -> males=p - ((p.sr)/(sr+1))
males=population*(1/sex ratio +1)
Sex ratio is calculated as (females population*1000)/(males poopulation)

-- State-wise Literate and Illiterate popuation
Literacy rate=Total literate people/Population
Total literate people=Literacy rate*Population
Total illiterate people=(1-Literacy rate)*Population
Literacy rate is calculated as (Total literate people*100)/Population

-- Population in previous census
Previous_census_population + (Growth * Previous_census_population) = New_Population
Previous_census_population = (1+Growth) = New_Population
Previous_census_population = (New_Population) / (1 + Growth)

-- Area vs Population
'Population in previous census' query calculated previous census population using current census population data. Using that data, 'Area vs Population' query calculated how area vs population hahs reduced from previous census to the current census.
Steps:-
1. Find total area of India.
2. Create a common key to join 'population in previous census' query and 'total area' query
3. Find Area/Population from joined query.
