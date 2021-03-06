##################################
#                                #
#   VMMenu MAKEFILE for all OS   #
#     For use with GNU Make      #
#                                #
#      Chad Gray, July 2020      #
#                                #
##################################
#                                #
# usage:                         #
#                                #
# make target=linux              #
# make target=linuxdvg(default)  #
# make target=Win32              #
# make target=DOS                #
# make target=DOSAud             #
#                                #
##################################

CC = gcc
LINK = gcc
CFLAGS= -W -Wall -O2 -s -g -ggdb3 -Wno-missing-braces
OBJ_DIR =obj

# Set the default target bulld here if not specified
ifndef target
   target=linuxdvg
endif
ifeq ($(target),linux)
   $(info Building for Linux ZVG)
   VPATH=VMMSrc iniparser Linux Linux/zvg VMMSDL
   INC = `sdl2-config --cflags` -I./VMMSrc -I./Linux -I./Linux/zvg -I./iniparser -I./VMMSDL
   LIBS= `sdl2-config --libs` -lSDL2 -lSDL2_mixer -lm
   CFLAGS += -DZEKTORZVG -Wno-missing-field-initializers
   EXEC = vmmenu
   RM = rm -f
   RMDIR = rm -rf
   MKDIR = mkdir -p $(1)
   OBJS = $(OBJ_DIR)/$(EXEC).o \
          $(OBJ_DIR)/zvgFrame.o \
          $(OBJ_DIR)/zvgPort.o \
          $(OBJ_DIR)/timer.o \
          $(OBJ_DIR)/zvgEnc.o \
          $(OBJ_DIR)/zvgError.o \
          $(OBJ_DIR)/zvgBan.o \
          $(OBJ_DIR)/iniparser.o \
          $(OBJ_DIR)/dictionary.o \
          $(OBJ_DIR)/LinuxVMM.o \
          $(OBJ_DIR)/VMM-SDL.o \
          $(OBJ_DIR)/hershey_font.o \
          $(OBJ_DIR)/vmmenu_font.o \
          $(OBJ_DIR)/gamelist.o \
          $(OBJ_DIR)/editlist.o
endif
ifeq ($(target),linuxdvg)
   $(info Building for Linux DVG)
   VPATH=VMMSrc iniparser Linux Win32/dvg VMMSDL
   INC = `sdl2-config --cflags` -I./VMMSrc -I./Linux -I./Win32/dvg -I./iniparser -I./VMMSDL
   LIBS= `sdl2-config --libs` -lSDL2 -lSDL2_mixer -lm
   CFLAGS += -DUSBDVG -Wno-missing-field-initializers
   EXEC = vmmenu
   RM = rm -f
   RMDIR = rm -rf
   MKDIR = mkdir -p $(1)
   OBJS = $(OBJ_DIR)/$(EXEC).o \
          $(OBJ_DIR)/zvgFrame.o \
          $(OBJ_DIR)/timer.o \
          $(OBJ_DIR)/iniparser.o \
          $(OBJ_DIR)/dictionary.o \
          $(OBJ_DIR)/LinuxVMM.o \
          $(OBJ_DIR)/VMM-SDL.o \
          $(OBJ_DIR)/hershey_font.o \
          $(OBJ_DIR)/vmmenu_font.o \
          $(OBJ_DIR)/gamelist.o \
          $(OBJ_DIR)/editlist.o
endif
ifeq ($(target),Win32)
   $(info Building for Win32)
   VPATH=VMMSrc iniparser Win32 Win32/dvg VMMSDL
   INC = -IC:/mingw_dev_lib/include/SDL2 -I./VMMSrc -I./Win32/dvg -I./iniparser -I./Win32 -I./VMMSDL
   LIBS = -LC:\mingw_dev_lib\lib -lmingw32 -lSDL2main -lSDL2 -lSDL2_mixer -lm
   CFLAGS += -DUSBDVG -Wno-missing-field-initializers
   EXEC = vmmenu.exe
   RM = del
   RMDIR = cmd /c rd /s /q
   MKDIR = mkdir $(subst /,\,$(1)) > nul 2>&1 || (exit 0)
   OBJS = $(OBJ_DIR)/vmmenu.o \
	       $(OBJ_DIR)/zvgFrame.o \
	       $(OBJ_DIR)/timer.o \
	       $(OBJ_DIR)/iniparser.o \
	       $(OBJ_DIR)/dictionary.o \
	       $(OBJ_DIR)/WinVMM.o \
	       $(OBJ_DIR)/VMM-SDL.o \
          $(OBJ_DIR)/hershey_font.o \
          $(OBJ_DIR)/vmmenu_font.o \
	       $(OBJ_DIR)/gamelist.o \
          $(OBJ_DIR)/editlist.o
endif
ifeq ($(target),DOSAud)
   $(info Building for DOS with SEAL audio)
   VPATH=VMMSrc iniparser DOS DOS/zvg
   INC = -IC:\djgpp\seal-1.07\src -I./DOS/zvg -I./DOS -I./iniparser -I./VMMSrc
   LIBS = -LC:\djgpp\seal-1.07\lib\DOS -laudio
   CFLAGS += -DZEKTORZVG
   EXEC = svmmenu.exe
   RM = del
   RMDIR = cmd /c rd /s /q
   MKDIR = mkdir -p $(1)
   OBJS = $(OBJ_DIR)/vmmenu.o \
	       $(OBJ_DIR)/zvgFrame.o \
	       $(OBJ_DIR)/zvgPort.o \
	       $(OBJ_DIR)/timer.o \
	       $(OBJ_DIR)/zvgEnc.o \
	       $(OBJ_DIR)/zvgError.o \
	       $(OBJ_DIR)/zvgBan.o \
	       $(OBJ_DIR)/iniparser.o \
	       $(OBJ_DIR)/dictionary.o \
	       $(OBJ_DIR)/DOSvmmSL.o \
          $(OBJ_DIR)/hershey_font.o \
          $(OBJ_DIR)/vmmenu_font.o \
	       $(OBJ_DIR)/gamelist.o \
          $(OBJ_DIR)/editlist.o
endif
ifeq ($(target),DOS)
   $(info Building for DOS)
   VPATH=VMMSrc iniparser DOS DOS/zvg
   INC = -I./DOS/zvg -I./DOS -I./iniparser -I./VMMSrc
   CFLAGS += -DZEKTORZVG
   EXEC = vmmenu.exe
   RM = del
   RMDIR = cmd /c rd /s /q
   MKDIR = mkdir -p $(1)
   OBJS = $(OBJ_DIR)/vmmenu.o \
	       $(OBJ_DIR)/zvgFrame.o \
	       $(OBJ_DIR)/zvgPort.o \
	       $(OBJ_DIR)/timer.o \
	       $(OBJ_DIR)/zvgEnc.o \
	       $(OBJ_DIR)/zvgError.o \
	       $(OBJ_DIR)/zvgBan.o \
	       $(OBJ_DIR)/iniparser.o \
	       $(OBJ_DIR)/dictionary.o \
	       $(OBJ_DIR)/DOSvmm.o \
          $(OBJ_DIR)/hershey_font.o \
          $(OBJ_DIR)/vmmenu_font.o \
	       $(OBJ_DIR)/gamelist.o \
          $(OBJ_DIR)/editlist.o
endif

all: $(EXEC)

# Clean up intermediate files
clean:
	$(RM) $(EXEC)
	$(RMDIR) $(OBJ_DIR)

# install
install:
#	cp $(EXEC) /usr/local/sbin
	chown root $(EXEC)
	chmod u+s $(EXEC)

# Flags for linker
$(EXEC) : $(OBJS)
	$(CC) -o $@ $^ $(LIBS)
	
# Flags for C compiler
$(OBJ_DIR)/%.o: %.c
	@$(call MKDIR,$(@D))
	$(CC) $(CFLAGS) -o $@ -c $< $(INC)
