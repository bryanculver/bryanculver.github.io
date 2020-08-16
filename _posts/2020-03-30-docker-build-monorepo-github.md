---
title: "Build Monorepo of Docker Images with Make & GitHub Actions"
description: "Monorepos are great for building and maintaining a bunch of small microservices. Here is a way to build a collection of Docker images both locally and in a CI/CD pipline with Make & GitHub Actions"
---
Typically I'm a big fan of every app having a separate repo. However many times in the early phases of a project a monorepo can make more sense as a small team is building out the core infrastructure of a platform.

Several GitHub Actions already exist to build a repo's Docker image but large in part they assume everything to be in `.`, aka the current, top-level directory.

This strategy I will show you will additionally allow you to build a monorepo of Docker images via any command line by running just `make`.

## Directory Structure

Let's start with the directory structure and then we'll walk through the components:
```sh
➜ tree
.
├── .github
│   └── workflows
│       └── main.yml
├── Makefile
├── README.md
├── app
│   └── example
│       ├── Dockerfile
│       └── ...
└── platform
    ├── proxy
    │   ├── Dockerfile
    │   └── ...
    ├── service-mon
    │   ├── Dockerfile
    │   └── ...
    └── ...
```

Keeping the location and depth of Dockerfiles consistent is a key to how this works. In this setup the names of the Docker images will be inferred from their folder names. So in the example above three images will be made:

- app-example
- platform-proxy
- platform-service-mon

If you have already published these images into DockerHub, you might want to adapt this setup to source a name from a dot file in the folders themselves. There is nothing special when it comes to the Dockerfiles themselves.

The first piece of the magic is the `Makefile`, something all projects should get back into the habit of making. In this example the default command (just running `make`) will build these images but you can easily adapt it to make it be a command of the `make` command.

## The Makefile
```makefile
GIT_SHA1 = $(shell git rev-parse --verify HEAD)
IMAGES_TAG = ${shell git describe --exact-match --tags 2> /dev/null || echo 'latest'}
IMAGE_PREFIX = my-super-awesome-monorepo-

IMAGE_DIRS = $(wildcard app/* platform/*)

# All targets are `.PHONY` ie allways need to be rebuilt
.PHONY: all ${IMAGE_DIRS}

# Build all images
all: ${IMAGE_DIRS}

# Build and tag a single image
${IMAGE_DIRS}:
	$(eval IMAGE_NAME := $(subst /,-,$@))
	docker build -t ${DOCKERHUB_OWNER}/${IMAGE_PREFIX}${IMAGE_NAME}:${IMAGES_TAG} -t ${DOCKERHUB_OWNER}/${IMAGE_PREFIX}${IMAGE_NAME}:latest --build-arg TAG=${IMAGE_PREFIX}${IMAGE_NAME} --build-arg GIT_SHA1=${GIT_SHA1} $@
	docker push ${DOCKERHUB_OWNER}/${IMAGE_PREFIX}${IMAGE_NAME}:${IMAGES_TAG}
	docker push ${DOCKERHUB_OWNER}/${IMAGE_PREFIX}${IMAGE_NAME}:latest
```

There is only one variable expected to be set in this Makefile and that's `DOCKERHUB_OWNER`. This is the top-level nesting of where these Docker images will be uploaded to. This will be supplied by the GitHub Actions workflow later but if you intend to also run this on the command line occasionally you should not only login to the registry by running `docker login` but also set `DOCKERHUB_OWNER` either in your personal environment variable or use something like [direnv](https://direnv.net/).

Depending on your directory structure, you will likely need to change `IMAGE_DIRS` to include the top level directory where your Dockerfiles will be.

Another customizable piece is the `IMAGE_PREFIX`. If you would like to keep all of your monorepo images together visually, you can supply a prefix to be prepended to the image name. With everything defined as above, the images would be named:

- my-super-awesome-monorepo-app-example
- my-super-awesome-monorepo-platform-proxy
- my-super-awesome-monorepo-platform-service-mon

Images will be built and pushed with both the tag `latest` as well as a Git version tag.

Now we could stop here and you already have an ability to rapidly build and push Docker images. However if you are working on a team you likely want this to be done by a somewhat central authority ensure the builds are consistent and secure.

That's where GitHub Actions comes in.

## GitHub Actions Workflow File
```yaml
name: CI

on:
  push:
    branches: [ master ]
    tags: [ v* ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Login to DockerHub Registry
      run: echo ${{"{{"}} secrets.DOCKERHUB_PASSWORD }} | docker login -u ${{"{{"}} secrets.DOCKERHUB_USERNAME }} --password-stdin

    - name: Build & Push Docker Images
      env:
        DOCKERHUB_OWNER: ${{"{{"}} secrets.DOCKERHUB_USERNAME }}
      run: make
```

This will trigger the GitHub Actions workflow on all pushes to the `master` branch (note: merges to branches after PRs are considered pushes, don't push to master directly) as well as any tags pushed beginning with `v`. The triggers [can be customized](https://help.github.com/en/actions/reference/events-that-trigger-workflows).

This leverages the [secrets storage in GitHub](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets) to securely store the username and password for the DockerHub login.

Since I am publishing this under my account in this example, I just mapped the `DOCKERHUB_OWNER` environment variable to my user from the secrets but this could easily be overridden to an organization or other owner.


Put it all together and you can now neatly and quickly build a monorepo of Docker images with `make` and GitHub Actions!

Since this solution largely uses `make` to do the building and pushing you can also use other CI/CD pipelines like [CirlceCI](https://circleci.com/docs/2.0/hello-world/) or [GitLab](https://docs.gitlab.com/ee/ci/pipelines/index.html).

