#!/bin/bash

filter_and_select_namespace() {
    if [ -z "$1" ]; then
        read -p "Enter namespace filter: " namespace_filter
    else
        namespace_filter=$1
    fi

    if [ -z "$namespace_filter" ]; then
        namespaces=$(kubectl get namespaces -o jsonpath="{.items[*].metadata.name}" 2>/dev/null)
    else
        namespaces=$(kubectl get namespaces -o jsonpath="{.items[*].metadata.name}" 2>/dev/null | tr ' ' '\n' | grep "$namespace_filter")
    fi

    if [ -z "$namespaces" ]; then
        echo "No namespaces found."
        exit 1
    fi

    namespaces=$(echo $namespaces | tr '\n' ' ')
    IFS=' ' read -r -a namespace_array <<<"$namespaces"

    select_option "${namespace_array[@]}"
}

select_pod_in_namespace() {
    local namespace=$1
    pods=$(kubectl get pods -n "$namespace" -o jsonpath="{.items[*].metadata.name}" 2>/dev/null)

    if [ -z "$pods" ]; then
        echo "No pods found in namespace $namespace."
        exit 1
    fi

    IFS=' ' read -r -a pod_array <<<"$pods"
    select_option "${pod_array[@]}"
}

start_debug_pod() {
    local selected_namespace=$1
    local selected_pod=$2
    local debug_image=$3

    echo "Starting debug pod in namespace $selected_namespace for pod $selected_pod using image $debug_image..."

    kubectl debug -n "$selected_namespace" "$selected_pod" -it --image=debian --share-processes
}

select_option() {
    PS3="Select an option: "
    select opt in "$@"; do
        if [ -n "$opt" ]; then
            echo "$opt"
            return
        else
            echo "Invalid option"
        fi
    done
}

select_volume_and_start_debug_pod() {
    local selected_namespace=$1
    local selected_pod=$2
    local debug_image=$3

    echo "Fetching volumes for pod $selected_pod in namespace $selected_namespace..."

    volumes=$(kubectl get pod "$selected_pod" -n "$selected_namespace" -o jsonpath="{.spec.volumes[*].name}")

    if [ -z "$volumes" ]; then
        echo "No volumes found for pod $selected_pod."
        exit 1
    fi

    IFS=' ' read -r -a volume_array <<<"$volumes"
    echo "Select a volume to mount in the debug pod:"
    selected_volume=$(select_option "${volume_array[@]}")

    echo "Starting debug pod and mounting volume $selected_volume..."

    pvc_exists=$(kubectl get pvc "$selected_volume" -n "$selected_namespace" --ignore-not-found)

    # Generate a debug pod spec with the selected volume mounted
    kubectl run debug-$selected_pod -n "$selected_namespace" --rm -it --image="debian" --overrides='{
      "spec": {
        "containers": [{
          "name": "debug-container",
          "image": "'"$debug_image"'",
          "stdin": true,
          "tty": true,
          "volumeMounts": [{
            "name": "'"$selected_volume"'",
            "mountPath": "/mnt/volume"
          }]
        }],
        "volumes": [{
          "name": "'"$selected_volume"'",
          "persistentVolumeClaim": {
            "claimName": "'"$selected_volume"'"
          }
        }],
        "restartPolicy": "Never"
      }
    }' -- /bin/sh
}

# Example usage:
# 1. Select a namespace
selected_namespace=$(filter_and_select_namespace)
echo "Selected namespace: $selected_namespace"

# 2. Select a pod in the selected namespace
selected_pod=$(select_pod_in_namespace "$selected_namespace")
echo "Selected pod: $selected_pod"

# 3. Start debug pod and mount a volume
debug_image="busybox" # Specify your debug image here
select_volume_and_start_debug_pod "$selected_namespace" "$selected_pod" "$debug_image"
