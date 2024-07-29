#!/bin/bash

# Function to display help message in man style
function display_help {
cat << EOF
NAME
    debugpod - Launch a debug pod using kubectl

SYNOPSIS
    debugpod [FILTER]

DESCRIPTION
    This script launches a debug pod using kubectl. You can pass a FILTER argument for filtering and helping a namespace selection. 
    After selecting the namespace, the user is prompted to select the pod and the image to run.

OPTIONS
    FILTER
        A filter string to select the namespace.

    -h, --help
        Display this help message and exit.

EXAMPLES
    debugpod my-filter
        Launches kubectl with the namespace filtered by 'my-filter', then prompts for the pod name and image to run.

AUTHOR
    Written by M14i@adeo

REPORTING BUGS
    Report bugs merzouke.mansouri@ext.adeo.com

COPYRIGHT
    This is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License.
    There is NO WARRANTY, to the extent permitted by law.
EOF
}
