#
# ${CATALINA_BASE}/bin/setenv.sh
#
# Note: as most environment settings are done in Dockerfile, this is almost empty,
#       except of executing the optional index initializing script below.
#

if [ -r "$CATALINA_BASE/bin/index-init.sh" ]; then
  . "$CATALINA_BASE/bin/index-init.sh"
fi
