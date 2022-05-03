-- ROLLUP
-- Ilosc zarobionych pieniêdzy w róznych miastach, w róznych datach.
SELECT o.nazwa_miasta, a.nazwa, c.data, sum(cena) FROM obszar o, atrakcja a, czas c, "SPRZEDA¯BILETÓW" s
WHERE o.id_obszaru = s.obszar_id_obszaru
AND a.id_atrakcji = s.atrakcja_id_atrakcji
AND c.id_czasu = s.czas_id_czasu
GROUP BY ROLLUP (o.nazwa_miasta, a.nazwa, c.data);

-- Ilosc biletów kupionych na poszczególnych regionach oraz ich suma
SELECT o.nazwa_miasta, a.nazwa, sum(ilosc) FROM Obszar o, "SPRZEDA¯BILETÓW" s, Atrakcja a 
WHERE o.id_obszaru = s.OBSZAR_ID_OBSZARU
AND a.id_atrakcji = s.atrakcja_id_atrakcji
GROUP BY ROLLUP(o.nazwa_miasta, a.nazwa);

-- CUBE
-- Ilosc biletów kupionych na poszczególnych regionach oraz ich suma
SELECT o.nazwa_miasta, a.nazwa, sum(ilosc) FROM Obszar o, "SPRZEDA¯BILETÓW" s, Atrakcja a 
WHERE o.id_obszaru = s.OBSZAR_ID_OBSZARU
AND a.id_atrakcji = s.atrakcja_id_atrakcji
GROUP BY cube(o.nazwa_miasta, a.nazwa);

-- Ilosc zarobionych pieniêdzy w róznych miastach, w róznych datach.
SELECT o.nazwa_miasta, a.nazwa, c.data, sum(cena) FROM obszar o, atrakcja a, czas c, "SPRZEDA¯BILETÓW" s
WHERE o.id_obszaru = s.obszar_id_obszaru
AND a.id_atrakcji = s.atrakcja_id_atrakcji
AND c.id_czasu = s.czas_id_czasu
GROUP BY CUBE(o.nazwa_miasta, a.nazwa, c.data);

-- GROUPING SETS
-- Iloœæ tranzakcji w róznych miastach na atrakcjach uwglêdniajc czy placono karta czy gotowka
SELECT o.nazwa_miasta, a.nazwa, p.nazwa, count(*) FROM obszar o, atrakcja a, platnosc p, "SPRZEDA¯BILETÓW" s
WHERE o.id_obszaru = s.OBSZAR_ID_OBSZARU
AND a.id_atrakcji = s.atrakcja_id_atrakcji
AND p.id_platnosc = s.platnosc_id_platnosc
GROUP BY grouping sets ((o.nazwa_miasta,a.nazwa, p.nazwa), (p.nazwa));

-- Ilosc sprzedanych biletów w danym miescie oraz danej atrakcji 
SELECT o.nazwa_miasta, a.nazwa, sum(ilosc) FROM Obszar o, "SPRZEDA¯BILETÓW" s, Atrakcja a 
WHERE o.id_obszaru = s.OBSZAR_ID_OBSZARU
AND a.id_atrakcji = s.atrakcja_id_atrakcji
GROUP BY grouping sets((o.nazwa_miasta, a.nazwa), (a.nazwa));

-- PARTITION
-- Udzial % w kazdym dniu, miescie oraz atrakcji z ilosci biletow* ceny do calkowitej kwoty 
SELECT a.nazwa, o.nazwa_miasta, c.data, s.cena, sum(s.cena) over (PARTITION BY a.nazwa) sum_kwota, 
    Round(100*s.cena/(sum(s.cena) over (PARTITION BY a.nazwa)),2) "UDZIAL %" 
    FROM "SPRZEDA¯BILETÓW" s, atrakcja a, obszar o, czas c
    WHERE o.id_obszaru = s.OBSZAR_ID_OBSZARU
    AND a.id_atrakcji = s.atrakcja_id_atrakcji
    AND c.id_czasu = s.czas_id_czasu
    ORDER BY a.nazwa, o.nazwa_miasta, c.data;
    
-- Okna ruchome
--Okno, które porusza siê po dacie, nazwie atrakcji oraz cenie.
SELECT c.data, a.nazwa, s.cena, sum(s.cena) over (PARTITION BY c.data ORDER BY a.nazwa
    RANGE BETWEEN unbounded preceding AND CURRENT ROW) AS kwota_sum FROM "SPRZEDA¯BILETÓW" s, czas c, atrakcja a
    WHERE c.id_czasu = s.czas_id_czasu
    AND a.id_atrakcji = s.atrakcja_id_atrakcji
    ORDER BY c.data, a.nazwa; 
