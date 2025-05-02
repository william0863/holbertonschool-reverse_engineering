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
magic_number=$(hexdump -n 16 -e '16/1 "%02x "' "$file_name" | sed 's/ $//')
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2}' | tr -d ' ')
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk '{print $(NF-1), $NF}' | sed 's/,//g' | tr -s ' ')
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# Display using function
display_elf_header_info

