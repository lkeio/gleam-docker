# Gleam Docker

This repository includes Dockerfile and Docker Compose setups for Gleam environments. It provides a script that manages tasks like starting and stopping containers, handling Gleam projects, and executing commands for tests, formatting, and more.

## Prerequisites

Make sure Docker and Docker Compose are installed on your machine.

## Getting Started

Clone your project repository and navigate to the project directory:

```bash
git clone <repository-url>
cd <project-directory>
```

## Usage Instructions

The script provides several commands to manage the Docker environment:

```bash
./gleam.sh new <project_name>           # Creates a new Gleam project
./gleam.sh up                           # Starts the Docker container
./gleam.sh down                         # Stops the Docker container
./gleam.sh build [version]              # Builds the Docker container with an optional specified version
./gleam.sh run <project_name>           # Runs the specified Gleam project
./gleam.sh test <project_name>          # Runs tests for the specified project
./gleam.sh format <project_name>        # Formats code in the specified project
./gleam.sh bash                         # Opens a bash shell in the container
```

## Examples

To create a new project named `my_app`:

```bash
./gleam.sh new my_app
```

To run the `my_app` project:

```bash
./gleam.sh run my_app
```

To build the Docker container with a specific version of Gleam:

```bash
./gleam.sh build 1.1.0
```

To enter the Docker container using bash:

```bash
./gleam.sh bash
```
