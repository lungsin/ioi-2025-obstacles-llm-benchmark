# IOI 2025 Obstacles LLM Benchmark


This is a repo to test LLM capability by using IOI 2025 problem: Day 2 Obstacles.

## Setup

1. Clone this repository: `git clone https://github.com/lungsin/ioi-2025-obstacles-llm-benchmark.git`
2. Copy the `workspace` directory to somewhere else to avoid LLM cheating by reading the git history. `cp -r workspace ~/random-directory`
3. Cd to that directory and let the agents solve the problem. The workspace directory contains problem description and supplementary attachment.
4. To prevent cheating (LLM can search for the solution or editorial online), disable the web search/fetch functionality of the LLM agents. I've added `opencode.json` that does this in `workspace` directory. It's probably a good idea to add a prompt to explicitly ban cheating: looking for editorial or solutions in the internet.

## Test

1. Cd back to this repository.
2. Run the test script:
    ```sh
    bash run_tests.sh <path-to-solution.cpp> 2048000 2 # Memory limit (~2GB) and time limit (2s)
    ```

    For example, if the LLM generate the solution at `~/random-directory/main.cpp`, the script to be run is:
    ```sh
    bash run_tests.sh ~/random-directory/main.cpp 2048000 2 # Memory limit and time limit
    ```

