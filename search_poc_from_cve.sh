#!/bin/bash
set -u
trap 'echo "[$BASH_SOURCE:$LINENO]: " $BASH_COMMAND " returns not zero status"' ERR
This=$(basename $0)

if [[ $# -eq 0 ]]; then
echo """ Usage:
  $This <cve list file> | <cve number1> <cve number2>...
  """
exit 0
fi

if [[ -f "$1" ]];then
  CVE_LIST="cat $1"
  cnt=$(cat $1|wc -l)
else # For specific cve numbers
  CVE_LIST="cat <(echo $@)"
  cnt=$#
fi

TEMP=$(mktemp)
trap "echo '[+] The process is finished...'; rm ${TEMP};  exit;" EXIT

echo Search for $cnt.

for cve in $(eval $CVE_LIST)
do
  echo "[+] Search for $cve"
  rs=$(docker run --rm -v local_volume:/go-exploitdb vuls/go-exploitdb search --type CVE --param "$cve")
  if [[ $(cat <(echo $rs) | grep 'No Record Found') ]]; then
    continue
  fi
  # echo "$rs"
  res_urls=$(cat <(echo $rs) | grep -P '(?<=URL: )https?:.*?\s' -o)
  res_cve=$(cat <(echo $rs) | grep -P '(?<=CVE: )CVE-[0-9]*-[0-9]*' -o | uniq)

  for u in $(cat <(echo "$res_urls"))
  do
      echo "$res_cve" ":" "$u" | tee -a ${TEMP}
  done
done

sort ${TEMP} | uniq > result/cve_poc.list


