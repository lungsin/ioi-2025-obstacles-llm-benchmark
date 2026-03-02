#!/bin/bash
# echo "pwd: $(pwd)"
# echo "ls: $(ls)"

# Check if both memory_limit and time_limit arguments are provided
if [ $# -lt 3 ]; then
    echo "Error: solution path, memory_limit and time_limit are required as command line arguments"
    echo "Usage: $0 <solution_path> <memory_limit> <time_limit>"
    exit 2
fi

SOLUTION_PATH=$1
MEMORY_LIMIT=$2
TIME_LIMIT=$3

# echo "Running batch script with memory limit: ${MEMORY_LIMIT} kilobytes and time limit: ${TIME_LIMIT} seconds"

# Track passed tests
PASSED_TESTS=""
OVERALL_SUCCESS=0

# compile solution
g++ -std=gnu++20 -Wall -O2 -pipe -g -o "solution" -I graders -include bits/stdc++.h "graders/grader.cpp" "$SOLUTION_PATH"
if [ $? -ne 0 ]; then
    echo "Error: Failed to compile solution"
    exit 3
fi

# compile checker
g++ -std=gnu++20 -Wall -O2 -pipe -g -o "checkr" -I checker "checker/checker.cpp"
if [ $? -ne 0 ]; then
    echo "Error: Failed to compile checker"
    exit 4
fi

# for each test case...
for infile in tests/*.in; do
    file=$(basename $infile .in)
    outfile=tests/$file.out

    # runs solution to generate output
    (
        ulimit -v $MEMORY_LIMIT
        timeout $TIME_LIMIT ./solution < $infile > output.txt
    )
    if [ $? -ne 0 ]; then
        echo "Error: Solution execution failed for test case $file"
        OVERALL_SUCCESS=1
        continue
    fi

    # runs checker against generated output and capture its output
    CHECKER_OUTPUT=$(./checkr $infile $outfile output.txt 2>&1)
    CHECKER_EXIT_CODE=$?
    
    # Check if checker execution failed
    if [ $CHECKER_EXIT_CODE -ne 0 ]; then
        echo "Error: Checker execution failed for test case $file"
        OVERALL_SUCCESS=1
        continue
    fi
    
    # Check the 0/1 bit from checker output
    # echo "Checker output: $CHECKER_OUTPUT"
    # Only check the last line of CHECKER_OUTPUT
    if [ "$(echo "$CHECKER_OUTPUT" | tail -n 1)" = "1" ]; then
        # echo "Test case $file: PASSED"
        PASSED_TESTS="$PASSED_TESTS $file"
    else
        # echo "Test case $file: FAILED"
        OVERALL_SUCCESS=1
    fi
done

# Report results
if [ $OVERALL_SUCCESS -eq 0 ]; then
    echo "All tests passed successfully!"
fi
echo "Passed tests:$PASSED_TESTS"

exit $OVERALL_SUCCESS
