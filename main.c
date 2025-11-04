#include <stdint.h>

#define RCC_BASE        (0x40021000UL)
#define GPIOA_BASE      (0x50000000UL)

#define RCC_IOPENR      (*(volatile uint32_t *)(RCC_BASE + 0x34))
#define GPIOA_MODER     (*(volatile uint32_t *)(GPIOA_BASE + 0x00))
#define GPIOA_ODR       (*(volatile uint32_t *)(GPIOA_BASE + 0x14))

#define RCC_IOPENR_GPIOAEN (1U << 0)
#define GPIO_MODER_OUTPUT  (1U << 0)

static void delay(volatile uint32_t t)
{
    while (t--) __asm__("nop");
}

int main(void)
{
    RCC_IOPENR |= RCC_IOPENR_GPIOAEN;

    GPIOA_MODER &= ~(3U << 0);
    GPIOA_MODER |= GPIO_MODER_OUTPUT;

    while (1)
    {
        GPIOA_ODR ^= (1U << 0);
        delay(200000);
    }
}
