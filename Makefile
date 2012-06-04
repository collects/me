# -*- makefile -*-
#
# JASSPA MicroEmacs - www.jasspa.com
# linux2.gmk - Make file for Linux v2 using gcc
#
# Copyright (C) 2001-2009 JASSPA (www.jasspa.com)
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 675 Mass Ave, Cambridge, MA 02139, USA.
#
##############################################################################

#
# Installation Directory
INSTDIR	      = /usr/local/bin
INSTPROGFLAGS = -s -o root -g root -m 0775

#
# Local Definitions
CP            = cp
RM            = rm -f
CC            = gcc
LD            = $(CC)
STRIP         =	strip
INSTALL       =	install
CDEBUG        =	-g -Wall
COPTIMISE     =	-O3 -DNDEBUG=1 -Wall -Wno-uninitialized
CDEFS         = -D_LINUX -I. -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 
CONSOLE_DEFS  = -D_ME_CONSOLE
WINDOW_DEFS   = $(MAKEWINDEFS) -D_ME_WINDOW
NANOEMACS_DEFS= -D_NANOEMACS
LDDEBUG       =
LDOPTIMISE    =
LDFLAGS       = 
LIBS          = 
WINDOW_LIBS   = $(MAKEWINLIBS) -L/usr/X11R6/lib -lX11

#
# figure out if termcap is avaiable or if ncurses should be tried
# to accomplish this try to compile test.c and see if it can link
# termcap
test = $(shell echo "\#include <stdio.h>" > _t.c ; echo "main() { printf(\"HW\n\"); }" >> _t.c ; $(LD) $(LDFLAGS) -o /dev/null -lncurses _t.c 2>&1 ; rm -f _t.c)
ifneq "$(strip $(test))" ""
  CONSOLE_LIBS  = -lncurses
else
  CONSOLE_LIBS  = -ltermcap
endif

#
# Rules
.SUFFIXES: .c .ob .on

.c.ob:	
	$(CC) $(COPTIMISE) $(CDEFS) $(MICROEMACS_DEFS) $(CONSOLE_DEFS) $(WINDOW_DEFS) $(MAKECDEFS) -o $@ -c $<

.c.on:
	$(CC) $(COPTIMISE) $(CDEFS) $(NANOEMACS_DEFS) $(CONSOLE_DEFS) $(MAKECDEFS) -o $@ -c $<

#
# Source files
STDHDR	= ebind.h edef.h eextrn.h efunc.h emain.h emode.h eprint.h \
	  esearch.h eskeys.h estruct.h eterm.h evar.h evers.h eopt.h \
	  ebind.def efunc.def eprint.def evar.def etermcap.def emode.def eskeys.def
STDSRC	= abbrev.c basic.c bind.c buffer.c crypt.c dirlist.c display.c \
	  eval.c exec.c file.c fileio.c frame.c hilight.c history.c input.c \
	  isearch.c key.c line.c macro.c main.c narrow.c next.c osd.c \
	  print.c random.c regex.c region.c registry.c search.c spawn.c \
	  spell.c tag.c termio.c time.c undo.c window.c word.c

PLTHDR  = 
PLTSRC  = unixterm.c

HEADERS = $(STDHDR) $(PLTHDR)
SRC     = $(STDSRC) $(PLTSRC)

#
# Object files
OBJ_B    = $(SRC:.c=.ob)
OBJ_N    = $(SRC:.c=.on)

#
# Targets
all: me

clean:
	$(RM) core me ne
	$(RM) *.ob *.on

me:	$(OBJ_B)
	$(RM) $@
	$(LD) $(LDFLAGS) $(LDOPTIMISE) -o $@ $(OBJ_B) $(CONSOLE_LIBS) $(WINDOW_LIBS) $(LIBS)
	$(STRIP) $@

ne:	$(OBJ_N)
	$(RM) $@
	$(LD) $(LDFLAGS) $(LDOPTIMISE) -o $@ $(OBJ_N) $(CONSOLE_LIBS) $(LIBS)
	$(STRIP) $@

#
# Dependancies
$(OBJ_B): $(HEADERS)
$(OBJ_N): $(HEADERS)

