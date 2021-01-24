#ifndef _LED_H
#define _LED_H

#include <linux/device.h>
#include <linux/kdev_t.h>

#define LED_NAME "led"

struct led_chip_t {
	int gpio_ctl;
};


#define dbg_printk(level, fmt, arg...) \
	printk(level "%s() %d--->" fmt "\n", __FUNCTION__, __LINE__, ## arg);

#define pr_error(fmt, arg...) \
	dbg_printk(KERN_ERR, fmt, ## arg)

#define pr_wrn(fmt, arg...) \
	dbg_printk(KERN_WARNING, fmt, ## arg)

#define pr_inf(fmt, arg...) \
	dbg_printk(KERN_INFO, fmt, ## arg)

#define pr_dbg(fmt, arg...) \
	do { \
		if (*p_debug > 0) \
			dbg_printk(KERN_INFO, fmt, ## arg); \
	} while (0)

#define pr_nsy(fmt, arg...) \
	do { \
		if (*p_debug > 1) \
			dbg_printk(KERN_DEBUG, fmt, ## arg); \
	} while (0)

extern int *p_debug;


#endif
