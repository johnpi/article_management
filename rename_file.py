import sys
import json
import re

obj = json.load(sys.stdin)
# Pretty printing
print json.dumps(obj, sort_keys=True, indent=4, separators=(',', ': '))

# JSON Validation and pretty printing from shell
# echo '{"json":"obj"}' | python -m json.tool

if obj["status"] == "ok":
    Type = obj["message"]["type"]
    if len(obj["message"]["author"]) == 1:
        Author = obj["message"]["author"][0]["family"]
    elif len(obj["message"]["author"]) == 2:
        Author = obj["message"]["author"][0]["family"] + "&" + obj["message"]["author"][1]["family"]
    elif len(obj["message"]["author"]) > 2:
        Author = obj["message"]["author"][0]["family"] + "_et_al"

    if "published-print" in obj["message"]:
        Date = obj["message"]["published-print"]["date-parts"][0][0]
    elif "published-online" in obj["message"]:
        Date = obj["message"]["published-online"]["date-parts"][0][0]
    else:
        Date = obj["message"]["issued"]["date-parts"][0][0]
    
    if len(obj["message"]["short-container-title"]) > 0:
        Publication_short = ''.join(obj["message"]["short-container-title"])
    else:
        Publication = obj["message"]["container-title"][0]
        if re.search(' ', Publication) is None:
            Publication_short = Publication
        else:
            match = re.search('\(([A-Z]{2,})\)', Publication)
            if match:
                Publication_short = match.group(1)
            else:
                match = re.findall('[A-Z]', Publication)
                if match:
                    Publication_short = ''.join(match)
                else:
                    Publication_short = ""
    Title = obj["message"]["title"]
    
    print "%s_%s_%s" % (Author, Date, "".join(Publication_short))
    
