load data
infile Sprzedaże.csv
into table SprzedażBiletów
fields terminated by ','
(Klient_id_klienta,Obszar_id_obszaru,Czas_id_czasu,Atrakcja_id_atrakcji,ilosc,cena,Platnosc_id_platnosc)