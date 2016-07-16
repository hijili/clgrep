# makefile for clgrep
NAME       = clgrep
INSTALLDIR = /opt/$(NAME)
BIN        = /usr/local/bin/clgrep

.PHONY: install uninstall test clean

install: uninstall
	mkdir -p $(INSTALLDIR)
	cp -r lib $(INSTALLDIR)
	install -m 755 clgrep.pl $(INSTALLDIR)/
	ln -s $(INSTALLDIR)/clgrep.pl $(BIN)

uninstall:
	@rm -rf $(INSTALLDIR)
	@[ -s $(BIN) ] && rm -f $(BIN)

test:
	(cd test; ./simple_test.sh)

clean:
	@rm -f *~
	@rm -f \#*\#
