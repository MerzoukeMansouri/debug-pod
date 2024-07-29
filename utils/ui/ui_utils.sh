select_option() {
    PS3='Please enter your choice: '
    select opt in "$@"
    do
        if [ -n "$opt" ]; then
            echo "$opt"
            break
        else
            log_warning "Invalid selection. Please try again."
        fi
    done
}