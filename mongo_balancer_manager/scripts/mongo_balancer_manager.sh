#!/bin/bash
#
# balancer_manager.suspensions
# { _id: ObjectId, expires: Date }
#
mongo balancer_manager <<EOF
var now = new Date();
var curr = 0;
var toremove = [];
var numtoremove = 0;
db.suspensions.find().forEach(function(x){
	if (now.getTime() > x.expires.getTime()) {
		toremove.push(x._id);
		numtoremove = 0;
	}
	else {
		curr++;
	}
});
if (numtoremove > 0) {
	db.suspensions.remove({_id:{$in: toremove}});
}
if (curr > 0) {
	sh.stopBalancer();
}
else {
	sh.startBalancer();
}
EOF
