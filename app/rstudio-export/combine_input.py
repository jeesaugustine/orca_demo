import numpy as np

import sys
import os


def combine_inputs(file1, file2):
    # print(file1, file2)
    f1 = open(file1, 'r')
    f2 = open(file2, 'r')
    edges1, sd_pairs = (f1.readline().split(","))
    edges2, sd_pairs_latest = (f2.readline().split(","))
    sd_pairs = int(sd_pairs.strip())
    sd_pairs_latest = int(sd_pairs_latest.strip())
    assert edges1 == edges2
    # print(sd_pairs, sd_pairs_latest)
    assert sd_pairs_latest > sd_pairs
    # print(f1.readline())

    # dirName = 'results/edges_' + str(edges1) + '_sd_pairs_' + str(sd_pairs_latest)
    dirName = 'edges_' + str(edges1) + '_sd_pairs_' + str(sd_pairs_latest)

    try:
        os.mkdir(dirName)
    except FileExistsError:
        print("Directory ", dirName, " already exists")

    new_file = open(dirName + '/a.txt', 'w')

    original_new_file = open(dirName + '/a_jees.txt', 'w')

    new_file.write(str(edges1.strip()) + ',' + str(sd_pairs_latest) + '\n')
    original_new_file.write(str(edges1.strip()) + ',' + str(sd_pairs_latest) + '\n')
    new_file.flush()


    original_new_file.flush()
    for first, second in zip(f1, f2):
        new_line_1 = ""
        new_line = ""
        first = first.split('\t')
        second = second.split('\t')
        assert first[0] == second[0]

        new_line_1 = str(first[0]) + "\t"
        first_null = True
        if first[1].strip() != '':
            first_null = False
            new_line = first[1].strip()
        if second[1].strip() != '':
            if not first_null:
                new_line = new_line + ','
            new_line = new_line + second[1].strip()
        new_line = new_line.strip() + "\n"
        new_line_1 = str(first[0]) + "\t" + new_line
        # new_line = first[1].strip() + ',' + second[1].strip() + '\n'
        # new_line_1 = str(first[0]) + '\t' + first[1].strip() + ',' + second[1].strip() + '\n'
        new_file.write(new_line)
        new_file.flush()
        original_new_file.write(new_line_1)
        original_new_file.flush()


combine_inputs(sys.argv[1], sys.argv[2])
# combine_inputs("partial_results_A_upto_502200.csv", "partial_results_A_upto_1004400.csv")
