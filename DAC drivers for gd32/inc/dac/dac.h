#ifndef DAC_
#define DAC_

#include "stdint.h"
#include "pinmap.h"
#include "gd32f4xx_dac.h"

//������ ���������� ��� ������ ������ ������ ���
#define DAC_CHANNEL_0		0//��������� ����� DAC1
#define DAC_CHANNEL_1		1//��������� ����� DAC2

//���������,  ��� ���������� ����
#define DAC_VAL_CURRENT_GAIN	((float)0.2702F)

//������� ���������� ������� ������ Digital Input.
typedef enum {
	DAC_SUCCESS = 0,				/**< ���������� ������� ��������� �������. */
	DAC_INCORECT_CH,				/**< ����������� ����� ������ ���. */
	DAC_ALREADY_INIT,				/**< ��������� ��� ��� ��������������� �����. */
	DAC_NOT_INIT,					/**< ��������� ��� �� ���������������. */
	DAC_INCORECT_VALUE				/**< ����������� ��������. */
}ERROR_DAC;


//������������� ������ ���.
ERROR_DAC DAC_Init(uint8_t channel);


//��������������� (�����) ������ ���.
ERROR_DAC DAC_DeInit(uint8_t channel);


ERROR_DAC DAC_Set(uint8_t channel, uint16_t value);

ERROR_DAC DAC_Set_Concurent(uint8_t mode, uint16_t value1, uint16_t value2);


#endif /* DAC_ */
