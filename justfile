
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
