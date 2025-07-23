source_files := $(wildcard */*.mod) $(wildcard */*/*.mod)
output_files := $(wildcard *.c) $(wildcard *.h) $(wildcard *.o) $(wildcard *.sym) $(wildcard */.tmp*) $(wildcard .tmp*)

build: build-modules build-target

build-modules:
	@failure=0; \
	for file in $(source_files); do \
		voc "$$file" -c; \
		if [ $$? -ne 0 ]; then \
			failure=1; \
		else \
			echo "Compiled file: $$file"; \
		fi; \
	done; \
	if [ $$failure -ne 0 ]; then \
		$(MAKE) build-modules; \
	fi

build-target:
	voc source/main.mod -m

delete:
	@for file in $(output_files); do \
		rm -f "$$file"; \
		echo "Deleted file: $$file"; \
	done

test-build:
	./braineron test.bf test.mod && voc test.mod -m