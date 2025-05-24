// K1986BE92FI example
// 19.05.2025
// Михаил Каа

#include <stdio.h>
#include <stdint.h>

#include "retarget.h"
#include "term_gxf.h"

#include "microrl.h"
#include "ucmd.h"
#include "memory_man.h"

#include "MDR32F9Q2I.h"
#include "MDR32FxQI_rst_clk.h"
#include "MDR32FxQI_port.h"

#include "micros.h"

#ifndef VERSION
#define VERSION "Dev build 0.00"
const unsigned char build_version[] = VERSION " " __DATE__ " "__TIME__;
#endif /* VERSION */ 


// define command list
command_t cmd_list[] = {
    {
      .cmd  = "help",
      .help = "print available commands with their help text",
      .fn   = print_help_cb,
    },

    {
      .cmd  = "mem",
      .help = "memory man, use mem help",
      .fn   = ucmd_mem,
    },

    {}, // null list terminator DON'T FORGET THIS!
  };

void delay(uint32_t val) {
    for(uint32_t i = 0; i < val; i++) { __ASM("nop"); }
}


void show_version(void) {

  char l[] = "████████████\000\045\033[H\033[2J\r\n\000\033[0m\r\n";
  printf("%s", &(12*3+1)[l]);
  for(uint8_t i = 0; i < 3; i++, (12*3+1)[l] -= 3) {
    printf("\033[%dm\t\t%s\r\n", (12*3+1)[l], &0[l]);
  }
  printf("%s", &48[l]);

  printf("%s\r\n", build_version);
  set_display_atrib(F_GREEN);
  printf ("MCU UNIQID4: 0x%08lx\r\n", *(uint32_t*)0x08000FF0);
  printf ("MCU UNIQID3: 0x%08lx\r\n", *(uint32_t*)0x08000FE0);
  printf ("MCU UNIQID2: 0x%08lx\r\n", *(uint32_t*)0x08000FD0);
  printf ("MCU UNIQID1: 0x%08lx\r\n", *(uint32_t*)0x08000FC0);
  printf ("MCU UNIQID0: 0x%08lx\r\n", *(uint32_t*)0x08000FB0);
  
  resetcolor();

  printf("System core clock %ld MHz\r\n", SystemCoreClock/1000000);
}

//Функция настройки тактовой частоты МК
void clk_CoreConfig(void)
{
    // Реинициализация настроек тактирования
    RST_CLK_DeInit();

    // Включение тактирования от внешнего источника HSE (High Speed External)
    RST_CLK_HSEconfig(RST_CLK_HSE_ON);

    // Проверка статуса HSE
    if (RST_CLK_HSEstatus() == ERROR) while (1);  	
        
    // Настройка делителя/умножителя частоты CPU_PLL(фазовая подстройка частоты
    RST_CLK_CPU_PLLconfig(RST_CLK_CPU_PLLsrcHSEdiv1, RST_CLK_CPU_PLLmul5);

    // Включение CPU_PLL
    RST_CLK_CPU_PLLcmd(ENABLE);
    
    // Проверка статуса CPU_PLL
    if (RST_CLK_CPU_PLLstatus() == ERROR) while (1);  

    // Коммутация выхода CPU_PLL на вход CPU_C3
    RST_CLK_CPU_PLLuse(ENABLE);

    // Выбор источника тактирования ядра процессора
    RST_CLK_CPUclkSelection(RST_CLK_CPUclkCPU_C3);

    SystemCoreClockUpdate();
}

// Функция инициализации светодиода B7
void led_Init(void)
{
    // Подача тактовой частоты на PORTB
    RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTB, ENABLE);

    // Создание структуры для инициализации порта	
    PORT_InitTypeDef PORT_InitStructure;

    // Настройки порта: вывод, функция ввода/вывода, цифровой режим, максимальная скорость, Pin2
    PORT_InitStructure.PORT_OE      = PORT_OE_OUT;
    PORT_InitStructure.PORT_FUNC    = PORT_FUNC_PORT;
    PORT_InitStructure.PORT_MODE    = PORT_MODE_DIGITAL;
    PORT_InitStructure.PORT_SPEED   = PORT_SPEED_MAXFAST;
    PORT_InitStructure.PORT_Pin     = PORT_Pin_7;	
    
    PORT_Init(MDR_PORTB, &PORT_InitStructure);				
}

int main() {
    clk_CoreConfig();
    led_Init();
    printf_init();
    show_version();
    ucmd_default_init();
    us_timer_init();
    int led_cnt = 0, led_tgl = 0;
    while (1) {
        if(led_cnt++%4096 == 0) {
            PORT_WriteBit(MDR_PORTB, PORT_Pin_7, led_tgl++%2);
            // printf("test micros: %u\r\n", micros());
            printf("test micros: %u\r\n", US_TIMER->CNT);
        }
        ucmd_default_proc();
        printf_flush();
    }
}

