# Search-Poc-from-CVE

### Deployment of go-exploitdb docker
```sh
./setup.sh
```
To update poc data, run `setup.sh` same way!

#### [Prepare CVE list](https://github.com/DharmaDoll/Search-Poc-from-CVE/blob/main/cve_sample.list)


### Search poc from CVE list
```sh
./search_poc_from_cve.sh cve_sample.list
```
##### [Check the result](https://github.com/DharmaDoll/Search-Poc-from-CVE/blob/main/result/cve_poc.list)


### It might be useful to set it in alias
```bash
cat <<"EOF" >> ~/.zshrc
search_poc () {
    docker run --rm -v local_volume:/go-exploitdb vuls/go-exploitdb search "$@"
}
EOF
```
### As needed you can see database
```bash
docker run -v local_volume:/go-exploitdb vuls/go-exploitdb
docker ps -a
CONTAINER ID   IMAGE               COMMAND                 CREATED         STATUS                     PORTS     NAMES
5ba9bad6fd4b   vuls/go-exploitdb   "go-exploitdb --help"   6 seconds ago   Exited (0) 5 seconds ago             eager_sinoussi

docker cp 5ba9bad6fd4b:/go-exploitdb/go-exploitdb.sqlite3 ./
docker rm 5ba
# View from sqlite command
sqlite3 go-exploitdb.sqlite3
```