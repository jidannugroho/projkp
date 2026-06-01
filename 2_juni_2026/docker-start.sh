#!/bin/sh

# Docker startup script for frontend

echo "Starting Asset Core Frontend"
echo "API URL: ${VITE_API_URL:-http://localhost:5001}"
echo "Socket URL: ${VITE_SOCKET_URL:-http://localhost:5001}"

# Start serve
exec serve -s dist -l 8080
