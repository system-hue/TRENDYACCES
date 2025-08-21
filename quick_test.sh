#!/bin/bash

# Quick curl tests for Trendy Backend API
# Run individual commands or all at once

BASE_URL="http://localhost:8000"

echo "🚀 Quick API Tests"

# Basic health
echo "Testing health..."
curl -s "$BASE_URL/health" | jq .

# Root endpoint
echo "Testing root..."
curl -s "$BASE_URL/" | jq .

# Posts
echo "Testing posts..."
curl -s "$BASE_URL/api/posts" | jq '.[0:3]'

# Users
echo "Testing users..."
curl -s "$BASE_URL/api/users/1" | jq .

# API info
echo "Testing API info..."
curl -s "$BASE_URL/api" | jq .

echo "✅ Quick tests completed!"
