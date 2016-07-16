# makefile for clgrep
NAME       = clgrep
INSTALLDIR = /opt/$(NAME)
BIN        = /usr/local/bin/clgrep

.PHONY: install uninstall test clean

install: uninstall
	mkdir -p $(INSTALLDIR)
	cp -r lib $(INSTALLDIR)
	install -m 755 clgrep.pl $(INSTALLDIR)/
	sed -i -e 's|^use lib .*|use lib qw($(INSTALLDIR)\/lib);|' $(INSTALLDIR)/clgrep.pl
	ln -s $(INSTALLDIR)/clgrep.pl $(BIN)

uninstall:
	if [ -L $(BIN) ]; then unlink $(BIN) ; fi
	rm -rf $(INSTALLDIR)

test:
	(cd test; ./simple_test.sh)

clean:
	find -type f -name *~ | xargs rm -f
	find -type f -name \#*\# | xargs rm -f
