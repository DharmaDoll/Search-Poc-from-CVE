#!/bin/bash
set -u

This=$(basename $0)

if [[ ! $# == 1 ]]; then
echo """ Usage:
  $This <cve list file> 
  """
exit 0
fi

CVE_LIST=$1
cnt=$(cat $CVE_LIST|wc -l)
TEMP=$(mktemp)

echo Search for $cnt.

for cve in $(cat "$CVE_LIST")
do
  rs=$(docker run --rm -v local_volume:/go-exploitdb vuls/go-exploitdb search --type CVE --param "$cve")
  if [[ $(cat <(echo $rs) | grep 'No Record Found') ]]; then
    continue
  fi
  echo "$rs"
  res_urls=$(cat <(echo $rs) | grep -P '(?<=URL: )https:.*?\s' -o)
  res_cve=$(cat <(echo $rs) | grep -P '(?<=CVE: )CVE-[0-9]*-[0-9]*' -o | uniq)

  for u in $(cat <(echo "$res_urls"))
  do
      echo "$res_cve" ":" "$u" | tee -a ${TEMP}
  done
done

uniq ${TEMP} > result/cve_poc.list
rm ${TEMP}
