#!/bin/sh -x

DEFAULT_PORT=6673
INSIDE_PORT=6673
PORT=${1:-${DEFAULT_PORT}}

export INFERNO_ROOT=/usr/inferno-os
export AUTH_ADDR=$1
export KEYFS_PASS=$2

docker run --rm -it --name auth 					     \
  -e AUTH_ADDR								     \
  -e KEYFS_PASS								     \
  -v `pwd`/profile:${INFERNO_ROOT}/lib/sh/profile			     \
  -v `pwd`/keyring:${INFERNO_ROOT}/usr/root/keyring/:rw		 	     \
  -v `pwd`/keydb:${INFERNO_ROOT}/keydb:rw 			             \
  -v `pwd`/host:${INFERNO_ROOT}/host:rw                                      \
  -p 0.0.0.0:${DEFAULT_PORT}:${INSIDE_PORT}                           	     \
  -p 0.0.0.0:42421:1917                           	     		     \
  --entrypoint emu-g							     \
  metacoma/inferno-os:latest                                                 \
  -r ${INFERNO_ROOT}
