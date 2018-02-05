--Improt Data 
.print ' '
.print 'Importing Data'
--Creating a table to store the CSV
CREATE TABLE "Insurance" (
	policyID INTERGER,
	statecode TEXT,
	county TEXT,
	eq_site_limit INTEGER,
	hu_site_limit INTEGER,
	fl_site_limit INTEGER,
	fr_site_limit INTEGER,
	tiv_2011 INTEGER,
	tiv_2012 REAL,
	eq_site_deductible INTEGER,
	hu_site_deductible REAL,
	fl_site_deductible INTEGER,
	fr_site_deductible INTEGER,
	point_latitude REAL,
	point_longitdue REAL,
	line TEXT,
	construction TEXT,
	point_granularity INTEGER
	);
.separator "," 
--Telling SQL to expect the CSV file 
.mode csv
--Importing the CSV
.import FL_insurance_sample.csv Insurance 


--Printing the 1st 10 rows 
.print ' '
.print 'View frist 10 observations'
SELECT * FROM Insurance LIMIT 10;


--What counties are in the sample 
.print ' ' 
.print 'Counties'
SELECT count(county) from Insurance;

--average property appreciation from 2011 to 2012 
.print ' '
.print 'Mean Appreciation' 
SELECT AVG(tiv_2011) FROM Insurance;
SELECT AVG(tiv_2012) FROM Insurance;
SELECT AVG(tiv_2012-tiv_2011) FROM Insurance;

--Distibution of construction varibale  
SELECT construction, COUNT(*) FROM Insurance GROUP BY construction; 
