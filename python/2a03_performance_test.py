from collections import Counter

# Define function to calculate the most frequent item in a list
def most_frequent_item(lst):
    counter = Counter(lst)
    most_common = counter.most_common(1)
    return most_common[0][0] if most_common else None

# Define constants
CHECK_FOR_ZERODIVISIONERROR = 1
BREAK_ON_ZERODIVISIONERROR = 0
DIVIDE_FAST_POWER_OF_TWO = 1
CHECK_FOR_DIVISOR_ONE = 1

# Initialize variables
cycle_times = []

# Loop through all possible combinations of dividend and divisor
for dividend in range(256):
    for divisor in range(256):
        if divisor == 0:
            # Handle division by zero
            if CHECK_FOR_ZERODIVISIONERROR:
                cycle_time = 6 if BREAK_ON_ZERODIVISIONERROR else 14
            else:
                cycle_time = float('inf')
        elif divisor == 1 and CHECK_FOR_DIVISOR_ONE:
            # Handle division by one
            cycle_time = 23 if CHECK_FOR_ZERODIVISIONERROR else 20
        elif dividend == 0:
            # Handle dividend is zero
            cycle_time = 25 if CHECK_FOR_ZERODIVISIONERROR else 22
            cycle_time -= 4 * (not CHECK_FOR_DIVISOR_ONE)
        elif dividend == divisor:
            # Handle dividend equals divisor
            cycle_time = 41 if CHECK_FOR_ZERODIVISIONERROR else 38
            cycle_time -= 4 * (not CHECK_FOR_DIVISOR_ONE)
        elif dividend == 1:
            # Handle dividend is one
            cycle_time = 43 if CHECK_FOR_ZERODIVISIONERROR else 40
            cycle_time -= 4 * (not CHECK_FOR_DIVISOR_ONE)
        elif divisor in {2, 4, 8, 16} and DIVIDE_FAST_POWER_OF_TWO and dividend > {-1: -1, 2: 18, 4: 40, 8: 92}.get(divisor, -1):
            # Handle fast power of two division
            index = (2, 4, 8, 16).index(divisor)
            adder = 73 if CHECK_FOR_DIVISOR_ONE else 69
            adder -= 4 * (not CHECK_FOR_DIVISOR_ONE)
            adder += index * 5 + 12
            cycle_time = 14 * (index + 2) + adder
        else:
            # Handle regular division
            if DIVIDE_FAST_POWER_OF_TWO == 1:
                if divisor in {2, 4, 6, 8}:
                    adder = 17 + (2, 4, 6, 8).index(divisor) * 5 + 9
                elif divisor in {16, 32, 64, 128}:
                    adder = 17
                else:
                    adder = 8
            else:
                adder = 0
            adder += 51 if CHECK_FOR_ZERODIVISIONERROR else 48
            adder -= 4 * (not CHECK_FOR_DIVISOR_ONE)
            cycle_time = 7 * (dividend // divisor) + adder
        cycle_times.append(cycle_time)

# Calculate average cycle time
average_cycle_time = most_frequent_item(cycle_times)

# Write results to file
with open("2a03_division_timings.txt", "w") as f:
    f.write("Cycle Count : Dividend, Divisor\n")
    for dividend in range(256):
        for divisor in range(256):
            f.write(f"{dividend} / {divisor} = {cycle_times[dividend * 256 + divisor]} cycles\n")
    f.write(f"\n\nAverage cycle time : {average_cycle_time}")

print("Results written to 2a03_division_timings.txt")
