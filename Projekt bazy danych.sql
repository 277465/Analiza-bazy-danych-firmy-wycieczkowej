CREATE TABLE Kierunki (
    kierunek_id BIGINT PRIMARY KEY AUTO_INCREMENT, -- Unikalny identyfikator kierunku
    nazwa_miejsca VARCHAR(255) NOT NULL,           -- Nazwa miejsca docelowego
    miasto VARCHAR(100) NOT NULL,                 -- Miasto, w którym znajduje się miejsce
    kraj VARCHAR(100) NOT NULL                    -- Kraj, w którym znajduje się miejsce
);
CREATE TABLE KosztyOrganizacji (
    id_kosztu BIGINT PRIMARY KEY AUTO_INCREMENT,                             
    koszt DECIMAL(10, 2) NOT NULL,                         
    typ_kosztu VARCHAR(100),                              
    opis TEXT,                                               
    data_dodania DATE NOT NULL,                              
    FOREIGN KEY (wycieczka_id) REFERENCES RodzajWycieczek(wycieczka_id) 
);
CREATE TABLE Noclegi (
    nocleg_id BIGINT PRIMARY KEY AUTO_INCREMENT,      -- Unikalny identyfikator noclegu
    nazwa VARCHAR(255) NOT NULL,                      -- Nazwa miejsca noclegowego (np. hotel, pensjonat)
    lokalizacja VARCHAR(255) NOT NULL,                -- Lokalizacja (miasto, region)
    koszt DECIMAL(10, 2) NOT NULL,                    -- Koszt noclegu
    liczba_osob INT NOT NULL,                         -- Liczba osób, dla których nocleg jest zarezerwowany
    data_rezerwacji DATE NOT NULL,                    -- Data rezerwacji noclegu
    opis TEXT                                          -- Dodatkowy opis (opcjonalnie, np. szczegóły dotyczące noclegu)
);

CREATE TABLE Bilety (
    bilet_id BIGINT PRIMARY KEY AUTO_INCREMENT,       -- Unikalny identyfikator biletu
    typ_transportu VARCHAR(100) NOT NULL,             -- Typ transportu (np. autobus, pociąg, samolot)
    koszt DECIMAL(10, 2) NOT NULL,                    -- Koszt biletu
    data_zakupu DATE NOT NULL,                        -- Data zakupu biletu
    miejsce_wyjazdu VARCHAR(255) NOT NULL,            -- Miejsce wyjazdu
    miejsce_przyjazdu VARCHAR(255) NOT NULL,          -- Miejsce przyjazdu
    numer_biletu VARCHAR(100) NOT NULL,               -- Numer biletu
    opis TEXT                                          -- Dodatkowy opis (opcjonalnie, np. szczegóły dotyczące podróży)
);

CREATE TABLE KosztyOrganizacji (
    id_kosztu BIGINT PRIMARY KEY AUTO_INCREMENT,              -- Unikalny identyfikator kosztu
    koszt DECIMAL(10, 2) NOT NULL,                            -- Kwota kosztu organizacji
    typ_kosztu VARCHAR(100),                                  -- Typ kosztu (np. transport, zakwaterowanie, itd.)
    opis TEXT,                                                -- Szczegółowy opis kosztu (opcjonalnie)
    data_dodania DATE NOT NULL,                               -- Data dodania kosztu
    bilet_id BIGINT,                                          -- Identyfikator biletu (jeśli koszt dotyczy biletu)
    nocleg_id BIGINT,                                         -- Identyfikator noclegu (jeśli koszt dotyczy noclegu)
    FOREIGN KEY (bilet_id) REFERENCES Bilety(bilet_id),                     -- Klucz obcy do tabeli biletów
    FOREIGN KEY (nocleg_id) REFERENCES Noclegi(nocleg_id)                    -- Klucz obcy do tabeli noclegów
);

CREATE TABLE Wycieczki (
    wycieczka_id BIGINT PRIMARY KEY AUTO_INCREMENT, 
    nazwa VARCHAR(255) NOT NULL,          
    opis TEXT,
    ilosc_dni INT NOT NULL,                             -- Liczba dni trwania wycieczki
    od_ilu_lat INT NOT NULL,                            -- Minimalny wiek uczestników
    max_ilosc_osob INT NOT NULL,                        -- Maksymalna liczba uczestników
    cena DECIMAL(10, 2) NOT NULL,                       -- Cena wycieczki
    typ VARCHAR(100),                            
    kierunek_id BIGINT NOT NULL,          
    FOREIGN KEY (kierunek_id) REFERENCES Kierunki(kierunek_id) 
);
ALTER TABLE Wycieczki
ADD COLUMN wysokie_ryzyko TINYINT(1) NOT NULL DEFAULT 0;

ALTER TABLE Wycieczki 
DROP COLUMN cena;

ALTER TABLE Wycieczki
ADD COLUMN id_kosztu BIGINT,
ADD FOREIGN KEY (id_kosztu) REFERENCES KosztyOrganizacji(id_kosztu);


CREATE TABLE Adres (
    adres_id BIGINT PRIMARY KEY AUTO_INCREMENT, -- Unikalny identyfikator adresu
    ulica VARCHAR(255) NOT NULL,                -- Nazwa ulicy
    numer_domu VARCHAR(50) NOT NULL,            -- Numer domu/lokalu
    miasto VARCHAR(100) NOT NULL,               -- Miasto
    kod_pocztowy VARCHAR(20) NOT NULL,          -- Kod pocztowy
    kraj VARCHAR(100) NOT NULL                  -- Kraj
);

CREATE TABLE Pracownicy (
    pracownik_id BIGINT PRIMARY KEY AUTO_INCREMENT,  -- Unikalny identyfikator pracownika
    imie VARCHAR(50) NOT NULL,                        -- Imię pracownika
    nazwisko VARCHAR(50) NOT NULL,                    -- Nazwisko pracownika
    stanowisko VARCHAR(50) NOT NULL,                  -- Stanowisko pracownika
    data_zatrudnienia DATE NOT NULL,                  -- Data zatrudnienia pracownika        
    telefon VARCHAR(15),                              -- Numer telefonu
    email VARCHAR(100),                               -- Adres e-mail
    adres_id BIGINT,                                  -- Odwołanie do tabeli Adres
    FOREIGN KEY (adres_id) REFERENCES Adres(adres_id) -- Klucz obcy łączący tabelę Pracownicy z Adres
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
    FOREIGN KEY (adres_id) REFERENCES Adres(adres_id) 
);

CREATE TABLE ZrealizowaneWyjazdy (
    id_zrealizowanej_wycieczki BIGINT PRIMARY KEY AUTO_INCREMENT,  -- Unikalny identyfikator zrealizowanej wycieczki
    wycieczka_id BIGINT,
    klient_id BIGINT,
    pracownik_id BIGINT,                                 -- Identyfikator wycieczki z tabeli RodzajWycieczek
    data_wyjazdu DATE NOT NULL,                                   -- Data wyjazdu
    data_powrotu DATE NOT NULL,                                   -- Data powrotu
    liczba_uczestnikow INT NOT NULL,                              -- Liczba uczestników wycieczki
    FOREIGN KEY (wycieczka_id) REFERENCES Wycieczki(wycieczka_id),
    FOREIGN KEY (klient_id) REFERENCES Klienci(klient_id),
    FOREIGN KEY (pracownik_id) REFERENCES Pracownicy(pracownik_id)  
);

CREATE TABLE Zapłata (
    id_zapłaty BIGINT PRIMARY KEY AUTO_INCREMENT,              -- Unikalny identyfikator zapłaty
    id_klienta BIGINT,                                         -- Identyfikator klienta (odwołanie do tabeli Klienci)
    id_zrealizowanej_wycieczki BIGINT,                          -- Identyfikator zrealizowanej wycieczki (odwołanie do tabeli ZrealizowaneWyjazdy)
    kwota DECIMAL(10, 2) NOT NULL,                              -- Kwota zapłaty
    data_przelewu DATE NOT NULL,                                -- Data przelewu
    FOREIGN KEY (id_klienta) REFERENCES Klienci(klient_id),    -- Klucz obcy do tabeli Klienci
    FOREIGN KEY (id_zrealizowanej_wycieczki) REFERENCES ZrealizowaneWyjazdy(id_zrealizowanej_wycieczki) -- Klucz obcy do tabeli ZrealizowaneWyjazdy
);
