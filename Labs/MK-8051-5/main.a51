; Смещение в памяти - 0H
; Тут лежат векторы прерываний - фактически это адреса по
; которым контроллер перейдёт в случае возникновения прерывания.
; Но начальный адрес 0000H должен перекидывать на основную программу (MAIN)
; чтоб после перезагрузки контроллер снова начинал её выполнять.
ORG	0H
	; Прыжок к основной программе
	AJMP	MAIN

; Таблица векторов прерываний выглядит так:
;
; Номер прерывания	Адрес в памяти	Описание
; 0					0003H			Внешнее прерывание (INT0).
; 1					000BH			Прерывание переполнения таймера/счётчика 0 (T/C0).
; 2					0013H			Внешнее прерывание (INT1).
; 3					001BH			Прерывание переполнения таймера/счётчика 1 (T/C1).
; 4					0023H			Прерывание последовательного порта.
;

; По условию задания используются прерывания INT0 и INT1, поэтому:

; INT0
ORG	3H
	; Переход к обработчику прерывания INT0
	AJMP	EXT_INT_0

; INT1
ORG	13H
	; Переход к обработчику прерывания INT1
	AJMP	EXT_INT_1


; Смещение в памяти - 30H
; Тут начинается область кода основной программы.
ORG	30H

; Основная программа
MAIN:
	; По-умолчанию все прерывания отключены т.к. для них не задано обработчиков.
	; Включаем те, для которых мы задали обработчики - INT0 и INT1.
	; Для этого в регистре IE (Interrupt Enable) ставим 1 в нужных битах.

; Значения битов в регистре IE (Interrupt Enable):
;
; Номер бита	Обозначение	Описание
; 7				EA			Когда 0 - отключены все прерывания независимо от бит ниже. Когда 1 - включены те в которых ниже единица
; 6				-			Не используется. Зарезервировано на будущее.
; 5				-			Не используется. Зарезервировано на будущее.
; 4				ES			Включение/выключение прерывания от последовательного порта.
; 3				ET1			Включение/выключение прерывания переполнения таймера/счётчика 1 (T/C1).
; 2				EX1			Включение/выключение внешнего прерывания (INT1).
; 1				ET0			Включение/выключение прерывания переполнения таймера/счётчика 0 (T/C0).
; 0				EX0			Включение/выключение внешнего прерывания (INT0). 

	; Теперь выставим значения в соответствии с таблицей выше:
	; Бит 0 - включено прерывание INT0.
	; Бит 2 - включено прерывание INT1.
	MOV		IE,		#00000101B
	; Теперь настройка приоритетов прерываний. В условии их придётся менять для тестов.
	; Меняются они в регистре IP (Interrupt Priority).
	; Приоритет может быть:
	; 0 - низкий
	; 1 - высокий

; Значения битов в регистре IP (Interrupt Priority):
;
; Номер бита	Обозначение	Описание
;
; 7				-			Не используется. Зарезервировано на будущее.
; 6				-			Не используется. Зарезервировано на будущее.
; 5				-			Не используется. Зарезервировано на будущее.
; 4				PS			Приоритет прерывания от последовательного порта.
; 3				PT1			Приоритет прерывания переполнения таймера/счётчика 1 (T/C1).
; 2				PX1			Приоритет внешнего прерывания (INT1).
; 1				PT0			Приоритет прерывания переполнения таймера/счётчика 0 (T/C0).
; 0				PX0			Приоритет внешнего прерывания (INT0). 

	; На сейчас ставлю обоим прерываниям высокий приоритет:
	MOV		IP,		#00000101B

	; Настройка регистра TCON (Timer Control Register). В условии ничего не сказано,
	; поэтому взял так-же из примера настройку:
	; Оба прерывания (INT0 и INT1) настроены на работу по срезу
	MOV		TCON,	#101B

	; Счётчики числа перываний. В условии задачи не нашёл какие значения должны быть,
	; поэтому взял значение из примера - 6.
	; R0 - счётчик количества прерываний INT0
	; R1 - счётчик количества прерываний INT1
	MOV		R0,		#6
	MOV		R1,		#6

	; Включаем прерывания (установка 1 в 7-м бите регистра IE)
	SETB	EA

; Теперь начинается цикл формирования импульса. Расчёт взят из примера т.к. в задании не формулы для него
CYCLE:
	; R2 - счётчик цикла. По формуле = t/2.
	; По заданию t = 40, поэтому в регистр R2 записываем 20
	MOV		R2,		#20
	; Генерация сигнала на нулевом бите порта P1
	SETB	P1.0
; Задержка на время t. Реализуется так:
	; Инструкция уменьшает значение в регистре R2 и если там не 0 - перепрыгивает сама на себя
	DJNZ	R2,		$
	; Сброс сигнала на нулевом бите порта P1
	CLR		P1.0
; Задержка на время T - t = 2 * R4 * R3. по заданию значение T = 600.
; Считаем: 600 - 40 = 560 = 2 * R4 * R3. Тогда:
; R4 * R3 = 560 / 20 = 280.
; Нужно выбрать значения R4 и R3 так чтоб получилось 280:
; Пусть будут значения 4 и 70 т.к. 4 * 7 = 28, а 4 * 70 = 280.
	; Предустановка значения R3 - выше мы выбрали 4
	MOV		R3,		#4
; Итак, задержка на время T - t = 2 * R4 * R3.
DELAY:
	; Предустановка значения R4 - выше мы выбрали 70
	MOV		R4,		#70
	; Инструкция уменьшает значение в регистре R4 и если там не 0 - перепрыгивает сама на себя
	DJNZ	R4,		$
		; Инструкция уменьшает значение в регистре R3 и если там не 0 - перепрыгивает на метку DELAY
	DJNZ	R3,		DELAY
	; Возврат в цикл формирования импульса
	AJMP	CYCLE

; Обработчик прерывания INT0
EXT_INT_0:
	; Инструкция уменьшает значение в регистре R0 и если там не 0 - переходит сразу к выходу из обработки прерывания
	DJNZ	R0,		EXIT_0
	; Запрет внешнего прерывания INT0 (иначе если во время обработки прилетит новое - контроллер перезагрузится).
	CLR		ET0
; Сюда перепрыгнет, если в начале обработчика DJNZ получило в регистре R0 значение НЕ 0!
EXIT_0:
	; Выход из обработчика прерывания INT0
	RETI

; Обработчик прерывания INT1
EXT_INT_1:
	; Инструкция уменьшает значение в регистре R1 и если там не 0 - переходит сразу к выходу из обработки прерывания
	DJNZ	R1,		EXIT_1
	; Запрет внешнего прерывания INT1 (иначе если во время обработки прилетит новое - контроллер перезагрузится).
	CLR		ET1
; Сюда перепрыгнет, если в начале обработчика DJNZ получило в регистре R1 значение НЕ 0!
EXIT_1:
	; Выход из обработчика прерывания INT1
	RETI

; Конец кода
END
