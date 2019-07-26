package io.agora.media;

public class RtcTokenBuilder {
	public enum Role {
        Role_Attendee(0),  // for communication
        Role_Publisher(1), // for live broadcast
        Role_Subscriber(2),  // for live broadcast
        Role_Admin(101);

        public int initValue;

        Role(int initValue) {
            this.initValue = initValue;
        }
    }

    /**
     * @param appId The App ID issued to you by Agora. Apply for a new App ID from 
     *        Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in 
     *        the Agora Dashboard. See Get an App Certificate.
     * @param channelName Unique channel name for the AgoraRTC session in the string format
     * @param uid  User ID. A 32-bit unsigned integer with a value ranging from 
     *        1 to (232-1). optionalUid must be unique.
     * @param role Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
     *             Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
     * @param privilegeTs represented by the number of seconds elapsed since 1/1/1970.
     *        If, for example, you want to access the Agora Service within 10 minutes
     *        after the token is generated, set expireTimestamp as the current time stamp
     *        + 600 (seconds).                             
     */
    public String buildTokenWithUid(String appId, String appCertificate, 
    		String channelName, int uid, Role role, int privilegeTs) {
    	String account = String.valueOf(uid);
    	return buildTokenWithUserAccount(appId, appCertificate, channelName, 
    			account, role, privilegeTs);
    }
    
    /**
     * @param appId The App ID issued to you by Agora. Apply for a new App ID from 
     *        Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in 
     *        the Agora Dashboard. See Get an App Certificate.
     * @param channelName Unique channel name for the AgoraRTC session in the string format
     * @param account  User account
     * @param role Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
     *             Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
     * @param privilegeTs represented by the number of seconds elapsed since 1/1/1970.
     *        If, for example, you want to access the Agora Service within 10 minutes
     *        after the token is generated, set expireTimestamp as the current time stamp
     *        + 600 (seconds).                             
     */
    public String buildTokenWithUserAccount(String appId, String appCertificate, 
    		String channelName, String account, Role role, int privilegeTs) {
    	
    	// Assign appropriate access privileges to each role.
    	AccessToken builder = new AccessToken(appId, appCertificate, channelName, account);
    	builder.addPrivilege(AccessToken.Privileges.kJoinChannel, privilegeTs);
    	if (role == Role.Role_Publisher || role == Role.Role_Subscriber || role == Role.Role_Admin) {
    		builder.addPrivilege(AccessToken.Privileges.kPublishAudioStream, privilegeTs);
    		builder.addPrivilege(AccessToken.Privileges.kPublishVideoStream, privilegeTs);
    		builder.addPrivilege(AccessToken.Privileges.kPublishDataStream, privilegeTs);
    	}
    	
    	try {
			return builder.build();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
    }
}
