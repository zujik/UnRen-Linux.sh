#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# UnRen.sh: UnRen for Linux and MacOS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --------------------------------------------------------------------------------
# START LICENSES
# --------------------------------------------------------------------------------
# unrpyc
# https://github.com/CensoredUsername/unrpyc
# ================================================================================
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# The license of codegen.py is included in the file itself.
#
# ================================================================================
# rpatool by Shizmob 9a58396 2019-02-22T17:31:07.000Z
# https://github.com/Shizmob/rpatool
# ================================================================================
# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# Version 2, December 2004
# 
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
# 
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
# 
# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
# 
# 0. You just DO WHAT THE FUCK YOU WANT TO.
#
# ================================================================================
# UnRen.sh
# https://github.com/zujik/UnRen.sh
# ================================================================================
# MIT License
# 
# Copyright (c) 2022 Troy Dallas
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# --------------------------------------------------------------------------------
# END LICENSES
# --------------------------------------------------------------------------------

# --------------------------------------------------------------------------------
# START CONTRIBUTIONS
# --------------------------------------------------------------------------------
# b64.file variables are Base64 encoded strings for unrpyc, rpatool
# unrpyc by CensoredUsername 2f9810c 2022-03-31 v1.1.8 (Python 2)
# https://github.com/CensoredUsername/unrpyc
# ================================================================================
# Added changes proposed by sigio for improved Ren'Py 7.5+ compatibility
# https://github.com/CensoredUsername/unrpyc/pull/154/files
#
# Edited to remove multiprocessing and adjust output spacing 44febb0 2019-10-07T07:06:47.000Z
# ================================================================================
# Based on UnRen.bat by Sam
# https://f95zone.to/threads/3083/
# https://github.com/F95Sam/UnRen
# https://github.com/F95Sam/unrpyc 
#
# Added changes from UnRen-ultrahack by VepsrP
# https://f95zone.to/threads/92717/
# https://f95zone.to/members/vepsrp.329951/
#
# Bash port of Windows script UnRen-ultrahack(vXX).bat by VepsrP
# https://github.com/VepsrP/UnRen-Gideon-mod-
# (https://f95zone.to/threads/92717) 
# --------------------------------------------------------------------------------
# END CONTRIBUTIONS
# --------------------------------------------------------------------------------

version = 2024.05.0001
version_date = "(20240502)"
quick_save_key="K_F5"
quick_load_key="K_F9"

# decompcab01=
# rpatool01
# unrenconsole01
# unrenquick01
# unrenskip01
# unrenrollback01=

# Function to check OS
function is_osx() {
    [ "$(uname)" == "Darwin" ]
}

# Function to check Python version
function get_python_version() {
    if command -v python3 &> /dev/null; then
        echo "python3"
    elif command -v python &> /dev/null; then
        echo "python2"
    else
        echo "none"
    fi
}

# Check OS
if is_osx; then
    os="MacOS"
    # MacOS function (replace with your MacOS specific logic)
    echo "Running on MacOS"
else
    os="Linux"
    # Linux function (replace with your Linux specific logic)
    echo "Running on Linux"
fi

# Check and install python3 if needed
python_version=$(get_python_version)
if [ "$python_version" == "none" ]; then
    if is_osx; then
        # Use Homebrew for MacOS
        echo "Python not found, installing python3 with Homebrew..."
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found! Script requires Homebrew for Python installation on MacOS."
            exit 1
        fi
        brew install python@3.11  # Update version as needed
    else
        # Use package manager for Linux (adapt based on your distro)
        echo "Python not found, installing python3 with apt..."
        sudo apt update && sudo apt install python3
    fi
    python_version="python3"
fi

# Now you can use the detected python version in your script
echo "Using Python: $python_version"

# Example usage (replace with your actual commands)
$python_version --version

# Array of filenames (replace with your actual filenames)
filenames=(
  "decompcab"
  "rpatool"
  "unrenconsole"
  "unrenquick"
  "unrenskip"
  "unrenrollback"
)

# Function to decode base64 and write to file
function decode_and_write() {
    base64_string="$1"
    index="$2"

    # Decode the base64 string
    decoded_data=$(echo "$base64_string" | base64 --decode)

    # Check if decoding was successful (avoid empty files)
    if [ $? -eq 0 ] && [ -n "$decoded_data" ]; then
        filename="${filenames[$index]}"
        echo "Writing to file: $filename"
        # Write the decoded data to the file
        echo "$decoded_data" > "$filename"
    else
        echo "Error decoding: $base64_string (Skipping)"
    fi
}

# Read the base64 encoded file line by line (assuming one line per file)
line_number=0
while IFS= read -r base64_string; do
    # Echo the line being processed for confirmation
    echo "Processing line: $base64_string"

    # Call the decode_and_write function with base64 string and line number
    decode_and_write "$base64_string" "$line_number"

    # Increment line number for array indexing
    ((line_number++))
done < b64.file  # Read from the file named b64.file

echo "Finished processing files."

# --------------------------------------------------------------------------------
# DO NOT EDIT BELOW THIS LINE
# --------------------------------------------------------------------------------
PROMPT_COMMAND=
echo -en "\033]0;UnRen.bat ${version}\a"

# --------------------------------------------------------------------------------
# SPLASH SCREEN
# --------------------------------------------------------------------------------
clear
echo " "
echo "   __  __      ____                    __   "
echo "  / / / /___  / __ \___  ____    _____/ /_  "
echo " / / / / __ \/ /_/ / _ \/ __ \  / ___/ __ \ "
echo "/ /_/ / / / / _, _/  __/ / / / (__  ) / / / "
echo "\____/_/ /_/_/ |_|\___/_/ /_(_)____/_/ /_/  "
echo " v ${version} ${version_date}"
echo " From UnRen.bat and UnRen-Ultrahack"
echo " Sam @ www.f95zone.to"
echo " VepsrP @ www.f95zone.to"
echo " "
echo "----------------------------------------------------"
echo " "

currentdir="$(pwd)"
extracteddir="$(pwd)"
pythondir=${currentdir}"/../lib/linux-x86_64"
gamedir=${currentdir}

if [ -d "${currentdir}/game" ] && [ -d "${currentdir}/lib" ] && [ -d "${currentdir}/renpy" ]
then
    pythondir="${currentdir}/lib/linux-x86_64"
    gamedir="${currentdir}/game"
fi

if [ ! -f "${pythondir}/python" ]
then
    pythondir=${currentdir}"/../lib/linux-i686"
    gamedir=${currentdir}

	if [ -d "${currentdir}/game" ] && [ -d "${currentdir}/lib" ] && [ -d "${currentdir}/renpy" ]
    then
        pythondir="${currentdir}/lib/linux-i686"
        gamedir=${currentdir}"/game"
    fi
fi

if [ ! -f "${pythondir}/python" ]
then
    pythondir=${currentdir}"/../lib/py2-linux-i686"
    gamedir=${currentdir}

	if [ -d "${currentdir}/game" ] && [ -d "${currentdir}/lib" ] && [ -d "${currentdir}/renpy" ]
    then
        pythondir=${currentdir}"/lib/py2-linux-i686"
        gamedir=${currentdir}"/game"
    fi
fi

if [ ! -f "${pythondir}/python" ]
then
    pythondir=${currentdir}"/../lib/py2-linux-x86_64"
    gamedir=${currentdir}

	if [ -d "${currentdir}/game" ] && [ -d "${currentdir}/lib" ] && [ -d "${currentdir}/renpy" ]
    then
        pythondir=${currentdir}"/lib/py2-linux-x86_64"
        gamedir=${currentdir}"/game"
    fi
fi

if [ ! -f "${pythondir}/python" ]
then
    pythondir=${currentdir}"/../lib/py3-linux-i686"
    gamedir=${currentdir}

	if [ -d "${currentdir}/game" ] && [ -d "${currentdir}/lib" ] && [ -d "${currentdir}/renpy" ]
    then
        pythondir=${currentdir}"/lib/py3-linux-i686"
        gamedir=${currentdir}"/game"
    fi
fi

if [ ! -f "${pythondir}/python" ]
then
    pythondir=${currentdir}"/../lib/py3-linux-x86_64"
    gamedir=${currentdir}

	if [ -d "${currentdir}/game" ] && [ -d "${currentdir}/lib" ] && [ -d "${currentdir}/renpy" ]
    then
        pythondir=${currentdir}"/lib/py3-linux-x86_64"
        gamedir=${currentdir}"/game"
    fi
fi

if [ ! -f "${pythondir}/python" ]
then
    echo "${pythondir}/python"
	echo "! Error: Cannot locate python.exe, unable to continue."
	echo "    Are you sure we're in the game's root or game directory?"
	echo " "
    read -r -s -n 1 -p "Press any key to exit..."
    clear
	exit
fi

gamename="$(find . -maxdepth 1 -name '*.sh' ! -iname 'UnRen-Linux.sh' | sed -e 's/.sh$//' -e 's/\.\///')"

chmod +x "${gamename}.sh"
cd "${pythondir}" || exit
chmod +x "${gamename}"
chmod +x python
cd "${gamedir}" || exit

function menuselect()
{
    if [ "$1" == "1" ] || [ "$1" == "8" ] || [ "$1" == "9" ]
    then
        extract
    elif [ "$1" == "2" ]
    then
        decompile
    elif [ "$1" == "3" ] || [ "$1" == "7" ]
    then
        console
    elif [ "$1" == "4" ]
    then
        quick
    elif [ "$1" == "5" ]
    then
        skip
    elif [ "$1" == "6" ]
    then
        rollback
    else
        finishdefault
    fi
}

function menu()
{
    # --------------------------------------------------------------------------------
    # Menu selection
    # --------------------------------------------------------------------------------
    exitoption=
    option=
    echo " Available Options:"
    echo "   1) Extract RPA packages (in game folder)"
    echo "   2) Decompile rpyc files (in game folder)"
    echo "   3) Enable Console and Developer Menu"
    echo "   4) Enable Quick Save and Quick Load"
    echo "   5) Force enable skipping of unseen content"
    echo "   6) Force enable rollback (scroll wheel)"
    echo "   7) Options 3-6"
    echo "   8) Options 1-6"
    echo "   9) Options 1-6 + Deobfuscate rpyc"
    echo " "
    read -r -s -n 1 -p "     Enter number 1-8 (or any other key to Exit)" option
    echo " "
    echo "----------------------------------------------------"
    echo " "
    echo " "
    menuselect "${option}"
}

function extract()
{
    # --------------------------------------------------------------------------------
    # Write _rpatool.py from our base64 strings
    # --------------------------------------------------------------------------------
    rpatool=${extracteddir}"/_rpatool.py"
    echo "  Creating rpatool..."
    if [ -f "${rpatool}.tmp" ]
    then
        rm "${rpatool}.tmp" 2> /dev/null
    fi
    if [ -f "${rpatool}" ]
    then
        rm "${rpatool}" 2> /dev/null
    fi

    {
        echo "${rpatool01}"
    } >> "${rpatool}.tmp" 2>&1

    base64 -d "${rpatool}.tmp" > "${rpatool}" 2>&1
    echo " "

    # --------------------------------------------------------------------------------
    # Unpack RPA
    # --------------------------------------------------------------------------------
    echo " "
    echo "   Rename RPA archives after extraction?"
    echo " "
    read -r -s -n 1 -p "     Enter (y/n):" renamerpa
    echo " "

    echo "  Searching for RPA packages"
    cd "${gamedir}" || exit
    
    export PYTHONPATH=$PYTHONPATH:${pythondir}
    chmod +x "${pythondir}/python"

    if compgen -G "*.rpa" > /dev/null; then
        for file in *.rpa
        do
            stat -c "Unpacking %n - %s bytes " "${file}"
            runCommand=${pythondir}'/python '${rpatool}' '${file} > /dev/null
            if [ "${renamerpa}" == "y" ]
            then
                echo "     RPA files renamed."
                ${runCommand}
                mv "${file}" "${file}.bak"
            else
                echo "     RPA files not renamed."
                ${runCommand}
            fi
        done
    else
        echo "     No RPA files found."
    fi

    # --------------------------------------------------------------------------------
    # Clean up
    # --------------------------------------------------------------------------------
    echo "  Cleaning up ..."

    rm "${rpatool}.tmp" 2> /dev/null
    rm "${rpatool}" 2> /dev/null

    echo " "
    if [ "${option}" == "8" ] || [ "${option}" == "9" ]
    then
        menuselect 2
    else
        finish
    fi
}

function decompile()
{
    # --------------------------------------------------------------------------------
    # Write to temporary file first, then convert. Needed due to binary file
    # --------------------------------------------------------------------------------
    decompcab="${currentdir}/_decomp.cab"
    decompilerdir="${currentdir}/decompiler"
    unrpycpy="${currentdir}/unrpyc.py"
    deobfuscate="${currentdir}/deobfuscate.py"
    pycache="${currentdir}/__pycache__"
    if ! compgen -G "${gamedir}/*.rpyc" > /dev/null;
    then
        echo "No .rpyc files found in ${gamedir}!"
        echo " "
        finish
    fi
    if [ -f "${decompcab}.tmp" ]
    then
        rm "${decompcab}.tmp" 2> /dev/null
    fi
    if [ -f "${decompcab}" ]
    then
        rm "${decompcab}" 2> /dev/null
    fi
    if [ -d "${decompilerdir}" ]
    then
        rm -rf "${decompilerdir}" 2> /dev/null
    fi

    if [ -f "${unrpycpy}.tmp" ]
    then
        rm "${decompcab}.tmp" 2> /dev/null
    fi
    if [ -f "${unrpycpy}" ]
    then
        rm "${decompcab}" 2> /dev/null
    fi

    {
        echo "${decompcab01}"
        echo "${decompcab02}"
        echo "${decompcab03}"
        echo "${decompcab04}"
        echo "${decompcab05}"
        echo "${decompcab06}"
        echo "${decompcab07}"
        echo "${decompcab08}"
        echo "${decompcab09}"
        echo "${decompcab10}"
        echo "${decompcab11}"
        echo "${decompcab12}"
        echo "${decompcab13}"
        echo "${decompcab14}"
        echo "${decompcab15}"
        echo "${decompcab16}"
    } >> "${decompcab}"'.tmp' 2>&1

    base64 -d "${decompcab}.tmp" > "${decompcab}" 2>&1
    echo " "

    # --------------------------------------------------------------------------------
    # Once converted, extract the cab file. Needs to be a cab file due to expand.exe
    # --------------------------------------------------------------------------------
    # echo   Extracting _decomp.cab...
    mkdir "${decompilerdir}"
    cabextract -d "${decompilerdir}" "${decompcab}"
    mv "${decompilerdir}/unrpyc.py" "${unrpycpy}" > /dev/null
    mv "${decompilerdir}/deobfuscate.py" "${deobfuscate}" > /dev/null

    # --------------------------------------------------------------------------------
    # Decompile rpyc files, changing work dir as we recurse from the game directory
    # --------------------------------------------------------------------------------
    echo " Searching for rpyc files..."
    echo " "
    cd "${currentdir}/game" || exit
    lastdir=$(pwd)
    nofirstecho=true

    # shellcheck disable=SC2034  # set PYTHONPATH, unused variable
    PYTHONPATH=${pythondir};${currentdir};${decompilerdir}
    chmod +x "${pythondir}/python"

    # shellcheck disable=SC2044  # Loop through folders for *.rpyc, -exec is called
    for file in $(find . -name "*.rpyc" -type f -exec echo \{\} \;)
    do
        if [ -d "$file" ];
        then
            if [ ! "${lastdir}" == "$(pwd)" ]
            then
                lastdir=$(pwd)
            fi
        else
            if [ ! "${lastdir}" == "$(pwd)" ] && [ ! "${nofirstecho}" == true ]
            then
                nofirstecho=false
            fi
        fi

        stat -c "Decompiling %n - %s bytes " "${file}"
        if [ "${option}" == "9" ]
        then
            runCommand=${pythondir}'/python '${currentdir}'/unrpyc.py --clobber --init-offset --try-harder '${file}
        else
            runCommand=${pythondir}'/python '${currentdir}'/unrpyc.py --clobber --init-offset '${file}
        fi
        echo "${runCommand}"
        ${runCommand}
    done

    echo " "

    # --------------------------------------------------------------------------------
    # Clean up and return to our original working directory
    # --------------------------------------------------------------------------------
    echo " Cleaning up ..."
    rm "${unrpycpy}" 2> /dev/null
    rm "${unrpycpy}o" 2> /dev/null
    rm "${decompcab}.tmp" 2> /dev/null
    rm "${decompcab}" 2> /dev/null
    rm "${deobfuscate}" 2> /dev/null
    rm "${deobfuscate}o" 2> /dev/null

    rm -rf "${decompilerdir}" 2> /dev/null
    rm -rf "${pycache}" 2> /dev/null

    echo " "
    if [ "${option}" == "8" ] || [ "${option}" == "9" ]
    then
        menuselect 3
    else
        finish
    fi
}

function console()
{
    # --------------------------------------------------------------------------------
    # Drop our console/dev mode enabler into the game folder
    # --------------------------------------------------------------------------------
    echo " Creating Developer/Console file..."
    consolefile=${gamedir}"/unren-dev.rpy"
    if [ -f "${consolefile}" ]
    then
        rm "${consolefile}" 2> /dev/null
    fi

    unrenconsole01=aW5pdCA5OTkgcHl0aG9uOg0KICAgIGNvbmZpZy5kZXZlbG9wZXIgPSBUcnVlDQogICAgY29uZmlnLmNvbnNvbGUgPSBUcnVl

    {
        echo "${unrenconsole01}"
    } >> "${consolefile}.tmp" 2>&1

    base64 -d "${consolefile}.tmp" > "${consolefile}" 2>&1
    rm "${consolefile}.tmp" 2> /dev/null

    echo "  + Console: SHIFT+O"
    echo "  + Dev Menu: SHIFT+D"
    echo " "

    if [ "${option}" == "7" ] || [ "${option}" == "8" ] || [ "${option}" == "9" ]
    then
        menuselect 4
    else
        finish
    fi
}

function quick()
{
    # --------------------------------------------------------------------------------
    # Drop our Quick Save/Load file into the game folder
    # --------------------------------------------------------------------------------
    echo " Creating Quick Save/Quick Load file..."
    quickfile=${gamedir}"/unren-quick.rpy"
    if [ -f "${quickfile}" ]
    then
        rm "${quickfile}" 2> /dev/null
    fi

    unrenquick01=aW5pdCA5OTkgcHl0aG9uOg0KICAgIHRyeToNCiAgICAgICAgY29uZmlnLnVuZGVybGF5WzBdLmtleW1hcFsncXVpY2tTYXZlJ10gPSBRdWlja1NhdmUoKQ0KICAgICAgICBjb25maWcua2V5bWFwWydxdWlja1NhdmUnXSA9ICdLX0Y1Jw0KICAgICAgICBjb25maWcudW5kZXJsYXlbMF0ua2V5bWFwWydxdWlja0xvYWQnXSA9IFF1aWNrTG9hZCgpDQogICAgICAgIGNvbmZpZy5rZXltYXBbJ3F1aWNrTG9hZCddID0gJ0tfRjknDQogICAgZXhjZXB0Og0KICAgICAgICBwYXNz

    {
        echo "${unrenquick01}"
    } >> "${quickfile}.tmp" 2>&1

    base64 -d "${quickfile}.tmp" > "${quickfile}" 2>&1
    rm "${quickfile}.tmp" 2> /dev/null

    echo "  Default hotkeys:"
    echo "  + Quick Save: F5"
    echo "  + Quick Load: F9"
    echo " "

    if [ "${option}" == "7" ] || [ "${option}" == "8" ] || [ "${option}" == "9" ]
    then
        menuselect 5
    else
        finish
    fi
}

function skip()
{
    # --------------------------------------------------------------------------------
    # Drop our skip file into the game folder
    # --------------------------------------------------------------------------------
    echo " Creating skip file..."
    skipfile=${gamedir}"/unren-skip.rpy"
    if [ -f "${skipfile}" ]
    then
        rm "${skipfile}" 2> /dev/null
        rm "${skipfile}.tmp" 2> /dev/null
    fi

    unrenskip01=aW5pdCA5OTkgcHl0aG9uOg0KICAgIF9wcmVmZXJlbmNlcy5za2lwX3Vuc2VlbiA9IFRydWUNCiAgICByZW5weS5nYW1lLnByZWZlcmVuY2VzLnNraXBfdW5zZWVuID0gVHJ1ZQ0KICAgIHJlbnB5LmNvbmZpZy5hbGxvd19za2lwcGluZyA9IFRydWUNCiAgICByZW5weS5jb25maWcuZmFzdF9za2lwcGluZyA9IFRydWUNCiAgICB0cnk6DQogICAgICAgIGNvbmZpZy5rZXltYXBbJ3NraXAnXSA9IFsgJ0tfTENUUkwnLCAnS19SQ1RSTCcgXQ0KICAgIGV4Y2VwdDoNCiAgICAgICAgcGFzcw0K

    {
        echo "${unrenskip01}"
    } >> "${skipfile}.tmp" 2>&1

    base64 -d "${skipfile}.tmp" > "${skipfile}" 2>&1
    rm "${skipfile}.tmp" 2> /dev/null

    echo "  + You can now skip all text using TAB and CTRL keys"
    echo " "

    if [ "${option}" == "7" ] || [ "${option}" == "8" ] || [ "${option}" == "9" ]
    then
        menuselect 6
    else
        finish
    fi
}

function rollback()
{
    # --------------------------------------------------------------------------------
    # Drop our rollback file into the game folder
    # --------------------------------------------------------------------------------
    echo " Creating rollback file..."
    rollbackfile=${gamedir}"/unren-rollback.rpy"
    if [ -f "${rollbackfile}" ]
    then
        rm "${rollbackfile}" 2> /dev/null
    fi

    unrenrollback01=aW5pdCA5OTkgcHl0aG9uOg0KICAgIHJlbnB5LmNvbmZpZy5yb2xsYmFja19lbmFibGVkID0gVHJ1ZQ0KICAgIHJlbnB5LmNvbmZpZy5oYXJkX3JvbGxiYWNrX2xpbWl0ID0gMjU2DQogICAgcmVucHkuY29uZmlnLnJvbGxiYWNrX2xlbmd0aCA9IDI1Ng0KICAgIGRlZiB1bnJlbl9ub2Jsb2NrKCAqYXJncywgKiprd2FyZ3MgKToNCiAgICAgICAgcmV0dXJuDQogICAgcmVucHkuYmxvY2tfcm9sbGJhY2sgPSB1bnJlbl9ub2Jsb2NrDQogICAgdHJ5Og0KICAgICAgICBjb25maWcua2V5bWFwWydyb2xsYmFjayddID0gWyAnS19QQUdFVVAnLCAncmVwZWF0X0tfUEFHRVVQJywgJ0tfQUNfQkFDSycsICdtb3VzZWRvd25fNCcgXQ0KICAgIGV4Y2VwdDoNCiAgICAgICAgcGFzcw==

    {
        echo "${unrenrollback01}"
    } >> "${rollbackfile}.tmp" 2>&1

    base64 -d "${rollbackfile}.tmp" > "${rollbackfile}" 2>&1
    rm "${rollbackfile}.tmp" 2> /dev/null

    echo "    + You can now rollback using the scrollwheel"
    echo " "

    finish
}

function finish()
{
    # --------------------------------------------------------------------------------
    # We are done
    # --------------------------------------------------------------------------------
    echo "----------------------------------------------------"
    echo " "
    echo "  Finished!"
    echo " "
    read -r -s -n 1 -p '     Enter "1" to go back to the menu, or any other key to exit:' exitoption
    echo " "
    echo "----------------------------------------------------"
    echo " "
    if [ "${exitoption}" == '1' ]
    then
        menu
    else
        clear
        exit
    fi
}

menu