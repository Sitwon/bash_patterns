#!/bin/bash

# This script assigns human-readable names to the various BASH colors.
# The names take the form of <style>_<foreground>_<background>, eg:
#   BOLD_WHITE_BLACK: bold style, white foreground, black background
#   RED_BLUE: default style, red foreground, blue background
#   UNDERLINE_GREEN: underline style, green foreground, default background
#
# It also defines RESET_COLOR to reset the terminal to the default colors,
# and the set_color() helper function to change the colors of the terminal.

set_color(){
	if [ -n "${1}" ]; then
		echo -ne "${1}"
	else
		echo -ne "${RESET_COLOR}"
	fi
}

RESET_COLOR="\033[m"

if [ -z "${COLORS_DEFINIED}" ]; then
	for fore in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
	do
		for style in NONE BOLD UNDERSCORE BLINK REVERSE CONCEALED
		do
			for back in NONE BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
			do
				VARNAME=""
				CODE=""
				case $style in
					NONE)
						CODE="00;"
						;;
					BOLD)
						VARNAME="${style}_"
						CODE="01;"
						;;
					UNDERLINE)
						VARNAME="${style}_"
						CODE="04;"
						;;
					BLINK)
						VARNAME="${style}_"
						CODE="05;"
						;;
					REVERSE)
						VARNAME="${style}_"
						CODE="07;"
						;;
					CONCEALED)
						VARNAME="${style}_"
						CODE="08;"
						;;
				esac
				case $fore in
					BLACK)
						VARNAME="${VARNAME}${fore}"
						CODE="${CODE}30"
						;;
					RED)
						VARNAME="${VARNAME}${fore}"
						CODE="${CODE}31"
						;;
					GREEN)
						VARNAME="${VARNAME}${fore}"
						CODE="${CODE}32"
						;;
					YELLOW)
						VARNAME="${VARNAME}${fore}"
						CODE="${CODE}33"
						;;
					BLUE)
						VARNAME="${VARNAME}${fore}"
						CODE="${CODE}34"
						;;
					MAGENTA)
						VARNAME="${VARNAME}${fore}"
						CODE="${CODE}35"
						;;
					CYAN)
						VARNAME="${VARNAME}${fore}"
						CODE="${CODE}36"
						;;
					WHITE)
						VARNAME="${VARNAME}${fore}"
						CODE="${CODE}37"
						;;
				esac
				case $back in
					NONE)
						;;
					BLACK)
						VARNAME="${VARNAME}_${back}"
						CODE="${CODE};40"
						;;
					RED)
						VARNAME="${VARNAME}_${back}"
						CODE="${CODE};41"
						;;
					GREEN)
						VARNAME="${VARNAME}_${back}"
						CODE="${CODE};42"
						;;
					YELLOW)
						VARNAME="${VARNAME}_${back}"
						CODE="${CODE};43"
						;;
					BLUE)
						VARNAME="${VARNAME}_${back}"
						CODE="${CODE};44"
						;;
					MAGENTA)
						VARNAME="${VARNAME}_${back}"
						CODE="${CODE};45"
						;;
					CYAN)
						VARNAME="${VARNAME}_${back}"
						CODE="${CODE};46"
						;;
					WHITE)
						VARNAME="${VARNAME}_${back}"
						CODE="${CODE};47"
						;;
				esac
				CODE="\033[${CODE}m"
				eval "export ${VARNAME}=\"${CODE}\""
				if [ "${BASH_SOURCE}" = "${0}" ]; then
					echo -en "${CODE}${VARNAME}${RESET_COLOR} "
				fi
			done
		if [ "${BASH_SOURCE}" = "${0}" ]; then
			echo
		fi
		done
	done
	export COLORS_DEFINED="yes"
fi

