#!/bin/bash
export LC_ALL=en_US.UTF_8

if [ ! -d scripts ]; then
  echo "You should run this script from the root git folder."
  exit 1
fi

# Raw files path
RAW=./data/task1/raw
TOK=./data/task1/tok

mkdir -p $TOK &> /dev/null

# Set path to Moses clone
MOSES="scripts/moses-3a0631a/tokenizer"
export PATH="${MOSES}:$PATH"

SUFFIX="lc.norm.tok"

##############################
# Preprocess files in parallel
##############################
for TYPE in "train" "val" "test_2016_flickr" "test_2017_flickr" "test_2017_mscoco"; do
  for LLANG in en de fr; do
    INP="${RAW}/${TYPE}.${LLANG}.gz"
    OUT="${TOK}/${TYPE}.${SUFFIX}.${LLANG}"
    if [ -f $INP ] && [ ! -f $OUT ]; then
      zcat $INP | lowercase.perl | normalize-punctuation.perl -l $LLANG | \
          tokenizer.perl -l $LLANG -threads 2 > $OUT &
    fi
  done
done
wait
