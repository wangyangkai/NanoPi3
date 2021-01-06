#ifndef _WYK_PLAT_H
#define _WYK_PLAT_H

struct wyk_led_platform_data {
	int led_nr;
	int *gpio_ctl;
};

#endif
