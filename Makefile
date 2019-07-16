TARGET := run-test
MAIN := Main.main

SML := sml
MLTON := mlton

SUFFIX := $(shell $(SML) @SMLsuffix)

default: $(USE)

smlnj: _build/$(TARGET)

mlton: _build/$(TARGET).opt

.PHONY: clean
clean:
	rm -rf _build .cm src/.cm *.du *.ud

_build/$(TARGET): _build/smlnj/$(TARGET).$(SUFFIX) _build/smlnj/$(TARGET)-wrapper.sh
	mkdir -p $(@D)
	sed -e 's+HEAP_IMAGE+$(realpath $<)+' _build/smlnj/$(TARGET)-wrapper.sh > $@
	chmod +x $@

ifeq ($(USE), smlnj)
_build/smlnj/$(TARGET).cm.mk: $(TARGET).cm
	mkdir -p $(@D)
	touch $@
	ml-makedepend -n -f $@ $< _build/smlnj/$(TARGET).$(SUFFIX) || rm -f $@

-include _build/smlnj/$(TARGET).cm.mk
endif

_build/smlnj/$(TARGET).$(SUFFIX): _build/smlnj/$(TARGET).cm.mk
	mkdir -p $(@D)
	ml-build $(TARGET).cm $(MAIN) _build/smlnj/$(TARGET)

_build/smlnj/$(TARGET)-wrapper.sh:
	mkdir -p $(@D)
	echo '#!/usr/bin/env bash' > $@
	echo '' >> $@
	echo 'exec $(SML) @SMLcmdname="$$0" @SMLload="HEAP_IMAGE" "$$@"' >> $@

_build/$(TARGET).opt: _build/mlton/$(TARGET)
	mkdir -p $(@D)
	cp $< $@

ifeq ($(USE), mlton)
_build/mlton/$(TARGET).mlb.mk: $(TARGET).mlb
	mkdir -p $(@D)
	echo '_build/mlton/$(TARGET): \\' >> $@
	$(MLTON) -stop f $< | sed -e 's/$$/ \\/' >> $@ || rm -f $@

-include _build/mlton/$(TARGET).mlb.mk
endif

_build/mlton/$(TARGET): _build/mlton/$(TARGET).mlb.mk
	mkdir -p $(@D)
	$(MLTON) -prefer-abs-paths true -show-def-use $(TARGET).du -output $@ $(TARGET).mlb
