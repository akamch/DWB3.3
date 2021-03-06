MAKE=/bin/make
MAKEFILE=common.mk

SYSTEM=SYSV
VERSION=3.3

FONTDIR=/usr/lib/font
HOSTDIR=/usr/lib/font/postscript
POSTLIB=/usr/lib/postscript

ROUNDPAGE=FALSE

CFLGS=-O
LDFLGS=-s

CFLAGS=$(CFLGS)\
    -DPOSTLIB="\"$(POSTLIB)\""
LDFLAGS=$(LDFLGS)

all :

install : all

clean :
	rm -f *.o

clobber : clean

bbox.o : bbox.c ext.h gen.h
	$(CC) $(CFLAGS) -c bbox.c

glob.o : glob.c gen.h
	$(CC) $(CFLAGS) -c glob.c

misc.o : misc.c ext.h gen.h path.h
	$(CC) $(CFLAGS) -c misc.c

request.o : request.c gen.h path.h request.h
	$(CC) $(CFLAGS) -c request.c

tempnam.o : tempnam.c
	$(CC) $(CFLAGS) -D$(SYSTEM) -c tempnam.c

changes :
	@trap "" 1 2 3 15; \
	sed \
	    -e "s'^SYSTEM=.*'SYSTEM=$(SYSTEM)'" \
	    -e "s'^VERSION=.*'VERSION=$(VERSION)'" \
	    -e "s'^FONTDIR=.*'FONTDIR=$(FONTDIR)'" \
	    -e "s'^HOSTDIR=.*'HOSTDIR=$(HOSTDIR)'" \
	    -e "s'^POSTLIB=.*'POSTLIB=$(POSTLIB)'" \
	    -e "s'^ROUNDPAGE=.*'ROUNDPAGE=$(ROUNDPAGE)'" \
	$(MAKEFILE) >XXX.mk; \
	mv XXX.mk $(MAKEFILE); \
	sed \
	    -e 's:"FONTDIR:"$(FONTDIR):' \
	    -e 's:"HOSTDIR:"$(HOSTDIR):' \
	    -e 's:"POSTLIB:"$(POSTLIB):' \
	pathtemplate >path.h; \
	sed \
	    -e "s'^#define.*DOROUND.*'#define DOROUND	$(ROUNDPAGE)'" \
	gen.h >Xgen.h; \
	mv Xgen.h gen.h

