API_URL="http://localhost:8000/predict"
#!/bin/bash

CONTAINER_NAME="temp_ml_container"

echo "Sending Valid Request..."

VALID_RESPONSE=$(docker exec $CONTAINER_NAME curl -s -w "\n%{http_code}" \
-X POST http://localhost:8000/predict \
-H "Content-Type: application/json" \
-d @tests/valid.json)

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
-d @tests/invalid.json)

INVALID_BODY=$(echo "$INVALID_RESPONSE" | head -n1)
INVALID_STATUS=$(echo "$INVALID_RESPONSE" | tail -n1)

echo "Invalid Response: $INVALID_BODY"
echo "Status Code: $INVALID_STATUS"

if [ "$INVALID_STATUS" == "200" ]; then
  echo "Invalid request should not succeed!"
  exit 1
fi

echo "Invalid request test passed."