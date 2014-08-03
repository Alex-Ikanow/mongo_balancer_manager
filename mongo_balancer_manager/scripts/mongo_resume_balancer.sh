#!/bin/bash
#
# mongo_resume_balancer.sh <suspension_id>
#
mongo balancer_manager <<EOF
db.suspensions.remove({_id: ObjectId("$1"})
EOF

