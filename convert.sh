#!/bin/bash

# Set colors
GREEN='\033[1;32m'
RED='\033[1;31m'
ORANGE='\033[1;33m'
NC='\033[0m' # No Color

usage() {
  echo "Usage: $0 path"
  echo "Convert all .mkv files in the given path to .mp4 files."
  echo "The path must be a directory."
  echo "Example: $0 /home/user/videos"
}

check_mp4(){

    local dir="$1"
    local thin_name=""

    for file in "$dir"/*.mp4; do
        if [ -f "$file" ]; then

        thin_name=$(sed 's/.*\///' <<< "$file")
        echo -e "${ORANGE}[INFO] ${NC}: Already mp4 file $thin_name."
        fi
    done
}

# Check if the user has given a path
if [ -d "$1" ]; then
  directory="$1"

    # List all .mkv files in the given path
    for file in "$directory"/*.mkv; do
        # Check if the file exists
        if [ -f "$file" ]; then
        # Get the file name without the extension
        file_name="${file%.*}"
        mp4_file="${file_name}.mp4"

        thin_name_mkv=$(sed 's/.*\///' <<< "$file_name")
        thin_name_mp4=$(sed 's/.*\///' <<< "$mp4_file")

        # Check if the .mp4 file already exists
        if [ -f "$mp4_file" ]; then
            echo -e "${ORANGE}[INFO] ${NC}: The file $thin_name_mp4 already converted (mkv|mp4). Skipping..."
        else
            read -p "$(echo -e "${ORANGE}Do you want to convert $thin_name ? (o/n) :${NC}")" choice
            if [[ $choice == "o" ]]; then
            ffmpeg -i "$file" -codec copy "$mp4_file"

            # Check if the conversion was successful
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}[INFO] ${NC}: The file $file has been converted in $mp4_file"
            else
                echo -e "${RED}[ERROR] ${NC}: Error when converting... $file"
            fi
            else
            echo -e "${RED}[INFO] ${NC}: Abort the conversion.$fichier"
            fi

            read -p "Do you want to convert the next file ? (o/n) : " response
            if [[ $response != "o" ]]; then
            echo -e "${RED}[INFO] ${NC}: Stop the script."
            check_mp4 "$directory"
            exit 0
            fi
        fi
        fi
    done
else
  echo -e "${RED}[INFO] ${NC}: The path is not a directory."
fi
