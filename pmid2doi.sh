#!/bin/bash

# Usage: pmid2doi.sh <PMID>

curl -L http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=$1

echo body.records[0].doi
