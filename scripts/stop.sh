#!/bin/bash

echo "🛑 Stopping and removing container 'ros1'..."

docker stop ros1 || true
docker rm ros1 || true

echo "✅ Container stopped and removed."
