/* Generated Code (IMPORT) */
/* Source File: Retail Analysis_Dataset.xlsx */
/* Source Path: /home/u48510292/RetAnaly */
/* Code generated on: 6/4/20, 12:12 PM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u48510292/RetAnaly/Retail Analysis_Dataset.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;

PROC MEANS DATA=WORK.IMPORT;
RUN;

/* Since it is been observed that the dataset has individual price of product 
   but no record measuring the total sales of each product, a new variable 
   Total_Sales = Sales*Quantity is being created*/
proc sql;
create table Retail_Analysis_Modified as
	select *, Sales*Quantity as Total_Sales from WORK.IMPORT;
	quit;

PROC MEANS data=Retail_Analysis_Modified;
RUN;

/* Checking whether individual variable is significant or linearly related to Total_Sales*/
proc reg data=Retail_Analysis_Modified;
	model Total_Sales = Quantity; /*Checking the suitability of variable quatity*/
	var Total_Sales;
	Run;

proc reg data=Retail_Analysis_Modified;
	model Total_Sales = Profit; /*Checking the suitability of variable Profit*/
	var Total_Sales;
	Run;
	
/*Checking the suitability of variable Shipping_Cost.
  Marketing cost is assumed as Shipping _Cost*/
proc reg data=Retail_Analysis_Modified;
	model Total_Sales = Discount; 
	var Total_Sales;
	Run;

/*Now performing Multivariate Regression Analysis*/
proc reg data=Retail_Analysis_Modified;
	model Total_Sales = Quantity Profit Shipping_Cost;
	var Total_Sales;
	Run;

proc reg data=Retail_Analysis_Modified;
	model Total_Sales = Quantity Profit Discount;
	var Total_Sales;
	Run;

ODS GRAPHICS ON;
 PROC TRANSREG DATA =Retail_Analysis_Modified TEST;
 MODEL BOXCOX(Total_Sales) = IDENTITY(Quantity Profit: );
 RUN;
ODS GRAPHICS OFF;

%web_open_table(WORK.IMPORT);