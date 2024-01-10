CFLAGS=
LDFLAGS=
CC=gcc $(CFLAGS)

LXDIALOG_HEADERS=$(wildcard lxdialog/*.h)
LXDIALOG_SOURCES=$(wildcard lxdialog/*.c)
LXDIALOG_OBJS=$(patsubst %.c,%.o,$(LXDIALOG_SOURCES))

COMMON_SOURCES=symbol.c expr.c preprocess.c confdata.c parser.tab.c lexer.tab.c util.c menu.c
COMMON_HEADERS=parser.tab.h $(wildcard *.h)

CONF_SOURCES=conf.c $(COMMON_SOURCES)
CONF_HEADERS=$(COMMON_HEADERS)
CONF_OBJS=$(patsubst %.c,%.o,$(CONF_SOURCES))

MCONF_SOURCES=mconf.c $(COMMON_SOURCES)
MCONF_HEADERS=$(LXDIALOG_HEADERS) $(COMMON_HEADERS)
MCONF_OBJS=$(LXDIALOG_OBJS) $(patsubst %.c,%.o,$(MCONF_SOURCES))

help:
	@echo "Usage doc:"
	@echo "Type 'make tryout' to try the example"
	@echo "Type 'make conf' to build conf"
	@echo "Type 'make mconf' to build menuconfig"
	@echo "Type 'make clean' to clean the repo"
	@echo "Type 'make help' to display this message"

tryout: mconf example.mconf
	./mconf example.mconf

mconf: LDFLAGS=-lncurses -ltinfo
mconf: $(MCONF_OBJS)
	$(CC) $^ -o $@ $(LDFLAGS)

conf: $(CONF_OBJS)

%.o: %.c
	$(CC) -c $< -o $@

lxdialog: $(LXDIALOG_OBJS)

parser.tab.o: CFLAGS=-DYYDEBUG
parser.tab.c parser.tab.h: parser.y
	bison -d -o $@ $<

lexer.tab.c: lexer.l
	flex -o $@ $< 

clean:
	rm -f lxdialog/*.o
	rm -f parser.tab.*
	rm -f lexer.tab.*
	rm -f *.o
	rm -f conf
	rm -f mconf

.PHONY: clean help tryout


