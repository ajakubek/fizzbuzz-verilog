#!/usr/bin/env python

# The algorithms implemented in this module are based on the following article:
# D. Lemire, O. Kaser, and N. Kurz, Faster Remainder by Direct Computation, 2018.

import argparse
import math


def generate_div_params(divisor, bits):
    """
    Calculate parameters for fast fixed point division by constant value.

    Returned value is a tuple (reciprocal, fractional_bits).

    The following formula is used to calculate division:
    (x / divisor) mod (1 << bits) => (x * reciprocal) >> fractional_bits

    The following formula is used to calculate remainder:
    fractional_mask = (1 << fractional_bits) - 1
    x mod divisor => (((x * reciprocal) & fractional_mask) * divisor) >> fractional_bits

    The following formula is used to check for divisibility:
    fractional_mask = (1 << fractional_bits) - 1
    x mod divisor == 0 => (x * reciprocal) & fractional_mask < reciprocal
    """

    assert(0 < divisor < (1 << bits))

    if is_power_of_2(divisor):
        reciprocal = 1
        fractional_bits = int(math.log2(divisor))
    else:
        for extra_bits in range(0, bits + 1):
            fractional_bits = bits + extra_bits
            val_range = 1 << fractional_bits
            reciprocal = ((val_range - 1) // divisor) + 1
            if divisor <= val_range % divisor + (1 << extra_bits):
                break
        else:
            raise AssertionError("Failed to calculate number of fractional bits")

    return (reciprocal, fractional_bits)


def is_power_of_2(x):
    return x != 0 and x & (x - 1) == 0


def parse_args():
    parser = argparse.ArgumentParser(
        description="Generate parameters for fixed-point division by a constant")

    parser.add_argument("divisor", type=int, help="constant divisor")
    parser.add_argument("num_bits", type=int, help="max number of numerator bits")

    return parser.parse_args()


if __name__ == '__main__':
    args = parse_args()
    reciprocal, fractional_bits = generate_div_params(args.divisor, args.num_bits)

    print("Divisor:", args.divisor)
    print("Max dividend bits:", args.num_bits)
    print()

    print("Reciprocal:", reciprocal)
    print("Fractional bits:", fractional_bits)
    print()

    value_range = 1 << args.num_bits
    fractional_mask = (1 << fractional_bits) - 1

    print("Division (x / {} mod {}): (x * {}) >> {}".format(
        args.divisor, value_range, reciprocal, fractional_bits))
    print("Remainder (x mod {}): (((x * {}) & 0x{:x}) * {}) >> {}".format(
        args.divisor, reciprocal, fractional_mask, args.divisor, fractional_bits))
    print("Divisibility test (x mod {} == 0): ((x * {}) & 0x{:x}) < {}".format(
        args.divisor, reciprocal, fractional_mask, reciprocal))
