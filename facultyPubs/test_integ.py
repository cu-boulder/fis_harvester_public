with open('../../dat-files/cub-new-data/fis_faculty_pubs.dat', 'r') as f:
    for line in f:
        t = line.split('|')
        if len(t) != 7:
            print(t)

