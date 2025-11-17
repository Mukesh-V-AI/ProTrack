#!/bin/bash

# EngiTrack Docker Deployment Script
# This script helps build and deploy the EngiTrack Flutter web app

set -e

echo "🚀 EngiTrack Docker Deployment Script"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker Compose not found. Using docker commands instead.${NC}"
    USE_COMPOSE=false
else
    USE_COMPOSE=true
fi

# Function to build the image
build_image() {
    echo -e "${GREEN}📦 Building Docker image...${NC}"
    docker build -t engitrack:latest .
    echo -e "${GREEN}✅ Build complete!${NC}"
}

# Function to run with docker-compose
run_compose() {
    echo -e "${GREEN}🐳 Starting with Docker Compose...${NC}"
    docker-compose up -d --build
    echo -e "${GREEN}✅ Container started!${NC}"
    echo -e "${YELLOW}📱 Access the app at: http://localhost:8080${NC}"
}

# Function to run with docker
run_docker() {
    echo -e "${GREEN}🐳 Starting Docker container...${NC}"
    docker run -d -p 8080:80 --name engitrack-web engitrack:latest
    echo -e "${GREEN}✅ Container started!${NC}"
    echo -e "${YELLOW}📱 Access the app at: http://localhost:8080${NC}"
}

# Function to stop container
stop_container() {
    echo -e "${YELLOW}🛑 Stopping container...${NC}"
    if [ "$USE_COMPOSE" = true ]; then
        docker-compose down
    else
        docker stop engitrack-web 2>/dev/null || true
        docker rm engitrack-web 2>/dev/null || true
    fi
    echo -e "${GREEN}✅ Container stopped!${NC}"
}

# Function to view logs
view_logs() {
    echo -e "${GREEN}📋 Viewing logs...${NC}"
    if [ "$USE_COMPOSE" = true ]; then
        docker-compose logs -f
    else
        docker logs -f engitrack-web
    fi
}

# Function to check status
check_status() {
    echo -e "${GREEN}📊 Container status:${NC}"
    if [ "$USE_COMPOSE" = true ]; then
        docker-compose ps
    else
        docker ps -a | grep engitrack-web || echo "No container found"
    fi
}

# Main menu
case "${1:-build}" in
    build)
        build_image
        ;;
    run)
        if [ "$USE_COMPOSE" = true ]; then
            run_compose
        else
            build_image
            run_docker
        fi
        ;;
    stop)
        stop_container
        ;;
    logs)
        view_logs
        ;;
    status)
        check_status
        ;;
    restart)
        stop_container
        sleep 2
        if [ "$USE_COMPOSE" = true ]; then
            run_compose
        else
            run_docker
        fi
        ;;
    clean)
        echo -e "${YELLOW}🧹 Cleaning up...${NC}"
        stop_container
        docker rmi engitrack:latest 2>/dev/null || true
        docker system prune -f
        echo -e "${GREEN}✅ Cleanup complete!${NC}"
        ;;
    *)
        echo "Usage: $0 {build|run|stop|logs|status|restart|clean}"
        echo ""
        echo "Commands:"
        echo "  build    - Build the Docker image"
        echo "  run      - Build and run the container"
        echo "  stop     - Stop the container"
        echo "  logs     - View container logs"
        echo "  status   - Check container status"
        echo "  restart  - Restart the container"
        echo "  clean    - Stop and remove containers/images"
        exit 1
        ;;
esac

