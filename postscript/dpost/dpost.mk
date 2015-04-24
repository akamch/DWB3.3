MAKE=/usr/bin/make
MAKEFILE=dpost.mk

SYSTEM=SYSV
VERSION=3.3

GROUP=bin
OWNER=bin

BINDIR=/usr/bin
FONTDIR=/usr/lib/font
MAN1DIR=/usr/man/u_man/man1
POSTBIN=/usr/lbin/postscript
POSTLIB=/usr/lib/postscript

COMMONDIR=../common

CFLGS=-O
LDFLGS=-s

CFLAGS=$(CFLGS) -I$(COMMONDIR)\
    -DPOSTLIB="\"$(POSTLIB)\""\
    -DDHOSTDIR="\"$(HOSTDIR)\""\
    -DDFONTDIR="\"$(FONTDIR)\""
LDFLAGS=$(LDFLGS)

HFILES=dpost.h\
       font.h\
       motion.h\
       ps_include.h\
       $(COMMONDIR)/comments.h\
       $(COMMONDIR)/ext.h\
       $(COMMONDIR)/gen.h\
       $(COMMONDIR)/path.h

OFILES=dpost.o\
       draw.o\
       color.o\
       font.o\
       pictures.o\
       ps_include.o\
       $(COMMONDIR)/bbox.o\
       $(COMMONDIR)/glob.o\
       $(COMMONDIR)/misc.o\
       $(COMMONDIR)/request.o\
       $(COMMONDIR)/tempnam.o

all : dpost

install : all
	@rm -f $(POSTBIN)/dpost
	@if [ ! -d "$(POSTLIB)" ]; then \
	    mkdir $(POSTLIB); \
	    chmod 755 $(POSTLIB); \
	    chgrp $(GROUP) $(POSTLIB); \
	    chown $(OWNER) $(POSTLIB); \
	fi
	cp dpost $(BINDIR)/dpost
	@chmod 755 $(BINDIR)/dpost
	@chgrp $(GROUP) $(BINDIR)/dpost
	@chown $(OWNER) $(BINDIR)/dpost
	cp dpost.ps $(POSTLIB)/dpost.ps
	@chmod 644 $(POSTLIB)/dpost.ps
	@chgrp $(GROUP) $(POSTLIB)/dpost.ps
	@chown $(OWNER) $(POSTLIB)/dpost.ps
	cp draw.ps $(POSTLIB)/draw.ps
	@chmod 644 $(POSTLIB)/draw.ps
	@chgrp $(GROUP) $(POSTLIB)/draw.ps
	@chown $(OWNER) $(POSTLIB)/draw.ps
	sed -e 's" /usr/lib/font$$" $(FONTDIR)"' \
	    -e 's" /usr/lib/postscript$$" $(POSTLIB)"' \
	    dpost.1 > $(MAN1DIR)/dpost.1
	@chmod 644 $(MAN1DIR)/dpost.1
	@chgrp $(GROUP) $(MAN1DIR)/dpost.1
	@chown $(OWNER) $(MAN1DIR)/dpost.1

clean :
	rm -f *.o

clobber : clean
	rm -f dpost

dpost : $(OFILES)
	$(CC) $(CFLAGS) $(LDFLAGS) -o dpost $(OFILES) -lm

dpost.o : $(HFILES)
color.o : $(COMMONDIR)/ext.h $(COMMONDIR)/gen.h
draw.o : motion.h $(COMMONDIR)/ext.h $(COMMONDIR)/gen.h
font.o : font.h $(COMMONDIR)/gen.h
pictures.o : $(COMMONDIR)/comments.h $(COMMONDIR)/gen.h
ps_include.o : ps_include.h

$(COMMONDIR)/bbox.o\
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
	    -e "s'^BINDIR=.*'BINDIR=$(BINDIR)'" \
	    -e "s'^FONTDIR=.*'FONTDIR=$(FONTDIR)'" \
	    -e "s'^MAN1DIR=.*'MAN1DIR=$(MAN1DIR)'" \
	    -e "s'^POSTBIN=.*'POSTBIN=$(POSTBIN)'" \
	    -e "s'^POSTLIB=.*'POSTLIB=$(POSTLIB)'" \
	$(MAKEFILE) >XXX.mk; \
	mv XXX.mk $(MAKEFILE); \
	sed \
	    -e "s'^.ds dF.*'.ds dF $(FONTDIR)'" \
	    -e "s'^.ds dQ.*'.ds dQ $(POSTLIB)'" \
	dpost.1 >XXX.1; \
	mv XXX.1 dpost.1

