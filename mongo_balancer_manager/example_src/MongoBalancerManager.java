package com.ikanow.mongodb.util;

class MongoBalancerManager {
	
	public final static String DB = "balancer_manager";
	public final static String COLLECTION = "suspensions";
	
	protected static MongoClient _mongoClient;
	
	public MongoBalancerManager() {
		this(null, 27017);
	}
	public MongoBalancerManager(int port) {
		this(null, port);
	}
	public MongoBalancerManager(String host, int port) {
		if (null == _mongoClient) {
			if (null == host) {
				host = "127.0.0.1";
			}
			_mongoClient = new MongoClient(host, port);
		}
	}
	// Default suspension time 5 minues
	public ObjectId suspendBalancing() {
		return suspendBalancing(300);
	}
	public ObjectId suspendBalancing(int expireIn_secs) {
		return suspendingBalancing(new Date(new Date().getTime() + expireIn_secs*1000L));
	}
	public ObjectId suspendBalancing(Date expiresOn) {
		ObjectId suspensionId = new ObjectId();
		BasicDBObject suspender = new BasicDBObject("_id", suspensionId);
		suspender.put("expires", expiresOn);
		_mongoClient.getDB(DB).getCollection(COLLECTION).save(suspender);
	}
	public void resumeBalancing(ObjectId suspensionId) {
		_mongoClient.getDB(DB).getCollection(COLLECTION).remove(new BasicDBObject("_id", suspensionId));
	}
}