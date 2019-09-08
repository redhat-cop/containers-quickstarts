
IMAGE_NAME = s2i-java

build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-test .
	IMAGE_NAME=$(IMAGE_NAME)-test BUILDER=maven test/run
	IMAGE_NAME=$(IMAGE_NAME)-test BUILDER=gradle test/run
