DIRS  = build pdfs
CC    = iverilog
CC1   = vvp
CC2   = gtkwave
CC3   = yosys -c
VPI   = -M ~/.local/install/ivl/lib/ivl

NO_OUTPUT = > /dev/null
NO_ERROR  = 2> /dev/null

# crea folders necesarios en caso que no existan
MAKE_FOLDERS := $(shell mkdir -p $(DIRS))

.PHONY: 	compile run


# Sintetiza con yosys, compila con iverilog y corre con vvp
all: synth compile run

# Compila con iverilog
compile:
	$(foreach test,$(wildcard pruebas/*.v),cd pruebas; $(CC) -E -DKEY=10 -o ../build/$(subst pruebas/,,$(subst .v,.pre.v,$(test))) $(subst pruebas/,,$(test)) -Ttyp -g specify;cd ..;)
	$(foreach test,$(wildcard build/*.pre.v),cd build; $(CC) -o $(subst build/,,$(subst .pre.v,.o,$(test))) $(subst build/,,$(test)) -Ttyp -g specify;cd ..;)

# Sintetiza segun scripts de yosys dentro de las carpetas para los bloques
synth: synthYosys renameSynths
synthYosys:
	$(foreach vlog,$(wildcard ./bloques/**/*.v), VLOG_FILE_NAME=$(vlog) VLOG_MODULE_NAME=$(subst .v,,$(notdir $(vlog))) CUR_DIR=$(shell pwd) $(CC3) ./yosys.tcl;)
	rm -f ./pdfs/*.dot
renameSynths:
	bash ./renameSynths.sh

run:
	$(foreach test,$(wildcard build/*.o), $(CC1) $(VPI) $(test);)
# Este comando acepta argumentos al correrlo de la siguiente manera
# > make gtkw="./achivo.gtkw" view
# Resulta más sencillo utilizar simplemente
# > gtkwave ./archivo.gtkw
# Sin embargo se agrega la funcionalidad
view:
	gtkwave $(gtkw)

clean:
	rm -r build
	rm -r pdfs
	rm -f ./*.dot
	rm -f gtkws/*.vcd
