INPUT_DIR := src
FILES := Data.as Debug.as Util.as ProjectilePlus.as CutScene.as Draw.as StringMap.as Loader.as
BASE_FILE := CampaignController.as
OUTPUT_FILE := output.tmp.as
FINAL_OUTPUT := EasyController_Installer/scripts/com/brockw/stickwar/campaign/controllers/CampaignController.as

all: $(FINAL_OUTPUT)

$(FINAL_OUTPUT): $(BASE_FILE) $(addprefix $(INPUT_DIR)/, $(FILES))
	@echo Concatenating files...
	@> $(OUTPUT_FILE)
	@cat $(BASE_FILE) >> $(OUTPUT_FILE)
	@echo >> $(OUTPUT_FILE)
	@for f in $(FILES); do \
		if [ -f "$(INPUT_DIR)/$$f" ]; then \
			cat "$(INPUT_DIR)/$$f" >> $(OUTPUT_FILE); \
			echo >> $(OUTPUT_FILE); \
		else \
			echo "File not found: $(INPUT_DIR)/$$f"; \
		fi \
	done
	@mkdir -p $(dir $(FINAL_OUTPUT))
	@cp -f $(OUTPUT_FILE) $(FINAL_OUTPUT)
	@echo Done. Output written to $(FINAL_OUTPUT)

clean:
	@rm -f $(OUTPUT_FILE)
