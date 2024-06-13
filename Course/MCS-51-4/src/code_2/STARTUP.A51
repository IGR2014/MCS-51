ORG 0000H
	SJMP START              ; Початок програми

ORG 0030H

START:
	MOV P0, #0FFH           ; Встановлюємо порт P0 як вхідний
	MOV P3, #00H            ; Очищаємо порт P3
	; Зчитуємо значення з порту P0
	MOV A, P0               ; Завантажуємо значення порту P0 в акумулятор
	; Маскуємо та зберігаємо значення X, W, Z в окремих бітах
	MOV C, P0.0             ; Завантажуємо X в прапор carry
	MOV ACC.0, C            ; Зберігаємо X в ACC.0
	MOV C, P0.1             ; Завантажуємо W в прапор carry
	MOV ACC.1, C            ; Зберігаємо W в ACC.1
	MOV C, P0.2             ; Завантажуємо Z в прапор carry
	MOV ACC.2, C            ; Зберігаємо Z в ACC.2
	; Обчислення виразу (not Z)
	MOV C, ACC.2            ; Завантажуємо Z в прапор carry
	CPL C                   ; Інвертуємо Z, тепер в C зберігається not Z
	MOV ACC.3, C            ; Зберігаємо not Z в ACC.3
	; Обчислення виразу X and (not Z)
	MOV C, ACC.0            ; Завантажуємо X в прапор carry
	ANL C, ACC.3            ; Виконуємо операцію AND з not Z
	MOV ACC.4, C            ; Зберігаємо X and (not Z) в ACC.4
	; Обчислення виразу (X or Z)
	MOV C, ACC.0            ; Завантажуємо X в прапор carry
	ORL C, ACC.2            ; Виконуємо операцію OR з Z
	MOV ACC.5, C            ; Зберігаємо (X or Z) в ACC.5
	; Обчислення виразу (X and (not Z)) and W
	MOV C, ACC.4            ; Завантажуємо результат (X and (not Z)) в прапор carry
	ANL C, ACC.1            ; Виконуємо операцію AND з W
	MOV ACC.6, C            ; Зберігаємо (X and (not Z) and W) в ACC.6
	; Обчислення виразу (X and (not Z) and W) and (X or Z)
	MOV C, ACC.6            ; Завантажуємо результат (X and (not Z) and W) в прапор carry
	ANL C, ACC.5            ; Виконуємо операцію AND з (X or Z)
	; Виводимо результат на P3.5
	MOV P3.5, C             ; Виводимо результат на P3.5
	SJMP START              ; Безкінечний цикл

END