#!/bin/bash
#
# mongo_suspend_balancer.sh [<expire_in_secs, default = 300>]
# returns suspension_id
#

if [ -z "$1" ]; then
	EXPIRE_DATE=$(date --from "XXX")
else
	EXPIRE_DATE=$(date --from "$1")
fi
retVal = $(mongo --quiet balancer_manager <<EOF
var suspensionId = new ObjectId();
var expireDate = new Date($EXPIRE_DATE);
db.suspensions.save({_id: suspensionId, expires: expireDate});
print(suspensionId.toString());
EOF
)
echo retVal | grep -o '[a-zA-Z0-9]+'
