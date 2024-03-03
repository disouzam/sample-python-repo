#!/bin/bash
date
# Uncomment line below if you need to debug this script
# set -o xtrace
PS4='${LINENO}: '

# This function assumes that we are at one level below repository root folder
function getrootrepositoryfolder(){
    
    # Record current folder where this script is executed to return to it later
    currentfolder=$PWD
    
    # # Up one level
    # cd ..

    # Store the root directory
    value=`echo $PWD`

    # Go back to initial folder
    cd $currentfolder

    # Return value
    echo "$value"
}

function readPythonPath(){
    value=`cat pythonPath.txt`
    echo "$value"
}

function readPythonVersion(){
    value=`cat pythonVersion.txt`
    echo "$value"
}

# This function assumes that you launched this script from folder python
function createEnvironment(){
    currentDirectory=$(pwd)

    # https://stackoverflow.com/questions/19858600/accessing-last-x-characters-of-a-string-in-bash/19858692#19858692
    folder=${currentDirectory:(-18)}

    if [[ "$folder" != "sample-python-repo" ]]
    then
        echo "Error creating .venv312. Current folder is not sample-python-repo. Current folder:": $currentDirectory
        exit 1
    fi

    if [[ -z $1 ]];
    then
        echo "Error creating .venv312. Provide the path to Python executable"
        echo "Example:"
        echo "bash create_python3.12_environment.sh "C:\\Program Files\\Python312\\python.exe""
        exit 1
    fi

    pythonVersion=$("$1" --version)
    echo "pythonVersion: " $pythonVersion

    if [[ ${pythonVersion:(-6)} != "$2" ]]
    then
        echo "Incorrect Python version. Repository is set to work with Python" "$2"
        echo "Current version: " $pythonVersion
        exit 1
    fi

    "$1" -m venv $destinationFolder

    touch $destinationFolder/.gitignore
    echo "*" > $destinationFolder/.gitignore
}

repositoryrootfolder=$(getrootrepositoryfolder)
destinationFolder="${repositoryrootfolder%/}/.venv312"
pythonPath=$(readPythonPath)
pythonVersion=$(readPythonVersion)
createEnvironment "$pythonPath" "$pythonVersion"
echo "Virtual environment created successfully at folder : $destinationFolder"