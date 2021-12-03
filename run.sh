#!/bin/bash
set -eo pipefail

echo "Create mount directory for service."
mkdir -p ./filestore
echo "Create mount directory for service completed."

echo "Mounting Cloud Filestore."
#mount -o nolock $FILESTORE_IP_ADDRESS:/$FILE_SHARE_NAME $MNT_DIR
#mount --verbose -o nolock 10.29.80.2:/filestore ./filestore
echo "Mounting completed."



echo "DO Main"
/app/main
echo "DO Main completed."


