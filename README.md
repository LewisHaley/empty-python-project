# Empty Python Project

This is an empty Python project, setup with linting and unit test config, requirements,
and a Makefile and docker setup for running CI.

To start using it, copy the file tree, then rename `src/empty_project` to whatever you
want to call your new project. This will also need to be changed in:
* pyproject.toml
* tests/test_ci.py
* docker-compose.yaml

All other names (such as CI targets, docker-compose targets) are generic so as
to not need changes when creating a new project.

## Development

### Running CI

While developing, there are CI targets to maintain standards. Native running with a
virtual environment and containerised running with Docker are both supported.
For native:

    $ make ci

This will create the virtual environment and run all the CI targets.

For docker:

    $ docker compose build ci
    $ docker compose run --rm ci

This will build the docker image and then run all the CI targets.

There are separate targets for each CI component under `make` and `docker compose`.

### Updating requirements

When updating requirements, either primary or extra, modify the pyproject.toml file
with the updated dependency and then run:

    $ docker compose run --rm --build requirements.prod.txt
    $ docker compose run --rm --build requirements.dev.txt

The dependencies for maintaining the pinned dependencies are captured within
Dockerfile.piptools, acting as a bootstrap environment.

To upgrade existing dependencies, you can do:

    $ docker compose run --rm --build requirements.prod.txt python -m piptools compile --output-file=requirements.prod.txt -P <the-package> [-P <another-package>]

The same applies for `requirements.dev.txt`.

## Running the production app

Some minimal configuration is provided for running the "production" app via a docker
compose target, where only the production dependencies are installed. Note that the
provided Python code in the empty app does not support being executed.
