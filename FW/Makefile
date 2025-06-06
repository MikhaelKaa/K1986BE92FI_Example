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
C_SOURCES += src/syscalls.c

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
platform/CMSIS/MDR32FxQI/DeviceSupport/K1986VE9xI/startup/gcc/startup_K1986VE9xI.s


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


# float-abi
FLOAT-ABI = -mfloat-abi=soft

# mcu
MCU = $(CPU) -mthumb  $(FLOAT-ABI)

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

C_INCLUDES += -Iapp/retarget/
C_INCLUDES += -Iapp/u_read_line
C_INCLUDES += -Iapp/mem
C_INCLUDES += -Iapp/micros
C_INCLUDES += -Iapp/coremark

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS += $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

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

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@
	
$(BUILD_DIR):
	mkdir $@

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)

#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)


#######################################
# OpenOCD
#######################################
# TODO: Сделать платформонезависимо.
OPENOCD_PATH =C:/arm_tool/tool-openocd/bin
OPENOCD = $(OPENOCD_PATH)/openocd.exe
OCD_F = -f ./dbg/cmsis-dap.cfg 
OCD_PRE = -c init -c "reset halt" -c "flash probe 0"
OCD_POST = -c "reset run" -c "exit"

program:
	$(OPENOCD) $(OCD_F) $(OCD_PRE) -c "program build/$(TARGET).hex verify" $(OCD_POST)

reset:
	$(OPENOCD) $(OCD_F) $(OCD_PRE) $(OCD_POST)

# *** EOF ***
