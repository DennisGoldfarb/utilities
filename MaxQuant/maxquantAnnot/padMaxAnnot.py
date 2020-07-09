#!/usr/bin/env python
import sys
import csv

infile = sys.argv[1]

with open(infile, encoding='utf-8-sig') as csvfile:
    reader = csv.reader(csvfile, delimiter="\t")
    header = next(reader)

    num_col = len(header)

    print("\t".join(header), end = "\r\n")

    for row in reader:
        row_len = len(row)
        for i in range(row_len, num_col):
            row.append("")
        print("\t".join(row), end = "\r\n")
