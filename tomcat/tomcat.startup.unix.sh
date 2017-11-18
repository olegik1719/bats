#!/bin/bash
# %CATALINA_HOME% можно прописать в системных переменных -- путь к томкату

export CATALINA_HOME=...
export CATALINA_BASE=$(dirname "$0")

export TITLE=My Tomcat Instance *NIX

$CATALINA_HOME/bin/startup.sh $TITLE