# Docker Build Description

The `.docker` structure in this folder contains the following components:

- **production**: Test environment Docker components
  - `.env`: Environment variables for production environment
  - `command.sh`: Commands to be run in the production environment
  - `docker-compose.yaml`: Docker Compose file
- **test**: Test environment Docker components

  - `.env`: Environment variables for testing environment
  - `command.sh`: Commands to be run in the test environment
  - `docker-compose.yaml`: Docker Compose file

- **development**: Development environment Docker components
  - `.env`: Environment variables for the development environment
  - `command.sh`: Commands to be run in the development environment
  - `docker-compose.yaml`: Docker Compose file

# Docker Build Description

The `.docker` structure in this folder contains the following components:

- `Dockerfile.$DISTRIB_ID`: Docker file and Linux Distrib ID
- `Dockerfile.alpine`: Alpine based image
- `Dockerfile.debian`: Debian based image

* Build and run image:

Alpine Image:

test

```
docker build -t template-alpine-test \
    -f .docker/Dockerfile.alpine \
    --target test \
    --build-arg BASE_IMAGE=alpine:latest  \
    --build-arg PROJECT_FOLDER=/workspace/template  \
    --build-arg BUILD_PACKAGES="nasm binutils" \
    --build-arg TEST_PACKAGES="curl" \
    .

docker run -it --rm template-alpine-test
```

production

```
docker build -t template-alpine-production \
    -f .docker/Dockerfile.alpine \
    --target production \
    --build-arg BASE_IMAGE=alpine:latest  \
    --build-arg PROJECT_FOLDER=/workspace/template  \
    --build-arg BUILD_PACKAGES="nasm binutils" \
    --build-arg TEST_PACKAGES="curl" \
    .

docker run -it --rm template-alpine-production /universe
```

Debian Image:

test

```
docker build -t template-debian-test \
    -f .docker/Dockerfile.debian \
    --target test \
    --build-arg BASE_IMAGE=debian:stable  \
    --build-arg PROJECT_FOLDER=/workspace/template  \
    --build-arg BUILD_PACKAGES="nasm binutils" \
    --build-arg TEST_PACKAGES="curl" \
    .

docker run -it --rm template-debian-test
```

production

```
docker build -t template-debian-production \
    -f .docker/Dockerfile.debian \
    --target production \
    --build-arg BASE_IMAGE=debian:stable  \
    --build-arg PROJECT_FOLDER=/workspace/template  \
    --build-arg BUILD_PACKAGES="nasm binutils" \
    --build-arg TEST_PACKAGES="curl" \
    .

docker run -it --rm template-debian-production /universe
```

Explains how to get started with your project's development, testing, and production environments.

# production

1. Navigate to the `production` folder:
   ```bash
   cd .docker/production
   ```
2. Create the production environment variables file (.env):

   ```
   nano .env
   ```

   Edit the .env file with the required production environment variables.

3. Build and run the production environment:
   ```
   docker compose -f "docker-compose.yaml" up -d --build
   ```
