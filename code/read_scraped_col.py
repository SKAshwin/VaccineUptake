# Must run with python3
# Reads the scraped data from https://www.epi.org/resources/budget/budget-map/
# Reads it into a csv, which can then be converted into a dta

import json
import csv

# path to the EPI's cost of living data
with open('../data/raw/webscrape/epi_col.json', 'r') as f:
    data = json.load(f)

print(data[0])
print(data[0].keys())
print(data[0].values())

headers = data[0].keys()

with open('../data/temp/epi_col.csv', 'w', encoding='UTF-8') as f:
    writer = csv.writer(f)
    writer.writerow(headers)
    for county in data:
        writer.writerow(county.values())