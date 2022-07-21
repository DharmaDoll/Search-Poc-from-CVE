#!/bin/bash
docker pull vuls/go-exploitdb:latest
for src in exploitdb inthewild githubrepos awesomepoc;
do
  docker run --rm -v local_volume:/go-exploitdb vuls/go-exploitdb fetch $src
done

echo '[+] Database import is complete.'

cat <<"EOF" >> ~/.zshrc
search_poc () {
		docker run --rm -v local_volume:/go-exploitdb vuls/go-exploitdb search "$@"
}
EOF
