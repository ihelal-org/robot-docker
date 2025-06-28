#!/bin/bash

echo "🔨 Building Docker image 'ros1-container'..."

docker build -t ros1-container -f docker/Dockerfile .

echo "✅ Build complete."
