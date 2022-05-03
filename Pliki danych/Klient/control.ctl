load data
infile Klienci.csv
into table Klient
fields terminated by ','
(id_klienta, imie, nazwisko, wiek, plec, wzrost)