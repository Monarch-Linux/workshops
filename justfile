default: build-and-copy

format:
    nix fmt

build:
    nix build
    @echo "Build completed."

copy:
    @if [ ! -d result ]; then \
        echo "Error: 'result' directory does not exist. Run 'just build' first."; \
        exit 1; \
    fi
    @mkdir -p lessons
    cp -R result/* lessons/
    @echo "Files copied to lessons."
    @echo "Adjusting file permissions and ownership..."
    chmod -R u+w lessons/
    @chown -R --reference=lessons lessons/
    @echo "Permissions and ownership adjusted."

build-and-copy: build copy
    @echo "Build and copy completed."
