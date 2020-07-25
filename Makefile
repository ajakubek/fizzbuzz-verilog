PROJECT_NAME := fizzbuzz
TOP_MODULE := top

SOURCES := fizzbuzz.v icebreaker.v

CONSTRAINTS := icebreaker.pcf

DEVICE := 5k
DEVICE_WIDE := up5k
PACKAGE := sg48

FORMAL_CONFIG := $(PROJECT_NAME).sby

TEST_TOP_MODULE := $(PROJECT_NAME)_tb
TEST_SOURCES := $(PROJECT_NAME)_tb.v
TEST_EXECUTABLE := test_$(PROJECT_NAME)

########################################################################

all: $(PROJECT_NAME).bin
	@echo 'Build complete!'

$(PROJECT_NAME).bin: $(PROJECT_NAME).asc
	icepack $< $@

# $(PROJECT_NAME).asc: $(PROJECT_NAME).blif
# 	arachne-pnr -d $(DEVICE) -P $(PACKAGE) -p $(CONSTRAINTS) -o $@ $<

$(PROJECT_NAME).asc: $(PROJECT_NAME).json
	nextpnr-ice40 \
		--$(DEVICE_WIDE) --package $(PACKAGE) --pcf $(CONSTRAINTS) --json $< --asc $@

$(PROJECT_NAME).blif: $(SOURCES)
	yosys -p 'read -sv $^; synth_ice40 -top $(TOP_MODULE) -blif $@'

$(PROJECT_NAME).json: $(SOURCES)
	yosys -p 'read -sv $^; synth_ice40 -top $(TOP_MODULE) -json $@'

formal: $(FORMAL_CONFIG)
	sby -f $<

test: $(TEST_EXECUTABLE)
	./$(TEST_EXECUTABLE)

$(TEST_EXECUTABLE): $(SOURCES) $(TEST_SOURCES)
	iverilog -s $(TEST_TOP_MODULE) -o $(TEST_EXECUTABLE) $(SOURCES) $(TEST_SOURCES)

timing: $(PROJECT_NAME).asc
	icetime -mt $<

clean:
	rm -rf fizzbuzz_bmc fizzbuzz_cover
	rm -f *.blif *.json *.asc *.bin $(TEST_EXECUTABLE)

.PHONY: all formal test timing clean
