
#led-objs := led.c

obj-m := led.o

all: modules

modules:
	@$(MAKE) -C $(KROOT) M=$(PWD) modules

clean:
	@$(MAKE) -C $(KROOT) M=$(PWD) clean


