#!/bin/bash

echo "Compiling LBM..."
make clean && make

OUTPUT_FILE="benchmark/benchmark_results.csv"
echo "Scenario,Exercise,Nodes,Time" > $OUTPUT_FILE

# Define the scenarios and their respective arguments
declare -A scenarios
scenarios=(
    ["default"]=""
    ["complex"]="-c cases/config-complex.txt"
    ["wing"]="-c cases/config-wing.txt"
)

# Specify execution order
SCENARIO_ORDER=("default" "complex" "wing")

for scenario in "${SCENARIO_ORDER[@]}"; do
    args="${scenarios[$scenario]}"
    echo "======================================"
    echo "Starting Scenario: $scenario"
    echo "======================================"
    
    TIME_SEC=$(/usr/bin/time -f "%e" mpirun -np 1 ./lbm -e 0 $args 2>&1 >/dev/null | tail -n 1)
    
    echo "$scenario,0,1,$TIME_SEC" >> $OUTPUT_FILE
    for e in {1..6}; do
        for np in 2 4 8; do
            echo "Running $scenario | Exercise $e | Nodes $np..."
            # Capture execution time in seconds
            TIME_SEC=$(/usr/bin/time -f "%e" mpirun -np $np ./lbm -e $e $args 2>&1 >/dev/null | tail -n 1)
            
            # Log to CSV
            echo "$scenario,$e,$np,$TIME_SEC" >> $OUTPUT_FILE
        done
    done
done

echo "Benchmarking complete. Data saved to $OUTPUT_FILE"
