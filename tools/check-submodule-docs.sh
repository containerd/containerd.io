#!/bin/bash

#   Copyright The containerd Authors.

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


set -e

COMMAND=$1

case "$COMMAND" in
    record)
        while read -r line; do
            hash=$(echo "$line" | grep -oE '[0-9a-f]{40}')
            path=$(echo "$line" | awk '{print $2}')
            if [ -n "$hash" ] && [ -n "$path" ]; then
                echo "$path $hash"
            fi
        done < <(git submodule status)
        ;;
    check)
        STATE_FILE=$2
        REPORT_FILE=$3
        if [ ! -f "$STATE_FILE" ]; then
            echo "Error: State file $STATE_FILE not found" >&2
            exit 2
        fi

        [ -n "$REPORT_FILE" ] && rm -f "$REPORT_FILE"

        declare -A old_hashes
        while read -r line; do
            path=$(echo "$line" | awk '{print $1}')
            hash=$(echo "$line" | awk '{print $2}')
            old_hashes["$path"]="$hash"
        done < "$STATE_FILE"

        has_relevant_changes=false

        while read -r line; do
            new_hash=$(echo "$line" | grep -oE '[0-9a-f]{40}')
            path=$(echo "$line" | awk '{print $2}')
            old_hash=${old_hashes["$path"]}

            if [ -n "$old_hash" ] && [ "$new_hash" != "$old_hash" ]; then
                echo "Submodule $path updated: $old_hash -> $new_hash"
                diff_output=$(git -C "$path" diff "$old_hash" "$new_hash" --name-only 2>/dev/null | grep -E "^(docs/|README\.md)" || true)
                if [ -n "$diff_output" ]; then
                    echo "--> Relevant changes found in $path"
                    has_relevant_changes=true
                    if [ -n "$REPORT_FILE" ]; then
                        echo "#### $path" >> "$REPORT_FILE"
                        echo "$diff_output" | sed 's/^/- /' >> "$REPORT_FILE"
                        echo "" >> "$REPORT_FILE"
                    fi
                fi
            fi
        done < <(git submodule status)

        if [ "$has_relevant_changes" = true ]; then
            echo "Result: Relevant changes detected."
            exit 0
        else
            echo "Result: No relevant changes."
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 {record|check [state_file]}" >&2
        exit 3
        ;;
esac
