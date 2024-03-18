# vim: ft=make noexpandtab

PREFIX ?= $(HOME)/.local

BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib
SHAREDIR = $(PREFIX)/share

install:
	mkdir -p $(BINDIR)
	mkdir -p $(LIBDIR)
	mkdir -p $(SHAREDIR)

	install -m 755 -t $(BINDIR) bin/*
	cp -r lib/* $(LIBDIR)/
	cp -r share/* $(SHAREDIR)/

uninstall:
	rm -f $(BINDIR)/chipgen
	rm -rf $(LIBDIR)/chipgen
	rm -rf $(SHAREDIR)/chipgen
