import random
import datetime
import mysql.connector

# Ustawienia połączenia z bazą danych
db_config = {
    'user': 'team11',
    'password': 'te@mzaii',
    'host': 'giniewicz.it',
    'database': 'team11',
    'port': 3306
}

# Święta, w które nie można zaczynać wycieczek
EXCLUDED_DATES = {
    (12, 31), (1, 1), (1, 6), (3, 31), (4, 1), (5, 1), (5, 3), (5, 30),
    (11, 1), (11, 11), (12, 24), (12, 25), (12, 26)
}

def random_start_date_within_last_year():
    """Zwraca losową datę z ostatnich 400 dni."""
    today = datetime.date.today()
    days_ago = random.randint(1, 400)
    return today - datetime.timedelta(days=days_ago)

def get_date_range_excluding_holidays(ilosc_dni, max_attempts=1000):
    """Losuje datę początkową i sprawdza, czy nie zawiera świąt."""
    for _ in range(max_attempts):
        start_date = random_start_date_within_last_year()
        end_date = start_date + datetime.timedelta(days=ilosc_dni - 1)

        # Sprawdzamy, czy którykolwiek dzień podróży przypada na święto
        if any((start_date + datetime.timedelta(days=i)).timetuple()[1:3] in EXCLUDED_DATES for i in range(ilosc_dni)):
            continue  # Jeśli zawiera święto, losujemy ponownie

        return start_date, end_date

    return None  # Nie udało się znaleźć odpowiedniego terminu

try:
    # Połączenie z bazą
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    # Pobieramy dostępne wycieczki
    cursor.execute("SELECT wycieczka_id, max_ilosc_osob, ilosc_dni FROM Wycieczki")
    wycieczki = cursor.fetchall()

    klient_ids = list(range(1, 101))   # klienci 1..100
    pracownik_ids = list(range(1, 9)) # pracownicy 1..8

    trips_to_insert = 300  # Ile wpisów chcemy dodać

    for i in range(trips_to_insert):
        max_attempts = 50
        inserted = False

        for attempt in range(max_attempts):
            # Losowo wybieramy wycieczkę
            wycieczka_id, max_ilosc_osob, ilosc_dni = random.choice(wycieczki)

            # Znajdujemy dostępny termin
            date_range = get_date_range_excluding_holidays(ilosc_dni)
            if not date_range:
                continue  # Spróbuj inną wycieczkę

            data_wyjazdu, data_powrotu = date_range

            # Losowo wybieramy klienta i pracownika
            klient_id = random.choice(klient_ids)
            pracownik_id = random.choice(pracownik_ids)

            # Liczba uczestników [5..max_ilosc_osob]
            liczba_uczestnikow = random.randint(5, max_ilosc_osob)

            # Sprawdzamy kolizję dla klienta i pracownika
            overlap_query = """
                SELECT COUNT(*)
                FROM ZrealizowaneWyjazdy
                WHERE (klient_id = %s OR pracownik_id = %s)
                  AND NOT (data_powrotu < %s OR data_wyjazdu > %s)
            """
            cursor.execute(overlap_query, (klient_id, pracownik_id, data_wyjazdu, data_powrotu))
            (conflict_count,) = cursor.fetchone()

            if conflict_count == 0:
                # Brak kolizji → wstawiamy do bazy
                insert_query = """
                    INSERT INTO ZrealizowaneWyjazdy
                    (wycieczka_id, klient_id, pracownik_id, data_wyjazdu, data_powrotu, liczba_uczestnikow)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """
                cursor.execute(insert_query, (wycieczka_id, klient_id, pracownik_id, 
                                              data_wyjazdu, data_powrotu, liczba_uczestnikow))
                inserted = True
                break  # Udało się dodać wpis, przechodzimy do kolejnej wycieczki

        if not inserted:
            print(f"Nie udało się znaleźć wolnego terminu dla wycieczki nr {i+1}.")

    connection.commit()
    print("300 losowych wycieczek zostało dodanych do tabeli 'ZrealizowaneWyjazdy'!")

except mysql.connector.Error as err:
    print(f"Błąd: {err}")

finally:
    if 'connection' in locals() and connection.is_connected():
        cursor.close()
        connection.close()
        print("Połączenie z bazą zostało zamknięte.")


