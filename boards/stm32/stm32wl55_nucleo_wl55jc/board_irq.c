#include "board_config.h"

void NMI_Handler(void) { printf("%s\r\n", __func__); }
void HardFault_Handler(void) { printf("%s\r\n", __func__); }
void MemManage_Handler(void) { printf("%s\r\n", __func__); }
void BusFault_Handler(void) { printf("%s\r\n", __func__); }
void UsageFault_Handler(void) { printf("%s\r\n", __func__); }
void DebugMon_Handler(void) { printf("%s\r\n", __func__); }

#ifndef CONFIG_BOARD_FREERTOS_ENABLE
void SVC_Handler(void) {}
void PendSV_Handler(void) {}
#endif

#ifdef CONFIG_BOARD_FREERTOS_ENABLE
#include <FreeRTOS.h>
#include <task.h>
#endif
void SysTick_Handler(void)
{
#ifdef CONFIG_BOARD_FREERTOS_ENABLE
    if (xTaskGetSchedulerState() != taskSCHEDULER_NOT_STARTED) {
        xPortSysTickHandler();
    }
#endif
    HAL_IncTick();
}
