ORG 0000H

START:
	MOV P0, #0FFH           ; Встановлюємо порт P0 як вхідний
	MOV P3, #00H            ; Очищаємо порт P3

	MOV A, P0               ; Завантажуємо значення порту P0 в акумулятор

	MOV C, P0.0             ; Завантажуємо X в прапор carry
	MOV ACC.0, C            ; Зберігаємо X в ACC.0
	MOV C, P0.1             ; Завантажуємо W в прапор carry
	MOV ACC.1, C            ; Зберігаємо W в ACC.1
	MOV C, P0.2             ; Завантажуємо Z в прапор carry
	MOV ACC.2, C            ; Зберігаємо Z в ACC.2

	MOV C, ACC.1            ; Завантажуємо W в прапор carry
	ORL C, ACC.2            ; Виконуємо операцію OR з Z
	ANL C, ACC.0            ; Виконуємо операцію AND з X та результатом (W OR Z)
	MOV ACC.3, C            ; Зберігаємо результат (X AND (W OR Z)) в ACC.3

	CPL ACC.0               ; Інвертуємо X
	MOV C, ACC.0            ; Завантажуємо результат у прапор carry
	ANL C, ACC.1            ; Виконуємо операцію AND з (NOT X) та W

	ORL C, ACC.3            ; Виконуємо операцію OR з (X AND (W OR Z)) та (NOT X) AND W

	MOV P3.5, C             ; Виводимо результат на P3.5

	SJMP START              ; Безкінечний цикл

	END