#!/bin/bash -xv
## stops a ballerina program execution using java jps:
## this is mainly used to stop ballerina services:
## pass the jar of the service as parameter and this service is stoped
## a program runs several services then run jps command alone to identify
## how/if jps identifies the execution a particular service and pass
## the identifier as parameter, the the command below greps on it and
## kills the retrievd PID. If this identifier match several execution
## the it is not an 'execution unique identifier' so it will kill one of
## the PID identified by it so it's not a valid way to kill a single execution.
APP_PID=`jps | grep $1 | awk {'print $1'}`
kill -TERM $APP_PID
if [ $? -eq 0 ]; then
    echo "app $1 stoped by SIGTERM"
else
    kill -9 $APP_PID
    if [ $? -eq 0 ]; then
        echo "app $1 stoped by SIGKILL"
    else
        echo "ERROR : couldn't stop app $1"
    fi
fi
