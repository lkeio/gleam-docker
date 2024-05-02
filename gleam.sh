#!/bin/bash

# This script manages Docker operations for Gleam projects

# Default Gleam version
DEFAULT_GLEAM_VERSION=1.1.0

show_help() {
    echo "Usage: $0 <command> [<project_name>] [<args>]"
    echo ""
    echo "Commands:"
    echo "  new <project_name>    Create a new Gleam project."
    echo "  up                    Start the Docker container."
    echo "  down                  Stop the Docker container."
    echo "  build [version]       Build the Docker container with a specified or default Gleam version."
    echo "  run <project_name>    Run the Gleam project."
    echo "  test <project_name>   Run tests in the Gleam project."
    echo "  format <project_name> Format the Gleam project code."
    echo "  bash                  Access the project directory via bash in the Docker container."
    echo ""
    echo "Examples:"
    echo "  $0 new my_app         Create a new project named 'my_app'."
    echo "  $0 run my_app         Run the application 'my_app'."
    echo "  $0 bash               Enter the project directory inside the container using bash."
}

check_dependencies() {
    if ! command -v docker &> /dev/null; then
        echo "Docker could not be found. Please install Docker."
        exit 1
    fi
    if ! command -v docker compose &> /dev/null; then
        echo "Docker Compose could not be found. Please install Docker Compose."
        exit 1
    fi
}

start_container() {
    if [ "$(docker compose ps -q erlang_gleam_app | wc -l)" -eq 0 ]; then
        echo "Building and starting the Docker container..."
        docker compose up -d --build
    fi
}

build_container_with_version() {
    local version=${2:-$DEFAULT_GLEAM_VERSION}

    # Check if the container is already running and stop it
    echo "Checking if the container is running..."
    if [ "$(docker compose ps -q erlang_gleam_app | wc -l)" -ne 0 ]; then
        echo "Stopping the already running container..."
        docker compose down
    fi

    # Proceed to build the new container with the specified Gleam version
    echo "Building Docker container with Gleam version $version..."
    docker build --build-arg GLEAM_VERSION=$version -t erlang_gleam_app .
}

create_new_project() {
    local project_name=$2
    if [ -z "$project_name" ]; then
        echo "Please specify a project name."
        exit 1
    fi
    if [ -d "./$project_name" ]; then
        echo "Directory $project_name already exists. Please choose a different name."
        exit 1
    fi
    echo "Creating a new Gleam project named $project_name..."
    docker compose exec erlang_gleam_app gleam new $project_name
    echo "Project $project_name created successfully."
}

execute_in_app() {
    local command=$1
    local project_name=$2
    if [ ! -d "$project_name" ]; then
        echo "Project directory $project_name does not exist."
        exit 1
    fi
    docker compose exec erlang_gleam_app sh -c "cd /app/$project_name && gleam $command"
}

# Entry point for command execution
case "$1" in
    new)
        check_dependencies
        start_container
        create_new_project "$@"
        ;;
    up)
        check_dependencies
        start_container
        ;;
    down)
        docker compose down
        ;;
    build)
        check_dependencies
        build_container_with_version "$@"
        ;;
    run|test|format)
        if [ -z "$2" ]; then
            echo "Please specify a project name."
            exit 1
        fi
        check_dependencies
        start_container
        execute_in_app "$1" "$2"
        ;;
    bash)
        check_dependencies
        start_container
        docker compose exec -it erlang_gleam_app bash
        ;;
    *)
        show_help
        ;;
esac
