## ${R_HOME}/share/make/winshlib.mk

include $(R_HOME)/etc${R_ARCH}/Makeconf

## NB, not parallel-safe but Matrix currently uses this
all: before $(SHLIB) after

BASE = $(shell basename $(SHLIB) .dll)

## do it with explicit rules as packages might add dependencies to this target
## (attempts to do this GNUishly failed for parallel makes,
## but we do want the link targets echoed)
$(SHLIB): $(OBJECTS)
	@if test -e "$(BASE)-win.def"; then \
	  echo $(SHLIB_LD) -shared $(DLLFLAGS) -o $@ $(BASE)-win.def $(OBJECTS) $(ALL_LIBS); \
	  $(SHLIB_LD) -shared $(DLLFLAGS) -o $@ $(BASE)-win.def $(OBJECTS) $(ALL_LIBS); \
	else \
	  echo EXPORTS > tmp.def; \
	  $(NM) $^ | $(SED) -n 's/^.* [BCDRT] _/ /p' >> tmp.def; \
	  echo $(SHLIB_LD) -shared $(DLLFLAGS) -o $@ tmp.def $(OBJECTS) $(ALL_LIBS); \
	  $(SHLIB_LD) -shared $(DLLFLAGS) -o $@ tmp.def $(OBJECTS) $(ALL_LIBS); \
	  $(RM) tmp.def; \
	fi

.PHONY: all before after shlib-clean
shlib-clean:
	@rm -f $(OBJECTS)
