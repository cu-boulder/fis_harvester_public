with open('/home/napr1444/elements-publications-list.txt', 'r') as f:
    contents = (line.split('\t') for line in f.readlines())

with open('/home/napr1444/elements-publications-list-mod.txt', 'w') as f:
    for row_vals in contents:
        if len(row_vals) == 8:
            rvals = row_vals
            for i in range(8):
                if rvals[i].lower().strip()  == 'null':
                   rvals[i] = ''
                if '|' in rvals[i]:
                    rvals[i] = rvals[i].replace('|','')

            del rvals[2]

            if len(rvals[5].split('-')) != 3:
                rvals[5] = '{0}-{1}-{2}'.format(rvals[5][:4], rvals[5][4:6], rvals[5][6:])
            f.write('|'.join(rvals).strip()+'\n')
