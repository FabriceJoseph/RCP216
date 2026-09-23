.DEFAULT_GOAL := help

COMPOSE := docker compose
SERVICE := rcp216

# Detect whether we are already running inside the RCP216 container.
IN_CONTAINER := $(shell [ "$$IN_RCP216_CONTAINER" = "1" ] && echo 1 || echo 0)

.PHONY: help build build-fast up down restart ps shell jupyter python pyspark spark env logs clean

help:
	@echo ""
	@echo "RCP216 - CNAM"
	@echo ""
	@echo "Usage:"
	@echo "  make <command>"
	@echo ""
	@echo "Commands:"
	@echo "  help       Show this help"
	@echo "  build      Rebuild the Docker image without cache"
	@echo "  build-fast Build the Docker image using Docker cache"
	@echo "  up         Start the RCP216 container"
	@echo "  down       Stop and remove the RCP216 container"
	@echo "  restart    Restart the RCP216 container"
	@echo "  ps         Show the RCP216 container status"
	@echo "  shell      Open a shell in the RCP216 environment"
	@echo "  jupyter    Start JupyterLab on port 8888"
	@echo "  python     Start Python"
	@echo "  pyspark    Start the PySpark shell"
	@echo "  spark      Show Spark version"
	@echo "  env        Show environment information"
	@echo "  logs       Show container logs"
	@echo "  clean      Stop containers and remove the local image"
	@echo ""

build:
ifeq ($(IN_CONTAINER),1)
	@echo "make build must be run from the host."
else
	$(COMPOSE) build --no-cache
endif

build-fast:
ifeq ($(IN_CONTAINER),1)
	@echo "make build-fast must be run from the host."
else
	$(COMPOSE) build
endif

up:
ifeq ($(IN_CONTAINER),1)
	@echo "make up must be run from the host."
else
	$(COMPOSE) up -d
endif

down:
ifeq ($(IN_CONTAINER),1)
	@echo "make down must be run from the host."
else
	$(COMPOSE) down
endif

restart:
ifeq ($(IN_CONTAINER),1)
	@echo "make restart must be run from the host."
else
	$(COMPOSE) down
	$(COMPOSE) up -d
endif

ps:
ifeq ($(IN_CONTAINER),1)
	@echo "make ps must be run from the host."
else
	$(COMPOSE) ps
endif

shell:
ifeq ($(IN_CONTAINER),1)
	@bash
else
	$(COMPOSE) exec $(SERVICE) bash
endif

jupyter:
ifeq ($(IN_CONTAINER),1)
	@jupyter lab --ip=0.0.0.0 --port=8888 --no-browser
else
	$(COMPOSE) exec $(SERVICE) jupyter lab --ip=0.0.0.0 --port=8888 --no-browser
endif

python:
ifeq ($(IN_CONTAINER),1)
	@python
else
	$(COMPOSE) exec $(SERVICE) python
endif

pyspark:
ifeq ($(IN_CONTAINER),1)
	@pyspark
else
	$(COMPOSE) exec $(SERVICE) pyspark
endif

spark:
ifeq ($(IN_CONTAINER),1)
	@spark-submit --version
else
	$(COMPOSE) exec $(SERVICE) spark-submit --version
endif

env:
ifeq ($(IN_CONTAINER),1)
	@echo ""
	@echo "RCP216 environment"
	@echo ""

	@echo "Python:"
	@python --version
	@echo ""

	@echo "Python executable:"
	@which python
	@echo ""

	@echo "Java:"
	@java -version
	@echo ""

	@echo "PySpark:"
	@python -c "import pyspark; print(pyspark.__version__)"
	@echo ""

	@echo "Spark NLP:"
	@python -c "import sparknlp; print(sparknlp.version())"
	@echo ""

	@echo "GraphFrames:"
	@python -c "from graphframes import GraphFrame; print('OK')"
	@echo ""

	@echo "Python data science libraries:"
	@python -c "import numpy; print('NumPy:', numpy.__version__)"
	@python -c "import pandas; print('Pandas:', pandas.__version__)"
	@python -c "import matplotlib; print('Matplotlib:', matplotlib.__version__)"
	@python -c "import sklearn; print('scikit-learn:', sklearn.__version__)"
	@python -c "import polars; print('Polars:', polars.__version__)"
	@python -c "import plotly; print('Plotly:', plotly.__version__)"
	@echo ""

	@echo "JupyterLab:"
	@jupyter lab --version
	@echo ""

else
	@echo ""
	@echo "RCP216 environment"
	@echo ""

	@echo "Python:"
	@$(COMPOSE) exec $(SERVICE) python --version
	@echo ""

	@echo "Python executable:"
	@$(COMPOSE) exec $(SERVICE) which python
	@echo ""

	@echo "Java:"
	@$(COMPOSE) exec $(SERVICE) java -version
	@echo ""

	@echo "PySpark:"
	@$(COMPOSE) exec $(SERVICE) python -c "import pyspark; print(pyspark.__version__)"
	@echo ""

	@echo "Spark NLP:"
	@$(COMPOSE) exec $(SERVICE) python -c "import sparknlp; print(sparknlp.version())"
	@echo ""

	@echo "GraphFrames:"
	@$(COMPOSE) exec $(SERVICE) python -c "from graphframes import GraphFrame; print('OK')"
	@echo ""

	@echo "Python data science libraries:"
	@$(COMPOSE) exec $(SERVICE) python -c "import numpy; print('NumPy:', numpy.__version__)"
	@$(COMPOSE) exec $(SERVICE) python -c "import pandas; print('Pandas:', pandas.__version__)"
	@$(COMPOSE) exec $(SERVICE) python -c "import matplotlib; print('Matplotlib:', matplotlib.__version__)"
	@$(COMPOSE) exec $(SERVICE) python -c "import sklearn; print('scikit-learn:', sklearn.__version__)"
	@$(COMPOSE) exec $(SERVICE) python -c "import polars; print('Polars:', polars.__version__)"
	@$(COMPOSE) exec $(SERVICE) python -c "import plotly; print('Plotly:', plotly.__version__)"
	@echo ""

	@echo "JupyterLab:"
	@$(COMPOSE) exec $(SERVICE) jupyter lab --version
	@echo ""
endif

logs:
ifeq ($(IN_CONTAINER),1)
	@echo "make logs must be run from the host."
else
	$(COMPOSE) logs -f $(SERVICE)
endif

clean:
ifeq ($(IN_CONTAINER),1)
	@echo "make clean must be run from the host."
else
	$(COMPOSE) down --remove-orphans
	docker image rm rcp216:latest 2>/dev/null || true
endif

