# SELECT

select * from kino_filmas;
select * from aktoriai;
select * from filmu_apdovanojimai;
select * from kino_filmu_rezisieriai;
select * from kino_filmu_zanrai;
select * from rezisierius;
select * from zanras;
select * from premjera;

# Gauti filmų pavadinimus kartu su jų IMDB vertinimu kaip tekstą:
SELECT CONCAT(pavadinimas,' - IMDB: ',IMDB_vertinimas) AS 'Filmai su įvertinimu' FROM kino_filmas;

#  Rodyti aktorius ir jų amžių:
SELECT CONCAT(vardas,' ',UPPER(pavarde),', amžius ',YEAR(CURDATE()) - YEAR(gimimo_data),' m.') AS 'Aktorius, jo amžius' FROM aktoriai;


# ROUND, SORT, LIMIT, OFFSET

# Apvalinti aktorių gimimo metus iki dešimtmečio tikslumo.
SELECT vardas, pavarde, (ROUND(YEAR(Gimimo_data), - 1)) AS Suapvalinti_metai FROM aktoriai;

# Apvalinti filmų IMDB reitingą iki sveikojo skaičiaus:
SELECT pavadinimas, ROUND(IMDB_vertinimas) AS IMDB_vertinimas FROM kino_filmas
ORDER BY ROUND(IMDB_vertinimas) DESC;

# Kokio senumo filmai?
SELECT pavadinimas, YEAR(CURDATE()) - isleidimo_metai AS 'Filmo amžius' FROM kino_filmas
ORDER BY YEAR(CURDATE()) - isleidimo_metai DESC;

# Kuris filmas yra pats seniausias DB?
SELECT pavadinimas, Isleidimo_metai FROM kino_filmas
ORDER BY Isleidimo_metai ASC
LIMIT 1;

# 3 ilgiausi filmai:
SELECT Pavadinimas, Isleidimo_metai, Filmo_trukme FROM kino_filmas
ORDER BY Filmo_trukme DESC
LIMIT 3;

# 10 filmas sąraše:
SELECT * FROM kino_filmas
LIMIT 1 OFFSET 9;


# WHERE

# Kokie filmai yra sukurti Japonijoje ir Pietų Korėjoje?
SELECT Pavadinimas, Salis FROM kino_filmas
WHERE salis = 'Japonija' OR salis LIKE '%Korėj%';

# Kurie aktoriai yra gimę sausio mėnesį?
SELECT vardas, pavarde, Gimimo_data FROM aktoriai
WHERE gimimo_data LIKE '%-01-%';


# AGREGACIJOS - AVG, MIN, MAX

# Vidutinis filmų amžius:
SELECT ROUND(AVG(YEAR(CURRENT_DATE()) - Isleidimo_metai), 0) AS Vidutinis_filmu_amzius FROM kino_filmas;

# Parodyti kiekvieno filmo IMDB įvertinimą kartu su didžiausiu filmo IMDB įvertinimu.
SELECT pavadinimas, IMDB_vertinimas, max(IMDB_vertinimas) over () as "Didžiausias įvertinimas" FROM kino_filmas;

# Seniausias ir naujausias filmai:
SELECT 
    MIN(isleidimo_metai) AS Seniausias_filmas,
    MAX(isleidimo_metai) AS Naujausias_filmas
FROM kino_filmas;


# SUBQUERIES

# Trumpiausias ir ilgiausias filmai:
SELECT pavadinimas, filmo_trukme FROM kino_filmas
WHERE
    filmo_trukme = (SELECT MIN(Filmo_trukme) FROM kino_filmas) OR
    filmo_trukme = (SELECT MAX(Filmo_trukme) FROM kino_filmas);

# Jauniausias aktorius pagal gimimo metus:
SELECT vardas, pavarde, gimimo_data FROM aktoriai
WHERE YEAR(gimimo_data) = (SELECT MAX(YEAR(gimimo_data)) FROM aktoriai);
    

# GROUP BY

# Kiek filmų buvo išleista kiekvienais metais?
SELECT Isleidimo_metai, COUNT(*) AS 'Filmų kiekis' FROM kino_filmas
GROUP BY Isleidimo_metai
ORDER BY COUNT(*) DESC;

# Kuri šalis surengė daugiausia premjerų?
SELECT Salis, COUNT(idPremjera) as kiek FROM premjera
GROUP BY salis
ORDER BY COUNT(idPremjera) DESC
LIMIT 1;

# Filmai, išleisti po 2000-ųjų:
SELECT pavadinimas, Isleidimo_metai FROM kino_filmas
WHERE isleidimo_metai >= 2000
GROUP BY pavadinimas, Isleidimo_metai
Order BY Isleidimo_metai;


# HAVING

# Kuriose šalyse buvo išleista daugiau nei 10 filmų?
SELECT Salis, COUNT(idKino_filmas) FROM kino_filmas
GROUP BY salis
HAVING COUNT(idKino_filmas) > 10;

# Filmai, kurie turi mažesnį nei 7.0 vertinimą:
SELECT pavadinimas, AVG(IMDB_vertinimas) AS Vidutinis_vertinimas FROM kino_filmas
GROUP BY pavadinimas
HAVING Vidutinis_vertinimas < 7;


# IF

# Parodyti filmų pavadinimus ir nurodyti, ar jie išleisti iki 1950 m., ar nuo 1950 m.
SELECT pavadinimas, Isleidimo_metai, IF(isleidimo_metai <= 1950, 'Išleisti iki 1950 m.', 'Išleisti po 1950 m.') AS Kategorija FROM kino_filmas
ORDER BY Isleidimo_metai;

# Parodyti filmų pavadinimus ir nurodyti, ar jų IMDB reitingas yra aukštesnis nei 7 (jei taip – „Geras“, jei ne – „Blogas“).
SELECT pavadinimas, IMDB_vertinimas, IF(IMDB_vertinimas >= 7, "Geras", 'Blogas') AS Įvertinimas FROM kino_filmas
ORDER BY IMDB_vertinimas;


# CASE

# Aktorių amžiaus grupės:
SELECT vardas, pavarde, YEAR(gimimo_data),
    CASE
        WHEN YEAR(gimimo_data) < 1975 THEN 'Vyresnis nei 50 m.'
        WHEN YEAR(gimimo_data) BETWEEN 1975 AND 1990 THEN 'Vidutinio amžiaus'
        ELSE 'Jaunas aktorius'
    END AS 'Amžiaus grupė'
FROM aktoriai;

# Filmų kiekis pagal IMDB vertinimo kategorijas (gera >= 8, vidutinė>= 6, prasta):
SELECT CASE
        WHEN IMDB_vertinimas >= 8 THEN 'Geras'
        WHEN IMDB_vertinimas >= 6 THEN 'Vidutinis'
        ELSE 'Prastas'
    END AS kategorija,
    COUNT(*) AS kiek
FROM kino_filmas
GROUP BY kategorija;


# JOINS:

# Kiek filmų yra susiję su fantastinių filmų kategorija?
SELECT COUNT(kino_filmas.idKino_filmas) FROM kino_filmas
JOIN kino_filmu_zanrai ON idKino_filmas = Kino_filmas_id
JOIN zanras ON Zanras_id = idZanras
WHERE zanras.Pavadinimas LIKE '%fantas%';

# Kuriuose filmuose vaidino aktoriai, gimę iki 1950 m.?
SELECT kino_filmas.Pavadinimas, aktoriai.Vardas, aktoriai.Pavarde, YEAR(aktoriai.Gimimo_data) as Gimimo_metai FROM kino_filmas
LEFT JOIN aktoriai ON aktoriai.Kino_filmas_id = kino_filmas.idKino_filmas
WHERE YEAR(aktoriai.Gimimo_data) < 1950;

# Kurie filmai buvo pristatyti San Francisco mieste?
SELECT kino_filmas.Pavadinimas, premjera.Premjeros_data FROM kino_filmas
RIGHT JOIN premjera ON idPremjera = Premjera_id
WHERE miestas = 'San francisco';


# JOINS IR GROUP BY

# Filmų kiekis pagal žanrus:
SELECT z.pavadinimas, COUNT(*) AS 'Filmų kiekis' FROM kino_filmas AS k
JOIN kino_filmu_zanrai ON idKino_filmas = Kino_filmas_id
JOIN zanras AS z ON Zanras_id = idZanras
GROUP BY z.pavadinimas
ORDER BY COUNT(*) DESC;

# Kuris filmas gavo daugiausiai apdovanojimų?
SELECT kino_filmas.Pavadinimas, COUNT(filmu_apdovanojimai.idFilmu_apdovanojimai) AS 'Apdovanojimų skaičius' FROM kino_filmas
JOIN filmu_apdovanojimai ON filmu_apdovanojimai.Kino_filmas_id = kino_filmas.idKino_filmas
GROUP BY kino_filmas.Pavadinimas
ORDER BY COUNT(filmu_apdovanojimai.idFilmu_apdovanojimai) DESC
LIMIT 1;

# Kuriose šalyse buvo apdovanota daugiau nei 10 filmų?
SELECT kino_filmas.salis, COUNT(filmu_apdovanojimai.idFilmu_apdovanojimai) AS 'Apdovanojimų skaičius' FROM kino_filmas
LEFT JOIN filmu_apdovanojimai ON filmu_apdovanojimai.idFilmu_apdovanojimai = kino_filmas.idKino_filmas
GROUP BY kino_filmas.salis
HAVING COUNT(filmu_apdovanojimai.idFilmu_apdovanojimai) > 10;

# Kurie filmai buvo režisuoti daugiau nei vieno režisieriaus?
SELECT kino_filmas.Pavadinimas, COUNT(rezisierius.idRezsierius) as "Režisierių sk." FROM kino_filmas
JOIN kino_filmu_rezisieriai ON idKino_filmas = Kino_filmas_id
JOIN rezisierius ON Rezisierius_id = idRezsierius
GROUP BY kino_filmas.Pavadinimas
HAVING COUNT(rezisierius.idRezsierius) > 1;