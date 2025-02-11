import mysql.connector
import datetime
import random

# Ustawienia połączenia z bazą danych
db_config = {
    'user': 'team11',
    'password': 'te@mzaii',
    'host': 'giniewicz.it',
    'database': 'team11',
    'port': 3306
}

try:
    # Połączenie z bazą danych
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()

    # Zapytanie SQL uwzględniające koszt, liczba uczestników i liczba dni
    select_query = """
        SELECT 
            zw.id_zrealizowanej_wycieczki, 
            zw.klient_id, 
            zw.data_wyjazdu, 
            zw.liczba_uczestnikow, 
            ko.koszt, 
            w.ilosc_dni
        FROM 
            ZrealizowaneWyjazdy AS zw
        JOIN 
            Wycieczki AS w ON zw.wycieczka_id = w.wycieczka_id
        JOIN 
            KosztyOrganizacji AS ko ON w.id_kosztu = ko.id_kosztu
    """
    cursor.execute(select_query)
    zrealizowane_wyjazdy = cursor.fetchall()

       # Ustal minimalną i maksymalną liczbę dni przed wyjazdem dla zapłaty
    minimalne_dni_przed = 7
    maksymalne_dni_przed = 60

    # Iteruj po wynikach i wypełnij tabelę Zapłata
    for id_zrealizowanej_wycieczki, klient_id, data_wyjazdu, liczba_uczestników, koszt, ilosc_dni in zrealizowane_wyjazdy:
               # Losowanie liczby dni przed datą wyjazdu
        losowe_dni_przed = random.randint(minimalne_dni_przed, maksymalne_dni_przed)
        data_przelewu = data_wyjazdu - datetime.timedelta(days=losowe_dni_przed)
        # Kwota: koszt * liczba uczestników 
        kwota = koszt * liczba_uczestników 

        # Wstaw dane do tabeli Zapłata
        insert_query = """
            INSERT INTO `Zapłata` (id_zrealizowanej_wycieczki, id_klienta, kwota, data_przelewu)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(insert_query, (id_zrealizowanej_wycieczki, klient_id, kwota, data_przelewu))

    # Zatwierdź zmiany w bazie danych
    connection.commit()
    print("Dane zostały pomyślnie dodane do tabeli 'Zapłata'.")

except mysql.connector.Error as err:
    print(f"Błąd: {err}")
finally:
    if 'connection' in locals() and connection.is_connected():
        cursor.close()
        connection.close()
        print("Połączenie z bazą zostało zamknięte.")
