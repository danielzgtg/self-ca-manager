#!/bin/bash

read -p 'Are you sure? ' -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo Cancelled
    exit 1
fi
