# Makefile for zlib
# Copyright (C) 1995-2024 Jean-loup Gailly, Mark Adler
# For conditions of distribution and use, see copyright notice in zlib.h

# To compile and test, type:
#    ./configure; make test
# Normally configure builds both a static and a shared library.
# If you want to build just a static library, use: ./configure --static

# To install /usr/local/lib/libz.* and /usr/local/include/zlib.h, type:
#    make install
# To install in $HOME instead of /usr/local, use:
#    make install prefix=$HOME

CC=gcc

CFLAGS=-O2 -fPIC -march=native -mtune=native  -O2 -march=native -mtune=native  -O2 -ftree-vectorize -fomit-frame-pointer -D_LARGEFILE64_SOURCE=1 -DHAVE_HIDDEN
#CFLAGS=-O -DMAX_WBITS=14 -DMAX_MEM_LEVEL=7
#CFLAGS=-g -DZLIB_DEBUG
#CFLAGS=-O3 -Wall -Wwrite-strings -Wpointer-arith -Wconversion \
#           -Wstrict-prototypes -Wmissing-prototypes

SFLAGS=-O2 -fPIC -march=native -mtune=native  -O2 -march=native -mtune=native  -O2 -ftree-vectorize -fomit-frame-pointer -fPIC -D_LARGEFILE64_SOURCE=1 -DHAVE_HIDDEN
LDFLAGS=-Wl,-rpath='$$ORIGIN/../lib' -Wl,-rpath-link='$$ORIGIN/../lib'
TEST_LIBS=-L. libz.a
LDSHARED=gcc
CPP=

STATICLIB=libz.a
SHAREDLIB=
SHAREDLIBV=
SHAREDLIBM=
LIBS=$(STATICLIB) $(SHAREDLIBV)

AR=ar
ARFLAGS=rc
RANLIB=ranlib
LDCONFIG=ldconfig
LDSHAREDLIBC=-lc
TAR=tar
SHELL=/bin/sh
EXE=

prefix =/data/data/com.termux/files/home/griefserver/bin/php7
exec_prefix =${prefix}
libdir =${exec_prefix}/lib
sharedlibdir =${libdir}
includedir =${prefix}/include
mandir =${prefix}/share/man
man3dir = ${mandir}/man3
pkgconfigdir = ${libdir}/pkgconfig
SRCDIR=
ZINC=
ZINCOUT=-I.

OBJZ = adler32.o crc32.o deflate.o infback.o inffast.o inflate.o inftrees.o trees.o zutil.o
OBJG = compress.o uncompr.o gzclose.o gzlib.o gzread.o gzwrite.o
OBJC = $(OBJZ) $(OBJG)

PIC_OBJZ = adler32.lo crc32.lo deflate.lo infback.lo inffast.lo inflate.lo inftrees.lo trees.lo zutil.lo
PIC_OBJG = compress.lo uncompr.lo gzclose.lo gzlib.lo gzread.lo gzwrite.lo
PIC_OBJC = $(PIC_OBJZ) $(PIC_OBJG)

# to use the asm code: make OBJA=match.o, PIC_OBJA=match.lo
OBJA =
PIC_OBJA =

OBJS = $(OBJC) $(OBJA)

PIC_OBJS = $(PIC_OBJC) $(PIC_OBJA)

all: static all64

static: example$(EXE) minigzip$(EXE)

shared: examplesh$(EXE) minigzipsh$(EXE)

all64: example64$(EXE) minigzip64$(EXE)

check: test

test: all teststatic test64

teststatic: static
	@TMPST=tmpst_$$; \
	if echo hello world | ${QEMU_RUN} ./minigzip | ${QEMU_RUN} ./minigzip -d && ${QEMU_RUN} ./example $$TMPST ; then \
	  echo '		*** zlib test OK ***'; \
	else \
	  echo '		*** zlib test FAILED ***'; false; \
	fi
	@rm -f tmpst_$$

testshared: shared
	@LD_LIBRARY_PATH=`pwd`:$(LD_LIBRARY_PATH) ; export LD_LIBRARY_PATH; \
	LD_LIBRARYN32_PATH=`pwd`:$(LD_LIBRARYN32_PATH) ; export LD_LIBRARYN32_PATH; \
	DYLD_LIBRARY_PATH=`pwd`:$(DYLD_LIBRARY_PATH) ; export DYLD_LIBRARY_PATH; \
	SHLIB_PATH=`pwd`:$(SHLIB_PATH) ; export SHLIB_PATH; \
	TMPSH=tmpsh_$$; \
	if echo hello world | ${QEMU_RUN} ./minigzipsh | ${QEMU_RUN} ./minigzipsh -d && ${QEMU_RUN} ./examplesh $$TMPSH; then \
	  echo '		*** zlib shared test OK ***'; \
	else \
	  echo '		*** zlib shared test FAILED ***'; false; \
	fi
	@rm -f tmpsh_$$

test64: all64
	@TMP64=tmp64_$$; \
	if echo hello world | ${QEMU_RUN} ./minigzip64 | ${QEMU_RUN} ./minigzip64 -d && ${QEMU_RUN} ./example64 $$TMP64; then \
	  echo '		*** zlib 64-bit test OK ***'; \
	else \
	  echo '		*** zlib 64-bit test FAILED ***'; false; \
	fi
	@rm -f tmp64_$$

infcover.o: $(SRCDIR)test/infcover.c $(SRCDIR)zlib.h zconf.h
	$(CC) $(CFLAGS) $(ZINCOUT) -c -o $@ $(SRCDIR)test/infcover.c

infcover: infcover.o libz.a
	$(CC) $(CFLAGS) -o $@ infcover.o libz.a

cover: infcover
	rm -f *.gcda
	${QEMU_RUN} ./infcover
	gcov inf*.c

libz.a: $(OBJS)
	$(AR) $(ARFLAGS) $@ $(OBJS)
	-@ ($(RANLIB) $@ || true) >/dev/null 2>&1

match.o: match.S
	$(CPP) match.S > _match.s
	$(CC) -c _match.s
	mv _match.o match.o
	rm -f _match.s

match.lo: match.S
	$(CPP) match.S > _match.s
	$(CC) -c -fPIC _match.s
	mv _match.o match.lo
	rm -f _match.s

example.o: $(SRCDIR)test/example.c $(SRCDIR)zlib.h zconf.h
	$(CC) $(CFLAGS) $(ZINCOUT) -c -o $@ $(SRCDIR)test/example.c

minigzip.o: $(SRCDIR)test/minigzip.c $(SRCDIR)zlib.h zconf.h
	$(CC) $(CFLAGS) $(ZINCOUT) -c -o $@ $(SRCDIR)test/minigzip.c

example64.o: $(SRCDIR)test/example.c $(SRCDIR)zlib.h zconf.h
	$(CC) $(CFLAGS) $(ZINCOUT) -D_FILE_OFFSET_BITS=64 -c -o $@ $(SRCDIR)test/example.c

minigzip64.o: $(SRCDIR)test/minigzip.c $(SRCDIR)zlib.h zconf.h
	$(CC) $(CFLAGS) $(ZINCOUT) -D_FILE_OFFSET_BITS=64 -c -o $@ $(SRCDIR)test/minigzip.c


adler32.o: $(SRCDIR)adler32.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)adler32.c

crc32.o: $(SRCDIR)crc32.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)crc32.c

deflate.o: $(SRCDIR)deflate.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)deflate.c

infback.o: $(SRCDIR)infback.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)infback.c

inffast.o: $(SRCDIR)inffast.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)inffast.c

inflate.o: $(SRCDIR)inflate.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)inflate.c

inftrees.o: $(SRCDIR)inftrees.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)inftrees.c

trees.o: $(SRCDIR)trees.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)trees.c

zutil.o: $(SRCDIR)zutil.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)zutil.c

compress.o: $(SRCDIR)compress.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)compress.c

uncompr.o: $(SRCDIR)uncompr.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)uncompr.c

gzclose.o: $(SRCDIR)gzclose.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)gzclose.c

gzlib.o: $(SRCDIR)gzlib.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)gzlib.c

gzread.o: $(SRCDIR)gzread.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)gzread.c

gzwrite.o: $(SRCDIR)gzwrite.c
	$(CC) $(CFLAGS) $(ZINC) -c -o $@ $(SRCDIR)gzwrite.c


adler32.lo: $(SRCDIR)adler32.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/adler32.o $(SRCDIR)adler32.c
	-@mv objs/adler32.o $@

crc32.lo: $(SRCDIR)crc32.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/crc32.o $(SRCDIR)crc32.c
	-@mv objs/crc32.o $@

deflate.lo: $(SRCDIR)deflate.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/deflate.o $(SRCDIR)deflate.c
	-@mv objs/deflate.o $@

infback.lo: $(SRCDIR)infback.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/infback.o $(SRCDIR)infback.c
	-@mv objs/infback.o $@

inffast.lo: $(SRCDIR)inffast.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/inffast.o $(SRCDIR)inffast.c
	-@mv objs/inffast.o $@

inflate.lo: $(SRCDIR)inflate.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/inflate.o $(SRCDIR)inflate.c
	-@mv objs/inflate.o $@

inftrees.lo: $(SRCDIR)inftrees.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/inftrees.o $(SRCDIR)inftrees.c
	-@mv objs/inftrees.o $@

trees.lo: $(SRCDIR)trees.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/trees.o $(SRCDIR)trees.c
	-@mv objs/trees.o $@

zutil.lo: $(SRCDIR)zutil.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/zutil.o $(SRCDIR)zutil.c
	-@mv objs/zutil.o $@

compress.lo: $(SRCDIR)compress.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/compress.o $(SRCDIR)compress.c
	-@mv objs/compress.o $@

uncompr.lo: $(SRCDIR)uncompr.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/uncompr.o $(SRCDIR)uncompr.c
	-@mv objs/uncompr.o $@

gzclose.lo: $(SRCDIR)gzclose.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/gzclose.o $(SRCDIR)gzclose.c
	-@mv objs/gzclose.o $@

gzlib.lo: $(SRCDIR)gzlib.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/gzlib.o $(SRCDIR)gzlib.c
	-@mv objs/gzlib.o $@

gzread.lo: $(SRCDIR)gzread.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/gzread.o $(SRCDIR)gzread.c
	-@mv objs/gzread.o $@

gzwrite.lo: $(SRCDIR)gzwrite.c
	-@mkdir objs 2>/dev/null || test -d objs
	$(CC) $(SFLAGS) $(ZINC) -DPIC -c -o objs/gzwrite.o $(SRCDIR)gzwrite.c
	-@mv objs/gzwrite.o $@


placebo $(SHAREDLIBV): $(PIC_OBJS) libz.a
	$(LDSHARED) $(SFLAGS) -o $@ $(PIC_OBJS) $(LDSHAREDLIBC) $(LDFLAGS)
	rm -f $(SHAREDLIB) $(SHAREDLIBM)
	ln -s $@ $(SHAREDLIB)
	ln -s $@ $(SHAREDLIBM)
	-@rmdir objs

example$(EXE): example.o $(STATICLIB)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ example.o $(TEST_LIBS)

minigzip$(EXE): minigzip.o $(STATICLIB)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ minigzip.o $(TEST_LIBS)

examplesh$(EXE): example.o $(SHAREDLIBV)
	$(CC) $(CFLAGS) -o $@ example.o $(LDFLAGS) -L. $(SHAREDLIBV)

minigzipsh$(EXE): minigzip.o $(SHAREDLIBV)
	$(CC) $(CFLAGS) -o $@ minigzip.o $(LDFLAGS) -L. $(SHAREDLIBV)

example64$(EXE): example64.o $(STATICLIB)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ example64.o $(TEST_LIBS)

minigzip64$(EXE): minigzip64.o $(STATICLIB)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ minigzip64.o $(TEST_LIBS)

install-libs: $(LIBS)
	-@if [ ! -d $(DESTDIR)$(exec_prefix)  ]; then mkdir -p $(DESTDIR)$(exec_prefix); fi
	-@if [ ! -d $(DESTDIR)$(libdir)       ]; then mkdir -p $(DESTDIR)$(libdir); fi
	-@if [ ! -d $(DESTDIR)$(sharedlibdir) ]; then mkdir -p $(DESTDIR)$(sharedlibdir); fi
	-@if [ ! -d $(DESTDIR)$(man3dir)      ]; then mkdir -p $(DESTDIR)$(man3dir); fi
	-@if [ ! -d $(DESTDIR)$(pkgconfigdir) ]; then mkdir -p $(DESTDIR)$(pkgconfigdir); fi
	rm -f $(DESTDIR)$(libdir)/$(STATICLIB)
	cp $(STATICLIB) $(DESTDIR)$(libdir)
	chmod 644 $(DESTDIR)$(libdir)/$(STATICLIB)
	-@($(RANLIB) $(DESTDIR)$(libdir)/libz.a || true) >/dev/null 2>&1
	-@if test -n "$(SHAREDLIBV)"; then \
	  rm -f $(DESTDIR)$(sharedlibdir)/$(SHAREDLIBV); \
	  cp $(SHAREDLIBV) $(DESTDIR)$(sharedlibdir); \
	  echo "cp $(SHAREDLIBV) $(DESTDIR)$(sharedlibdir)"; \
	  chmod 755 $(DESTDIR)$(sharedlibdir)/$(SHAREDLIBV); \
	  echo "chmod 755 $(DESTDIR)$(sharedlibdir)/$(SHAREDLIBV)"; \
	  rm -f $(DESTDIR)$(sharedlibdir)/$(SHAREDLIB) $(DESTDIR)$(sharedlibdir)/$(SHAREDLIBM); \
	  ln -s $(SHAREDLIBV) $(DESTDIR)$(sharedlibdir)/$(SHAREDLIB); \
	  ln -s $(SHAREDLIBV) $(DESTDIR)$(sharedlibdir)/$(SHAREDLIBM); \
	  ($(LDCONFIG) || true)  >/dev/null 2>&1; \
	fi
	rm -f $(DESTDIR)$(man3dir)/zlib.3
	cp $(SRCDIR)zlib.3 $(DESTDIR)$(man3dir)
	chmod 644 $(DESTDIR)$(man3dir)/zlib.3
	rm -f $(DESTDIR)$(pkgconfigdir)/zlib.pc
	cp zlib.pc $(DESTDIR)$(pkgconfigdir)
	chmod 644 $(DESTDIR)$(pkgconfigdir)/zlib.pc
# The ranlib in install is needed on NeXTSTEP which checks file times
# ldconfig is for Linux

install: install-libs
	-@if [ ! -d $(DESTDIR)$(includedir)   ]; then mkdir -p $(DESTDIR)$(includedir); fi
	rm -f $(DESTDIR)$(includedir)/zlib.h $(DESTDIR)$(includedir)/zconf.h
	cp $(SRCDIR)zlib.h zconf.h $(DESTDIR)$(includedir)
	chmod 644 $(DESTDIR)$(includedir)/zlib.h $(DESTDIR)$(includedir)/zconf.h

uninstall:
	cd $(DESTDIR)$(includedir) && rm -f zlib.h zconf.h
	cd $(DESTDIR)$(libdir) && rm -f libz.a; \
	if test -n "$(SHAREDLIBV)" -a -f $(SHAREDLIBV); then \
	  rm -f $(SHAREDLIBV) $(SHAREDLIB) $(SHAREDLIBM); \
	fi
	cd $(DESTDIR)$(man3dir) && rm -f zlib.3
	cd $(DESTDIR)$(pkgconfigdir) && rm -f zlib.pc

docs: zlib.3.pdf

zlib.3.pdf: $(SRCDIR)zlib.3
	groff -mandoc -f H -T ps $(SRCDIR)zlib.3 | ps2pdf - $@

zconf.h.cmakein: $(SRCDIR)zconf.h.in
	-@ TEMPFILE=zconfh_$$; \
	echo "/#define ZCONF_H/ a\\\\\n#cmakedefine Z_PREFIX\\\\\n#cmakedefine Z_HAVE_UNISTD_H\n" >> $$TEMPFILE &&\
	sed -f $$TEMPFILE $(SRCDIR)zconf.h.in > $@ &&\
	touch -r $(SRCDIR)zconf.h.in $@ &&\
	rm $$TEMPFILE

zconf: $(SRCDIR)zconf.h.in
	cp -p $(SRCDIR)zconf.h.in zconf.h

minizip-test: static
	cd contrib/minizip && { CC="$(CC)" CFLAGS="$(CFLAGS)" $(MAKE) test ; cd ../.. ; }

minizip-clean:
	cd contrib/minizip && { $(MAKE) clean ; cd ../.. ; }

mostlyclean: clean
clean: minizip-clean
	rm -f *.o *.lo *~ \
	   example$(EXE) minigzip$(EXE) examplesh$(EXE) minigzipsh$(EXE) \
	   example64$(EXE) minigzip64$(EXE) \
	   infcover \
	   libz.* foo.gz so_locations \
	   _match.s maketree contrib/infback9/*.o
	rm -rf objs
	rm -f *.gcda *.gcno *.gcov
	rm -f contrib/infback9/*.gcda contrib/infback9/*.gcno contrib/infback9/*.gcov

maintainer-clean: distclean
distclean: clean zconf zconf.h.cmakein
	rm -f Makefile zlib.pc configure.log
	-@rm -f .DS_Store
	@if [ -f Makefile.in ]; then \
	printf 'all:\n\t-@echo "Please use ./configure first.  Thank you."\n' > Makefile ; \
	printf '\ndistclean:\n\tmake -f Makefile.in distclean\n' >> Makefile ; \
	touch -r $(SRCDIR)Makefile.in Makefile ; fi

tags:
	etags $(SRCDIR)*.[ch]

adler32.o zutil.o: $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h
gzclose.o gzlib.o gzread.o gzwrite.o: $(SRCDIR)zlib.h zconf.h $(SRCDIR)gzguts.h
compress.o example.o minigzip.o uncompr.o: $(SRCDIR)zlib.h zconf.h
crc32.o: $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h $(SRCDIR)crc32.h
deflate.o: $(SRCDIR)deflate.h $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h
infback.o inflate.o: $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h $(SRCDIR)inftrees.h $(SRCDIR)inflate.h $(SRCDIR)inffast.h $(SRCDIR)inffixed.h
inffast.o: $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h $(SRCDIR)inftrees.h $(SRCDIR)inflate.h $(SRCDIR)inffast.h
inftrees.o: $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h $(SRCDIR)inftrees.h
trees.o: $(SRCDIR)deflate.h $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h $(SRCDIR)trees.h

adler32.lo zutil.lo: $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h
gzclose.lo gzlib.lo gzread.lo gzwrite.lo: $(SRCDIR)zlib.h zconf.h $(SRCDIR)gzguts.h
compress.lo example.lo minigzip.lo uncompr.lo: $(SRCDIR)zlib.h zconf.h
crc32.lo: $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h $(SRCDIR)crc32.h
deflate.lo: $(SRCDIR)deflate.h $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h
infback.lo inflate.lo: $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h $(SRCDIR)inftrees.h $(SRCDIR)inflate.h $(SRCDIR)inffast.h $(SRCDIR)inffixed.h
inffast.lo: $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h $(SRCDIR)inftrees.h $(SRCDIR)inflate.h $(SRCDIR)inffast.h
inftrees.lo: $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h $(SRCDIR)inftrees.h
trees.lo: $(SRCDIR)deflate.h $(SRCDIR)zutil.h $(SRCDIR)zlib.h zconf.h $(SRCDIR)trees.h
