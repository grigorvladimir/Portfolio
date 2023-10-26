/* Определение точки входа в программу (первая исполняемая инструкция) */
ENTRY(Reset_Handler)

/* Начало стека */
_estack = ORIGIN(RAM) + LENGTH(RAM); /* Стек растет вниз (full descending) */


/* Размер стека */
_Min_Stack_Size = 0x400;

/* Размер кучи */
_Min_Heap_Size = 0x200;


/* Разлиновка памяти */
MEMORY
{
  RAM    (xrw)    : ORIGIN = 0x20000000,   LENGTH = 192K    /* Области SRAM0(112 KB) SRAM1(16 KB) SRAM2(64 KB) */
  FLASH    (rx)    : ORIGIN = 0x08000000,   LENGTH = 1024K  /* Область Flash памяти с нулевой задержкой доступа (zero-wait state) */
  CCMRAM    (xrw)    : ORIGIN = 0x10000000,   LENGTH = 64K  /* Область TCMSRAM */
}

/* Секции */
SECTIONS
{
  /* Секция содежрщая таблицу векторов из startup_gd32f4xxx.S */
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector)) /*  */
    . = ALIGN(4);
  } >FLASH

  /* Секция исполняемого кода, который хранится в FLASH */
  .text :
  {
    . = ALIGN(4);
    *(.text)           /* .text sections (code) */
    *(.text*)          /* .text* sections (code) */
    *(.glue_7)         /* glue arm to thumb code */
    *(.glue_7t)        /* glue thumb to arm code */
    *(.eh_frame)

    KEEP (*(.init))
    KEEP (*(.fini))

    . = ALIGN(4);
    _etext = .;        /* Глобальный символ содержищий конец секции */
  } >FLASH

  /* Cекция константных данных, которые хранятся в FLASH */
  .rodata :
  {
    . = ALIGN(4);
    *(.rodata)         /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
    . = ALIGN(4);
  } >FLASH

  .ARM.extab : 
  {
    . = ALIGN(4);
    *(.ARM.extab* .gnu.linkonce.armextab.*)
    . = ALIGN(4);
  } >FLASH

  /* section containing information for unwinding the stack */
  .ARM : 
  {
    . = ALIGN(4);
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
    . = ALIGN(4);
  } >FLASH

  .preinit_array :
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
    . = ALIGN(4);
  } >FLASH

  .init_array :
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
    . = ALIGN(4);
  } >FLASH

  .fini_array :
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array*))
    PROVIDE_HIDDEN (__fini_array_end = .);
    . = ALIGN(4);
  } >FLASH

  /* Used by the startup to initialize data */
  _sidata = LOADADDR(.data);

  /* Initialized data sections into "RAM" Ram type memory */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */
    *(.RamFunc)        /* .RamFunc sections */
    *(.RamFunc*)       /* .RamFunc* sections */

    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */

  } >RAM AT> FLASH

  _siccmram = LOADADDR(.ccmram);

  /* Секция данных, которые хранятся в TCMSRAM */
  .ccmram :
  {
    . = ALIGN(4);
    _sccmram = .;       /* Начало секции */
    *(.ccmram)
    *(.ccmram*)

    . = ALIGN(4);
    _eccmram = .;       /* Конец секции */
  } >CCMRAM AT> FLASH

  /* Неинициализированные данные хранящиеся в RAM */
  . = ALIGN(4);
  .bss :
  {
    /* В startup_gd32f4xxx.S данные относящиеся к данной секции инициализируются 0 */
    _sbss = .;         /* Начало bss секции */
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)

    . = ALIGN(4);
    _ebss = .;         /* Конец bss секции */
    __bss_end__ = _ebss;
  } >RAM
  
  /* Секция глобальных данных модуля CAN */
  .can_data :
  {
        . = ALIGN(4);
        __CAN_HGLOBAL_START = .;
        KEEP (*(.can_hdata)) 
        . = ALIGN(4) ;
        __CAN_HGLOBAL_END = .;
        . = ALIGN(4);
        __CAN1_RXBUF_START = .;
        KEEP (*(.can1_rxbuf)) 
        . = ALIGN(4) ;
        __CAN1_RXBUF_END = .;
        . = ALIGN(4);
        __CAN2_RXBUF_START = .;
        KEEP (*(.can2_rxbuf)) 
        . = ALIGN(4) ;
        __CAN2_RXBUF_END = .;
        . = ALIGN(4);
        __CAN1_TXBUF_START = .;
        KEEP (*(.can1_txbuff)) 
        . = ALIGN(4) ;
        __CAN1_TXBUF_END = .;
        . = ALIGN(4);
        __CAN2_TXBUF_START = .;
        KEEP (*(.can2_txbuff)) 
        . = ALIGN(4) ;
        __CAN2_TXBUF_END = .;
  } > RAM
    
  /* Секция глобальных данных модуля MCU2MCU UART*/
  .mcu2mcu_uart_data :
  {
        . = ALIGN(4);
        __MCU2MCU_UART_MASTER_START = .;
        KEEP (*(.mcu2mcu_uart_master_data)) 
        . = ALIGN(4) ;
        __MCU2MCU_UART_MASTER_END = .;
                . = ALIGN(4);
        __MCU2MCU_UART_SLAVE_START = .;
        KEEP (*(.mcu2mcu_uart_slave_data)) 
        . = ALIGN(4) ;
        __MCU2MCU_UART_SLAVE_END = .;
  } > RAM
  
  /* Секция глобальных данных модуля MCU2MCU SPI*/
  .mcu2mcu_spi_data :
  {
        . = ALIGN(4);
        __MCU2MCU_SPI_MASTER_START = .;
        KEEP (*(.mcu2mcu_spi_master_data)) 
        . = ALIGN(4) ;
        __MCU2MCU_SPI_MASTER_END = .;
        . = ALIGN(4);
        __MCU2MCU_SPI_SLAVE_START = .;
        KEEP (*(.mcu2mcu_spi_slave_data)) 
        . = ALIGN(4) ;
        __MCU2MCU_SPI_SLAVE_END = .;
  } > RAM
  
  /* Секция кучи */
  ._user_heap_stack :
  {
    . = ALIGN(8);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } >RAM

  /* Remove information from the compiler libraries */
  /DISCARD/ :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  .ARM.attributes 0 : { *(.ARM.attributes) }
}
