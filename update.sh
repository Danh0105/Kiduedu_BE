#!/bin/bash
#!echo "🌀 Pulling latest code..."
#!git pull

#!echo "🛠 Building NestJS..."
npm run build

echo "🐳 Rebuilding Docker image..."
docker compose build

echo "🚀 Restarting containers..."
docker compose up -d

echo "✅ Update complete!"
