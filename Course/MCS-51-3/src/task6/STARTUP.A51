ORG 0000H

; Вектор обробки INT1 переривання
ORG 0013H
INT1_ISR: 
        MOV SBUF, #'N'      ; Надсилаємо 'New Message'
        ACALL WAIT_TX
        MOV SBUF, #'e'
        ACALL WAIT_TX
        MOV SBUF, #'w'
        ACALL WAIT_TX
        MOV SBUF, #' '
        ACALL WAIT_TX
        MOV SBUF, #'M'
        ACALL WAIT_TX
        MOV SBUF, #'e'
        ACALL WAIT_TX
        MOV SBUF, #'s'
        ACALL WAIT_TX
        MOV SBUF, #'s'
        ACALL WAIT_TX
        MOV SBUF, #'a'
        ACALL WAIT_TX
        MOV SBUF, #'g'
        ACALL WAIT_TX
        MOV SBUF, #'e'
        ACALL WAIT_TX
        MOV SBUF, #'!'
        ACALL WAIT_TX
        RETI

; Основна програма
ORG 0030H
START:
        MOV TMOD, #20H       ; Налаштування таймера 1 в режим 2 (8-бітовий автозавантаження)
        MOV TH1, #-3         ; Встановлення значення для отримання 9600 бод (при 11.0592 МГц)
        MOV SCON, #50H       ; Налаштування серійного порту в режим 1, 8-бітове дане, 1 стоп-біт
        SETB TR1             ; Запуск таймера 1
        SETB EX1             ; Дозвіл на переривання від INT1
        SETB EA              ; Дозвіл на глобальні переривання
        ; Виведення першого повідомлення
        MOV SBUF, #'H'       ; Надсилаємо 'Hello World!'
        ACALL WAIT_TX
        MOV SBUF, #'e'
        ACALL WAIT_TX
        MOV SBUF, #'l'
        ACALL WAIT_TX
        MOV SBUF, #'l'
        ACALL WAIT_TX
        MOV SBUF, #'o'
        ACALL WAIT_TX
        MOV SBUF, #' '
        ACALL WAIT_TX
        MOV SBUF, #'W'
        ACALL WAIT_TX
        MOV SBUF, #'o'
        ACALL WAIT_TX
        MOV SBUF, #'r'
        ACALL WAIT_TX
        MOV SBUF, #'l'
        ACALL WAIT_TX
        MOV SBUF, #'d'
        ACALL WAIT_TX
        MOV SBUF, #'!'
        ACALL WAIT_TX
; Цикл
MAIN_LOOP:
        SJMP MAIN_LOOP       ; Основний цикл (очікування переривання)

; Підпрограма очікування завершення передачі
WAIT_TX:
        JNB TI, WAIT_TX      ; Чекаємо, поки прапор TI (Transmit Interrupt) буде встановлений
        CLR TI               ; Очищуємо прапор TI
        RET

; Завершення програми
END