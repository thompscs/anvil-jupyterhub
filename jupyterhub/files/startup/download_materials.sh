#!/bin/bash

# Step 1: Check if the user provided a URL
if [ -z "$COURSE_MATERIALS" ]; then
    echo "No URL provided. Exiting."
    exit 0
fi

# Step 2: Check if materials already exist
materials_directory="/home/jovyan/newmaterials"

if [ -d "$materials_directory" ]; then
    echo "Materials already exist. Exiting."
    exit 0
fi

# Step 3: Check if the URL matches a supported Git repository
if [[ "$COURSE_MATERIALS" =~ ^(https?://)?([^/]+/)*([^/]+/[^/]+)$ ]]; then
    # Step 4: Clone the Git repository into the materials directory
    git clone "$COURSE_MATERIALS" "$materials_directory"
    exit 0
fi

# Step 5: Download the file directly
wget -P "$materials_directory" "$COURSE_MATERIALS"

# Step 6: Determine the file type and process accordingly
file_type=$(mimetype -b "$materials_directory/$(basename "$COURSE_MATERIALS")")

if [[ "$file_type" == application/zip ]]; then
    # Step 7: Extract ZIP file
    unzip "$materials_directory/$(basename "$COURSE_MATERIALS")" -d "$materials_directory"
    exit 0
elif [[ "$file_type" == application/x-tar || "$file_type" == application/x-gzip ]]; then
    # Step 8: Extract TAR file
    tar -xf "$materials_directory/$(basename "$COURSE_MATERIALS")" -C "$materials_directory"
    exit 0
fi

# Step 9: Move the file to the materials directory as-is
mv "$materials_directory/$(basename "$COURSE_MATERIALS")" "$materials_directory"
