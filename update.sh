#!/bin/bash

(pwd=$(pwd); cd $(dirname $0); sup -e SERVICE=$pwd dev update)