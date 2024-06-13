ORG 0000H
		SJMP START        ; Початок програми

ORG 0030H

START:
		MOV SP, #60H      ; Ініціалізація стеку
		MOV R0, #10       ; Приклад: обчислити 10-те число Фібоначі
		LCALL FIB         ; Виклик підпрограми
		SJMP $            ; Безкінечний цикл (зупинка)

; Підпрограма для обчислення n-го числа Фібоначі
FIB:
		MOV A, R0         ; A = n
		CJNE A, #1, FIB2
		MOV A, #1         ; Якщо n = 1, повертаємо 1
		RET
FIB2:
		CJNE A, #2, FIB3
		MOV A, #1         ; Якщо n = 2, повертаємо 1
		RET
FIB3:
		MOV B, #1         ; B = F(n-1) (перший 1)
		MOV A, #1         ; ACC = F(n-2) (другий 1)
		DEC R0            ; R0 = n-1 (зменшуємо лічильник на 1)
		DEC R0            ; R0 = n-2 (зменшуємо лічильник на 1)
FIB_LOOP:
		ADD A, B          ; F(n) = F(n-1) + F(n-2)
		MOV R2, A         ; Збережемо поточне значення F(n) в R2
		MOV A, B          ; A = F(n-1)
		MOV B, R2         ; B = F(n)
		DJNZ R0, FIB_LOOP ; Повторюємо, поки R0 не стане 0
		MOV A, B          ; Результат в ACC
		RET

END