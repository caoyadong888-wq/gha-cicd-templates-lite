.PHONY: demo test images

demo:
	./demo.sh

test:
	./tests/run_tests.sh

images:
	python3 marketing/make_images.py
