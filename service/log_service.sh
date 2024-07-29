log_verbose(){
    local text="$1"
    echo "📝 ${bold}${cyan} ${text} ${normal}"
}

log_information(){
    local text="$1" coucou
    echo "ℹ️ ${bold}${blue} ${text} ${normal}"
}

log_warning(){
    local text="$1"
    echo "⚠️ ${bold}${yellow} ${text} ${normal}"
}

log_error(){
    local text="$1"
    echo "❌ ${bold}${red} ${text} ${normal}"
}

log_success(){
    local text="$1"
    echo "✅ ${bold}${green} ${text} ${normal}"
}

log_selected_value() {
    local text="$1"
    if command -v figlet > /dev/null; then
    figlet "$1"
    else
        echo "${bold} $text${normal}"
    fi
   
}

log_result() {
    local text="$1"
    echo "🚀 ${bold}${green}$text${normal}"
}

log_and_exit_if_error() {
    if [ $? -ne 0 ]; then
        log_warning "$1"
        exit 1
    fi
}