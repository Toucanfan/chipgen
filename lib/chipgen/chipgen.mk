# vim: ft=make noexpandtab

GENERATORS_DIR ?= generators

#INSTANCES = $(patsubst chipgen/%.instance,_generate/%,$(wildcard chipgen/*))

-include generate.cg


GENERATE_INSTANCES = $(addsuffix _generate, $(INSTANCES))
CLEAN_INSTANCES = $(addsuffix _clean, $(INSTANCES))

.PHONY: clean clean_common generate $(GENERATE_INSTANCES) $(CLEAN_INSTANCES)

_chipgen:
	mkdir -p _chipgen

clean_common:
	rm -rf _chipgen

generate: _chipgen $(GENERATE_INSTANCES)

clean: $(CLEAN_INSTANCES) clean_common

# Define a generate rule for each instance
define GENERATE_TEMPLATE
$(1)_DEPFILE = $$(GENERATORS_DIR)/$$($(1)_GENERATOR)/deps.cg
$(1)_DEPS = generator.cg deps.cg $$(shell if [ -f $$($(1)_DEPFILE) ]; then cat $$($(1)_DEPFILE); else echo ""; fi)
$(1)_DEPS_FULLPATH = $$(addprefix $$(GENERATORS_DIR)/$$($(1)_GENERATOR)/,$$($(1)_DEPS))
_chipgen/generate/$(1): generate.cg $$($(1)_DEPS_FULLPATH)
	mkdir -p _chipgen/generate/$(1)
	touch -c _chipgen/generate/$(1)
	cp -r $$(GENERATORS_DIR)/$$($(1)_GENERATOR)/* _chipgen/generate/$(1)/
	if [ -n "$$($(1)_FILES)" ]; then cp $$($(1)_FILES) _chipgen/generate/$(1)/ ; fi

$(1)_generate: _chipgen/generate/$(1)
	$$(MAKE) -C _chipgen/generate/$(1) -f generator.cg generate
endef
$(foreach inst,$(INSTANCES),$(eval $(call GENERATE_TEMPLATE,$(inst))))


# Define a clean rule for each instance
define CLEAN_TEMPLATE
$(1)_clean:
	rm -rf _chipgen/generate/$(1)
endef
$(foreach inst,$(INSTANCES),$(eval $(call CLEAN_TEMPLATE,$(inst))))

#_generate/%: chipgen/%.instance 
#	mkdir -p $@
#	cp -r $(CORES_DIR)/$($(patsubst _generate/%,%,$@)_CORE)/* $@/
#	$(MAKE) -C $@ -f chipgen/generator
