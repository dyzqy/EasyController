.PHONY: all clean

INPUT_DIR := src
FILES := Data.as Debug.as Util.as CutScene.as StringMap.as Loader.as
BASE_FILE := CampaignController.as
OUTPUT_FILE := output.tmp.as
FINAL_OUTPUT := EasyController_Installer/scripts/com/brockw/stickwar/campaign/controllers/CampaignController.as

FFDEC := "EasyController_Installer/ffdec_18.5.0/ffdec.sh"
SWF := "EasyController_Installer/EasyController.swf"
SW2 := "EasyController_Installer/SW2-EasyController.swf"

all:
	@echo Concatenating files...
	@rm -f $(OUTPUT_FILE)
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
	$(FFDEC) -replace $(SWF) $(SWF) com.brockw.stickwar.campaign.controllers.CampaignController $(FINAL_OUTPUT)
	
sw2:
	@echo Concatenating files...
	@rm -f $(OUTPUT_FILE)
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
	$(FFDEC) -replace $(SW2) $(SW2) com.brockw.stickwar.campaign.controllers.CampaignController $(FINAL_OUTPUT)

clean:
	@rm -f $(OUTPUT_FILE)
