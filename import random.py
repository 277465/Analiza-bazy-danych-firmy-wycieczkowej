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

# Zbiór wykluczanych świąt
EXCLUDED_DATES = {(12, 31), (1, 1), (1, 6), (3, 31), (4, 1), (5, 1), (5, 3), (5, 30), (11, 1), (11, 11), (12, 24), (12, 25), (12, 26)}

def random_start_date_within_last_year():
    """Zwraca losową datę z ostatnich 400 dni."""
    today = datetime.date.today()
    days_ago = random.randint(1, 400)
    return today - datetime.timedelta(days=days_ago)

def get_date_range_excluding_holidays(ilosc_dni, max_attempts=1000):
    """Znajduje zakres dat bez świąt."""
    for _ in range(max_attempts):
        data_wyjazdu = random_start_date_within_last_year()
        data_powrotu = data_wyjazdu + datetime.timedelta(days=ilosc_dni - 1)

        days_range = [data_wyjazdu + datetime.timedelta(days=i) for i in range(ilosc_dni)]
        
        if not any((d.month, d.day) in EXCLUDED_DATES for d in days_range):
            return data_wyjazdu, data_powrotu
    return None

try:
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    # Pobranie wycieczek
    cursor.execute("SELECT wycieczka_id, max_ilosc_osob, ilosc_dni FROM Wycieczki")
    wycieczki = cursor.fetchall()
    
    # Słownik wag wycieczek
    wycieczki_wagi = {
        1: 2.5,
        2: 3.5,
        3: 2.0,
        4: 4.0,
        5: 4.5,
        6: 5.0,
        7: 0.1,
        8: 3.5
    }
    
    for wycieczka_id, _, _ in wycieczki:
        if wycieczka_id not in wycieczki_wagi:
            waga = float(input(f"Podaj wagę dla wycieczki {wycieczka_id}: "))
            wycieczki_wagi[wycieczka_id] = waga

    # Lista ID klientów i pracowników
    klient_ids = list(range(1, 201))
    pracownik_ids = list(range(1, 9))

    trips_to_insert = 200  # Ilość wpisów do dodania

    for i in range(trips_to_insert):
        max_attempts = 50
        inserted = False

        for _ in range(max_attempts):
            wycieczka_id, max_ilosc_osob, ilosc_dni = random.choices(
                wycieczki, 
                weights=[wycieczki_wagi[w_id] for w_id, _, _ in wycieczki]
            )[0]
            
            date_range = get_date_range_excluding_holidays(ilosc_dni)
            if not date_range:
                continue
            
            data_wyjazdu, data_powrotu = date_range
            klient_id = random.choice(klient_ids)
            pracownik_id = random.choice(pracownik_ids)
            liczba_uczestnikow = random.randint(5, max_ilosc_osob)
            
            # Sprawdzamy kolizję terminów
            cursor.execute(
                """
                SELECT COUNT(*) FROM ZrealizowaneWyjazdy
                WHERE klient_id = %s AND NOT (data_powrotu < %s OR data_wyjazdu > %s)
                """, 
                (klient_id, data_wyjazdu, data_powrotu)
            )
            (conflict_count,) = cursor.fetchone()
            
            if conflict_count == 0:
                cursor.execute(
                    """
                    INSERT INTO ZrealizowaneWyjazdy
                    (wycieczka_id, klient_id, pracownik_id, data_wyjazdu, data_powrotu, liczba_uczestnikow)
                    VALUES (%s, %s, %s, %s, %s, %s)
                    """,
                    (wycieczka_id, klient_id, pracownik_id, data_wyjazdu, data_powrotu, liczba_uczestnikow)
                )
                inserted = True
                break

        if not inserted:
            print(f"Nie udało się znaleźć wolnego terminu dla wycieczki nr {i+1}.")

    connection.commit()
    print("Losowe wycieczki (z wagami) zostały dodane do 'ZrealizowaneWyjazdy'!")

except mysql.connector.Error as err:
    print(f"Błąd: {err}")
finally:
    if 'connection' in locals() and connection.is_connected():
        cursor.close()
        connection.close()
        print("Połączenie z bazą zostało zamknięte.")
