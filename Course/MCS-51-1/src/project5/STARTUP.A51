ORG 0x0000
	SJMP MAIN

; Початок програми
MAIN:
	MOV P0, #0xFF   ; встановлюємо порт P0 як вхід для тумблерів
	MOV P2, #0x00   ; встановлюємо порт P2 як вихід для 7-сегментного індикатора
LOOP:
    MOV A, P0       ; зчитуємо значення з тумблерів
    ANL A, #0x0F    ; маскуємо старші 4 біти, залишаючи тільки молодші
    MOVC A, @A+PC   ; використовуємо значення як індекс для таблиці
    MOV P2, A       ; відправляємо значення на 7-сегментний індикатор
    SJMP LOOP       ; повторюємо цикл
    ; Таблиця перетворень для 7-сегментного індикатора
    DB 0x79         ; 3
    DB 0x33         ; 4
    DB 0x6D         ; 5
    DB 0x6F         ; 6
    DB 0x78         ; 7
    DB 0x7F         ; 8
    DB 0x7B         ; 9
    DB 0x7D         ; A
    DB 0x67         ; B
    DB 0x63         ; C
    DB 0x77         ; D
END