#!/bin/bash
# %CATALINA_HOME% можно прописать в системных переменных -- путь к томкату

export CATALINA_HOME=...
export CATALINA_BASE=$(dirname "$0")

$CATALINA_HOME/bin/shutdown.sh