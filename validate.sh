#!/bin/bash

CONTAINER_NAME="temp_ml_container"

VALID_JSON='{"feature1":5.1,"feature2":3.5,"feature3":1.4,"feature4":0.2}'
INVALID_JSON='{"feature1":"wrong"}'

echo "Sending Valid Request..."

VALID_RESPONSE=$(docker exec $CONTAINER_NAME curl -s -w "\n%{http_code}" \
-X POST http://localhost:8000/predict \
-H "Content-Type: application/json" \
-d "$VALID_JSON")

VALID_BODY=$(echo "$VALID_RESPONSE" | head -n1)
VALID_STATUS=$(echo "$VALID_RESPONSE" | tail -n1)

echo "Valid Response: $VALID_BODY"
echo "Status Code: $VALID_STATUS"

if [ "$VALID_STATUS" != "200" ]; then
  echo "Valid request failed!"
  exit 1
fi

if [[ $VALID_BODY != *"prediction"* ]]; then
  echo "Prediction field missing!"
  exit 1
fi

echo "Valid request passed."

echo "Sending Invalid Request..."

INVALID_RESPONSE=$(docker exec $CONTAINER_NAME curl -s -w "\n%{http_code}" \
-X POST http://localhost:8000/predict \
-H "Content-Type: application/json" \
-d "$INVALID_JSON")

INVALID_BODY=$(echo "$INVALID_RESPONSE" | head -n1)
INVALID_STATUS=$(echo "$INVALID_RESPONSE" | tail -n1)

echo "Invalid Response: $INVALID_BODY"
echo "Status Code: $INVALID_STATUS"

if [ "$INVALID_STATUS" == "200" ]; then
  echo "Invalid request should not succeed!"
  exit 1
fi

echo "Invalid request test passed."