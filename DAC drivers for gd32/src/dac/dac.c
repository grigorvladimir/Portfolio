#include "dac.h"

#define DAC_NOT_ACTIVATED   	((uint32_t)0U)
#define DAC_ACTIVATED  	  	((uint32_t)1U)

uint32_t DAC_init_st[2];


ERROR_DAC DAC_Init(uint8_t channel)
{
	rcu_periph_clock_enable(RCU_DAC);

	if ((channel != DAC_CHANNEL_0) && (channel != DAC_CHANNEL_1))
		return DAC_INCORECT_CH;

	if(DAC_init_st[channel] == DAC_NOT_ACTIVATED)
	{
		if(channel == DAC_CHANNEL_0)
		{
			gpio_mode_set(MAP_DAC_PORT, GPIO_MODE_ANALOG, GPIO_PUPD_NONE, MAP_DAC_1_PIN);

			dac_trigger_disable(DAC0);
			dac_wave_mode_config(DAC0, DAC_WAVE_DISABLE);
			dac_output_buffer_enable(DAC0);

			dac_enable(DAC0);
			DAC_init_st[channel] = DAC_ACTIVATED;
		}
		else
		{
			gpio_mode_set(MAP_DAC_PORT, GPIO_MODE_ANALOG, GPIO_PUPD_NONE, MAP_DAC_2_PIN);

			dac_trigger_disable(DAC1);
			dac_wave_mode_config(DAC1, DAC_WAVE_DISABLE);
			dac_output_buffer_enable(DAC1);

			dac_enable(DAC1);
			DAC_init_st[channel] = DAC_ACTIVATED;
		}
	}
	else
	{
		return DAC_ALREADY_INIT;
	}

	return DAC_SUCCESS;
}

ERROR_DAC IO_BSP_DAC_DeInit(uint8_t channel)
{
	if ((channel != DAC_CHANNEL_0) && (channel != DAC_CHANNEL_1))
		return DAC_INCORECT_CH;

	if(DAC_init_st[channel] != DAC_NOT_ACTIVATED)
	{
		if(channel == DAC_CHANNEL_0)
		{
			gpio_bit_reset(MAP_DAC_PORT, MAP_DAC_1_PIN);

			dac_output_buffer_disable(DAC0);

			dac_disable(DAC0);
		}

		if(channel ==  DAC_CHANNEL_1)
		{
			gpio_bit_reset(MAP_DAC_PORT, MAP_DAC_2_PIN);

			dac_output_buffer_disable(DAC1);

			dac_disable(DAC1);
		}
	}

	return DAC_SUCCESS;
}

ERROR_DAC DAC_Set(uint8_t channel, uint16_t value)
{
	if ((channel != DAC_CHANNEL_0) && (channel != DAC_CHANNEL_1))
		return DAC_INCORECT_CH;

	if(DAC_init_st[channel] == DAC_ACTIVATED)
	{
		if(value > 10000)
			return DAC_INCORECT_VALUE;


		uint16_t inVal = (uint16_t)( ((float)value) * 0.001 * DAC_VAL_CURRENT_GAIN * 1241.2F );

		if (channel == DAC_CHANNEL_0)
		{
			dac_enable(DAC0);
			dac_data_set(DAC0, DAC_ALIGN_12B_R, inVal);
		}
		if (channel == DAC_CHANNEL_1)
		{
			dac_enable(DAC1);
			dac_data_set(DAC1, DAC_ALIGN_12B_R, inVal);
		}
	}
	else
	{
		return DAC_NOT_INIT;
	}


	return DAC_SUCCESS;
}
