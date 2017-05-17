#!/bin/bash

echo Dimitar
# Directory containing Scribble jars
LIB=lib

# antlr 3.2 location (if no lib jar)
ANTLR=
  # e.g. '/cygdrive/c/Users/[User]/.m2/repository/org/antlr/antlr-runtime/3.2/antlr-runtime-3.2.jar'

PRG=`basename "$0"`
DIR=`dirname "$0"`   # Non Cygwin..
#DIR=`dirname "$0"`/.. # Cygwin
#BASEDIR=$(dirname $0)

usage() {
  echo Usage:  'scribblec.sh [option]... <SCRFILE> [option]...'
  cat <<EOF
  
 <SCRFILE>     Source Scribble module (.scr file) 
  
 Options: 
  -h, --help                                     Show this info and exit
  --verbose                                      Echo the java command
  -V                                             Scribble debug info

  -ip <path>                                     Scribble import path

  -project <simple global protocol name> <role>  Project protocol

  -fsm <simple global protocol name> <role>      Generate Endpoint FSM
  -fsmdot <simple global protocol name> <role> <output file>
          Draw Endpoint FSM as png (requires dot)
  -minfsm                                        
          Minimise EFSMs for dot and API generation (but not global modelling)
          (Requires ltsconvert)

  -model <simple global protocol name>           Generate global model
  -modeldot <simple global protocol name> <role> <output file>
          Draw global model as png (requires dot)
  -fair                                          Assume fair output choices

  -api <simple global protocol name> <role>      Generate Endpoint API
  -d <path>                                      API output path
  -session <simple global protocol name>         Generate Session API only
  -schan <simple global protocol name> <role>    Generate State Channel API only
  -subtypes                                      Enable subtype API generation
EOF
}

fixpath() {
  windows=0

  if [ `uname | grep -c CYGWIN` -ne 0 ]; then
    windows=1
  fi

  cp="$1"
  if [ "$windows" = 1 ]; then
      cygpath -pw "$cp"
  else
      echo "$cp"
  fi
}

ARGS=

CLASSPATH=$DIR'/modules/cli/target/classes/'
CLASSPATH=$CLASSPATH':'$DIR'/modules/core/target/classes'
CLASSPATH=$CLASSPATH':'$DIR'/modules/parser/target/classes'
CLASSPATH=$CLASSPATH':'$ANTLR
CLASSPATH=$CLASSPATH':'$DIR'/../'$LIB'/antlr-4.4.jar'
CLASSPATH=$CLASSPATH':'$DIR'/../'$LIB'/antlr-runtime-4.4.jar'
CLASSPATH=$CLASSPATH':'$DIR'/../'$LIB'/commons-io-1.0.jar'
CLASSPATH=$CLASSPATH':'$DIR'/../'$LIB'/scribble-cli-1.0.jar'
CLASSPATH=$CLASSPATH':'$DIR'/../'$LIB'/scribble-core-1.0.jar'
CLASSPATH=$CLASSPATH':'$DIR'/../'$LIB'/scribble-parser-1.0.jar'
CLASSPATH=$CLASSPATH':'$DIR'/../'$LIB'/stringtemplate-0.1.jar'
CLASSPATH="'"`fixpath "$CLASSPATH"`"'"

echo CLASS___PATH___ $CLASSPATH


usage=0
verbose=0
dot=0
nondot=0

while true; do
    case "$1" in
        "")
            break
            ;;
        #-dot)
        #    # Should not be used in conjunction with other flags..
        #    # ..that output to stdout
        #    ARGS="$ARGS '-fsm'"
        #    shift
        #    ARGS="$ARGS '$1'"
        #    shift
        #    ARGS="$ARGS '$1'"
        #    shift
        #    dot=$1
        #    if [ "$dot" == '' ]; then
        #      echo '-dot missing output file name argument'
        #      exit 1
        #    fi
        #    shift
        #    ;;
        -h)
            usage=1
            break
            ;;
        --help)
            usage=1
            break
            ;;
        --verbose)
            verbose=1
            shift
            ;;
        #-ip)
        #    ARGS="$ARGS '$1'"
        #    shift
        #    ;;
        #-d)
        #    ARGS="$ARGS '$1'"
        #    shift
        #    ;;
        #-subtypes)
        #    ARGS="$ARGS '$1'"
        #    shift
        #    ;;
        #-*)
        #    nondot=1
        #    ARGS="$ARGS '$1'"
        #    shift
        #    ;;
        *)
            ARGS="$ARGS '$1'"
            shift
            ;;
    esac
done