#
# notes
# project makefile
#

PYTHON:=python3.7
BUILD_DIR:=build
SRC_DIR:=src

# src/target variables
SRC_NOTES:=$(shell find  $(SRC_DIR) -type f -name '*.md')
SRC_ASSETS:=$(shell find $(SRC_DIR) -type d -name 'assets')
TARGET_NOTES:=$(subst $(SRC_DIR),$(BUILD_DIR),$(SRC_NOTES))
TARGET_DIRS:=$(dir $(TARGET_NOTES))
TARGET_ASSETS:=$(subst $(SRC_DIR),$(BUILD_DIR),$(SRC_ASSETS))

.PHONY: all clean

all: $(TARGET_ASSETS) $(TARGET_NOTES)

# create dirs
dirs:
	mkdir -p $(TARGET_DIRS)

# copy assets
build/%/assets: src/%/assets dirs
	cp -af $< -t $(dir $@)


# render notes
# use readme2tex to render latex as svm
define render_note
$(subst $(SRC_DIR),$(BUILD_DIR),$(1)): $(1) dirs
	cd $$(dir $$@) && \
		$(PYTHON) -m readme2tex --nocdn  --svgdir ./assets \
		--output $$(notdir $$@) $(CURDIR)/$$< &&\
		sed -i -e "s/svg[?]/svg?sanitize=true\&/g" $$(notdir $$@) 
endef


$(foreach SRC_NOTE,$(SRC_NOTES), $(eval $(call render_note,$(SRC_NOTE))))

clean:
	rm -rf $(BUILD_DIR)
