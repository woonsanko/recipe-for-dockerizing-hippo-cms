#!/bin/sh

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ "$#" -lt 2 ]; then
  echo
  echo "  Usage: $0 <backup_storage_path> <index_export_download_URI> [<index_export_download_URI> ...]" >&2
  echo
  echo "  Examples:"
  echo "    > $0 /data/index http://admin:admin@localhost:8080/cms/ws/indexexport"
  echo
  exit 1
fi

BACKUP_STORAGE_PATH="${1}"
shift
INDEX_DOWNLOAD_URIS="$@"

##########################################################################
# Configuration Parameters
##########################################################################

# The symbolic link file name to the latest index backup zip file.
LOCAL_INDEX_SL_ZIP="index-export-latest.zip"
# Local index backup download file name with the current timestamp.
LOCAL_INDEX_TS_ZIP="index-export-$(date +'%Y%m%d-%H%M%S').zip"

##########################################################################
# Internal Flow from here.
##########################################################################

LOCAL_INDEX_TS_ZIP_TMP="${LOCAL_INDEX_TS_ZIP}.tmp"
LOCAL_INDEX_TS_ZIP_TMP_DOWNLOADED="false"
mkdir -p ${BACKUP_STORAGE_PATH}

# Loop each index export download URL and break the loop when successful.
for INDEX_URL in ${INDEX_DOWNLOAD_URIS}; do
  curl -f ${INDEX_URL} -o ${BACKUP_STORAGE_PATH}/${LOCAL_INDEX_TS_ZIP_TMP}
  if [ $? -eq 0 ]; then
    LOCAL_INDEX_TS_ZIP_TMP_DOWNLOADED="true"
    break
  fi
done

# Fail if it failed to download index export zip file.
if [ "${LOCAL_INDEX_TS_ZIP_TMP_DOWNLOADED}" != "true" ]; then
  echo "Failed to download index export zip file."
  exit 1
fi

mv ${BACKUP_STORAGE_PATH}/${LOCAL_INDEX_TS_ZIP_TMP} ${BACKUP_STORAGE_PATH}/${LOCAL_INDEX_TS_ZIP}

# Remove the existing symbolic link if exists.
if [ -f "${BACKUP_STORAGE_PATH}/${LOCAL_INDEX_SL_ZIP}" ]; then
  rm ${BACKUP_STORAGE_PATH}/${LOCAL_INDEX_SL_ZIP}
fi

ln -s ${BACKUP_STORAGE_PATH}/${LOCAL_INDEX_TS_ZIP} ${BACKUP_STORAGE_PATH}/${LOCAL_INDEX_SL_ZIP}
