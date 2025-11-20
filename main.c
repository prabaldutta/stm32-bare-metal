#include <stdint.h>

#define RCC_BASE        (0x40021000UL)
#define GPIOA_BASE      (0x50000000UL)

#define RCC_IOPENR      (*(volatile uint32_t *)(RCC_BASE + 0x34))
#define GPIOA_MODER     (*(volatile uint32_t *)(GPIOA_BASE + 0x00))
#define GPIOA_ODR       (*(volatile uint32_t *)(GPIOA_BASE + 0x14))

#define RCC_IOPENR_GPIOAEN (1U << 0)

int main(void)
{
    // Enable GPIOA clock
    RCC_IOPENR |= RCC_IOPENR_GPIOAEN;

    // Configure PA8 and PA12 as outputs
    GPIOA_MODER &= ~((3U << (8 * 2)) | (3U << (12 * 2)));  // clear mode bits
    GPIOA_MODER |=  ((1U << (8 * 2)) | (1U << (12 * 2)));  // set output mode

    // Delay counts (adjust to match real timing):
    const uint32_t delay = 500000;
    
    uint32_t count = 0;

    while (1)
    {
        if (count++ >= delay) {
	    GPIOA_ODR ^= (1U << 8);
	    GPIOA_ODR ^= (1U << 12);
            count = 0;
        }
    }
}
