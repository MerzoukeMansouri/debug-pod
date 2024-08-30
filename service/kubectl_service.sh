filter_and_select_namespace() {
    if [ -z "$1" ]; then
        read namespace_filter
    else
        namespace_filter=$1
    fi
    if [ -z "$namespace_filter" ]; then
        namespaces=$(kubectl get namespaces -o jsonpath="{.items[*].metadata.name}" 2>/dev/null)
    else
        namespaces=$(kubectl get namespaces -o jsonpath="{.items[*].metadata.name}" 2>/dev/null | tr ' ' '\n' | grep "$namespace_filter")
    fi

    if [ -z "$namespaces" ]; then
        exit 1
    fi

    namespaces=$(echo $namespaces | tr '\n' ' ')
    IFS=' ' read -r -a namespace_array <<< "$namespaces"

    select_option "${namespace_array[@]}"
}

select_pod_in_namespace() {
    local namespace=$1
    pods=$(kubectl get pods -n "$namespace" -o jsonpath="{.items[*].metadata.name}" 2>/dev/null)

    if [ -z "$pods" ]; then
        exit 1
    fi

    IFS=' ' read -r -a pod_array <<< "$pods"
    select_option "${pod_array[@]}"
}

start_debug_pod() {
    local selected_namespace=$1
    local selected_pod=$2
    local debug_image=$3
    kubectl debug -n "$selected_namespace" "$selected_pod" -it --image="$debug_image" --share-processes
}
