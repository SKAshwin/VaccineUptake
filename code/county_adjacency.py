import csv

with open('../data/raw/adjacency.txt', 'r') as f:
    lines = f.readlines()

row = []
output = []
for line in lines:
    if line[0]=="\"":
        if len(row) != 0:
            output.append(row)
        row = line[:-1].split("\t")
        row[0] = row[0].replace("\"", "")
        row[2] = row[2].replace("\"", "")
        if row[3] in row[0:2]:
            row = row[0:2]
    else:
        county = line[:-1].split("\t")[2:]
        if len(county) != 0:
            county[0] = county[0].replace("\"", "")
            if county[1] not in row:
                row += county

with open('../data/temp/adjacencymap.csv', 'w') as f:
    writer = csv.writer(f)
    for row in output:
        writer.writerow(row)