/* Entry Point */
ENTRY(Reset_Handler)

/* Highest address of the user mode stack */
_estack = ORIGIN(RAM) + LENGTH(RAM); /* end of "RAM" Ram type memory */

_Min_Heap_Size = 0x200 ; /* required amount of heap */
_Min_Stack_Size = 0x400 ; /* required amount of stack */

/* Memories definition */
MEMORY
{
  CCMRAM    (xrw)    : ORIGIN = 0x10000000,   LENGTH = 64K /* TCMSRAM */
  RAM    (xrw)    : ORIGIN = 0x20000000,   LENGTH = 192K /* SRAM0 (112 KB) SRAM1 (16 KB) SRAM2 (64 KB) */
  FLASH    (rx)    : ORIGIN = 0x08000000,   LENGTH = 512K /* Code area of flash memory with zero wait time */
}

/* Sections */
SECTIONS
{
  /* The startup code into "FLASH" Rom type memory */
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector)) /* Startup code */
    . = ALIGN(4);
  } >FLASH

  /* The program code and other data into "FLASH" Rom type memory */
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
    _etext = .;        /* define a global symbols at end of code */
  } >FLASH

  /* Constant data into "FLASH" Rom type memory */
  .rodata :
  {
    . = ALIGN(4);
    *(.rodata)         /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
    . = ALIGN(4);
  } >FLASH

  .ARM.extab   : {
    . = ALIGN(4);
    *(.ARM.extab* .gnu.linkonce.armextab.*)
    . = ALIGN(4);
  } >FLASH

  .ARM : {
    . = ALIGN(4);
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
    . = ALIGN(4);
  } >FLASH

  .preinit_array     :
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

  /* CCM-RAM section
  *
  * IMPORTANT NOTE!
  * If initialized variables will be placed in this section,
  * the startup code needs to be modified to copy the init-values.
  */
  .ccmram :
  {
    . = ALIGN(4);
    _sccmram = .;       /* create a global symbol at ccmram start */
    *(.ccmram)
    *(.ccmram*)

    . = ALIGN(4);
    _eccmram = .;       /* create a global symbol at ccmram end */
  } >CCMRAM AT> FLASH

  /* Uninitialized data section into "RAM" Ram type memory */
  . = ALIGN(4);
  .bss :
  {
    /* This is used by the startup in order to initialize the .bss section */
    _sbss = .;         /* define a global symbol at bss start */
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)

    . = ALIGN(4);
    _ebss = .;         /* define a global symbol at bss end */
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
  
  /* User_heap_stack section, used to check that there is enough "RAM" Ram  type memory left */
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
