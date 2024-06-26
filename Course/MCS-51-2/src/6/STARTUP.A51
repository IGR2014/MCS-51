ORG 0x0000         ; Початок програми

MAIN:
	MOV P1, #0xFF  ; Ініціалізуємо порт P1 як вихідний для підключення тумблерів
	MOV P2, #0x00  ; Ініціалізуємо порт P2 як вихідний для керування LED-дисплеєм
    MOV A, P1      ; Зчитуємо значення з порту P1 (значення тумблерів)
    ANL A, #0x0F   ; Обмежуємо значення до 4 біт
    CJNE A, #0x00, NOT_ZERO  ; Якщо значення не дорівнює 0, переходимо до NOT_ZERO
    SJMP MAIN      ; Якщо значення дорівнює 0, чекаємо на нове введення

NOT_ZERO:
    MOV R1, A      ; Зберігаємо значення тумблерів у регістрі R1
    MOV R2, #0x01  ; Початкове значення для обчислення 2^N (2 в степені N)
    MOV R3, #0x00  ; Лічильник для підрахунку ступеня

LOOP:
    MOV A, R1      ; Завантажуємо значення тумблерів з R1 в A
    ANL A, R2      ; Перевіряємо, чи біт N встановлений у значенні тумблерів
    CJNE A, #0x00, POWER_OF_2  ; Якщо біт N встановлений, переходимо до POWER_OF_2
    INC R3         ; Якщо біт N не встановлений, збільшуємо лічильник
    MOV A, R3      ; Завантажуємо лічильник в A
    CJNE A, #0x04, SHIFT_LEFT  ; Якщо лічильник не дорівнює 4, зсувуємо R2 вліво та повторюємо цикл
    SJMP DONE      ; Якщо лічильник дорівнює 4, завершуємо програму

SHIFT_LEFT:
    MOV A, R2      ; Завантажуємо значення R2 в A
    RL A           ; Здвигаємо вліво (двічі додаємо до себе)
    MOV R2, A      ; Зберігаємо нове значення в R2
    SJMP LOOP      ; Повертаємося до початку циклу

POWER_OF_2:
    MOV P2, R2      ; Виводимо результат на LED-дисплей (або інше пристрій)
    SJMP MAIN       ; Повертаємося до головного циклу

DONE:
    SJMP $          ; Зациклюємо програму

	END             ; Кінець програми