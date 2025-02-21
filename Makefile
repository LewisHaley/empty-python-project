PYTHON_VER := python3.13

USE_VENV ?= yes
ifeq ($(USE_VENV),yes)
PYTHON_BIN := venv/bin/python
else
PYTHON_BIN := $(PYTHON_VER)
endif

ci: \
	autoformat \
	lint \
	tests \
	;
.PHONY: ci

autoformat: venv
	$(PYTHON_BIN) -m black \
	    --check \
	    --diff \
	    . \
	;
.PHONY: autoformat

lint: \
	isort \
	pylint \
	;
.PHONY: lint

isort: venv
	$(PYTHON_BIN) -m isort \
	    --check \
	    --diff \
	    . \
	;
.PHONY: isort

pylint: venv
	$(PYTHON_BIN) -m pylint \
		src \
		tests \
	;
.PHONY: pylint

tests: venv
	$(PYTHON_BIN) -m pytest
.PHONY: tests

ifeq ($(USE_VENV),no)
venv: venv/pyvenv.cfg
venv/pyvenv.cfg: requirements.dev.txt
	$(PYTHON_VER) -m venv --upgrade-deps venv
	venv/bin/python -m pip install \
		--prefer-binary \
		--require-virtualenv \
		--progress-bar=off \
		--quiet \
		--requirement=requirements.dev.txt \
		--editable=. \
	;
else
venv:
endif

clean:
	rm -rf venv
	find -name *.pyc -delete
	find -name __pycache__ -delete
	rm -rf .pytest_cache
.PHONY: clean
