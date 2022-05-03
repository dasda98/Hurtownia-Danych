CREATE OR REPLACE VIEW ROLLUP_1 as SELECT o.nazwa_miasta as miasto, a.nazwa as nazwa_atrakcji, c.data as data, sum(cena) as suma FROM obszar o, atrakcja a, czas c, "SPRZEDA¯BILETÓW" s
WHERE o.id_obszaru = s.obszar_id_obszaru
AND a.id_atrakcji = s.atrakcja_id_atrakcji
AND c.id_czasu = s.czas_id_czasu
GROUP BY ROLLUP (o.nazwa_miasta, a.nazwa, c.data);

CREATE OR REPLACE VIEW CUBE_1 as SELECT o.nazwa_miasta as miasto, a.nazwa as nazwa_atrakcji, sum(ilosc) as suma FROM Obszar o, "SPRZEDA¯BILETÓW" s, Atrakcja a 
WHERE o.id_obszaru = s.OBSZAR_ID_OBSZARU
AND a.id_atrakcji = s.atrakcja_id_atrakcji
GROUP BY cube(o.nazwa_miasta, a.nazwa);


CREATE OR REPLACE VIEW GROUPING_1 as SELECT o.nazwa_miasta as miasto, a.nazwa as nazwa_atrakcji, p.nazwa as platnosc, count(*) as ilosc FROM obszar o, atrakcja a, platnosc p, "SPRZEDA¯BILETÓW" s
WHERE o.id_obszaru = s.OBSZAR_ID_OBSZARU
AND a.id_atrakcji = s.atrakcja_id_atrakcji
AND p.id_platnosc = s.platnosc_id_platnosc
GROUP BY grouping sets ((o.nazwa_miasta,a.nazwa, p.nazwa), (p.nazwa));

CREATE OR REPLACE VIEW PARTITION_1 as SELECT a.nazwa as nazwa_atrakcji, o.nazwa_miasta as miasto, c.data as data, 
    s.cena*s.ilosc as zarobki, sum(s.cena*s.ilosc) over (PARTITION BY a.nazwa) sum_kwota, 
    Round(100*s.cena/(sum(s.cena) over (PARTITION BY a.nazwa)),2) "UDZIAL %" 
    FROM "SPRZEDA¯BILETÓW" s, atrakcja a, obszar o, czas c
    WHERE o.id_obszaru = s.OBSZAR_ID_OBSZARU
    AND a.id_atrakcji = s.atrakcja_id_atrakcji
    AND c.id_czasu = s.czas_id_czasu
    ORDER BY a.nazwa, o.nazwa_miasta, c.data;
    
    
CREATE OR REPLACE VIEW WINDOW_1 as SELECT c.data as data, a.nazwa as nazwa_atrakcji, s.cena*s.ilosc as zarobki, sum(s.cena*s.ilosc) over (PARTITION BY c.data ORDER BY a.nazwa
    RANGE BETWEEN unbounded preceding AND CURRENT ROW) AS kwota_sum FROM "SPRZEDA¯BILETÓW" s, czas c, atrakcja a
    WHERE c.id_czasu = s.czas_id_czasu
    AND a.id_atrakcji = s.atrakcja_id_atrakcji
    ORDER BY c.data, a.nazwa; 


