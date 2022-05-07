import json
# This parses either of the HTML outputs scraped from the PRRI website (see https://www.prri.org/research/2020-census-of-american-religion/)
# Outputs a csv file, deposited in the temp folder
# CSV file will have, by county, the religious breakdown in 2020
# eg how many catholics, muslims, jews per county
# SOURCE can be set to the prri_religion dataset, or the religion subset x race dataset
# The latter has groups like "white evangelical protestant", "white mainline protestant" instead of just the overarching groups


#SOURCE = "prri_religion_subset_race"
SOURCE = "prri_religion"

with open("../data/raw/webscrape/"+SOURCE+".html", "r") as f:
    # Find the JSON object embedded in the HTML response
    start_indicator = "window.__DW_SVELTE_PROPS__ = JSON.parse(\""
    end_indicator = "}\");"
    data = f.read()
    after_start = data.split(start_indicator)[1]
    json_string = after_start.split(end_indicator)[0]

    # Find the CSV data (semicolon deliminated) embedded in the JSON
    data_start_indicator = r'\"chartData\":\"'
    data_end_indicator = r'\",\"isPreview\":false'
    after_data_start = json_string.split(data_start_indicator)[1]
    data_string = after_data_start.split(data_end_indicator)[0]
    data_rows = data_string.split(r'\\n')

with open("../data/temp/"+SOURCE+".csv", "w") as f:
    # write the data to a csv file
    f.write('\n'.join(data_rows))
