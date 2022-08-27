# Search-Poc-from-CVE
Search PoC from cve using [go-exploitdb](https://github.com/vulsio/go-exploitdb) and output to list.
### Deployment of go-exploitdb docker
```sh
$ ./setup.sh
```
To update poc data, run `setup.sh` same way!

### Search poc from CVE number
```sh
$ ./search_poc_from_cve.sh CVE-2022-0848 CVE-2022-0846
```

### Search poc from CVE list
#### [Prepare CVE list](https://github.com/DharmaDoll/Search-Poc-from-CVE/blob/main/cve_sample.list)

```sh
$ ./search_poc_from_cve.sh cve_sample.list
```
### [Check the result](https://github.com/DharmaDoll/Search-Poc-from-CVE/blob/main/result/cve_poc.list)


### As needed you can see database
```bash
$ docker run -v local_volume:/go-exploitdb vuls/go-exploitdb
$ docker ps -a
CONTAINER ID   IMAGE               COMMAND                 CREATED         STATUS                     PORTS     NAMES
5ba9bad6fd4b   vuls/go-exploitdb   "go-exploitdb --help"   6 seconds ago   Exited (0) 5 seconds ago             eager_sinoussi

$ docker cp 5ba9bad6fd4b:/go-exploitdb/go-exploitdb.sqlite3 ./
$ docker rm 5ba
# View from sqlite command
$ sqlite3 go-exploitdb.sqlite3
```

### It might be useful to set it in alias
```bash
$ cat <<"EOF" >> ~/.zshrc
search_poc () {
    docker run --rm -v local_volume:/go-exploitdb vuls/go-exploitdb search --type CVE --param "$@"
}
EOF
```