DIRS  = build tests synth pdfs
CC    = iverilog
CC1   = vvp
CC2   = gtkwave
CC3   = yosys -c
VPI = -M ~/.local/install/ivl/lib/ivl
NO_OUTPUT = > /dev/null

# crea folders necesarios en caso que no existan
MAKE_FOLDERS := $(shell mkdir -p $(DIRS))

.PHONY: synth compile run


# Sintetiza con yosys, compila con iverilog y corre con vvp
all: synth compile run

# Compila con iverilog
compile:
	@$(foreach test,$(wildcard pruebas/test*.v), $(CC) -o build/$(subst pruebas/,,$(subst .v,,$(test))) $(test) -Ttyp -g specify;)

# Sintetiza segun scripts de yosys dentro de las carpetas para los bloques
synth:
	$(foreach vlog,$(wildcard ./bloques/paraleloSerial/*.v), VLOG_FILE_NAME=$(vlog) VLOG_MODULE_NAME=$(subst .v,,$(notdir $(vlog))) CUR_DIR=$(shell pwd) $(CC3) ./yosys.tcl;)
	rm -f ./pdfs/*.dot

run:
	@$(foreach test,$(wildcard build/test*), $(CC1) $(VPI) $(test);)

# Este comando acepta argumentos al correrlo de la siguiente manera
# > make gtkw="./achivo.gtkw" view
# Resulta más sencillo utilizar simplemente
# > gtkwave ./archivo.gtkw
# Sin embargo se agrega la funcionalidad
view:
	gtkwave $(gtkw)

clean:
	rm -r build
	rm -r synth
	rm -r pdfs
	rm -f ./*.dot
	rm -f tests/*.vcd
