#!/bin/bash

source ./messages.sh

file_name="$1"

# Check input
if [ -z "$file_name" ]; then
    echo "Usage: $0 <ELF file>"
    exit 1
fi

# Check if file exists
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist."
    exit 1
fi

# Check ELF file type
if ! readelf -h "$file_name" &> /dev/null; then
    echo "Error: '$file_name' is not a valid ELF file."
    exit 1
fi

# Extract information
magic_number=$(xxd -p -l 4 "$file_name" | sed 's/../& /g' | tr '[:lower:]' '[:upper:]')
class=$(readelf -h "$file_name" | grep "Class:" | awk '{$1=""; print $0}' | xargs)
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk '{$1=""; print $0}' | xargs)
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# Display using function
display_elf_header_info

