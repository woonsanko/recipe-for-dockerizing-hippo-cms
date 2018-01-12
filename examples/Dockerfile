###############################################################################
# Base Image
###############################################################################

FROM tomcat:8.5-jre8

# Tomcat Base Directory
ENV CATALINA_BASE "/usr/local/tomcat"

###############################################################################
# Environment Variables
###############################################################################

# JVM Heap Size
ENV MIN_HEAP_SIZE "1024m"
ENV MAX_HEAP_SIZE "2048m"

# Repository Cluster Node ID
ENV CLUSTER_ID "$(whoami)-$(hostname -f)"

# Repository Configuration File
ENV REPO_CONFIG "file:${CATALINA_BASE}/conf/repository.xml"

# Bootstrapping enabled?
ENV REPO_BOOTSTRAP "true"

ENV REP_OPTS "-Drepo.bootstrap=${REPO_BOOTSTRAP} -Drepo.config=${REPO_CONFIG}"
ENV JVM_OPTS "-server -Xms${MIN_HEAP_SIZE} -Xmx${MAX_HEAP_SIZE} -XX:+UseG1GC -Djava.util.Arrays.useLegacyMergeSort=true"
ENV HEAP_DMP_OPTS "-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${CATALINA_BASE}/temp"
ENV RMI_OPTS "-Djava.rmi.server.hostname=127.0.0.1"
ENV JRC_OPTS "-Dorg.apache.jackrabbit.core.cluster.node_id=${CLUSTER_ID}"
ENV L4J_OPTS "-Dlog4j.configurationFile=file://${CATALINA_BASE}/conf/log4j2.xml -DLog4jContextSelector=org.apache.logging.log4j.core.selector.BasicContextSelector"
ENV VGC_OPTS "-verbosegc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:${CATALINA_BASE}/logs/gc.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=2048k"

ENV CATALINA_OPTS "${JVM_OPTS} ${VGC_OPTS} ${REP_OPTS} ${DMP_OPTS} ${RMI_OPTS} ${L4J_OPTS} ${JRC_OPTS}"

###############################################################################
# Remove existing artifacts and extract the tar ball
###############################################################################

RUN rm -rf ${CATALINA_BASE}/common/lib/*.jar
RUN rm -rf ${CATALINA_BASE}/shared/lib/*.jar
RUN rm -rf ${CATALINA_BASE}/webapps/*

ARG TAR_BALL
ADD ${TAR_BALL} ${CATALINA_BASE}/