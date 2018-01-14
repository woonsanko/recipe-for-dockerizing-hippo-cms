#
# ${CATALINA_BASE}/bin/index-init.sh
#
# Check if the index directory exists. If not, and if the latest index export zip file is available,
# initialize the index directory by extracting the index export zip file to the index directory.
#
# Note: this script assumes that the latest index export zip file could be shared at
#       ${INDEX_EXPORT_ZIP} (configured in Dockerfile) through a volume.
#
# Ref) https://www.onehippo.org/library/enterprise/enterprise-features/lucene-index-export/lucene-index-export.html
#

echo "Checking if index directory exists at $REPO_PATH/workspaces/default/index..."

if [ ! -d "$REPO_PATH/workspaces/default/index" ]; then
  if [ -f "${INDEX_EXPORT_ZIP}" ]; then
    echo "Creating index directory at $REPO_PATH/workspaces/default/index..."
    mkdir -p $REPO_PATH/workspaces/default/index/
    echo "Unzipping index export zip, ${INDEX_EXPORT_ZIP}, to $REPO_PATH/workspaces/default/index/..."
    unzip ${INDEX_EXPORT_ZIP} -d $REPO_PATH/workspaces/default/index/
  fi
fi
