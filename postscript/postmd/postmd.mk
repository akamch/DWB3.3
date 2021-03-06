#MAKE=/bin/make
MAKEFILE=postmd.mk

SYSTEM=SYSV
VERSION=3.3

GROUP=bin
OWNER=bin

MAN1DIR=/usr/man/u_man/man1
POSTBIN=/usr/lbin/postscript
POSTLIB=/usr/lib/postscript

COMMONDIR=../common

CFLGS=-Wall -Wextra
LDFLGS=-s

CFLAGS=$(CFLGS) -I$(COMMONDIR)\
    -DPOSTLIB="\"$(POSTLIB)\""
LDFLAGS=$(LDFLGS)

HFILES=postmd.h\
       $(COMMONDIR)/comments.h\
       $(COMMONDIR)/ext.h\
       $(COMMONDIR)/gen.h\
       $(COMMONDIR)/path.h

OFILES=postmd.o\
       $(COMMONDIR)/glob.o\
       $(COMMONDIR)/misc.o\
       $(COMMONDIR)/request.o\
       $(COMMONDIR)/tempnam.o

all : postmd

install : all
	@if [ ! -d "$(POSTBIN)" ]; then \
	    mkdir $(POSTBIN); \
	    chmod 755 $(POSTBIN); \
	    chgrp $(GROUP) $(POSTBIN); \
	    chown $(OWNER) $(POSTBIN); \
	fi
	@if [ ! -d "$(POSTLIB)" ]; then \
	    mkdir $(POSTLIB); \
	    chmod 755 $(POSTLIB); \
	    chgrp $(GROUP) $(POSTLIB); \
	    chown $(OWNER) $(POSTLIB); \
	fi
	cp postmd $(POSTBIN)/postmd
	@chmod 755 $(POSTBIN)/postmd
	@chgrp $(GROUP) $(POSTBIN)/postmd
	@chown $(OWNER) $(POSTBIN)/postmd
	cp postmd.ps $(POSTLIB)/postmd.ps
	@chmod 644 $(POSTLIB)/postmd.ps
	@chgrp $(GROUP) $(POSTLIB)/postmd.ps
	@chown $(OWNER) $(POSTLIB)/postmd.ps
	sed -e 's" /usr/lib/postscript$$" $(POSTLIB)"' \
	    postmd.1 > $(MAN1DIR)/postmd.1
	@chmod 644 $(MAN1DIR)/postmd.1
	@chgrp $(GROUP) $(MAN1DIR)/postmd.1
	@chown $(OWNER) $(MAN1DIR)/postmd.1

clean :
	rm -f *.o

clobber : clean
	rm -f postmd

postmd : $(OFILES)
	$(CC) $(CFLAGS) $(LDFLAGS) -o postmd $(OFILES) -lm

postmd.o : $(HFILES)

$(COMMONDIR)/glob.o\
$(COMMONDIR)/misc.o\
$(COMMONDIR)/request.o\
$(COMMONDIR)/tempnam.o :
	@cd $(COMMONDIR); $(MAKE) -f common.mk SYSTEM=$(SYSTEM) $(@F)

changes :
	@trap "" 1 2 3 15; \
	sed \
	    -e "s'^SYSTEM=.*'SYSTEM=$(SYSTEM)'" \
	    -e "s'^VERSION=.*'VERSION=$(VERSION)'" \
	    -e "s'^GROUP=.*'GROUP=$(GROUP)'" \
	    -e "s'^OWNER=.*'OWNER=$(OWNER)'" \
	    -e "s'^MAN1DIR=.*'MAN1DIR=$(MAN1DIR)'" \
	    -e "s'^POSTBIN=.*'POSTBIN=$(POSTBIN)'" \
	    -e "s'^POSTLIB=.*'POSTLIB=$(POSTLIB)'" \
	$(MAKEFILE) >XXX.mk; \
	mv XXX.mk $(MAKEFILE); \
	sed \
	    -e "s'^.ds dQ.*'.ds dQ $(POSTLIB)'" \
	postmd.1 >XXX.1; \
	mv XXX.1 postmd.1

