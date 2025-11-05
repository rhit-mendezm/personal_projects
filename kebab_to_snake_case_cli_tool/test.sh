#!/bin/bash

source "./rename_to_snake_case.sh"

test_rename_to_snake_case_on_kebab_case_file() {
	mkdir test_environment
	cd test_environment || { echo "Unable to enter test_environment."; return 1; }
	touch kebab-case-file.txt

	rename_to_snake_case --silent kebab-case-file.txt > /dev/null 2>&1

	if [[ -f "kebab_case_file.txt" ]]; then
		echo -e "${GREEN}Test passed: ${WHITE}File in kebab case was renamed successfully."
	else
		echo -e "${RED}Test failed: ${WHITE}File in kebab case was not renamed successfully."
	fi

	cd ..
	rm -r test_environment
}

test_rename_to_snake_case_on_kebab_case_directory() {
	mkdir test_environment
	cd test_environment || { echo "Unable to enter test_environment."; return 1; }
	mkdir kebab-case-directory

	rename_to_snake_case --silent kebab-case-directory > /dev/null 2>&1

	if [[ -d "kebab_case_directory" ]]; then
		echo -e "${GREEN}Test passed: ${WHITE}Directory in kebab case was renamed successfully."
	else
		echo -e "${RED}Test failed: ${WHITE}Directory in kebab case was not renamed successfully."
	fi

	cd ..
	rm -r test_environment
}

test_rename_to_snake_case_on_snake_case_file() {
	mkdir test_environment
	cd test_environment || { echo "Unable to enter test_environment."; return 1; }
	touch snake_case_file.txt

	rename_to_snake_case --silent snake_case_file.txt > /dev/null 2>&1

	if [[ -f "snake_case_file.txt" ]]; then
		echo -e "${GREEN}Test passed: ${WHITE}File in snake case was not renamed."
	else
		echo -e "${RED}Test failed: ${WHITE}File in snake case was renamed."
	fi

	cd ..
	rm -r test_environment
}

test_rename_to_snake_case_on_snake_case_directory() {
	mkdir test_environment
	cd test_environment || { echo "Unable to enter test_environment."; return 1; }
	mkdir snake_case_directory

	rename_to_snake_case --silent snake_case_directory > /dev/null 2>&1

	if [[ -d "snake_case_directory" ]]; then
		echo -e "${GREEN}Test passed: ${WHITE}Directory in snake case was not renamed."
	else
		echo -e "${RED}Test failed: ${WHITE}Directory in snake was renamed."
	fi

	cd ..
	rm -r test_environment
}

test_rename_to_snake_case_on_kebab_case_directory_with_one_file_and_one_empty_directory() {
	mkdir test_environment
	cd test_environment || { echo "Unable to enter test_environment."; return 1; }
	mkdir top-level-kebab-case-directory
	touch top-level-kebab-case-directory/kebab-case-file.txt
	mkdir top-level-kebab-case-directory/empty-kebab-case-directory

	rename_to_snake_case --silent top-level-kebab-case-directory > /dev/null 2>&1

	local is_failed=false
	if [[ -d "top_level_kebab_case_directory" ]]; then
		cd top_level_kebab_case_directory
	else
		is_failed=true
		cd top-level-kebab-case-directory
		echo -e "${RED}Level 0: ${WHITE}Top level directory was not successfully renamed."
	fi

	if [[ -f "kebab_case_file.txt" ]]; then
		:
	else
		is_failed=true
		echo -e "${RED}Level 1: ${WHITE} Kebab case file was not successfully renamed."
	fi

	if [[ -d "empty_kebab_case_directory" ]]; then
		:
	else
		is_failed=true
		echo -e "${RED}Level 1: ${WHITE}Empty kebab case directory was not successfully renamed."
	fi

	if [[ ${is_failed} == true ]]; then
		echo -e "${RED}Test failed: ${WHITE}Kebab case directory with one file and one empty directory."
	else
		echo -e "${GREEN}Test passed: ${WHITE}Kebab case directory with one file and one empty directory."
	fi

	cd ../..
	rm -r test_environment
}

test_rename_to_snake_case_with_negative_max_depth() {
	mkdir test_environment
	
	rename_to_snake_case --max-depth -1 test_environment > /dev/null 2>&1

	if [[ -d "test_environment" ]]; then
		echo -e "${GREEN}Test passed: ${WHITE}test_environment was not modified when max-depth was negative."
	else
		echo -e "${RED}Test failed: ${WHITE}test_environment was modified when max-depth was negative."
	fi

	rm -r test_environment
}

test_rename_to_snake_case_on_kebab_case_directory_with_two_files_and_one_empty_directory_and_one_populated_directory() {
	mkdir test_environment
	cd test_environment || { echo "Unable to enter test_environment."; return 1; }
	mkdir top-level-kebab-case-directory
	touch top-level-kebab-case-directory/kebab-case-file.txt
	mkdir top-level-kebab-case-directory/empty-kebab-case-directory
	mkdir top-level-kebab-case-directory/populated-kebab-case-directory
	touch top-level-kebab-case-directory/populated-kebab-case-directory/another-kebab-case-file.txt
	touch top-level-kebab-case-directory/populated-kebab-case-directory/final-kebab-case-file-to-be-touched.txt
	mkdir top-level-kebab-case-directory/populated-kebab-case-directory/final-kebab-case-directory-to-be-touched
	touch top-level-kebab-case-directory/populated-kebab-case-directory/final-kebab-case-directory-to-be-touched/should-remain-kebab-case-file.txt
	mkdir top-level-kebab-case-directory/populated-kebab-case-directory/final-kebab-case-directory-to-be-touched/should-remain-kebab-case-directory
	touch top-level-kebab-case-directory/populated-kebab-case-directory/final-kebab-case-directory-to-be-touched/should-remain-kebab-case-directory/another-untouched-kebab-case-file.txt

	rename_to_snake_case --silent --max-depth 2 top-level-kebab-case-directory > /dev/null 2>&1

	echo -e "${WHITE}Test: ${CYAN}Kebab directory with nested files and directories (max-depth=2)${WHITE}"

	local is_failed=false
	if [[ -d "top_level_kebab_case_directory" ]]; then
		cd top_level_kebab_case_directory
	else
		is_failed=true
		cd top-level-kebab-case-directory
		echo -e "${RED}Level 0: ${WHITE}Top level directory was not successfully named."
	fi

	if [[ -f "kebab_case_file.txt" ]]; then
		continue
	else
		is_failed=true
		echo -e "${RED}Level 1: ${WHITE}First file was not successfully named."
	fi

	if [[ -d "empty_kebab_case_directory" ]]; then
		continue
	else
		is_failed=true
		echo -e "${RED}Level 1: ${WHITE}Empty directory was not successfully named."
	fi

	if [[ -d "populated_kebab_case_directory" ]]; then
		cd populated_kebab_case_directory
	else
		is_failed=true
		cd populated-kebab-case-directory
		echo -e "${RED}Populated directory was not successfully named."
	fi

	if [[ -f "another_kebab_case_file.txt" ]]; then
		continue
	else
		is_failed=true
		echo -e "${RED}File was not successfully named."
	fi

	if [[ -d "final_kebab_case_directory_to_be_touched" ]]; then
		cd final_kebab_case_directory_to_be_touched
	else
		is_failed=true
		cd final-kebab-case-directory-to-be-touched
		echo -e "${RED}Directory was not successfully named."
	fi

	if [[ -f "should-remain-kebab-case-file.txt" ]]; then
		continue
	else
		is_failed=true
		echo -e "${RED}File did not keep original name."
	fi

	if [[ -d "should-remain-kebab-case-directory" ]]; then
		cd should-remain-kebab-case-directory
	else
		is_failed=true
		cd should_remain_kebab_case_directory
		echo -e "${RED}Directory did not keep original name."
	fi

	if [[ -f "another-untouched-kebab-case-file.txt" ]]; then
		continue
	else
		is_failed=true
		echo -e "${RED}File did not keep original name."
	fi

	if [[ ${is_failed} == true ]]; then
		echo -e "${RED}Test failed.${WHITE}"
	else
		echo -e "${GREEN}Test passed.${WHITE}"
	fi

	cd ../../../../..
	rm -r test_environment
}

test_rename_to_snake_case_on_kebab_case_file
test_rename_to_snake_case_on_kebab_case_directory
test_rename_to_snake_case_on_snake_case_file
test_rename_to_snake_case_on_snake_case_directory
test_rename_to_snake_case_on_kebab_case_directory_with_one_file_and_one_empty_directory
test_rename_to_snake_case_with_negative_max_depth
test_rename_to_snake_case_on_kebab_case_directory_with_two_files_and_one_empty_directory_and_one_populated_directory

