#!/bin/bash --login
LANG=zh_CN.utf8;export LANG

cd `dirname $0`
BIN_DIR=`pwd -P`
cd ..
DEPLOY_DIR=`pwd -P`
CONF_DIR=$DEPLOY_DIR/conf
START_CLASS=com.alex.start.Main

SERVER_PATH=`echo $BIN_DIR | sed 's/bin//g'`
HOSTNAME=`hostname`

if [ -z "$SERVER_PATH" ]; then
	SERVER_PATH=`hostname`
fi

PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$SERVER_PATH" |awk '{print $2}'`
if [ -n "$PIDS" ]; then
    echo "ERROR: The $SERVER_PATH already started!"
    echo "PID: $PIDS"
    exit 1
fi


LOGS_DIR=$DEPLOY_DIR/logs

if [ ! -d $LOGS_DIR ]; then
	mkdir $LOGS_DIR
fi
CUR_DATE=`date '+%Y%m%d%H%M%S'`
STDOUT_FILE=$LOGS_DIR/stdout.log.${CUR_DATE}

LIB_DIR=$DEPLOY_DIR/lib
LIB_JARS=`ls $LIB_DIR|grep .jar|awk '{print "'$LIB_DIR'/"$0}'|tr "\n" ":"`

JAVA_OPTS=" -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Ddubbo.shutdown.hook=true "
JAVA_DEBUG_OPTS=""
if [ "$1" = "debug" ]; then
    JAVA_DEBUG_OPTS=" -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8002,server=y,suspend=n "
fi
JAVA_JMX_OPTS=""
if [ "$1" = "jmx" ]; then
    JAVA_JMX_OPTS=" -Dcom.sun.management.jmxremote.port=1100 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=$HOSTNAME"
fi

JAVA_MEM_OPTS=" -server -XX:PermSize=1024m -Xss2048k -Xms2048m -XX:+PrintGC -XX:+PrintGCDateStamps -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=512m -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -XX:MaxTenuringThreshold=15 -XX:SurvivorRatio=6 "

JAVA_COMPILER_OPTS=" -XX:InitialCodeCacheSize=48m -XX:ReservedCodeCacheSize=256m -XX:+UseCodeCacheFlushing -XX:CICompilerCount=4 -XX:+TieredCompilation "
if [ "$1" == "JIT_LOG" ]; then
    JAVA_COMPILER_OPTS="$JAVA_COMPILER_OPTS -XX:+PrintCompilation "
fi
echo -e "Starting the $SERVER_PATH ...\c"
AGENT_PATH=/usr/local/pinpoint-agent
APPLICATION_NAME=`pwd |xargs basename`
APPLICATION_NAME=`expr substr "$APPLICATION_NAME" 1 14`
HOST_NAME=`hostname`
APPLICATION_ID=`expr substr "${APPLICATION_NAME}_$HOST_NAME" 1 24`
JAVA_AGENT=" -javaagent:$AGENT_PATH/pinpoint-bootstrap.jar -Dpinpoint.agentId=$APPLICATION_ID -Dpinpoint.applicationName=$APPLICATION_NAME"
if [ -d $AGENT_PATH ]; then
  JAVA_OPTS="$JAVA_OPTS $JAVA_AGENT"
fi
nohup java $JAVA_OPTS $JAVA_COMPILER_OPTS $JAVA_MEM_OPTS $JAVA_DEBUG_OPTS $JAVA_JMX_OPTS -classpath $CONF_DIR:$LIB_JARS $START_CLASS > $STDOUT_FILE 2>&1 &

echo "OK!"

PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$DEPLOY_DIR""/" | awk '{print $2}'`
echo "PID: $PIDS"

echo $PIDS>run.pid

echo "STDOUT: $STDOUT_FILE"
