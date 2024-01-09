# common_cflags =
# common_ldflags =

# rule cc
#   command = gcc $common_cflags $cflags -c $in -o $out

# rule ld
#   command = gcc $common_cflags $cflags $common_ldflags $ldflags $in -o $out

# rule flex
#   command = flex -o $out $in

# rule bison
#   command = bison -d -o $out $in

# build lexer.tab.c: flex lexer.l
# build parser.tab.c | parser.tab.h: bison parser.y

# build conf.o: cc conf.c
# build confdata.o: cc confdata.c
# build expr.o: cc expr.c
# build mconf.o: cc mconf.c
# build menu.o: cc menu.c
# build preprocess.o: cc preprocess.c
# build symbol.o: cc symbol.c
# build util.o: cc util.c
# build parser.tab.o: cc parser.tab.c
#   cflags = -DYYDEBUG
# build lexer.tab.o: cc lexer.tab.c | parser.tab.h
# build lxdialog/util.o: cc lxdialog/util.c
# build lxdialog/yesno.o: cc lxdialog/yesno.c
# build lxdialog/inputbox.o: cc lxdialog/inputbox.c
# build lxdialog/checklist.o: cc lxdialog/checklist.c
# build lxdialog/textbox.o: cc lxdialog/textbox.c
# build lxdialog/menubox.o: cc lxdialog/menubox.c

# build conf: ld conf.o symbol.o expr.o preprocess.o confdata.o parser.tab.o lexer.tab.o util.o menu.o
# build mconf: ld mconf.o symbol.o expr.o preprocess.o confdata.o parser.tab.o lexer.tab.o lxdialog/util.o lxdialog/yesno.o lxdialog/inputbox.o lxdialog/checklist.o lxdialog/textbox.o lxdialog/menubox.o util.o menu.o
#   ldflags = -lncurses

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


