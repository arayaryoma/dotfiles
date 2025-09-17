#!/bin/bash

echo "ANSI Color Codes:"
echo

echo "Escape Sequences:"
echo "\\033[XXm or \\x1b[XXm (where XX is the code number)"
echo

echo "Foreground Colors:"
echo -e -n "\033[30mBlack (30)\033[0m         "; echo "\\033[30m or \\x1b[30m"
echo -e -n "\033[31mRed (31)\033[0m           "; echo "\\033[31m or \\x1b[31m"
echo -e -n "\033[32mGreen (32)\033[0m         "; echo "\\033[32m or \\x1b[32m"
echo -e -n "\033[33mYellow (33)\033[0m        "; echo "\\033[33m or \\x1b[33m"
echo -e -n "\033[34mBlue (34)\033[0m          "; echo "\\033[34m or \\x1b[34m"
echo -e -n "\033[35mMagenta (35)\033[0m       "; echo "\\033[35m or \\x1b[35m"
echo -e -n "\033[36mCyan (36)\033[0m          "; echo "\\033[36m or \\x1b[36m"
echo -e -n "\033[37mWhite (37)\033[0m         "; echo "\\033[37m or \\x1b[37m"

echo
echo "Bright Foreground Colors:"
echo -e -n "\033[90mBright Black (90)\033[0m    "; echo "\\033[90m or \\x1b[90m"
echo -e -n "\033[91mBright Red (91)\033[0m      "; echo "\\033[91m or \\x1b[91m"
echo -e -n "\033[92mBright Green (92)\033[0m    "; echo "\\033[92m or \\x1b[92m"
echo -e -n "\033[93mBright Yellow (93)\033[0m   "; echo "\\033[93m or \\x1b[93m"
echo -e -n "\033[94mBright Blue (94)\033[0m     "; echo "\\033[94m or \\x1b[94m"
echo -e -n "\033[95mBright Magenta (95)\033[0m  "; echo "\\033[95m or \\x1b[95m"
echo -e -n "\033[96mBright Cyan (96)\033[0m     "; echo "\\033[96m or \\x1b[96m"
echo -e -n "\033[97mBright White (97)\033[0m    "; echo "\\033[97m or \\x1b[97m"

echo
echo "Background Colors:"
echo -e -n "\033[40mBlack Background (40)\033[0m    "; echo "\\033[40m or \\x1b[40m"
echo -e -n "\033[41mRed Background (41)\033[0m      "; echo "\\033[41m or \\x1b[41m"
echo -e -n "\033[42mGreen Background (42)\033[0m    "; echo "\\033[42m or \\x1b[42m"
echo -e -n "\033[43mYellow Background (43)\033[0m   "; echo "\\033[43m or \\x1b[43m"
echo -e -n "\033[44mBlue Background (44)\033[0m     "; echo "\\033[44m or \\x1b[44m"
echo -e -n "\033[45mMagenta Background (45)\033[0m  "; echo "\\033[45m or \\x1b[45m"
echo -e -n "\033[46mCyan Background (46)\033[0m     "; echo "\\033[46m or \\x1b[46m"
echo -e -n "\033[47mWhite Background (47)\033[0m    "; echo "\\033[47m or \\x1b[47m"

echo
echo "Bright Background Colors:"
echo -e -n "\033[100mBright Black Background (100)\033[0m   "; echo "\\033[100m or \\x1b[100m"
echo -e -n "\033[101mBright Red Background (101)\033[0m     "; echo "\\033[101m or \\x1b[101m"
echo -e -n "\033[102mBright Green Background (102)\033[0m   "; echo "\\033[102m or \\x1b[102m"
echo -e -n "\033[103mBright Yellow Background (103)\033[0m  "; echo "\\033[103m or \\x1b[103m"
echo -e -n "\033[104mBright Blue Background (104)\033[0m    "; echo "\\033[104m or \\x1b[104m"
echo -e -n "\033[105mBright Magenta Background (105)\033[0m "; echo "\\033[105m or \\x1b[105m"
echo -e -n "\033[106mBright Cyan Background (106)\033[0m    "; echo "\\033[106m or \\x1b[106m"
echo -e -n "\033[107mBright White Background (107)\033[0m   "; echo "\\033[107m or \\x1b[107m"

echo
echo "Text Styles:"
echo -e -n "\033[0mReset (0)\033[0m            "; echo "\\033[0m or \\x1b[0m"
echo -e -n "\033[1mBold (1)\033[0m             "; echo "\\033[1m or \\x1b[1m"
echo -e -n "\033[2mDim (2)\033[0m              "; echo "\\033[2m or \\x1b[2m"
echo -e -n "\033[3mItalic (3)\033[0m           "; echo "\\033[3m or \\x1b[3m"
echo -e -n "\033[4mUnderline (4)\033[0m        "; echo "\\033[4m or \\x1b[4m"
echo -e -n "\033[5mBlink (5)\033[0m            "; echo "\\033[5m or \\x1b[5m"
echo -e -n "\033[7mReverse (7)\033[0m          "; echo "\\033[7m or \\x1b[7m"
echo -e -n "\033[8mHidden (8)\033[0m           "; echo "\\033[8m or \\x1b[8m"
echo -e -n "\033[9mStrikethrough (9)\033[0m    "; echo "\\033[9m or \\x1b[9m"

echo
echo "Example combinations:"
echo -e -n "\033[1;31mBold Red\033[0m                    "; echo "\\033[1;31m or \\x1b[1;31m"
echo -e -n "\033[4;34mUnderlined Blue\033[0m             "; echo "\\033[4;34m or \\x1b[4;34m"
echo -e -n "\033[7;32mReversed Green\033[0m              "; echo "\\033[7;32m or \\x1b[7;32m"
echo -e -n "\033[1;4;35mBold Underlined Magenta\033[0m     "; echo "\\033[1;4;35m or \\x1b[1;4;35m"