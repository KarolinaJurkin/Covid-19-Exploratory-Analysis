# Covid-19 project

### Introduction

In this analysis I'll be taking a closer look at Case Fatality Rate (CFT) versus Infection Rate and see how these metrics were changing over time. I also want to compare Total Deaths in different countries with Crude Mortality Rate (CMR) to see which countries were most affected by the pandemic.
As it is my first big project I decided to follow Alex Freberg's process [YouTube video](https://www.youtube.com/watch?v=qfyynHBFOsM&list=PLUaB-1hjhk8H48Pj32z4GZgGWyylqv85f&index=1&ab_channel=AlexTheAnalyst) and blend it with self-directed exploration and problem solving. Structured guidance provided me the foundation and allowed me to focus on deriving meaningful insights from the data. 

### Overview 

According to [Our World In Data]( https://ourworldindata.org/mortality-risk-covid):

![Pasted image 20231209160536](https://github.com/KarolinaJurkin/Covid-19-Exploratory-Analysis/assets/53952580/588f4347-6955-45e8-bd0c-907130c3ff22)

**Case Fatality Rate** is most likely overestimated due to the fact many people are undiagnosed, which results in the incomplete data. In reality total number of cases > diagnosed number of cases, which is why CFR should not be considered as a metric showing the true risk of death for an infected person.

**Crude Mortality Rate** is calculated by dividing number of deaths by total population. This metric is much more accurate in comparison to CFR, but it reflects different data and it will always be smaller, since number of diagnosed cases < total population (unless the whole population gets infected).

Initially I also planned to analyze the statistics of Covid19 among different income groups as they were included in the dataset. Unfortunately after checking the source [World Bank income classification](https://datahelpdesk.worldbank.org/knowledgebase/articles/906519-world-bank-country-and-lending-groups), the income groups are in fact certain regions without consideration of income differences within these regions, which makes the data insufficient. For that reason I decided not to perform Covid19 vs income analysis and not to include income records in the whole project. 

### Sources and tools used for this analysis

- Data source: [Our World In Data](https://ourworldindata.org)
- Preliminary cleaning and creating: Microsoft Excel
- Querying the data and creating Views: Microsoft SQL Server Management Studio
- Visualization: Power BI

### Data visualization

- **Case Fatality Rate vs Infection Rate**: line chart is the best choice to show both metrics. It's important to keep in mind that IR takes total cases and divides it by population. Taking into account sum of new cases would not be a good solution in this case as data was not always collected daily and there are discrepancies between actual cases and confirmed cases. Day to day data varies so much that such chart would not be informative in any way. For this reason it's important to know what to look for when reading this chart. If IR was stable we would observe a linear growth of this metric and what we see instead is exponential increase with some sudden growths. After 2023 IR becomes almost a flat line which shows that not many new cases were observed.

- **World numbers (Total Cases, Total Deaths, Infection Rate)**: card visuals to show summaries.

- **Total Deaths and Crude Mortality Rate**: I chose bar charts as these metrics are shown by country. Charts are seperate as Total Deaths are absolute number and CRM is a percentage and combining them in a singular chart would be confusing. 

- **Infection Rate by country**: I decided to include a world shape map showing the Infection Rate in different countries. The unexpected challenge I encountered was that Power BI doesn't have such a map built in and it required me to search for a specific topoJSON file. Once I customized and downloaded the map, I was able to create a custom world shape map visualization. 

### Insights

- Infection Rate (IR) and Case Fatality Rate (CFR) are undeniably correlated. Whenever we see a rise in Infection Rate the deadliness goes down. A virus that kills its host quickly may not have a chance to spread further thus the mutations in time tend to increase IR.

- Both IR and CFR changed drastically over time and most definitely one of the biggest factors causing it is the mutation and different variants of the virus. We can clearly see the change in metrics right after the Omicron variant started spreading at the end of 2021.

- Even though USA has the greatest absolute value of Total Deaths (over 1 million), its Crude Mortality Rate (CRM=0.33%) does not stand out and is comparable with most of the European countries. The data suggests that countries that were most affected by the pandemic are as follows: Peru (CRM=0.65%), Bulgaria (0.57%) and Bosnia and Herzegovina (0.51%).

- As we look at the Infection Rate on the map, what really stands out is Africa that has really low values in comparison to the other parts of the world. Further analysis would be required to come to a conclusion why we can observe such trend.
