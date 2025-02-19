libname Nandinis "C:\Users\swapn\Desktop\Nandini\Metro College\SAS Project\SAS project Library";

PROC IMPORT DATAFILE="C:\Users\swapn\Desktop\Nandini\Metro College\SAS Project\Project\Nandini_Desai_Sas_Adidas\Adidas US Sales Datasets.xlsx"
            OUT=Nandinis.Adidas
            DBMS=XLSX
            REPLACE;
    GETNAMES=YES;
	RUN;
/*The Adidas US Sales Dataset contains information about sales transactions, including details about 
	retailers, products, regions, and sales performance. Here's an explanation of each of the variables in the dataset:

Variables:
Retailer:The name of the retailer that made the sale. In this dataset, an example retailer is "Foot Locker".

Retailer ID:A unique identifier for the retailer. This ID is used to distinguish between different retailers in the dataset.

Invoice Date:The date when the sale was made. This is in a YYYY-MM-DD format (e.g., "2020-01-01").

Region:The geographic region in which the sale took place. For example, "Northeast" refers to the northeastern region 
		of the United States.

State:The state where the sale occurred. For example, "New York" is the state in the provided dataset.

City:The specific city where the sale was made. For example, "New York" is the city in the dataset.

Product:The type of product sold. In the dataset, it includes specific categories like "Men's Street Footwear", 
	"Men's Athletic Footwear", and "Women's Street Footwear".

Price per Unit:The price for a single unit of the product sold. This is represented as a dollar value (e.g., "$50.00").

Units Sold:The number of units of the product that were sold in that transaction. For example, 1,200 units of "Men's Street 
	Footwear" were sold on "2020-01-01".

Total Sales:The total revenue from the sale, calculated as the Price per Unit multiplied by the Units Sold. 
	For example, if the price is $50 and 1,200 units were sold, the total sales would be $600,000.

Operating Profit:The profit made from the sale, after accounting for operating expenses (excluding taxes, interest, etc.). 
	This is the total sales revenue minus the cost of goods sold and operating expenses. For example, $300,000 operating 
	profit from $600,000 total sales.

Operating Margin:The operating margin is the percentage of revenue that represents operating profit. It is calculated as:
Operating Margin=Operating Profit*100/Total Sales
For instance, with an operating profit of $300,000 and total sales of $600,000, the operating margin would be 50%.

Sales Method:The method by which the product was sold. In the example dataset, the sales method is "In-store", 
	indicating that the sale was made at a physical store location.*/

proc contents Data=Nandinis.Adidas;run;

proc print Data=Nandinis.Adidas (obs=10);run;

proc sql;
select count(distinct(Invoice_Date))
from Nandinis.Adidas;
quit;

/*Checking Invoicing trend*/
proc sql;
select Invoice_Date,count(*) as invoice_count
from Nandinis.Adidas
group by Invoice_Date
order by invoice_count desc;
quit;

/*Invoice Trend for year 2020*/
proc sql;
    create table Nandinis.InvoiceMonthSummary2020 as
    select
        put(Invoice_Date, yymmn6.) as Invoice_Month,  
        count(*) as invoice_count
    from Nandinis.Adidas
    where year(Invoice_Date) = 2020  
    group by put(Invoice_Date, yymmn6.) 
    order by Invoice_Month;
quit;


proc sgplot Data=Nandinis.InvoiceMonthSummary2020;
    series x=Invoice_Month y=invoice_count / markers;
    xaxis label="Invoice Month";
    yaxis label="Invoice Count";
run;

/*Invoice Trend for year 2021*/
proc sql;
    create table Nandinis.InvoiceMonthSummary2021 as
    select
        put(Invoice_Date, yymmn6.) as Invoice_Month,   
        count(*) as invoice_count
    from Nandinis.Adidas
    where year(Invoice_Date) = 2021  
    group by put(Invoice_Date, yymmn6.)  
    order by Invoice_Month;
quit;


proc sgplot Data=Nandinis.InvoiceMonthSummary2021;
    series x=Invoice_Month y=invoice_count / markers;
    xaxis label="Invoice Month";
    yaxis label="Invoice Count";
run;


/*Univariate Analysis for Categorical Variables*/
Data Nandinis.Adidas;
set Nandinis.Adidas;
Retailer_ID=put(Retailer_ID,8.);run;


proc freq Data=Nandinis.Adidas;
table City Product Region Retailer Retailer_ID Sales_Method State/missing;
run;

proc sql;
select count(distinct(city))as Distinct_City
from Nandinis.Adidas;
quit;

Title'Univariate Analysis of City';
Title'Bar Chart for City';
proc sgplot Data=Nandinis.Adidas;
vbar City/FIlltype=gradient groupdisplay=cluster datalabel;
run;

proc freq data=Nandinis.Adidas noprint;
tables city / out=city_counts(keep=city count);
run;


Proc sort Data=city_counts out=city_counts_sort;
by descending count;
run;
proc print data=city_counts_sort;
run;

/*Top 10 cities w.r.t Invoice Count*/
proc sgplot data=city_counts_sort (obs=10);
vbar city / response=count datalabel;
xaxis label="City" discreteorder=data; 
yaxis label="Invoice Count";
title "Top 10 Cities by Invoice Count";
run;
title;


Title'Univariate Analysis of Product';
Title'Bar Chart for Product';
proc sgplot Data=Nandinis.Adidas;
vbar product/FIlltype=gradient groupdisplay=cluster datalabel;
run;

Title'Univariate Analysis of Region';
Title'Bar Chart for Region';
proc sgplot Data=Nandinis.Adidas;
vbar Region/FIlltype=gradient groupdisplay=cluster datalabel;
run;

Title'Univariate Analysis of Retailer';
Title'Bar Chart for Retailer';
proc sgplot Data=Nandinis.Adidas;
vbar Retailer/FIlltype=gradient groupdisplay=cluster datalabel;
run;

Title'Univariate Analysis for State';/*recuce states categories*/
Title'Bar Chart for State';
proc sgplot Data=Nandinis.Adidas;
vbar State/FIlltype=gradient groupdisplay=cluster datalabel;
run;

/*SHowing top 10 states w.r.t invoice count*/
proc freq Data=Nandinis.adidas;
table State/out=state_count (keep=State count);
run;

proc sort Data=state_count out=state_count_sort;
by descending count;
run;

proc print Data=state_count_sort;run;

Proc sql;
select count(distinct(state)) as Dictinct_State
from Nandinis.Adidas;
quit;


proc sgplot data=state_count_sort (obs=10);
vbar State / response=count datalabel;
xaxis label="State" discreteorder=data; 
yaxis label="Invoice Count";
title "Top 10 States by Invoice Count";
run;
title;

Title'Univariate Analysis Retailer ID';
Title'Bar Chart for Retailer ID';
proc sgplot Data=Nandinis.Adidas;
vbar Retailer_ID/FIlltype=gradient groupdisplay=cluster datalabel;
run;

/*Univariate Analysis Numerical Variables*/
proc means Data=Nandinis.Adidas n nmiss var std cv clm mean sum min max maxdec=2;run;

Title 'Univariate Analysis of Units Sold';
proc univariate Data=Nandinis.Adidas normal;
var Units_Sold;
run;

Title ' Histogram and Kernal Plot of Units Sold';
Proc sgplot Data=Nandinis.Adidas;
histogram Units_Sold;
density Units_Sold/type=kernel;
run;
title;

Title 'Univariate Analysis of Operating_Margin';
proc univariate Data=Nandinis.Adidas normal;
var Operating_Margin;
run;

Title ' Histogram and Kernal Plot of Operating_Margin';
Proc sgplot Data=Nandinis.Adidas;
histogram Operating_Margin;
density Operating_Margin/type=kernel;
run;
title;

title 'Univariate Analysis of Operating Profit';
proc univariate Data=Nandinis.Adidas normal;
var Operating_Profit;
run;

Title'Histogram and Kernal Plot of Operating Profit';
Proc sgplot Data=Nandinis.Adidas;
histogram Operating_profit;
density Operating_profit/type=kernel;
run;
title;

Title 'Univariate Analysis of Price Per Unit';
proc univariate Data=Nandinis.Adidas normal;
var Price_per_unit;
run;

Title' Histogram and Kernel Plot of Price per Unit';
Proc sgplot Data=Nandinis.Adidas;
histogram Price_per_unit;
density Price_per_unit/type=kernel;
run;
title;

title 'Univariate Analysis for Total Sales';
proc univariate Data=Nandinis.Adidas normal;
var Total_Sales;
run;
title 'Histogram and Kernel plot for Total Sales';
Proc Sgplot Data=Nandinis.Adidas;
histogram Total_sales;
density Total_Sales/type=kernel;
run;
title;

/*Checking Outliers*/
Title 'Outliers In Operating Margin';
Proc Sgplot Data=Nandinis.Adidas;
vbox Operating_Margin ;
run;
title;

Title 'Outlier In Operating Profit';
Proc sgplot Data=Nandinis.Adidas;
vbox operating_profit;
run;
title;

Title ' Outliers in Price per Unit';
Proc sgplot data=Nandinis.adidas;
vbox Price_Per_unit;
run;title;

Title 'Outliers In Units Sold';
Proc sgplot Data=Nandinis.adidas;
vbox Units_sold;
run;
title;

title 'Outliers In Total Sales';
Proc SGPlot Data=Nandinis.Adidas;
vbox Total_Sales;
run;
title;

/*SInce Numerical variables are skewed and has outliers- Lets Standardize them*/
proc standard data=Nandinis.Adidas out=standardized_data mean=0 std=1;
var Units_Sold operating_Profit operating_margin total_sales price_per_unit;
run;

Title 'Outlier In Operating Profit';
Proc sgplot Data=standardized_data;
vbox operating_profit;
run;
title;

Title 'Histogram Operating Profit';
Proc sgplot Data=standardized_data;
histogram operating_profit;
density operating_profit/type=kernel;
run;
title;

Title 'Outlier In Operating MArgin';
Proc sgplot Data=standardized_data;
vbox operating_margin;
run;
title;

Title 'Histogram Operating Margin';
Proc sgplot Data=standardized_data;
histogram operating_margin;
density operating_margin/type=kernel;
run;
title;

Title 'Outlier In Price Per Unit';
Proc sgplot Data=standardized_data;
vbox price_per_unit;
run;
title;

Title 'Histogram Price Per Unit';
Proc sgplot Data=standardized_data;
histogram price_per_unit;
density price_per_unit/type=kernel;
run;
title;

Title 'Outlier In Units SOld';
Proc sgplot Data=standardized_data;
vbox Units_sold;
run;
title;

Title 'Histogram of Units SOld';
Proc sgplot Data=standardized_data;
histogram Units_sold;
density Units_sold/type=kernel;
run;
title;

Title 'Outlier In Total Sales';
Proc sgplot Data=standardized_data;
vbox Total_Sales;
run;
title;

Title 'Histogram Total Sales';
Proc sgplot Data=standardized_data;
histogram Total_Sales;
density Total_Sales/type=kernel;
run;
title;

/*Bivariate Analysis- Categorical Vs categorical*/

/*Distribution of Products w.r.t Region using Contingency Table*/
proc freq Data=Nandinis.Adidas;
table Region*Product/missing chisq norow nocol;
run;
title"Association Between Region and Product";
proc SGplot Data=Nandinis.Adidas;
vbar Region/group=Product filltype=gradient groupdisplay=cluster datalabel;
run;

/*H0= There is no association between Region and Products
H1- There is association between Region and Products

Since P value in CHisq test is >0.05. We Failed to reject null Hypothesis. Means There is no association between Region and Products*/

/*Distribution of Retailers and Sales Method using Contingency Table*/
proc freq Data=Nandinis.Adidas;
table Retailer*Sales_method/missing chisq norow nocol;
run;
title"Association Between Retailer and Sales Method";
proc SGplot Data=Nandinis.Adidas;
vbar Retailer/group=Sales_method filltype=gradient groupdisplay=cluster datalabel;
run;

/*H0= There is no association between Retailer and Sales Method
H1- There is association between Retailer and Sales Method

Since P value in CHisq test is <0.05. We reject null Hypothesis. Means There is a statistically significant association 
between Retailer ans Sales Method*/


/*Distribution of Products w.r.t Retailer using Contingency Table*/
proc freq Data=Nandinis.Adidas;
table Retailer*Product/missing chisq norow nocol;
run;
title"Association Between Retailer and Product";
proc SGplot Data=Nandinis.Adidas;
vbar Product/group=Retailer filltype=gradient groupdisplay=cluster datalabel;
run;

/*H0= There is no association between Retailer and Products
H1- There is association between Retailer and Products

Since P value in CHisq test is >0.05. We Failed to reject null Hypothesis. Means There is no association between Retailer and Products*/

/*Distribution of Region w.r.t Retailer using Contingency Table*/
proc freq Data=Nandinis.Adidas;
table Retailer*Region/missing chisq norow nocol;
run;
title"Association Between Retailer and Region";
proc SGplot Data=Nandinis.Adidas;
vbar Region/group=Retailer filltype=gradient groupdisplay=cluster datalabel;
run;

/*H0= There is no association between Retailer and Region
H1- There is association between Retailer and Region

Since P value in CHisq test is <0.05. We reject null Hypothesis. Means There is statistically sigificant association between Retailer and Region*/

/*Distribution of Product w.r.t Sales Method using Contingency Table*/
proc freq Data=Nandinis.Adidas;
table Product*Sales_Method/missing chisq norow nocol;
run;
title"Association Between Product and Sales Method";
proc SGplot Data=Nandinis.Adidas;
vbar Sales_method/group=Product filltype=gradient groupdisplay=cluster datalabel;
run;

/*H0= There is no association between Product and Sales Method
H1- There is association between Product and Sales Method

Since P value in CHisq test is >0.05. We fail to reject null Hypothesis. Means There is no association between Product and Sales Method*/

/*Distribution of Region w.r.t Sales Method using Contingency Table*/
proc freq Data=Nandinis.Adidas;
table Region*Sales_Method/missing chisq norow nocol;
run;
title"Association Between Region and Sales Method";
proc SGplot Data=Nandinis.Adidas;
vbar Sales_method/group=Region filltype=gradient groupdisplay=cluster datalabel;
run;

/*H0= There is no association between Region and Sales Method
H1- There is association between Region and Sales Method

Since P value in CHisq test is <0.05. We reject null Hypothesis. Means There is statistically significant association between Region and Sales Method*/

/*Bivariate Analysis between 2 continuous numerical variables using Correlation */

/*Correlation between Price per Unit and Units Sold */
proc surveyselect data=Nandinis.Adidas out=Nandinis.Adicorr method=srs n=100;
run;
proc print data=Nandinis.Adicorr;run;

proc corr Data=Nandinis.Adicorr;
var Units_sold;
with Price_Per_unit;
run;
proc reg data=Nandinis.Adicorr;
model Units_SOld=Price_Per_Unit;
run;


/*Correlation Between Total Sales and Operating Profit*/
proc corr Data=Nandinis.Adicorr;
var Total_Sales;
with Operating_profit;
run;
proc reg data=Nandinis.Adicorr;
model Total_Sales=Operating_profit;
run;

/*Correlation Between Operating Margin and Operating Profit*/
proc corr Data=Nandinis.Adicorr;
var Operating_margin;
with Operating_profit;
run;
proc reg data=Nandinis.Adicorr;
model Operating_margin=Operating_profit;
run;

/*Correlation Between Price and Operating Profit*/
proc corr Data=Nandinis.Adidas;
var Total_Sales Price_Per_Unit Units_SOld Operating_profit Operating_margin;
run;

proc corr Data=Nandinis.Adicorr;
var Total_Sales Price_Per_Unit Units_SOld Operating_profit Operating_margin;
run;
proc reg data=Nandinis.Adicorr;
model Operating_margin=Operating_profit;
model Total_Sales=Operating_profit;
model Price_per_unit=Units_sold;
model Price_per_unit=Total_Sales;
model Price_per_unit=operating_profit;
model units_sold=Total_Sales;
model units_sold=Operating_profit;
model units_sold= operating Margin;
model Operating_margin=Total_Sales;
run;


/*Distribution of Operating Profit as per Sales Method using Anova*/

/*Descriptive Analysis Operating Profit Vs Sales Method*/
title'Distribution of Operating Profit with Sales Method';
proc means Data=Nandinis.Adidas n nmiss var std cv clm mean sum min Q1 Q3 qrange max maxdec=2 ;
var Operating_Profit;
class Sales_method;
run;

/*Normality test Operating Profit Vs Sales Method*/
proc univariate Data=Nandinis.Adidas normal plot;
var Operating_Profit;
Class Sales_method;
qqplot /normal (mu=est sigma=est);
run;
/*Ho- Operating Profit in all group of Sales Method  is normally distributed
H1- Operating Profit in all group of Sales Method is not normally distributed*/
/*Since P value for all groups of Sales Method is <0.05. Hense we reject the null hypothesis and conclude that
Operating Profit is not normally distributed in any Sales Method .
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Operating Profit Vs Sales Method*/
proc glm data=Nandinis.Adidas;
class Sales_method;
model Operating_Profit = Sales_Method;
means Sales_method / hovtest=levene(type=abs) welch;
run;
/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Operating Profit in all Sales Method is not equal*/

/*Proving Operating Profit is not same in all Sales Method Categories */

/*H0= Means of Operating Profit is equal across all Sales Methods
H1- Means of Operating Profit  is not equal across all Sales Methods*/

TITLE "Operating Profit distribution across Sales Method";
PROC ANOVA DATA = Nandinis.Adidas;
 CLASS Sales_method;
 MODEL Operating_Profit = Sales_method;
 MEANS Sales_method/scheffe;
RUN;
QUIT;
title;

proc npar1way data=Nandinis.Adidas wilcoxon;
  class Sales_method;
  var Operating_profit;
run;
/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Operating Profit is not equal in all Sales Method




/*Distribution of Total Sales as per Retailer using Anova*/

/*Descriptive Analysis Of Total Sales  Vs Retailer*/
proc means Data=Nandinis.Adidas n nmiss var std cv clm mean sum min Q1 Q3 qrange max maxdec=2 ;
var Total_Sales;
class Retailer;
run;

/*Normality test Total Sales  Vs Retailer*/
proc univariate Data=Nandinis.Adidas normal plot;
var Total_Sales;
Class Retailer;
qqplot /normal (mu=est sigma=est);
run;
/*Ho- Total Sales in all group of Retailer  is normally distributed
H1- Total Sales in all group of Retailer is not normally distributed*/
/*Since P value for all groups of Retailer is <0.05. Hense we reject the null hypothesis and conclude that
Total Sales is not normally distributed in any Retailer Type .
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption
/*Equality of variance Total Sales Vs Retailer*/
proc glm data=Nandinis.Adidas;
class Retailer;
model Total_Sales = Retailer;
means Retailer / hovtest=levene(type=abs) welch;
run;
/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Total Sales  in all Retailers is not equal*/

/*Proving Total Sales is not same in all Retailer Categories */

/*H0= Means of Total Sales  is equal across all Retailers
H1- Means of Total Sales is not equal across all Retailers*/

TITLE "Total Sales distribution across Retailer";
PROC ANOVA DATA = Nandinis.Adidas;
 CLASS Retailer;
 MODEL Total_Sales = Retailer;
 MEANS Retailer/scheffe;
RUN;
QUIT;
title;

proc npar1way data=Nandinis.Adidas wilcoxon;
  class Retailer;
  var Total_Sales;
run;

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Total Sales is not equal in all Retailers */

-----------------------------------------------------------------------------------------------------------------

%macro cat_num(num,cat);
title"Distribution of &cat with &num";
proc means Data=Nandinis.Adidas n nmiss var std cv clm mean sum min Q1 Q3 qrange max maxdec=2 ;
var &num;
class &cat;
run;
/*Normality test Operating Profit Vs Sales Method*/
proc univariate Data=Nandinis.Adidas normal plot;
var &num;
Class &cat;
qqplot /normal (mu=est sigma=est);
run;

proc glm data=Nandinis.Adidas;
class &cat;
model &num = &cat;
means &cat / hovtest=levene(type=abs) welch;
run;

PROC ANOVA DATA = Nandinis.Adidas;
 CLASS &cat;
 MODEL &num = cat;
 MEANS cat/scheffe;
RUN;
QUIT;
title;
%mend cat_num;



%cat_num(Units_sold,retailer)

/*Ho- Units SOld in all group of Retailer is normally distributed
H1- Units Sold in all group of Retailers is not normally distributed*/
/*Since P value for all groups of Retailers is <0.05. Hense we reject the null hypothesis and conclude that
Units SOld is not normally distributed in any Retailer group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Units Sold and Retailers*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Units Sold in all Retailers is not equal*/

/*Proving Units SOld is not same in all Retailer Categories */

/*H0= Means of Units Sold is equal across all Retailers
H1- Means of Units Sold is not equal across all Retailers*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Units SOld is not equal in all Retailers */

%cat_num(Operating_profit,retailer)

/*Ho- Operating Profit in all group of Retailer is normally distributed
H1- Operating Profit in all group of Retailers is not normally distributed*/
/*Since P value for all groups of Retailers is <0.05. Hense we reject the null hypothesis and conclude that
Operating Profit is not normally distributed in any Retailer group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Operating Profit and Retailers*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Operating Profit in all Retailers is not equal*/

/*Proving Operating Profit is not same in all Retailer Categories */

/*H0= Means of Operating Profit is equal across all Retailers
H1- Means of Operating Profit is not equal across all Retailers*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Operating Profit is not equal in all Retailers */

%cat_num(Operating_margin,retailer)

/*Ho- Operating Margin in all group of Retailer is normally distributed
H1- Operating Margin in all group of Retailers is not normally distributed*/
/*Since P value for all groups of Retailers is <0.05. Hense we reject the null hypothesis and conclude that
Operating Margin is not normally distributed in any Retailer group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Operating Margin and Retailers*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Operating Margin in all Retailers is not equal*/

/*Proving Operating Margin is not same in all Retailer Categories */

/*H0= Means of Operating Margin is equal across all Retailers
H1- Means of Operating Margin is not equal across all Retailers*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Operating Margin is not equal in all Retailers */

%cat_num(Price_per_unit,retailer)

/*Ho- Price Per Unit in all group of Retailer is normally distributed
H1- Price Per Unit in all group of Retailers is not normally distributed*/
/*Since P value for all groups of Retailers is <0.05. Hense we reject the null hypothesis and conclude that
Price Per Unit is not normally distributed in any Retailer group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Price Per Unit and Retailers*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Price Per Unit in all Retailers is not equal*/

/*Proving Price Per Unit is not same in all Retailer Categories */

/*H0= Means of Price Per Unit is equal across all Retailers
H1- Means of Price Per Unit is not equal across all Retailers*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Price Per Unit is not equal in all Retailers */

%cat_num(Total_Sales,Sales_method)

/*Ho- Total Sales in all group of Sales Method is normally distributed
H1- Total Sales in all group of Sales Methods is not normally distributed*/
/*Since P value for all groups of Sales Methods is <0.05. Hense we reject the null hypothesis and conclude that
Total Sales is not normally distributed in any Sales Method group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Total Sales and Sales Methods*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Total Sales in all Sales Methods is not equal*/

/*Proving Total Sales is not same in all Sales Method Categories */

/*H0= Means of Total Sales is equal across all Sales Methods
H1- Means of Total Sales is not equal across all Sales Methods*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Total Sales is not equal in all Sales Methods */

%cat_num(Units_sold,Sales_method)

/*Ho- Units Sold in all group of Sales Method is normally distributed
H1- Units Sold in all group of Sales Methods is not normally distributed*/
/*Since P value for all groups of Sales Methods is <0.05. Hense we reject the null hypothesis and conclude that
Units Sold is not normally distributed in any Sales Method group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Units Sold and Sales Methods*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Units Sold in all Sales Methods is not equal*/

/*Proving Units Sold is not same in all Sales Method Categories */

/*H0= Means of Units Sold is equal across all Sales Methods
H1- Means of Units Sold is not equal across all Sales Methods*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Units Sold is not equal in all Sales Methods */

%cat_num(Operating_margin,Sales_method)

/*Ho- Operating Margin in all group of Sales Method is normally distributed
H1- Operating Margin in all group of Sales Methods is not normally distributed*/
/*Since P value for all groups of Sales Methods is <0.05. Hense we reject the null hypothesis and conclude that
Operating Margin is not normally distributed in any Sales Method group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Operating Margin and Sales Methods*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Operating Margin in all Sales Methods is not equal*/

/*Proving Operating Margin is not same in all Sales Method Categories */

/*H0= Means of Operating Margin is equal across all Sales Methods
H1- Means of Operating Margin is not equal across all Sales Methods*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Operating Margin is not equal in all Sales Methods */

%cat_num(Price_per_unit,Sales_method)

/*Ho- Price Per Unit in all group of Sales Method is normally distributed
H1- Price Per Unit in all group of Sales Methods is not normally distributed*/
/*Since P value for all groups of Sales Methods is <0.05. Hense we reject the null hypothesis and conclude that
Price Per Unit is not normally distributed in any Sales Method group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Price Per Unit and Sales Methods*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Price Per Unit in all Sales Methods is not equal*/

/*Proving Price Per Unit is not same in all Sales Method Categories */

/*H0= Means of Price Per Unit is equal across all Sales Methods
H1- Means of Price Per Unit is not equal across all Sales Methods*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Price Per Unit is not equal in all Sales Methods */

%cat_num(Total_Sales,Region)

/*Ho- Total Sales in all group of Region is normally distributed
H1- Total Sales in all group of Regions is not normally distributed*/
/*Since P value for all groups of Regions is <0.05. Hense we reject the null hypothesis and conclude that
Total Sales is not normally distributed in any Region group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Total Sales and Regions*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Total Sales in all Regions is not equal*/

/*Proving Total Sales is not same in all Region Categories */

/*H0= Means of Total Sales is equal across all Regions
H1- Means of Total Sales is not equal across all Regions*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Total Sales is not equal in all Regions */

%cat_num(Operating_profit,Region)

/*Ho- Operating Profit in all group of Region is normally distributed
H1- Operating Profit in all group of Regions is not normally distributed*/
/*Since P value for all groups of Regions is <0.05. Hense we reject the null hypothesis and conclude that
Operating Profit is not normally distributed in any Region group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Operating Profit and Regions*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Operating Profit in all Regions is not equal*/

/*Proving Operating Profit is not same in all Region Categories */

/*H0= Means of Operating Profit is equal across all Regions
H1- Means of Operating Profit is not equal across all Regions*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Operating Profit is not equal in all Regions */

%cat_num(Units_sold,Region)

/*Ho- Units Sold in all group of Region is normally distributed
H1- Units Sold in all group of Regions is not normally distributed*/
/*Since P value for all groups of Regions is <0.05. Hense we reject the null hypothesis and conclude that
Units Sold is not normally distributed in any Region group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Units Sold and Regions*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Units Sold in all Regions is not equal*/

/*Proving Units Sold is not same in all Region Categories */

/*H0= Means of Units Sold is equal across all Regions
H1- Means of Units Sold is not equal across all Regions*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Units Sold is not equal in all Regions */

%cat_num(Operating_margin,Region)

/*Ho- Operating Margin in all group of Region is normally distributed
H1- Operating Margin in all group of Regions is not normally distributed*/
/*Since P value for all groups of Regions is <0.05. Hense we reject the null hypothesis and conclude that
Operating Margin is not normally distributed in any Region group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Operating Margin and Regions*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Operating Margin in all Regions is not equal*/

/*Proving Operating Margin is not same in all Region Categories */

/*H0= Means of Operating Margin is equal across all Regions
H1- Means of Operating Margin is not equal across all Regions*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Operating Margin is not equal in all Regions */


%cat_num(Price_per_unit,Region)

/*Ho- Price Per Unit in all group of Region is normally distributed
H1- Price Per Unit in all group of Regions is not normally distributed*/
/*Since P value for all groups of Regions is <0.05. Hense we reject the null hypothesis and conclude that
Price Per Unit is not normally distributed in any Region group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Price Per Unit and Regions*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Price Per Unit in all Regions is not equal*/

/*Proving Price Per Unit is not same in all Region Categories */

/*H0= Means of Price Per Unit is equal across all Regions
H1- Means of Price Per Unit is not equal across all Regions*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Price Per Unit is not equal in all Regions */

%cat_num(Total_Sales,Product)

/*Ho- Total Sales in all group of Products is normally distributed
H1- Total Sales in all group of Products is not normally distributed*/
/*Since P value for all groups of Products is <0.05. Hense we reject the null hypothesis and conclude that
Total Sales is not normally distributed in any Product group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Total Sales and Products*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Total Sales in all Products is not equal*/

/*Proving Total Sales is not same in all Product Categories */

/*H0= Means of Total Sales is equal across all Products
H1- Means of Total Sales is not equal across all Products*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Total Sales is not equal in all Products */

%cat_num(Operating_profit,Product)

/*Ho- Operating Profit in all group of Products is normally distributed
H1- Operating Profit in all group of Products is not normally distributed*/
/*Since P value for all groups of Products is <0.05. Hense we reject the null hypothesis and conclude that
Operating Profit is not normally distributed in any Product group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Operating Profit and Products*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Operating Profit in all Products is not equal*/

/*Proving Operating Profit is not same in all Product Categories */

/*H0= Means of Operating Profit is equal across all Products
H1- Means of Operating Profit is not equal across all Products*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Operating Profit is not equal in all Products */

%cat_num(Units_Sold,Product)

/*Ho- Units Sold in all group of Products is normally distributed
H1- Units Sold in all group of Products is not normally distributed*/
/*Since P value for all groups of Products is <0.05. Hense we reject the null hypothesis and conclude that
Units Sold is not normally distributed in any Product group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Units Sold and Products*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Units Sold in all Products is not equal*/

/*Proving Units Sold is not same in all Product Categories */

/*H0= Means of Units Sold is equal across all Products
H1- Means of Units Sold is not equal across all Products*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Units Sold is not equal in all Products */

%cat_num(Operating_margin,Product)

/*Ho- Operating Margin in all group of Products is normally distributed
H1- Operating Margin in all group of Products is not normally distributed*/
/*Since P value for all groups of Products is <0.05. Hense we reject the null hypothesis and conclude that
Operating Margin is not normally distributed in any Product group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Operating Margin and Products*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Operating Margin in all Products is not equal*/

/*Proving Operating Margin is not same in all Product Categories */

/*H0= Means of Operating Margin is equal across all Products
H1- Means of Operating Margin is not equal across all Products*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Operating Margin is not equal in all Products */

%cat_num(Price_Per_Unit,Product)

/*Ho- Price Per Unit in all group of Products is normally distributed
H1- Price Per Unit in all group of Products is not normally distributed*/
/*Since P value for all groups of Products is <0.05. Hense we reject the null hypothesis and conclude that
Price Per Unit is not normally distributed in any Product group
However since the sample quantity in each group is large, by applying Central Limit Theoram we can skip the normality assumption */

/*Equality of variance Price Per Unit and Products*/

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value is < 0.05. we reject null hypothesis and conclude that variance of Price Per Unit in all Products is not equal*/

/*Proving Price Per Unit is not same in all Product Categories */

/*H0= Means of Price Per Unit is equal across all Products
H1- Means of Price Per Unit is not equal across all Products*/

/*Since P value is <0.05 in anova procedure. we reject the Null Hypothesis and conclude that
means of Price Per Unit is not equal in all Products */


/*Distribution of Units_Sold between Profit Class*/
proc means Data=Nandinis.Adidas n nmiss mean;
var Operating_Margin;run;

/*Average  Operating Margin is 42%. So creating a classification variable 'Profit Class'
'Low Profit'= less than or equal to 42% Operating Margin
'High Profit'= More than 42% of Operating Margin */

Data Nandinis.Adidas1;
set Nandinis.Adidas;
length Profit_Class $ 20.;
if Operating_margin <=0.42 then Profit_Class="Low Profit";
else if Operating_margin >0.42 then Profit_Class="High Profit";
run;
proc print Data=Nandinis.Adidas1 (obs=10);run;
Proc Contents Data=Nandinis.Adidas1;run;


proc means Data=Nandinis.Adidas1 n min max std mean cv clm maxdec=2;
class Profit_class/missing;
var Units_sold;
run;

proc univariate Data=Nandinis.Adidas1 normal plot;
var Units_Sold;
Class Profit_Class;
qqplot /normal (mu=est sigma=est);
run;
/*Ho=  Units Sold is normally distributed .
H1- Units Sold is not normally distributed .

Units_Sold in Low Profit Class  -P value<0.05- We reject Null Hypothesis
Units_Sold in Hig Profit Class  -P value<0.05- We reject Null Hypothesis
/*For both status p value <0.05 . so we reject Null Hypotheis of Units Sold  distribution being normal in bth status*/
/*However as per CLT since each group size is >30 we can skip this assumption*/

/*Equality of variance*/
proc glm data=Nandinis.Adidas1;
class Profit_CLass;
model Units_Sold = Profit_Class;
means Profit_Class / hovtest=levene(type=abs) welch;
run;

/*Ho= All groups of Equal variances
H1= All groups do not have equal variances

Since P value 0.0001 is < 0.05. we reject null hypothesis and conclude that variance of Units_Sold in 
both Profit CLass is not equal*/

/*Proving Units Sold is same in both status*/
/*Ho- Mean of Units Sold is same in both Profit Classes
H1- Mean of Units Sold  is not same in both Profit CLasses */
proc ttest Data=Nandinis.Adidas1;
Var Units_Sold;
Class Profit_Class;
run;

/*The folded f value for equality of variance is 0.0001< 0.05, so we conclude that variances are not equeal for both categories of 
Profit CLass
Going further we will refer Sattherthwaite test as the variances are not equal. P value in Sattherthwaite Test 0.0001 is <0.05.
hense
we reject null hypotheis. and conclude mean of Units_SOld  is not same in both categories of Profit Class*/

/*Finally we can say that the Units SOld qty differ among profit classes */


/* Checking Collinearity and Multicollinerity*/

proc reg data=Nandinis.Adidas;
model Total_Sales= operating_profit operating_margin price_per_unit /vif collinoint ;
output out=outstat
p= predicted
r= Residual
stdr=se_resid
rstudent=Rstudent
h=Leverage
cookd=CooksD;
run;
quit;

/*Regression Assumption*/
ods graphics on;
proc pls Data=Nandinis.Adidas plots=all;
class Sales_method retailer product region;
model Total_Sales= Operating_profit operating_margin units_sold price_per_unit sales_method Retailer Product region/solution;
run;
quit;

/*Log transformation of Dependent variable for heteroscdascitiy */
data Nandinis.Adi_trans;
   set Nandinis.Adidas;
   log_sales = log(total_sales); /* Apply log transformation */
run;



proc glm data=Nandinis.Adi_trans;
class Retailer Product Sales_Method REGION;
model Total_Sales = Retailer Product Sales_Method region Price_per_unit Units_sold 
Operating_Profit operating_margin  /solution;
lsmeans sales_method Retailer Region Product/ pdiff stderr cl;
output out=outstat2
p=Predicted
r=Residual
stdr=se_Resid
student=Rstudent
h=Leverage
cookd=CooksD;
run;
quit;


/*Visualising coefficients*/

proc standard data=Nandinis.Adi_Trans out=Nandinis.Adidas_stand mean=0 std=1;
var Units_Sold operating_Profit operating_margin total_sales price_per_unit;
run;

proc glm data=Nandinis.Adidas_stand;
class Retailer Product Sales_Method REGION;
model Total_Sales = Retailer Product Sales_Method region Price_per_unit 
Units_sold Operating_Profit operating_margin  /solution ss3 clparm;
output out=outstat3
p=Predicted
r=Residual
stdr=se_Resid
student=Rstudent
h=Leverage
cookd=CooksD;
ods output ParameterEstimates =Nandinis.Paramest;
run;
quit;

proc sgplot Data=Nandinis.Paramest;
where parameter ne "Intercept";
scatter y=parameter x=estimate /xerrorlower=LowerCl xerrorupper=UpperCl markerattrs=(symbol=diamondfilled);
refline 0/axis=x;
xaxis grid;
yaxis grid;
run;

/*Splitting of Data into Train and Test*/
title;
proc surveyselect Data=Nandinis.Adi_stand rate=0.70 outall out=Nandinis.Adi_result seed=1234;
run;

Data Nandinis.Train Nandinis.Test;
set Nandinis.Adi_result;
if selected =1 then output Nandinis.Train;
else output Nandinis.Test;
run;

proc glmselect Data=Nandinis.Train testdata=Nandinis.Test plots=all;
class Retailer Sales_method Product Region;
model Total_Sales=Operating_profit Operating_margin Units_sold Price_per_unit Retailer Sales_method Region 
Product/selection =lasso(stop=none);
score data=Nandinis.test out=Nandinis.Testpred;
output out =Outputedata p=prob_predicted r=residual;
run;

/*Visualize Prediction by Operating Profit*/

proc means Data=Nandinis.Testpred n min p10 p30 p40 p50 p60 p70 p80 p90 max maxdec=2;
var Operating_profit;
run;

proc rank Data=Nandinis.Testpred out=Nandinis.Testpred_percent groups=10;
var Operating_profit;
ranks rank;
run;

proc summary Data=Nandinis.Testpred_percent;
class rank;
var total_Sales p_total_sales;
output out=Nandinis.pred_op mean=;
quit;

proc sgplot Data=Nandinis.pred_op;
vbar rank /response =_freq_;
vline rank / response =Total_Sales y2axis stat=mean;
vline rank /response=p_Total_Sales y2axis stat=mean;
run;

Proc means Data=Nandinis.pred_op;
class rank;
var total_sales p_total_sales;
run;

/*Visualize Prediction by Units Sold */

proc means Data=Nandinis.Testpred n min p10 p30 p40 p50 p60 p70 p80 p90 max maxdec=2;
var Units_sold;
run;

proc rank Data=Nandinis.Testpred out=Nandinis.Testpred_percent groups=10;
var Units_sold;
ranks rank;
run;

proc summary Data=Nandinis.Testpred_percent;
class rank;
var total_Sales p_total_sales;
output out=Nandinis.pred_us mean=;
quit;

proc sgplot Data=Nandinis.pred_us;
vbar rank /response =_freq_;
vline rank / response =Total_Sales y2axis stat=mean;
vline rank /response=p_Total_Sales y2axis stat=mean;
run;

Proc means Data=Nandinis.pred_us;
class rank;
var total_sales p_total_sales;
run;

/*Visualize Prediction by Oprating Margin*/

proc means Data=Nandinis.Testpred n min p10 p30 p40 p50 p60 p70 p80 p90 max maxdec=2;
var Operating_margin;
run;

proc rank Data=Nandinis.Testpred out=Nandinis.Testpred_percent groups=10;
var Operating_margin;
ranks rank;
run;

proc summary Data=Nandinis.Testpred_percent;
class rank;
var total_Sales p_total_sales;
output out=Nandinis.pred_om mean=;
quit;

proc sgplot Data=Nandinis.pred_om;
vbar rank /response =_freq_;
vline rank / response =Total_Sales y2axis stat=mean;
vline rank /response=p_Total_Sales y2axis stat=mean;
run;

Proc means Data=Nandinis.pred_om;
class rank;
var total_sales p_total_sales;
run;


/*Visualize Prediction by Price_per_unit */

proc means Data=Nandinis.Testpred n min p10 p30 p40 p50 p60 p70 p80 p90 max maxdec=2;
var price_per_unit;
run;

proc rank Data=Nandinis.Testpred out=Nandinis.Testpred_percent groups=10;
var price_per_unit;
ranks rank;
run;

proc summary Data=Nandinis.Testpred_percent;
class rank;
var total_Sales p_total_sales;
output out=Nandinis.pred_ppu mean=;
quit;

proc sgplot Data=Nandinis.pred_ppu;
vbar rank /response =_freq_;
vline rank / response =Total_Sales y2axis stat=mean;
vline rank /response=p_Total_Sales y2axis stat=mean;
run;

Proc means Data=Nandinis.pred_ppu;
class rank;
var total_sales p_total_sales;
run;




