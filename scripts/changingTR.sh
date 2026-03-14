#!/bin/bash

find . -type f -exec sed -i "s/\r$//g" {} \;

