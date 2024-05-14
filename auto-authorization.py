from selenium import webdriver
import requests
import time

def check_internet():
    """
    Проверяет наличие интернет соединения
    Пытается получить страницу Google и если невозможно – возвращает False
    """
    try:
        requests.get("http://www.google.com", timeout=5)
        return True
    except requests.ConnectionError:
        return False

driver = webdriver.Firefox(executable_path='/usr/bin/geckodriver')
driver.get("https://ise4.irkutskoil.ru")  # Заменить на нужный URL

# Бесконечный цикл проверки состояния интернет соединения
while True:
    # Интернет работает
    if check_internet():
        print("Интернет соединение установлено")
    # Интернет не работает
    else:
        print("Интернет соединение отсутствует, заполняем поля авторизации...")
        # Селекторы полей для ввода логина и пароля на веб-странице
        try:
            driver.find_element_by_id("").send_keys("732")  # Изменить "ID_поля_логина" на актуальный id элемента
            driver.find_element_by_id("ID_поля_пароля").send_keys("102616")  # Изменить "ID_поля_пароля" на актуальный id элемента
            driver.find_element_by_id("ID_кнопки_входа").click()  # Изменить "ID_кнопки_входа" на актуальный id элемента
        except Exception as e:
            print("Ошибка при заполнении формы:", e)
        break  # Завершаем цикл после выполнения действий без интернета

    time.sleep(10)  # Ожидать 10 секунд перед следующей проверкой


