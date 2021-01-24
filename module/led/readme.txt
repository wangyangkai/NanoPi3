/* register platform_device: */
#include <linux/wyk_plat.h>

/*
 * WYK LED
 */
static int led_gpio_ctl[] = {LED_CTL_IO_R, LED_CTL_IO_G, LED_CTL_IO_B};

static struct wyk_led_platform_data wyk_led_pdata = {
	.led_nr = ARRAY_SIZE(led_gpio_ctl),
        .gpio_ctl = led_gpio_ctl,
};

 static struct platform_device wyk_led_plat_device= {
        .name = "wyk_led",
        .id = -1,
        .dev = {
                .platform_data = &wyk_led_pdata,
        },
};

platform_device_register(&wyk_led_plat_device);


/* wyk_plat.h: */
#ifndef _WYK_PLAT_H
#define _WYK_PLAT_H

struct wyk_led_platform_data {
	int led_nr;
	int *gpio_ctl;
};

#endif