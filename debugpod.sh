#!/bin/bash
source ./utils/ui/style_utils.sh
source ./help/display_help.sh
source ./service/log_service.sh
source ./service/check_environnement_service.sh
source ./service/kubectl_service.sh
source ./utils/ui/ui_utils.sh
source ./utils/strings_utils.sh

if [[ $1 == "--help" || $1 == "-h" ]]; then
    display_help
    exit 0
fi

# Filter and select namespace
log_information "Enter namespace filter (press Enter to list all namespaces):"
selected_namespace=$(filter_and_select_namespace $1)
log_and_exit_if_error "No namespaces found or you do not have permission to list namespaces."
selected_namespace=$(trim "$selected_namespace")
log_selected_value "$selected_namespace"


# Select pod in the selected namespace
selected_pod=$(select_pod_in_namespace "$selected_namespace")
log_and_exit_if_error "No pods found in namespace $namespace or you do not have permission to list pods."
selected_pod=$(trim "$selected_pod")
log_selected_value "$selected_pod"

# Prompt user to enter the image to use for debugging
read -p "${bold}${blue}Enter the image to use for debugging (e.g., debian): ${normal}" debug_image
debug_image=$(trim "$debug_image")
log_selected_value "$debug_image"

# Start the debug session
log_result "Starting debug session with image $debug_image for pod $selected_pod in namespace $selected_namespace..."
log_information "Press Enter to start the debug pod..."
read
start_debug_pod "$selected_namespace" "$selected_pod" "$debug_image"