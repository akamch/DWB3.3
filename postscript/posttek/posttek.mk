#MAKE=/bin/make
MAKEFILE=posttek.mk

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

HFILES=posttek.h\
       $(COMMONDIR)/comments.h\
       $(COMMONDIR)/ext.h\
       $(COMMONDIR)/gen.h\
       $(COMMONDIR)/path.h

OFILES=posttek.o\
       $(COMMONDIR)/glob.o\
       $(COMMONDIR)/misc.o\
       $(COMMONDIR)/request.o

all : posttek

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
	cp posttek $(POSTBIN)/posttek
	@chmod 755 $(POSTBIN)/posttek
	@chgrp $(GROUP) $(POSTBIN)/posttek
	@chown $(OWNER) $(POSTBIN)/posttek
	cp posttek.ps $(POSTLIB)/posttek.ps
	@chmod 644 $(POSTLIB)/posttek.ps
	@chgrp $(GROUP) $(POSTLIB)/posttek.ps
	@chown $(OWNER) $(POSTLIB)/posttek.ps
	sed -e 's" /usr/lib/postscript$$" $(POSTLIB)"' \
	    posttek.1 > $(MAN1DIR)/posttek.1
	@chmod 644 $(MAN1DIR)/posttek.1
	@chgrp $(GROUP) $(MAN1DIR)/posttek.1
	@chown $(OWNER) $(MAN1DIR)/posttek.1

clean :
	rm -f *.o

clobber : clean
	rm -f posttek

posttek : $(OFILES)
	$(CC) $(CFLAGS) $(LDFLAGS) -o posttek $(OFILES)

posttek.o : $(HFILES)

$(COMMONDIR)/glob.o\
$(COMMONDIR)/misc.o\
$(COMMONDIR)/request.o :
	@cd $(COMMONDIR); $(MAKE) -f common.mk $(@F)

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
	posttek.1 >XXX.1; \
	mv XXX.1 posttek.1

