#!/bin/bash

# Function: folderSize
folderSize() {
    # Get the terminal width to make the bar responsive
    local terminal_width
    terminal_width=$(tput cols)
    if [ -z "$terminal_width" ] || [ "$terminal_width" -lt 60 ]; then
        terminal_width=80 # Set a sane default if tput fails
    fi

    # Set column widths based on terminal size
    local name_width=$((terminal_width / 2))
    local bar_width=$((terminal_width * 25 / 100))

    # Get disk usage in Kilobytes, sort, and remove the total line
    local du_command_output
    du_command_output=$(du -k --max-depth=1 . 2>/dev/null | sort -nr | tail -n +2)

    # ZSH/BASH compatibility for reading into an array
    # We use a workaround: split the output using read and store in array
    local sorted_data=()
    if [ -n "$du_command_output" ]; then
        # Read each line into array using read with IFS and while loop
        while IFS= read -r line; do
            if [ -n "$line" ]; then
                sorted_data+=("$line")
            fi
        done <<< "$du_command_output"
    fi

    if [ ${#sorted_data[@]} -eq 0 ]; then
        echo "No sub-directories found or accessible."
        return
    fi

    # Get max size for bar scaling from the first line of the sorted list
    local max_size_kb
    if [ -n "$ZSH_VERSION" ]; then
        max_size_kb=$(echo "${sorted_data[1]}" | awk '{print $1}') # ZSH is 1-based
    else
        max_size_kb=$(echo "${sorted_data[0]}" | awk '{print $1}') # BASH is 0-based
    fi

    # Validate max_size_kb is a number
    if ! [[ "$max_size_kb" =~ ^[0-9]+$ ]]; then
        max_size_kb=0
    fi

    local max_size_bytes=$((max_size_kb * 1024))
    if [ "$max_size_bytes" -eq 0 ]; then
        max_size_bytes=1 # Avoid division by zero
    fi

    # --- HELPER FUNCTIONS ---

    # CORRECTED human_readable function
    human_readable() {
        local bytes=$1
        local units=("Bytes" "KB" "MB" "GB" "TB" "PB")
        local i=0
        # Use bc to check if bytes >= 1024
        while [ "$(echo "$bytes >= 1024" | bc -l)" -eq 1 ] && [ $i -lt 5 ]; do
            bytes=$(echo "scale=2; $bytes / 1024" | bc)
            i=$((i + 1))
        done
        printf "%.2f %s\n" "$bytes" "${units[$i]}"
    }

    draw_bar() {
        local current_bytes=$1
        local max_bytes=$2
        local filled_blocks=0

        if (( $(echo "$current_bytes > 0" | bc -l) )); then
            filled_blocks=$(echo "scale=0; ($current_bytes * $bar_width) / $max_bytes" | bc)
        fi

        # Print filled blocks
        for ((j=0; j<filled_blocks; j++)); do
            printf "█"
        done
        # Print empty blocks
        for ((j=filled_blocks; j<bar_width; j++)); do
            printf "░"
        done
    }

    # --- MAIN OUTPUT ---

    local separator
    separator=$(printf "%${terminal_width}s" | tr ' ' '-')

    printf "\e[1m%-${name_width}s | %-${bar_width}s | %s\e[0m\n" "Folder" "Relative Size" "Size"
    printf "%.${terminal_width}s\n" "$separator"

    for line in "${sorted_data[@]}"; do
        if [ -z "$line" ]; then
            continue
        fi

        local size_kb=$(echo "$line" | awk '{print $1}')
        local size_bytes=$((size_kb * 1024))
        local name=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^[ \t]*\.\///')

        # Truncate name if too long
        if [ ${#name} -gt $((name_width - 3)) ]; then
            name="${name:0:$((name_width-3))}..."
        fi

        local human_size=$(human_readable "$size_bytes")
        printf "%-${name_width}s | " "$name"
        draw_bar "$size_bytes" "$max_size_bytes"
        printf " | %s\n" "$human_size"
    done
}

# Optional: Run the function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    folderSize
fi
