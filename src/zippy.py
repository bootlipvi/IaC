#!/usr/bin/env python3
import argparse
import os
import json
import random
from zippy.quotes import get_random_quote


def main():
    parser = argparse.ArgumentParser(description='Zippy Quotes CLI')
    #parser.add_argument('-h', '--help', action='help', help='Show help message and exit')
    #parser.add_argument('--all', action='store_true', all='Display all quotes')
    
    args = parser.parse_args()

 #   if args.all:
 #       print('\n'.join(quotes))
 #   else:
    print(get_random_quote())

if __name__ == '__main__':
    main()