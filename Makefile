RPMBUILD = rpmbuild --define "_topdir ${PWD}/build"
VERSION = 0.1
RPMS =  build/RPMS/noarch/http-server-${VERSION}-1.x86_64.rpm
CFLAGS = -std=gnu99 -fPIC -levent
LDFLAGS = -shared 

all : http-server.so http-server index.html

index.html : README.md
	pandoc $< -o $@

libevent-2.0.so.5 :
	cp /lib64/$@ .

http-server.so : http-server.c libevent-2.0.so.5
	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $^

http-server : http-server.c
	$(CC) -o $@ $(CFLAGS) $^

rpm : ${RPMS}

${RPMS} : http-server.spec http-server.c
	rm -rf build
	mkdir -p build/SOURCES
	cp -a Makefile http-server.c build/SOURCES
	VERSION=${VERSION} ${RPMBUILD} -bb $<

install : http-server
	install -d $(DESTDIR)/usr/sbin
	install $< $(DESTDIR)/usr/sbin

hooks : .git/hooks/pre-commit

.git/hooks/% : Makefile
	echo "#!/bin/sh" > $@
	echo "make `basename $@`" >> $@
	chmod 755 $@

pre-commit :
	git diff-index --check HEAD

clean :
	rm -rf build
	rm index.html
	rm -f http-server.so http-server.o http-server libevent-2.0.so.5

.PHONY : all clean hooks install rpm
