CREATE TABLE Kierunki (
    kierunek_id BIGINT PRIMARY KEY AUTO_INCREMENT, 
    nazwa_miejsca VARCHAR(255) NOT NULL,         
    miasto VARCHAR(100) NOT NULL,               
    kraj VARCHAR(100) NOT NULL
);


CREATE TABLE Noclegi (
    nocleg_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nazwa VARCHAR(255) NOT NULL,
    lokalizacja VARCHAR(255) NOT NULL,
    koszt DECIMAL(10, 2) NOT NULL,
    liczba_osob INT NOT NULL,
);


CREATE TABLE Bilety (
    bilet_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    typ_transportu VARCHAR(100) NOT NULL,
    koszt DECIMAL(10, 2) NOT NULL,
    miejsce_wyjazdu VARCHAR(255) NOT NULL,
    miejsce_przyjazdu VARCHAR(255) NOT NULL,
);


CREATE TABLE KosztyOrganizacji (
    id_kosztu BIGINT PRIMARY KEY AUTO_INCREMENT,
    koszt DECIMAL(10, 2) NOT NULL,
    opis TEXT,
    data_dodania DATE NOT NULL,
    bilet_id BIGINT,
    nocleg_id BIGINT,
    FOREIGN KEY (bilet_id) REFERENCES Bilety(bilet_id),
    FOREIGN KEY (nocleg_id) REFERENCES Noclegi(nocleg_id)
);


CREATE TABLE Wycieczki (
    wycieczka_id BIGINT PRIMARY KEY AUTO_INCREMENT, 
    nazwa VARCHAR(255) NOT NULL,          
    opis TEXT,
    ilosc_dni INT NOT NULL,                         
    od_ilu_lat INT NOT NULL,                          
    max_ilosc_osob INT NOT NULL,                                            
    typ VARCHAR(100),                            
    kierunek_id BIGINT NOT NULL,          
    FOREIGN KEY (kierunek_id) REFERENCES Kierunki(kierunek_id),
    wysokie_ryzyko TINYINT(1) NOT NULL DEFAULT 0,
    id_kosztu BIGINT NOT NULL,          
    FOREIGN KEY (id_kosztu) REFERENCES KosztyOrganizacji(id_kosztu),
    dniowka_pracowników DECIMAL(10,2) NOT NULL
);


CREATE TABLE Adres (
    adres_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ulica VARCHAR(255) NOT NULL,                
    numer_domu VARCHAR(50) NOT NULL,        
    miasto VARCHAR(100) NOT NULL,              
    kod_pocztowy VARCHAR(20) NOT NULL,          
    kraj VARCHAR(100) NOT NULL                 
);

CREATE TABLE Pracownicy (
    pracownik_id BIGINT PRIMARY KEY AUTO_INCREMENT, 
    imie VARCHAR(50) NOT NULL,                    
    nazwisko VARCHAR(50) NOT NULL,                   
    stanowisko VARCHAR(50) NOT NULL,          
    data_zatrudnienia DATE NOT NULL,                      
    telefon VARCHAR(15),                           
    email VARCHAR(100),           
    adres_id BIGINT,                                  
    FOREIGN KEY (adres_id) REFERENCES Adres(adres_id) 
);

CREATE TABLE Klienci (
    klient_id BIGINT PRIMARY KEY AUTO_INCREMENT,  
    imie VARCHAR(50) NOT NULL,                   
    nazwisko VARCHAR(50) NOT NULL,                    
    telefon VARCHAR(15),                              
    email VARCHAR(100),
    kontakt_rodzinny VARCHAR(100),
    kontakt_rodzinny_telefon VARCHAR(15),                          
    adres_id BIGINT,                                  
    FOREIGN KEY (adres_id) REFERENCES Adres(adres_id),
    płeć CHAR(1) NOT NULL,
    wiek INT NOT NULL 
);

CREATE TABLE ZrealizowaneWyjazdy (
    id_zrealizowanej_wycieczki BIGINT PRIMARY KEY AUTO_INCREMENT, 
    wycieczka_id BIGINT,
    klient_id BIGINT,
    pracownik_id BIGINT,                               
    data_wyjazdu DATE NOT NULL,                                
    data_powrotu DATE NOT NULL,                                 
    liczba_uczestnikow INT NOT NULL,                            
    FOREIGN KEY (wycieczka_id) REFERENCES Wycieczki(wycieczka_id),
    FOREIGN KEY (klient_id) REFERENCES Klienci(klient_id),
    FOREIGN KEY (pracownik_id) REFERENCES Pracownicy(pracownik_id)  
);

CREATE TABLE Zapłata (
    id_zapłaty BIGINT PRIMARY KEY AUTO_INCREMENT,           
    id_klienta BIGINT,                                      
    id_zrealizowanej_wycieczki BIGINT,                          
    kwota DECIMAL(10, 2) NOT NULL,                            
    data_przelewu DATE NOT NULL,                               
    FOREIGN KEY (id_klienta) REFERENCES Klienci(klient_id),    
    FOREIGN KEY (id_zrealizowanej_wycieczki) REFERENCES ZrealizowaneWyjazdy(id_zrealizowanej_wycieczki)
);

-- Uzupełnianie bazy danymi 
INSERT INTO Bilety
VALUES
    (1,'Samolot',2000,'2025-01-04', 'Warszawa', 'Warszawa', 1, 'xd');

INSERT INTO Noclegi
VALUES
    (1, 'Tomi Village Hotel', 'Tomi Village', 3000,20,'2025-01-04','xd');

INSERT INTO Kierunki
VALUES
    (1,'Tomi Village, Okinawa','Tomi Village','Japonia');

INSERT INTO KosztyOrganizacji
VALUES
    (1, 5000,'wycieczka', 'xd', '2025-01-04' ,1 ,1);


INSERT INTO Wycieczki
VALUES 
    (1, 'Szkoła ninja', 'To intensywny, pełen emocji i przygody program treningowy, który łączy elementy sztuk walki, wspinaczki, parkouru oraz sprawności fizycznej. Nasz oboz to idealne miejsce, aby poczuć się jak prawdziwy ninja i poznać sekrety, które pozwalają mistrzom na wykonywanie niewiarygodnych akrobacji. Każdego dnia będziesz miał okazję rozwijać swoje umiejętności w bezpiecznym, ale pełnym wyzwań środowisku. To doskonała okazja do aktywnego spędzenia czasu i budowania pewności siebie.',
    14, 7, 20, 'Sportowy', 1, 0, 1);

UPDATE Kierunki
SET miasto = 'Tomi Village';

ALTER TABLE KosztyOrganizacji
DROP COLUMN opis;

ALTER TABLE KosztyOrganizacji
ADD COLUMN opis varchar(100);

UPDATE KosztyOrganizacji
SET opis = 'opis';

UPDATE Bilety
SET miejsce_przyjazdu='Okinawa';

ALTER TABLE KosztyOrganizacji
DROP COLUMN opis;

ALTER TABLE Bilety
DROP COLUMN opis;

ALTER TABLE Noclegi
DROP COLUMN opis;
INSERT INTO Bilety
VALUES
    (2, 'Samolot', 2000, '2024-02-10', 'Warszawa', 'Reykjavik', 2);

INSERT INTO Kierunki
VALUES
    (2, 'Lodowiec Vatnajökull', 'Vatnajökull', 'Islandia');

INSERT INTO Noclegi
VALUES
    (2, 'Lodowcowy Basecamp', 'Vatnajökull', 200, 15, '2024-02-10');

INSERT INTO KosztyOrganizacji
VALUES
    (2, 8000, '2024-02-10', 2, 2);

INSERT INTO Wycieczki
VALUES
    (2, 'Obóz przetrwania na lodowcu Vatnajökull', 
    'Odkryj lodowiec Vatnajökull na Islandii podczas niezapomnianego obozu przetrwania! Nauczysz się technik survivalu w ekstremalnych warunkach: budowy igloo, nawigacji w terenie lodowcowym, posługiwania się rakami i czekanem, a także ratowania z lodowych szczelin. Spędzisz noc na lodowcu w namiotach polarowych, eksplorując jaskinie lodowe i poznając tajemnice arktycznego środowiska. Pod okiem doświadczonych przewodników przeżyjesz przygodę, która sprawdzi Twoją wytrzymałość i zapewni niezapomniane wrażenia. Przygotuj się na wyzwanie życia!', 
    5, 18, 15, 'Przygodowy', 2, 1, 2); 

UPDATE Bilety
SET typ_transportu = 'Samolot, Bus'
WHERE bilet_id = 2;

INSERT INTO Bilety
VALUES
    (3,'Samolot',5000,'2025-01-04','Wrocław','Nikaragua',3);
INSERT INTO Noclegi
VALUES
    (3,'Sohla Rooftop Hostel','Nikaragua',1000,30,'2024-05-03');
UPDATE Bilety
SET data_zakupu = '2024-05-03';
INSERT INTO Kierunki
VALUES
    (3,'Nikaragua','San Juan del Sur','Nikaragua');
INSERT INTO KosztyOrganizacji
VALUES
    (3,6300,'2024-05-03',3,3);--wejscie na wulkan+wynajecie sprzetu 300 zl

INSERT INTO  Wycieczki
VALUES
    (3, 'Ekstremalny zjazd z wulkanu', 'Przeżyj niezapomnianą przygodę zjazdu z wulkanu! Z pomocą doświadczonych przewodników zjedziesz w dół wulkanu na specjalnych deskach, poczujesz adrenalinę i podziwisz spektakularne widoki. To wyjątkowe połączenie ekscytacji, natury i bezpieczeństwa!',10,13,30,'Przygodowy',3,1,3);
INSERT INTO Bilety
VALUES
    (4,'Autobus', 200,'2023-01-11', 'Wrocław', 'Karpacz',4);

INSERT INTO Noclegi
VALUES
    (4,'U Musa','Karpacz',400,50,'2023-01-10');

INSERT INTO Kierunki
VALUES
    (4,'Śnieżka','Karpacz','Polska');

INSERT INTO KosztyOrganizacji
VALUES 
    (4,600,'2023-01-10',4,4);

INSERT INTO Wycieczki
VALUES
    (4,'Wejście na Śnieżke boso','Idealna wycieczka dla osób szukających wyzwań. Na tym wyjeździe udamy się w góry Narodowego Parku Karkonoskiego i podbijemy Śnieżke na boso! Jeśli masz ochotę poczuć zastrzyk adrenaliny i dokonać czegoś niekonwencjonalnego to będzie to idealna wycieczka dla Ciebie!', 3,16,50,'Sportowy',4,1,4);
UPDATE Wycieczki
SET nazwa='Zjazd z wulkanu'
WHERE wycieczka_id=3;
UPDATE Wycieczki
SET opis='Idealna wycieczka dla osób szukających wyzwań. Na tym wyjeździe udamy się w góry Narodowego Parku Karkonoskiego i podbijemy Śnieżkę na boso! Jeśli masz ochotę poczuć zastrzyk adrenaliny i dokonać czegoś niekonwencjonalnego to będzie to idealna wycieczka dla Ciebie!'
WHERE wycieczka_id=4;

INSERT INTO Wycieczki
VALUES 
    (5,'Wyprawa archeologiczna','Wyprawa archeologiczna do Doliny Królów w Egipcie to niezapomniana podróż w serce starożytnego Egiptu, gdzie odkrywa się grobowce faraonów, w tym słynny grobowiec Tutanchamona. Uczestnicy wycieczki mają okazję zwiedzać majestatyczne, wykute w skale komory grobowe, podziwiając wspaniałe malowidła i artefakty, a także uczestniczyć w wykopaliskach archeologicznych i dowiedzieć się o procesach badawczych prowadzonych przez archeologów. To idealna okazja, by zgłębić tajemnice jednej z najstarszych cywilizacji na świecie.',7,6,10,'Przygodowy, Naukowy',5,0,5);

INSERT INTO Bilety
VALUES(
    5,'Samolot',1000,'2022-11-12','Kraków','Luksor',5
);
INSERT INTo Noclegi
VALUES
    (5,'Blue Lotus House','Luksor','700','10','2022-11-12');

INSERT INTO Kierunki
VALUES
    (5,'Dolina Królów','Luksor','Egipt');

INSERT INTO KosztyOrganizacji
VALUES
    (5,1700,'2022-11-12',5,5);

UPDATE Wycieczki
SET nazwa='Obóz przetrwania na lodowcu Vatnajökull'
WHERE wycieczka_id=2;

-- Spływ pontonowy Dunajcem
INSERT INTO Bilety
VALUES
    (6, 'bus', 150, '2023-02-10', 'Wrocław', 'Szczawnica', 6);

INSERT INTO Kierunki
VALUES
    (6, 'Dunajec', 'Szczawnica', 'Polska'); 

INSERT INTO Noclegi
VALUES
    (6, 'Brak', 'Brak', 0, 0, '2023-07-03'); 

INSERT INTO KosztyOrganizacji
VALUES
    (6, 300, '2023-07-03', 6, 6);

INSERT INTO Wycieczki
VALUES
    (6, 'Spływ pontonowy Dunajcem', 
    'Spływ pontonowy Dunajcem to relaksująca przygoda w otoczeniu malowniczych Pienin. Trasa prowadzi przez Pieniński Park Narodowy, oferując widoki na Trzy Korony i Sokolicę. Po spływie (ok. 2–3 godz.) można zjeść regionalny obiad i zwiedzić Szczawnicę lub Krościenko. Idealne połączenie aktywności i wypoczynku w pięknej scenerii.', 
    1, 7, 20, 'Przygodowy', 6, 0, 6);
UPDATE Wycieczki
SET nazwa='Obóz przetrwania na lodowcu Vatnajökull'
WHERE wycieczka_id=2;

ALTER TABLE Bilety
DROP COLUMN numer_biletu;

INSERT into Bilety
VALUES
    (7,'Samolot, Łódź',4495.75,'Warszawa', 'Puerto Vallarta');

UPDATE Bilety
SET miejsce_przyjazdu='Wyspa Marieta'
WHERE bilet_id=7;

ALTER TABLE Noclegi
DROP COLUMN data_rezerwacji;
INSERT INTO Noclegi
VALUES
    (7,'Friendly Fun Vallarta Different Experiences','Puerto Vallarta',3500,8);

INSERT into Kierunki
VALUES
    (7,'Plaża Miłości, wyspa Marieta','Puerto Vallarta','Meksyk')
;

INSERT into KosztyOrganizacji
VALUES
    (7,7995.75,'2025-01-08',7,7);

INSERT INTO Wycieczki
VALUES
    (7,'Podróż na Plażę Miłości', 'Wycieczka na Plażę Miłości w Meksyku to niezapomniana przygoda, która pozwoli Ci odkryć jedno z najpiękniejszych miejsc na świecie, gdzie krystalicznie czysta woda spotyka się z białym piaskiem. Zanurz się w romantycznej atmosferze, korzystając z malowniczych widoków, egzotycznej przyrody i relaksujących aktywności, które sprawią, że poczujesz się jak w raju.',7,18,8,'Rekreacyjny',7,0,7);
-- Dodanie biletu na lot na Karaiby
INSERT INTO Bilety
VALUES
    (8, 'Samolot', 3000,'Warszawa', 'Bahamy');

-- Dodanie kierunku Bahamy
INSERT INTO Kierunki
VALUES
    (8, 'Bahamy - Wyspa Piratów', 'Nassau', 'Bahamy');

-- Dodanie noclegu z pełnym kosztem statku
INSERT INTO Noclegi
VALUES
    (8, 'Piracki Statek Adventure', 'Karaiby - Bahamy', 8500, 25);

-- Dodanie kosztów organizacji
INSERT INTO KosztyOrganizacji
VALUES
    (8, 8000.00, '2024-07-10', 8, 8);

-- Dodanie wycieczki w klimacie pirackim
INSERT INTO Wycieczki
VALUES
    (8, 'Piracka Przygoda na Karaibach', 
    'Tygodniowa przygoda w stylu "Piratów z Karaibów" na Bahamach. Rejs pirackim statkiem, poszukiwanie skarbów, nurkowanie wśród wraków i wieczory przy ognisku. Idealne połączenie tropikalnej przygody i relaksu.', 
    7, 16, 25, 'Przygodowy', 8, 0, 8);
UPDATE KosztyOrganizacji

UPDATE KosztyOrganizacji
SET koszt = 11500
WHERE id_kosztu = 8;

UPDATE KosztyOrganizacji
SET koszt = 150
WHERE id_kosztu = 6;

UPDATE KosztyOrganizacji
SET koszt = 6000
WHERE id_kosztu = 3;

UPDATE KosztyOrganizacji
SET koszt = 2200
WHERE id_kosztu = 2;

UPDATE KosztyOrganizacji
SET koszt = 2200
WHERE id_kosztu = 2;

SET koszt = koszt * 1.1;

ALTER TABLE Wycieczki
ADD dniowka_pracownikow DECIMAL(10, 2);

UPDATE Wycieczki
SET dniowka_pracownikow = CASE 
    WHEN wycieczka_id = 1 THEN 300 -- Szkoła Ninja
    WHEN wycieczka_id = 2 THEN 450 -- Obóz przetrwania na lodowcu
    WHEN wycieczka_id = 3 THEN 340 -- Zjazd z wulkanu
    WHEN wycieczka_id = 4 THEN 300 -- Wejście na ścieżkę boso
    WHEN wycieczka_id = 5 THEN 350 -- Wyprawa archeologiczna
    WHEN wycieczka_id = 6 THEN 300 -- Spływ pontonowy Dunajcem
    WHEN wycieczka_id = 7 THEN 280 -- Podróż na Plażę Miłości
    WHEN wycieczka_id = 8 THEN 420 -- Piracka przygoda na Karaibach
    ELSE NULL -- Na wypadek innych wycieczek
END;
