LIB := base
TEST := run-test
MAIN := Main.main

SML := sml
MLTON := mlton

SUFFIX := $(shell $(SML) @SMLsuffix)

default: $(USE)

smlnj: _build/$(TEST)

mlton: _build/$(TEST).opt

.PHONY: clean
clean:
	rm -rf _build .cm lib/.cm test/.cm *.du *.ud

_build/$(TEST): _build/smlnj/$(TEST).$(SUFFIX) _build/smlnj/$(TEST)-wrapper.sh
	mkdir -p $(@D)
	sed -e 's+HEAP_IMAGE+$(realpath $<)+' _build/smlnj/$(TEST)-wrapper.sh > $@
	chmod +x $@

ifeq ($(USE), smlnj)
_build/smlnj/$(TEST).cm.mk: $(TEST).cm $(LIB).cm
	mkdir -p $(@D)
	touch $@
	ml-makedepend -n -f $@ $< _build/smlnj/$(TEST).$(SUFFIX) || rm -f $@

-include _build/smlnj/$(TEST).cm.mk
endif

_build/smlnj/$(TEST).$(SUFFIX): _build/smlnj/$(TEST).cm.mk
	mkdir -p $(@D)
	ml-build $(TEST).cm $(MAIN) _build/smlnj/$(TEST)

_build/smlnj/$(TEST)-wrapper.sh:
	mkdir -p $(@D)
	echo '#!/usr/bin/env bash' > $@
	echo '' >> $@
	echo 'exec $(SML) @SMLcmdname="$$0" @SMLload="HEAP_IMAGE" "$$@"' >> $@

_build/$(TEST).opt: _build/mlton/$(TEST)
	mkdir -p $(@D)
	cp $< $@

ifeq ($(USE), mlton)
_build/mlton/$(TEST).mlb.mk: $(TEST).mlb $(LIB).mlb
	mkdir -p $(@D)
	echo '_build/mlton/$(TEST): \\' >> $@
	$(MLTON) -stop f $< | sed -e 's/$$/ \\/' >> $@ || rm -f $@

-include _build/mlton/$(TEST).mlb.mk
endif

_build/mlton/$(TEST): _build/mlton/$(TEST).mlb.mk
	mkdir -p $(@D)
	$(MLTON) -prefer-abs-paths true -show-def-use $(TEST).du -output $@ $(TEST).mlb
