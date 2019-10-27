SHELL := /bin/bash
VERSION := $(shell git tag -l --points-at HEAD)
BRANCH := $(shell  git rev-parse --abbrev-ref HEAD)
GID := $(shell id -g)
ifeq ( $(BRANCH), "master")
	BRANCH = "latest"
endif
file=templates/template_en
NAME := europass-cv
DOCKER_BUILDKIT := 0

.PHONY: clean all help docker docker-test template-cv template-cover docker-show-image

clean: ## cleanup
	@echo "+$@"
	rm -f *.pdf *.log *.out *.synctex.gz *.aux

template-cv: ## Test CV
	@echo "+$@"
	@pdflatex -synctex=1 -interaction=nonstopmode $(file)_cv.tex
	@pdflatex -synctex=1 -interaction=nonstopmode $(file)_cv.tex

template-cover: ## Test cover letter
	@echo "+$@"
	@pdflatex -synctex=1 -interaction=nonstopmode $(file)_cover.tex
	@pdflatex -synctex=1 -interaction=nonstopmode $(file)_cover.tex

docker-lint: Dockerfile ## Lint Dockerfile
	@echo "+$@"
	@docker run --rm -i \
		hadolint/hadolint:latest-debian \
		hadolint \
		--ignore DL3003 \
  		--ignore DL3008 \
  		--ignore SC1010 - < Dockerfile

test: clean template-cv template-cover docker-lint ## lint and test render

DOCKER_USER := tprasadtp

docker: ## Build Docker image (not on CI)
	@echo "+$@"
	@DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) docker build --rm --force-rm -t $(NAME) -f Dockerfile .
	@if ! [ -z $(VERSION) ]; then \
		echo -e "\e[92mCommit is Tagggd with :: $(VERSION)\e[39m"; \
		docker tag $(NAME) $(DOCKER_USER)/$(NAME):$(VERSION); \
	elif [ $(BRANCH) == "master" ]; then \
		echo -e "\e[92mNot a tagged commit, but on master add latest.\e[39m"; \
		docker tag $(NAME) $(DOCKER_USER)/$(NAME):latest; \
	else \
		echo -e "\e[92mNot a tagged commit, not on master add tag $(BRANCH).\e[39m"; \
		docker tag $(NAME) $(DOCKER_USER)/$(NAME):$(BRANCH); \
	fi

docker-test: ## Test inside docker image
	@echo "+$@"
	@echo "Using tprasadtp/europass-cv:$(BRANCH) $$UID:$(GID)"
	@docker run -it -v $(pwd):/home/user/cv:rw -u $$UID:$(GID) tprasadtp/europass-cv:$(BRANCH) make test

docker-show-image: ## list image properties
	@echo "+$@"
	@docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}" | grep tprasadtp


help: ## This help dialog.
	@IFS=$$'\n' ; \
    help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
    printf "%-30s %s\n" "--------" "------------" ; \
	printf "%-30s %s\n" " Target " "    Help " ; \
    printf "%-30s %s\n" "--------" "------------" ; \
    for help_line in $${help_lines[@]}; do \
        IFS=$$':' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        printf '\033[92m'; \
        printf "%-30s %s" $$help_command ; \
        printf '\033[0m'; \
        printf "%s\n" $$help_info; \
    done
