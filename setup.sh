#!/bin/zsh

setopt verbose
go get golang.org/x/tools/cmd/goimports

sudo ln -sf $GOPATH/bin/goimports /usr/local/bin/goimports
