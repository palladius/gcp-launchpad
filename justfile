
# shows available tasks
list:
    just -l

# serve-onramp:
#     @echo "Starting server for onramp presentation..."
#     @echo "Navigate to http://localhost:8000/onramp/onramp.html"
#     @python3 -m http.server 8000
serve-onramp:
    @echo "Starting server for onramp presentation..."
    @echo "Navigate to http://localhost:8000/onramp/onramp.html"
    @python3 -m http.server 8000

serve-index:
    npm start

onramp:
    npm start -- --port=8080 --cwd onramp-new/  2>&1 | tee log/onramp.geminilog

start-images:
    npm start -- --port=8081 --cwd onramp-images/  2>&1 | tee log/onramp-images8081.geminilog


start-images-with-onramp-url:
    ONRAMP_URL=https://example.com/reclaim/from-justfile just start-images


check-deployment-logs:
    bash bin/gh-logs.sh
