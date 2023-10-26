#include "bsp_init.h"
#include "dwt_prof.h"
#include "dac.h"


uint16_t adc_val = 0;

uint32_t val = 0;

ERROR_DAC status;
uint32_t time;
int main(void)
{
	DRIVER_Init();

    status = DAC_Init(DAC_CHANNEL_0);
    status = DAC_Init(DAC_CHANNEL_1);

    if(status == DAC_SUCCESS)
    {
    status = DAC_Set(DAC_CHANNEL_0, 5000);
    status = DAC_Set(DAC_CHANNEL_1, 10000);

    }

    while(1)
    {


    }
}
