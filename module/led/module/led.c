/*
 * led driver, led.c
 *
 * Author: Yangkai Wang <wang_yangkai@163.com>
 * 2014.12.25
 */

#include <linux/module.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include <linux/cdev.h>
#include <asm/io.h>
#include <linux/gpio.h>
#include <linux/slab.h>
#include <linux/wyk_plat.h>

#include <mach/platform.h>
#include <mach/devices.h>
#include <mach/soc.h>

#include "led.h"

static int debug = 0;
int *p_debug = &debug;
module_param(debug, int, 0644);

static dev_t led_cdev_region;
static struct cdev *led_cdev;

static int led_chip_nr = 0;
struct led_chip_t *led_chip = NULL;

int led_device_open(int id)
{
	int status = 0;

	return status;
}

int led_device_release(int id)
{
	int status = 0;

	return status;
}

static int led_open(struct inode *inode, struct file *file)
{
	int id = MINOR(inode->i_rdev);
	int status = 0;
	struct led_chip_t *chip;
	
	pr_dbg("id:%d", id);

	status = led_device_open(id);
	if (status == 0) {
		file->private_data = (void *)id;
	}

	chip = &led_chip[id];

	return status;
	
}

static int led_release(struct inode *indoe, struct file *file)
{
	int id = (int)file->private_data;
	int status = 0;
	struct led_chip_t *chip;

	pr_dbg("id:%d", id);

	status = led_device_release(id);
	if (status == 0) {
		file->private_data = (void *)id;
	}

	chip = &led_chip[id];

	if (status < 0)
		status = -EIO;
	
	return status;
}

static ssize_t led_write(struct file *file, const char __user *usrbuf, size_t lbuf, loff_t *ppos)
{
	int id = (int)file->private_data;

	pr_dbg("id:%d", id);

	return 0;
}

/*static int led_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)*/
static long led_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	int id = (int)file->private_data;
	int status = 0;
	struct led_chip_t *chip;

	pr_dbg("id:%d", id);

	chip = &led_chip[id];

	pr_dbg("cmd:%u arg:%u", cmd, arg);

	switch (cmd) {
	case 0:
		gpio_set_value(chip->gpio_ctl, 0);
		/*gpio_direction_output(chip->gpio_ctl, 0);*/
		break ;
	case 1:
		gpio_set_value(chip->gpio_ctl, 1);
		/*gpio_direction_output(chip->gpio_ctl, 1);*/
		break ;
	default:
		break ;
	}

	return status;
}

static const struct file_operations led_fops = {
	.owner = THIS_MODULE,
	.open = led_open,
	.release = led_release,
	.write = led_write,
	.unlocked_ioctl = led_ioctl,
};

int led_io_register(void)
{
	int status = 0;

	return status;
}

void led_io_unregister(void)
{

}

int led_io_init(int id, int gpio)
{
	struct led_chip_t *chip;
	int status = -1;
	char str[] = "led00";

	if (id < 0 ||  id >= led_chip_nr) {
		pr_error("id:%d out of range", id);			
	} else {
		chip = &led_chip[id];
		status = 0;

		chip->gpio_ctl = gpio;
		pr_dbg("id:%d, gpio:%d", id, gpio);

		memset(str, sizeof(str), 0);
		sprintf(str, "led%1d", id);
		status = gpio_request(chip->gpio_ctl, str);
		gpio_direction_output(chip->gpio_ctl, 0);
	}
	
	return status;
}

void led_io_exit(int id)
{
	struct led_chip_t *chip;

	chip = &led_chip[id];

	gpio_free(chip->gpio_ctl);
}

static struct class_attribute led_class_attrs[] = {
	__ATTR_NULL,
};

static struct class led_class = {
	.name = LED_NAME,
	.owner = THIS_MODULE,
	.class_attrs = led_class_attrs,
};

static void led_cleanup(void)
{
	int i;

	for (i = 0; i < led_chip_nr; i++) {
		device_destroy(&led_class, MKDEV(MAJOR(led_cdev_region), i));

		led_io_exit(i);
	}

	/*led_io_unregister();*/

	if (led_chip != NULL)
		kfree(led_chip);

	if (led_cdev)
		cdev_del(led_cdev);

	class_unregister(&led_class);

	unregister_chrdev_region(led_cdev_region, led_chip_nr);
}

int led_driver_probe(struct platform_device *pdev)
{
	int status = 0;
	int i;
	struct device *dev;
	struct wyk_led_platform_data *pdata = pdev->dev.platform_data;

	pr_dbg("start");

	if (pdata->led_nr < 1)
		pr_error("pdata->nr");

	led_chip_nr = pdata->led_nr;
	pr_dbg("led_chip_nr:%d", led_chip_nr);

	if (status == 0) {
		status = alloc_chrdev_region(&led_cdev_region, 0, led_chip_nr, LED_NAME);
		if (status < 0)
			pr_error("alloc_chrdev_region");
	}

	if (status == 0) {
		status = class_register(&led_class);
		if (status < 0)
			pr_error("class_register");
	}

	if (status == 0) {
		led_cdev = cdev_alloc();
		if (led_cdev == NULL) {
			pr_error("cdev_alloc");
			status = -1;
		} else {
			cdev_init(led_cdev, &led_fops);
			status = cdev_add(led_cdev, led_cdev_region, led_chip_nr);
			if (status < 0)
				pr_error("cdev_add");
		}
	}

	if (status == 0) {
		/*led_io_register();*/
	}

	led_chip = kzalloc(sizeof(struct led_chip_t) * led_chip_nr, GFP_KERNEL);
	if (led_chip == NULL)
		pr_error("kzalloc");

	for (i = 0; (status ==0) && (i < led_chip_nr); i++) {
		status = led_io_init(i, pdata->gpio_ctl[i]);
		if (status == 0) {
			dev = device_create(&led_class, NULL, MKDEV(MAJOR(led_cdev_region), i), (void*)i, "%s-%d", LED_NAME, i);
			if (dev == NULL) {
				pr_error("device_create id:%d name:%s-%d maj:%d min:%d", i, LED_NAME, i, MAJOR(led_cdev_region), i);
				status = -1;
			} else {
				dev_set_drvdata(dev, (void *)i);
				//status = sysfs_create_group(&dev->kobj, &buzzer_attr_group);
			}
		}

		if (status == 0)
			pr_dbg("id:%d name:%s-%d maj:%d min:%d", i, LED_NAME, i, MAJOR(led_cdev_region), i);
	}

	if (status != 0)
		led_cleanup();

	pr_dbg("done");

	return status;
}

int led_driver_remove(struct platform_device *pdev)
{
	led_cleanup();
	
	return 0;
}

/*const struct platform_device_id led_id_table[] = {
	{"led", 0x00},
};*/

struct platform_driver led_pdrv = {
	.probe = led_driver_probe,
	.remove = led_driver_remove,
	.driver = {
		.name = "wyk_led"
	},
	/*.id_table = led_id_table,*/
};


static int __init led_driver_init(void)
{
	pr_dbg("led platform_driver_register.\n");
	return platform_driver_register(&led_pdrv);
}

static void __exit led_driver_exit(void)
{
	pr_dbg("led platform_driver_unregister.\n");
	return platform_driver_unregister(&led_pdrv);
}

module_init(led_driver_init);
module_exit(led_driver_exit);

MODULE_DESCRIPTION("device driver for led");
MODULE_AUTHOR("Yangkai Wang");
MODULE_LICENSE("GPL");
