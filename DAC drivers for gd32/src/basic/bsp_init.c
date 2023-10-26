#include "bsp_init.h"

#include "systick.h"
#include "gd32f4xx_rcu.h"

static void DRIVER_RcuBasicInit(void)
{
	/* ��������� �������� ������������ HXTAL */
	RCU_CTL |= RCU_CTL_HXTALEN;

	/* �������� ���������� ��������� �������� ������������ HXTAL */
    while(0U == (RCU_CTL & RCU_CTL_HXTALSTB))
    {
    }

    /* ��������� ���������� ������ Power management unit (����. ��� ����������� �� ��������� �������������) */
    /* ��������� ������������ */
    RCU_APB1EN |= RCU_APB1EN_PMUEN;
    /* ��������� LDO output voltage high mode */
    PMU_CTL |= PMU_CTL_LDOVS;

    RCU_CFG0 |= RCU_AHB_CKSYS_DIV1;
    /* CK_APB1 = CK_AHB / 4 */
    RCU_CFG0 |= RCU_APB1_CKAHB_DIV4;
    /* CK_APB2 = CK_AHB / 2 */
    RCU_CFG0 |= RCU_APB2_CKAHB_DIV2;


    RCU_PLL = (25U | (400 << 6U) | (((2U >> 1U) -1U) << 16U) | (RCU_PLLSRC_HXTAL) | (9U << 24U));

    /* ��������� PLL */
    RCU_CTL |= RCU_CTL_PLLEN;

    /* �������� ���������� ��������� PLL */
    while(0U == (RCU_CTL & RCU_CTL_PLLSTB))
    {
    }

    /* ����� PLL � �������� ��������� ������������ CK_SYS */
    RCU_CFG0 &= ~RCU_CFG0_SCS;
    RCU_CFG0 |= RCU_CKSYSSRC_PLLP;

    /* �������� ���������� ��������� PLL */
    while(0U == (RCU_CFG0 & RCU_SCSS_PLLP))
    {
    }
}

void DRIVER_Init(void)
{
	/* ��������� ������������ */
	DRIVER_RcuBasicInit();

	/* ��������� ������������ GPIO ������ */
	rcu_periph_clock_enable(RCU_GPIOA);
	rcu_periph_clock_enable(RCU_GPIOB);
	rcu_periph_clock_enable(RCU_GPIOC);
	rcu_periph_clock_enable(RCU_GPIOD);
	rcu_periph_clock_enable(RCU_GPIOE);
	rcu_periph_clock_enable(RCU_GPIOF);
	rcu_periph_clock_enable(RCU_GPIOG);
	rcu_periph_clock_enable(RCU_GPIOH);
	rcu_periph_clock_enable(RCU_GPIOI);

	/* ��������� ������������  SYSCFG */
	rcu_periph_clock_enable(RCU_SYSCFG);

    /* ������������� ���������� �������*/
    systick_config();
}
