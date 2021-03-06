#MAKE=/bin/make
MAKEFILE=checkdoc.mk

SYSTEM=SYSV
VERSION=3.3

GROUP=bin
OWNER=bin

BINDIR=/usr/bin
LIBDIR=/usr/lib/dwb
MAN1DIR=/usr/man/u_man/man1

CFLGS=-Wall -Wextra
LDFLGS=-s

CFLAGS=$(CFLGS)
LDFLAGS=$(LDFLGS)

all : checkdoc

install : all 
	cp checkdoc $(BINDIR)/checkdoc
	@chmod 755 $(BINDIR)/checkdoc
	@chgrp $(GROUP) $(BINDIR)/checkdoc
	@chown $(OWNER) $(BINDIR)/checkdoc
	cp checkdoc.1 $(MAN1DIR)/checkdoc.1
	@chmod 644 $(MAN1DIR)/checkdoc.1
	@chgrp $(GROUP) $(MAN1DIR)/checkdoc.1
	@chown $(OWNER) $(MAN1DIR)/checkdoc.1

clean :
	rm -f *.o

clobber : clean
	rm -f checkdoc

checkdoc : checkdoc.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o checkdoc checkdoc.c

changes :
	@trap "" 1 2 3 15; \
	sed \
	    -e "s'^SYSTEM=.*'SYSTEM=$(SYSTEM)'" \
	    -e "s'^VERSION=.*'VERSION=$(VERSION)'" \
	    -e "s'^GROUP=.*'GROUP=$(GROUP)'" \
	    -e "s'^OWNER=.*'OWNER=$(OWNER)'" \
	    -e "s'^BINDIR=.*'BINDIR=$(BINDIR)'" \
	    -e "s'^LIBDIR=.*'LIBDIR=$(LIBDIR)'" \
	    -e "s'^MAN1DIR=.*'MAN1DIR=$(MAN1DIR)'" \
	$(MAKEFILE) >X$(MAKEFILE); \
	mv X$(MAKEFILE) $(MAKEFILE);

