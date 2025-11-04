#!/bin/bash

source "./colors.sh" 

_do_rename() {
	local file="$1"
	local is_silent="$2"
	local path=$( dirname "${file}" )
	local current_name=$( basename "${file}" )
	local new_name="${current_name//-/_}"

	if [[ "${current_name}" != "${new_name}" ]]; then
		if [[ "${is_silent}" == true ]]; then
			mv "${file}" "${path}/${new_name}"
		else
			mv -v "${file}" "${path}/${new_name}"
		fi
	else
		if [[ "${is_silent}" != true ]]; then
			echo -e "${ORANGE}No change needed: ${WHITE}${current_name} is already snake_case."
		fi
	fi

	echo "${path}/${new_name}"
}

_rename_recursive() {
	local current_name="$1"
	local is_silent="$2"
	local max_depth="$3"
	local current_depth="$4"

	local new_name=$( _do_rename "${current_name}" "${is_silent}" )

	shopt -s nullglob
	for entry in "${new_name}"/*; do
		local entry_depth=$(( current_depth + 1 ))

		if [[ -n "${max_depth}" && "${entry_depth}" -gt "${max_depth}" ]]; then
			continue
		elif [[ -f "${entry}" ]]; then
			_do_rename "${entry}" "${is_silent}"
		elif [[ -d "${entry}" ]]; then
			_rename_recursive "${entry}" "${is_silent}" "${max_depth}" "${entry_depth}"
		else
			continue
		fi
	done
	shopt -u nullglob
}

rename_to_snake_case() {
	local is_silent=false
	local max_depth=""
	local file=""

	while [[ $# -gt 0 ]]; do
		case "$1" in
			--silent)
				is_silent=true
				shift
				;;
			--max-depth)
				max_depth="$2"
				if ! [[ "${max_depth}" =~ ^[0-9]+$ ]]; then
					echo "Error: --max-depth must be a non-negative integer." >&2
					return 1
				fi

				shift 2
				;;
			*)
				file="$1"
				shift
				;;
		esac
	done

	if [[ -z "${file}" || ! -e "${file}" ]]; then
		echo "Usage: $0 [--silent] [--max-depth N] <file-name>|<directory-name>"
		return 1
	elif [[ -f "${file}" ]]; then
		_do_rename "${file}" "${is_silent}"
	elif [[ -d "${file}" ]]; then
		_rename_recursive "${file}" "${is_silent}" "${max_depth}" 0
	fi

	return 0
}

