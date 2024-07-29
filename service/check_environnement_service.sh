function check_kubectl() {
    if ! command -v kubectl &> /dev/null
    then
        log_error "kubectl could not be found. Please install kubectl and try again."
        exit 1
    fi
}

function check_figlet() {
    if ! command -v figlet &> /dev/null
    then
        log_verbose "This scripts uses figlet to display some messages. Please install figlet for better experience."
        exit 1
    fi
}


log_verbose "Checking kubectl..."
check_kubectl
check_figlet
log_success "Everything is fine ✅"