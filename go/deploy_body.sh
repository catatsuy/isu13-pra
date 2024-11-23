#!/bin/bash

set -x

echo "start deploy ${USER}"
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o isupipe_linux -ldflags "-s -w"

for server in isu01; do
  ssh -t $server "sudo systemctl stop isupipe-go.service"
  # for build on Linux
  # rsync -vau --exclude=app ./ $server:/home/isucon/private_isu/webapp/golang/
  # ssh -t $server "cd /home/isucon/private_isu/webapp/golang; PATH=/home/isucon/.local/go/bin/:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make"

  scp ./isupipe_linux $server:/home/isucon/webapp/go/isupipe
  # rsync -vau ../sql/ $server:/home/isucon/isucari/webapp/sql/
  ssh -t $server "sudo systemctl start isupipe-go.service"
done

echo "finish deploy ${USER}"
