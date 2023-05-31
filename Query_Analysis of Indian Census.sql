select * from [Analysis on Indian Census].[dbo].[dataset1];

select * from dataset2;

-- Number of rows in our dataset (Use .. if don't want to use dbo)

select count(*) from dataset1;
select count(*) from [Analysis on Indian Census]..[dataset2];

-- Printing top 5 rows data from the dataset
select top 5 * from [Analysis on Indian Census].[dbo].[dataset1];
select top 5 * from dataset2;

-- Data from particular states
select * from dataset2 where State='Andhra Pradesh';
select State,count(*) from dataset2 group by State;
select * from [Analysis on Indian Census]..Dataset1 where state in ('Bihar','Delhi');

-- Population
select sum(population) [India Population] from dataset2;
select State,sum(population) as [Population] from dataset2 group by State;

-- Average Growth
select state, avg(growth)*100 as [Average growth] from dataset1 group by State;

-- Average sex ratio
select State, avg(Sex_Ratio) as [Average Sex ratio] from dataset1 group by State order by [Average Sex ratio] desc;

-- Average literacy rate
select State, round(avg(Literacy),0) as [Average Literacy Rate] from dataset1 group by State having round(avg(Literacy),0)>90 order by [Average Literacy Rate] desc;

-- Highest population growth in state
select State,sum(growth) as Growth from dataset1 group by state order by Growth desc;
select top 1 state, sum(growth) as Growth from dataset1 group by state order by Growth desc;

-- Top 3 states showing highest growth ratio
select top 3 state,avg(growth)*100 Avg_Growth from dataset1 group by state order by Avg_Growth desc;

--Bottom 3 states showing lowest sex ratio
select top 3 state,round(avg(sex_ratio),0) Avg_Sex_Ratio from dataset1 group by state order by Avg_Sex_Ratio asc;

-- Top and Bottom 3 states in literacy state
drop table if exists topstates;
create table topstates(
state nvarchar(255),
topstate integer
)

insert into topstates
select state,round(avg(literacy),0) Avg_Literacy from dataset1 group by state order by Avg_Literacy desc;

drop table if exists bottomstates;
create table bottomstates(
state nvarchar(255),
bottomstate integer
)

insert into bottomstates
select state,round(avg(literacy),0) Avg_Literacy from dataset1 group by state order by Avg_Literacy asc;

--Union opertor
select * from (select top 3 * from topstates order by topstates.topstate desc) a
union
select * from (select top 3 * from bottomstates order by #bottomstates.bottomstate asc) b order by topstate desc;

-- States which start or end with particular letter
select distinct state from dataset1 where upper(state) like 'A%' or upper(state) like 'B%';
select distinct state from dataset1 where lower(state) like 'A%' and lower(state) like '%H'

-- Joining both table
select d1.district,d1.state,d1.Sex_Ratio,d2.population from dataset1 d1
inner join
dataset2 d2 on d1.district=d2.district;

--Finding state-wise male and female poopulation
select r.state,sum(r.females) Females,sum(r.males) Males 
from
(select d.District,d.State,d.Popualtion, round((d.population*d.sex_ratio)/(d.sex_ratio+1),0) females, 
round((d.poppulation*(1/(d.sex_ratio+1))),0) males
from
(select d1.District,d1.State,d1.sex_ratio/1000 sex_ratio,d2.population from dataset1 d1
inner join
dataset2 d2 on d1.district=d2.district ) d) r group by r.State;

-- State-wise Literate and Illiterate popuation
select State,sum([Literate population]) [Literate],sum([Illiterate population]) [Illiterate],sum(Populaltion) [Total Population]
from 
(select d.District,d.State,d.[Literacy Rate],d.population,round((d.[Literacy Rate]*d.Population),0) as [Literate population],
round((1-d.[Literacy Rate])* d.population,0) as [Illiterate population] from
(select d1.District,d1.State,d1.Literacy/100 [Literacy Rate],d2.Population from dataset1 d1
inner join dataset2 d2 on d1.district=d2.district) d) r group by State;
group by c.state

--Finding top 3 states which have highest literate people

select top 3 * from (select State,sum([Literate population]) [Literate],sum([Illiterate population]) [Illiterate],sum(Population) [Total Population]
from
(select d.District,d.State,d.[Literacy Rate],d.population,round((d.[Literacy Rate]*d.Population),0) as [Literate population],
round((1-d.[Literacy Rate])*d.Population,0) as [Illiterate population] from
(select d1.District,d1.State,d1.Literacy/100 [Literacy Rate], d2.Population fromm dataset1 d1
inner join dataset2 d2 on d1.district=d2.district) d) r group by State) z order by [Literate] desc;

-- population in previous census
select sum(z.previous_census_population) [Previous Census Population],sum(z.current_census_population) [Current_Census_Population] from
(sselect e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from dataset1 a inner join dataset2 b on a.district=b.district) d) e
group by e.state) z;

--  Area vs Population (To find out how much area per popuation has reduced)

select q.[Total Area]/q.[Previous Census Population]  as [Old_AreaPerPopulation], 
q.[Total Area]/q.[Current Census Population] as [New_AreaPerPopulation] from
(select o.*,p.[Total Area] from 
(select '1' as keyy,n.* from
(select sum(z.previous_census_population) [Previous Census Population],sum(z.current_census_population) [Current Census Population] from
(select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from dataset1 a inner join dataset2 b on a.district=b.district) d) e
group by e.state) z) n) o 
inner join 
(select '1' as keyy,m.* from 
(select sum(Area_km2) [Total Area] from [Analysis on Indian Census]..Dataset2) m) p on o.keyy=p.keyy) q;

--window (Output top 3 districts from each state with highest literacy rate)
select l.* from
(select District,State,Literacy,rank() over (partition by State order by Literacy) [Rank] from [Analysis on Indian Census].dbo.Dataset1) l
where l.[Rank] in (1,2,3) order by State;