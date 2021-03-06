#MAKE=/bin/make
MAKEFILE=tc.mk

SYSTEM=SYSV
VERSION=3.3

GROUP=bin
OWNER=bin

BINDIR=/usr/bin
MAN1DIR=/usr/man/u_man/man1

CFLGS=-Wall -Wextra
LDFLGS=-s

CFLAGS=$(CFLGS)
LDFLAGS=$(LDFLGS)

OFILES=tc.o\
       draw.o

all : tc

install : all
	cp tc $(BINDIR)/tc
	@chmod 755 $(BINDIR)/tc
	@chgrp $(GROUP) $(BINDIR)/tc
	@chown $(OWNER) $(BINDIR)/tc
	cp tc.1 $(MAN1DIR)/tc.1
	@chmod 644 $(MAN1DIR)/tc.1
	@chgrp $(GROUP) $(MAN1DIR)/tc.1
	@chown $(OWNER) $(MAN1DIR)/tc.1

clean :
	rm -f *.o

clobber : clean
	rm -f tc

tc : $(OFILES)
	$(CC) $(CFLAGS) $(LDFLAGS) -o tc $(OFILES) -lm

tc.o : dev.h

changes :
	@trap "" 1 2 3 15; \
	sed \
	    -e "s'^SYSTEM=.*'SYSTEM=$(SYSTEM)'" \
	    -e "s'^VERSION=.*'VERSION=$(VERSION)'" \
	    -e "s'^GROUP=.*'GROUP=$(GROUP)'" \
	    -e "s'^OWNER=.*'OWNER=$(OWNER)'" \
	    -e "s'^BINDIR=.*'BINDIR=$(BINDIR)'" \
	    -e "s'^MAN1DIR=.*'MAN1DIR=$(MAN1DIR)'" \
	$(MAKEFILE) >X$(MAKEFILE); \
	mv X$(MAKEFILE) $(MAKEFILE)

