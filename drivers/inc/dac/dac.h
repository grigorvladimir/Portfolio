#ifndef DAC_
#define DAC_

#include "stdint.h"
#include "pinmap.h"
#include "gd32f4xx_dac.h"

//Список параметров для выбора режима работы ЦАП
#define DAC_CHANNEL_0		0//Генерация через DAC1
#define DAC_CHANNEL_1		1//Генерация через DAC2

//Множитель,  для нахождения тока
#define DAC_VAL_CURRENT_GAIN	((float)0.2702F)

//Статусы выполнения функций модуля Digital Input.
typedef enum {
	DAC_SUCCESS = 0,				/**< Выполнение функции завершено успешно. */
	DAC_INCORECT_CH,				/**< Некоректный режим работы ЦАП. */
	DAC_ALREADY_INIT,				/**< Выбранный ЦАП был инициализирован ранее. */
	DAC_NOT_INIT,					/**< Выбранный ЦАП не инициализирован. */
	DAC_INCORECT_VALUE				/**< Некоректное значение. */
}ERROR_DAC;


//Инициализация модуля ЦАП.
ERROR_DAC DAC_Init(uint8_t channel);


//Деинициализация (сброс) модуля ЦАП.
ERROR_DAC DAC_DeInit(uint8_t channel);


ERROR_DAC DAC_Set(uint8_t channel, uint16_t value);

ERROR_DAC DAC_Set_Concurent(uint8_t mode, uint16_t value1, uint16_t value2);


#endif /* DAC_ */
