
# shows available tasks
list:
    just -l

serve-onramp:
    @echo "Starting server for onramp presentation..."
    @echo "Navigate to http://localhost:8000/onramp.html"
    @cd onramp && python3 -m http.server 8000
