import sys

data = {}
fh = open(sys.argv[1])
for line in fh:
    a = line.strip().split()
    gene = a[0]
    sc = float(a[2])
    if a[0] in data.keys():
        data[gene] += sc
    else:
        data[gene] = sc
fh.close()

l = sorted(data, key=data.get, reverse=True)

for k in l:
    print k, data[k]
