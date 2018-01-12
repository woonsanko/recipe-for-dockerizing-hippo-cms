###############################################################################
# Base Image
###############################################################################

FROM tomcat:8.5-jre8

# Tomcat Base Directory, inherited from the base image by default.
ENV CATALINA_BASE "/usr/local/tomcat"

# Customize catalina.properties to add additional common and shared loader jar paths.
RUN sed -i s:common.loader=\.\*:common.loader=\${catalina.base}/lib,\${catalina.base}/lib/\*\.jar,\${catalina.base}/common/lib/\*\.jar,\${catalina.home}/lib,\${catalina.home}/lib/\*\.jar:g ${CATALINA_BASE}/conf/catalina.properties
RUN sed -i s:shared.loader=\.\*:shared.loader=\${catalina.base}/shared/classes,\${catalina.base}/shared/lib/\*\.jar:g ${CATALINA_BASE}/conf/catalina.properties

###############################################################################
# Environment Variable Configurations
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

###############################################################################
# Merging the Environment Variables
###############################################################################

ENV REP_OPTS "-Drepo.bootstrap=${REPO_BOOTSTRAP} -Drepo.config=${REPO_CONFIG}"
ENV JVM_OPTS "-server -Xms${MIN_HEAP_SIZE} -Xmx${MAX_HEAP_SIZE} -XX:+UseG1GC -Djava.util.Arrays.useLegacyMergeSort=true"
ENV DMP_OPTS "-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${CATALINA_BASE}/temp"
ENV RMI_OPTS "-Djava.rmi.server.hostname=127.0.0.1"
ENV JRC_OPTS "-Dorg.apache.jackrabbit.core.cluster.node_id=${CLUSTER_ID}"
ENV L4J_OPTS "-Dlog4j.configurationFile=file://${CATALINA_BASE}/conf/log4j2.xml -DLog4jContextSelector=org.apache.logging.log4j.core.selector.BasicContextSelector"
ENV VGC_OPTS "-verbosegc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:${CATALINA_BASE}/logs/gc.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=2048k"

ENV CATALINA_OPTS "${JVM_OPTS} ${VGC_OPTS} ${REP_OPTS} ${DMP_OPTS} ${RMI_OPTS} ${L4J_OPTS} ${JRC_OPTS}"

###############################################################################
# Remove existing artifacts and install new ones by extracting the tar ball
###############################################################################

RUN rm -rf ${CATALINA_BASE}/common/lib/*.jar
RUN rm -rf ${CATALINA_BASE}/shared/lib/*.jar
RUN rm -rf ${CATALINA_BASE}/webapps/*

ARG TAR_BALL
ADD ${TAR_BALL} ${CATALINA_BASE}/
