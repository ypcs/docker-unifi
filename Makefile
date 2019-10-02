all:

build:
	$(DOCKER) build -t ypcs/ubifi .

run:
	$(DOCKER) run ypcs/ubifi
