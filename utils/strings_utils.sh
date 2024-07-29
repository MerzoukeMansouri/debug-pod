trim() {
    echo "$1" | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}