load data
infile Czas.csv
into table Czas
fields terminated by ','
(id_czasu, 
data "to_date (:data, 'mm/dd/yyyy')"
)