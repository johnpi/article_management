#!/bin/bash

# Usage: arxivid2doi.sh <ArXivID>

curl -L http://export.arxiv.org/api/query?id_list=$1

echo result.feed.entry[0]['arxiv:doi'][0]

