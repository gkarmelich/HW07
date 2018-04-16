#!/bin/bash

export PORT=5103

cd ~/www/taskTracker
./bin/taskTracker stop || true
./bin/taskTracker start


