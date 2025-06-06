######################################
# target
######################################
TARGET = firmware


######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -Og


#######################################
# paths
#######################################
# Build path
BUILD_DIR = build

######################################
# source
######################################
C_SOURCES = src/main.c


C_SOURCES += platform/CMSIS/MDR32FxQI/DeviceSupport/K1986VE9xI/startup/system_K1986VE9xI.c
C_SOURCES += platform/SPL/MDR32FxQI/src/MDR32FxQI_rst_clk.c
C_SOURCES += platform/SPL/MDR32FxQI/src/MDR32FxQI_port.c
C_SOURCES += platform/SPL/MDR32FxQI/src/MDR32FxQI_uart.c
C_SOURCES += platform/SPL/MDR32FxQI/src/MDR32FxQI_timer.c

# printf
C_SOURCES += app/retarget/retarget.c
# uCMD
C_SOURCES += $(wildcard app/u_read_line/*.c)
C_SOURCES += $(wildcard app/mem/*.c)
# CoreMark
C_SOURCES += $(wildcard app/coremark/*.c)

ASM_SOURCES = \
platform/CMSIS/MDR32FxQI/DeviceSupport/K1986VE9xI/startup/gcc/startup_K1986VE9xI.S


#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m3

# fpu
# FPU = -mfpu=fpv4-sp-d16
# FPU = -mfpu=fpv4-sp-d16 -u _printf_float

# float-abi
FLOAT-ABI = -mfloat-abi=soft

# mcu
MCU = $(CPU) -mthumb $(FLOAT-ABI)
# MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  \
-DUSE_K1986VE92xI \
-DITERATIONS=4096 \
-DCLOCKS_PER_SEC=1000 \
-DCOREMARK_TIME=millis

# AS includes
AS_INCLUDES = 

# C includes
C_INCLUDES =  \
-Iplatform/CMSIS/MDR32FxQI/CoreSupport/CM3 \
-Iplatform/CMSIS/MDR32FxQI/DeviceSupport/K1986VE9xI/inc \
-Iplatform/CMSIS/MDR32FxQI/DeviceSupport/K1986VE9xI/startup \
-Iplatform/SPL/MDR32FxQI/inc \
-Iplatform/SPL/MDR32FxQI \
-Iapp/retarget/ \
-Iapp/u_read_line \
-Iapp/mem \
-Iapp/micros \
-Iapp/coremark

ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections
CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

# Этот флаг GCC позволяет смотреть .i и .s файлы. 
CFLAGS += -save-temps=obj 

#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = ./platform/ld/K1986VE9xI.ld

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# Функция для создания путей к объектным файлам
define file_paths
$(addprefix $(BUILD_DIR)/obj/,$(addsuffix .o,$(basename $(1))))
endef

C_OBJS = $(call file_paths,$(C_SOURCES))
ASM_OBJS = $(call file_paths,$(ASM_SOURCES))
OBJECTS = $(C_OBJS) $(ASM_OBJS)

# Default target
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

#######################################
# Build rules
#######################################
$(BUILD_DIR)/obj/%.o: %.c Makefile | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/obj/%.o: %.s Makefile | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(AS) -c $(ASFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf
	$(BIN) $< $@

$(BUILD_DIR):
	mkdir $@

#######################################
# Clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)

#######################################
# Dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/obj/*.d)

#######################################
# OpenOCD
#######################################
OPENOCD_PATH = C:/arm_tool/tool-openocd/bin
OPENOCD = $(OPENOCD_PATH)/openocd.exe
OCD_F = -f ./dbg/cmsis-dap.cfg 
OCD_PRE = -c init -c "reset halt" -c "flash probe 0"
OCD_POST = -c "reset run" -c "exit"

program:
	$(OPENOCD) $(OCD_F) $(OCD_PRE) -c "program build/$(TARGET).hex verify" $(OCD_POST)

reset:
	$(OPENOCD) $(OCD_F) $(OCD_PRE) $(OCD_POST)

# *** EOF ***
