use crate::utils;
use hmac::{Hmac, Mac};
use sha2::Sha256;
use std::any::Any;
use std::collections::HashMap;
use std::io::{Cursor, Error, ErrorKind, Read, Write};

pub const VERSION: &str = "007";
pub const VERSION_LENGTH: usize = 3;

// Service type
pub const SERVICE_TYPE_RTC: u16 = 1;
pub const SERVICE_TYPE_RTM: u16 = 2;
pub const SERVICE_TYPE_FPA: u16 = 4;
pub const SERVICE_TYPE_CHAT: u16 = 5;
pub const SERVICE_TYPE_APAAS: u16 = 7;

// Rtc
pub const PRIVILEGE_JOIN_CHANNEL: u16 = 1;
pub const PRIVILEGE_PUBLISH_AUDIO_STREAM: u16 = 2;
pub const PRIVILEGE_PUBLISH_VIDEO_STREAM: u16 = 3;
pub const PRIVILEGE_PUBLISH_DATA_STREAM: u16 = 4;

// Rtm
// Fpa
pub const PRIVILEGE_LOGIN: u16 = 1;

// Chat
pub const PRIVILEGE_CHAT_USER: u16 = 1;
pub const PRIVILEGE_CHAT_APP: u16 = 2;

// Apaas
pub const PRIVILEGE_APAAS_ROOM_USER: u16 = 1;
pub const PRIVILEGE_APAAS_USER: u16 = 2;
pub const PRIVILEGE_APAAS_APP: u16 = 3;

/// Defines the behavior shared by all Token007 services.
pub trait IService {
    fn as_any(&self) -> &dyn Any;
    fn get_service_type(&self) -> u16;
    fn pack(&self, writer: &mut dyn Write) -> Result<(), Error>;
    fn unpack(&mut self, reader: &mut dyn Read) -> Result<(), Error>;
}

#[derive(Debug)]
/// Stores a service type and its privilege expiration timestamps.
pub struct Service {
    pub privileges: HashMap<u16, u32>,
    pub service_type: u16,
}

/// Creates a service with the specified type and no privileges.
pub fn new_service(service_type: u16) -> Service {
    Service {
        privileges: HashMap::new(),
        service_type,
    }
}

impl Service {
    /// Adds or replaces a privilege expiration timestamp.
    pub fn add_privilege(&mut self, privilege: u16, expire: u32) {
        self.privileges.insert(privilege, expire);
    }

    /// Serializes all privileges in numeric key order.
    pub fn pack_privileges(&self, writer: &mut dyn Write) -> Result<(), Error> {
        utils::pack_map_uint32(writer, &self.privileges)
    }

    /// Serializes the numeric service type.
    pub fn pack_type(&self, writer: &mut dyn Write) -> Result<(), Error> {
        utils::pack_uint16(writer, self.service_type)
    }
}

impl IService for Service {
    fn as_any(&self) -> &dyn Any {
        self
    }

    fn get_service_type(&self) -> u16 {
        self.service_type
    }

    fn pack(&self, writer: &mut dyn Write) -> Result<(), Error> {
        self.pack_type(writer)?;
        self.pack_privileges(writer)
    }

    fn unpack(&mut self, reader: &mut dyn Read) -> Result<(), Error> {
        self.privileges = utils::unpack_map_uint32(reader)?;
        Ok(())
    }
}

#[derive(Debug)]
/// Stores an RTC service payload.
pub struct ServiceRtc {
    pub service: Service,
    pub channel_name: String,
    pub uid: String,
}

/// Creates an RTC service for a channel and user ID.
pub fn new_service_rtc(channel_name: &str, uid: &str) -> ServiceRtc {
    ServiceRtc {
        service: new_service(SERVICE_TYPE_RTC),
        channel_name: channel_name.to_string(),
        uid: uid.to_string(),
    }
}

impl IService for ServiceRtc {
    fn as_any(&self) -> &dyn Any {
        self
    }

    fn get_service_type(&self) -> u16 {
        self.service.service_type
    }

    fn pack(&self, w: &mut dyn Write) -> Result<(), Error> {
        self.service.pack(w)?;
        utils::pack_string(w, &self.channel_name)?;
        utils::pack_string(w, &self.uid)
    }

    fn unpack(&mut self, r: &mut dyn Read) -> Result<(), Error> {
        self.service.unpack(r)?;
        self.channel_name = utils::unpack_string(r)?;
        self.uid = utils::unpack_string(r)?;
        Ok(())
    }
}

#[derive(Debug)]
/// Stores an RTM service payload.
pub struct ServiceRtm {
    pub service: Service,
    pub user_id: String,
}

/// Creates an RTM service for a user ID.
pub fn new_service_rtm(user_id: &str) -> ServiceRtm {
    ServiceRtm {
        service: new_service(SERVICE_TYPE_RTM),
        user_id: user_id.to_string(),
    }
}

impl IService for ServiceRtm {
    fn as_any(&self) -> &dyn Any {
        self
    }

    fn get_service_type(&self) -> u16 {
        self.service.service_type
    }

    fn pack(&self, w: &mut dyn Write) -> Result<(), Error> {
        self.service.pack(w)?;
        utils::pack_string(w, &self.user_id)
    }

    fn unpack(&mut self, r: &mut dyn Read) -> Result<(), Error> {
        self.service.unpack(r)?;
        self.user_id = utils::unpack_string(r)?;
        Ok(())
    }
}

#[derive(Debug)]
/// Stores an FPA service payload.
pub struct ServiceFpa {
    pub service: Service,
}

/// Creates an FPA service.
pub fn new_service_fpa() -> ServiceFpa {
    ServiceFpa {
        service: new_service(SERVICE_TYPE_FPA),
    }
}

impl IService for ServiceFpa {
    fn as_any(&self) -> &dyn Any {
        self
    }

    fn get_service_type(&self) -> u16 {
        self.service.service_type
    }

    fn pack(&self, w: &mut dyn Write) -> Result<(), Error> {
        self.service.pack(w)
    }

    fn unpack(&mut self, r: &mut dyn Read) -> Result<(), Error> {
        self.service.unpack(r)
    }
}

#[derive(Debug)]
/// Stores a Chat service payload.
pub struct ServiceChat {
    pub service: Service,
    pub user_id: String,
}

/// Creates a Chat service for a user ID.
pub fn new_service_chat(user_id: &str) -> ServiceChat {
    ServiceChat {
        service: new_service(SERVICE_TYPE_CHAT),
        user_id: user_id.to_string(),
    }
}

impl IService for ServiceChat {
    fn as_any(&self) -> &dyn Any {
        self
    }

    fn get_service_type(&self) -> u16 {
        self.service.service_type
    }

    fn pack(&self, w: &mut dyn Write) -> Result<(), Error> {
        self.service.pack(w)?;
        utils::pack_string(w, &self.user_id)
    }

    fn unpack(&mut self, r: &mut dyn Read) -> Result<(), Error> {
        self.service.unpack(r)?;
        self.user_id = utils::unpack_string(r)?;
        Ok(())
    }
}

#[derive(Debug)]
/// Stores an APaaS service payload.
pub struct ServiceApaas {
    pub service: Service,
    pub room_uuid: String,
    pub user_uuid: String,
    pub role: i16,
}

/// Creates an APaaS service for a room, user, and role.
pub fn new_service_apaas(room_uuid: &str, user_uuid: &str, role: i16) -> ServiceApaas {
    ServiceApaas {
        service: new_service(SERVICE_TYPE_APAAS),
        room_uuid: room_uuid.to_string(),
        user_uuid: user_uuid.to_string(),
        role,
    }
}

impl IService for ServiceApaas {
    fn as_any(&self) -> &dyn Any {
        self
    }

    fn get_service_type(&self) -> u16 {
        self.service.service_type
    }

    fn pack(&self, w: &mut dyn Write) -> Result<(), Error> {
        self.service.pack(w)?;
        utils::pack_string(w, &self.room_uuid)?;
        utils::pack_string(w, &self.user_uuid)?;
        utils::pack_int16(w, self.role)
    }

    fn unpack(&mut self, r: &mut dyn Read) -> Result<(), Error> {
        self.service.unpack(r)?;
        self.room_uuid = utils::unpack_string(r)?;
        self.user_uuid = utils::unpack_string(r)?;
        self.role = utils::unpack_int16(r)?;
        Ok(())
    }
}

#[derive(Debug)]
/// Builds, parses, and verifies Token007 tokens containing one or more services.
pub struct AccessToken {
    app_cert: String,
    app_id: String,
    expire: u32,
    issue_ts: u32,
    salt: u32,
    pub services: Vec<Box<dyn IService>>,
    signature: Vec<u8>,
    signing_info: Vec<u8>,
    parsed: bool,
}

/// Creates a Token007 builder with the current timestamp and a random salt.
pub fn new_access_token(app_id: &str, app_cert: &str, expire: u32) -> AccessToken {
    let issue_ts = std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_secs() as u32;
    let salt = utils::get_rand(1, 99999999) as u32;

    return AccessToken {
        app_cert: app_cert.to_string(),
        app_id: app_id.to_string(),
        expire,
        issue_ts,
        salt,
        services: Vec::new(),
        signature: Vec::new(),
        signing_info: Vec::new(),
        parsed: false,
    };
}

/// Creates an empty Token007 parser.
pub fn create_access_token() -> AccessToken {
    new_access_token("", "", 900)
}

impl std::fmt::Debug for dyn IService + 'static {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "service_type:{:?}", self.get_service_type())
    }
}

impl AccessToken {
    /// Adds a service without replacing services of the same type.
    pub fn add_service(&mut self, service: Box<dyn IService>) {
        self.services.push(service);
    }

    /// Returns all services of the requested type in insertion or token order.
    pub fn get_services(&self, service_type: u16) -> Vec<&dyn IService> {
        self.services.iter().filter(|service| service.get_service_type() == service_type).map(|service| service.as_ref()).collect()
    }

    /// Builds a Token007 token and requires at least one service.
    pub fn build(&self) -> Result<String, Box<dyn std::error::Error>> {
        if !is_uuid(&self.app_id) || !is_uuid(&self.app_cert) {
            return Err("check appId or appCertificate".to_string().into());
        }
        if self.services.is_empty() {
            return Err("no service added".to_string().into());
        }

        let mut buf = Vec::new();
        utils::pack_string(&mut buf, &self.app_id)?;
        utils::pack_uint32(&mut buf, self.issue_ts)?;
        utils::pack_uint32(&mut buf, self.expire)?;
        utils::pack_uint32(&mut buf, self.salt)?;
        let mut services: Vec<&dyn IService> = self.services.iter().map(|service| service.as_ref()).collect();
        services.sort_by_key(|service| service.get_service_type());
        utils::pack_uint16(&mut buf, services.len() as u16)?;

        // Sign
        let sign = self.get_sign()?;

        // Stable sorting preserves insertion order for repeated service types.
        for service in services {
            service.pack(&mut buf)?;
        }

        // Signature
        let mut h_sign = Hmac::<Sha256>::new_from_slice(&sign)?;
        h_sign.update(&buf);
        let signature = h_sign.finalize().into_bytes();

        let mut buf_content = Vec::new();
        utils::pack_bytes(&mut buf_content, signature.as_slice())?;

        buf_content.extend(&buf);

        let res = get_version() + &utils::base64_encode_str(&utils::compress_zlib(&buf_content));
        Ok(res)
    }

    /// Parses known services and retains the original bytes for signature verification.
    pub fn parse(&mut self, token: &str) -> Result<bool, Error> {
        // Clear the previous token state so a failed parse cannot reuse its signature or services.
        self.app_id.clear();
        self.issue_ts = 0;
        self.expire = 0;
        self.salt = 0;
        self.services.clear();
        self.signature.clear();
        self.signing_info.clear();
        self.parsed = false;

        if token.as_bytes().get(..VERSION_LENGTH) != Some(VERSION.as_bytes()) {
            return Ok(false);
        }

        let encoded = token.get(VERSION_LENGTH..).ok_or_else(|| Error::new(ErrorKind::InvalidData, "invalid token encoding"))?;
        let decoded = utils::base64_decode_str(encoded).map_err(|error| Error::new(ErrorKind::InvalidData, error))?;
        let mut decoder = flate2::read::ZlibDecoder::new(decoded.as_slice());
        let mut data = Vec::new();
        decoder.read_to_end(&mut data)?;
        let mut buffer = Cursor::new(data.as_slice());

        self.signature = utils::unpack_bytes(&mut buffer)?;
        self.signing_info = data[buffer.position() as usize..].to_vec();
        self.services.clear();

        self.app_id = utils::unpack_string(&mut buffer)?;
        self.issue_ts = utils::unpack_uint32(&mut buffer)?;
        self.expire = utils::unpack_uint32(&mut buffer)?;
        self.salt = utils::unpack_uint32(&mut buffer)?;

        let service_num = utils::unpack_uint16(&mut buffer)?;

        for _ in 0..service_num {
            let service_type = utils::unpack_uint16(&mut buffer)?;
            let Some(mut service) = create_service(service_type) else {
                self.parsed = true;
                return Ok(true);
            };

            service.unpack(&mut buffer)?;
            self.add_service(service);
        }

        self.parsed = true;
        Ok(true)
    }

    /// Derives the signing key with the stored App Certificate.
    pub fn get_sign(&self) -> Result<Vec<u8>, Error> {
        self.get_sign_with_certificate(&self.app_cert)
    }

    /// Verifies the signature of a successfully parsed token.
    pub fn verify_signature(&self, app_certificate: &str) -> bool {
        if !self.parsed || self.signature.is_empty() || self.signing_info.is_empty() || !is_uuid(&self.app_id) || !is_uuid(app_certificate) {
            return false;
        }

        let Ok(sign) = self.get_sign_with_certificate(app_certificate) else {
            return false;
        };
        let Ok(mut h_sign) = Hmac::<Sha256>::new_from_slice(&sign) else {
            return false;
        };
        h_sign.update(&self.signing_info);
        h_sign.verify_slice(&self.signature).is_ok()
    }

    /// Creates a parser for a known service type and panics for an unknown type.
    pub fn new_service(&mut self, service_type: u16) -> Box<dyn IService> {
        create_service(service_type).unwrap_or_else(|| panic!("new service failed: unknown service type `{}`", service_type))
    }

    /// Derives the signing key with the supplied App Certificate.
    fn get_sign_with_certificate(&self, app_certificate: &str) -> Result<Vec<u8>, Error> {
        // IssueTs
        let mut buf_issue_ts = Vec::new();
        utils::pack_uint32(&mut buf_issue_ts, self.issue_ts)?;
        let mut h_issue_ts = Hmac::<Sha256>::new_from_slice(&buf_issue_ts).expect("HMAC issue_ts error");
        h_issue_ts.update(app_certificate.as_bytes());

        // Salt
        let mut buf_salt = Vec::new();
        utils::pack_uint32(&mut buf_salt, self.salt)?;
        let mut h_salt = Hmac::<Sha256>::new_from_slice(&buf_salt).expect("HMAC salt error");
        h_salt.update(h_issue_ts.finalize().into_bytes().as_slice());

        Ok(h_salt.finalize().into_bytes().to_vec())
    }
}

/// Creates a parser for a known service type.
fn create_service(service_type: u16) -> Option<Box<dyn IService>> {
    match service_type {
        SERVICE_TYPE_RTC => Some(Box::new(new_service_rtc("", ""))),
        SERVICE_TYPE_RTM => Some(Box::new(new_service_rtm(""))),
        SERVICE_TYPE_FPA => Some(Box::new(new_service_fpa())),
        SERVICE_TYPE_CHAT => Some(Box::new(new_service_chat(""))),
        SERVICE_TYPE_APAAS => Some(Box::new(new_service_apaas("", "", -1))),
        _ => None,
    }
}

/// Converts a numeric user ID to its token string representation.
pub fn get_uid_str(uid: u32) -> String {
    if uid == 0 {
        return String::from("");
    }
    uid.to_string()
}

/// Returns the Token007 version prefix.
pub fn get_version() -> String {
    String::from(VERSION)
}

/// Returns whether a value is a 32-character hexadecimal identifier.
pub fn is_uuid(s: &str) -> bool {
    if s.len() != 32 {
        return false;
    }

    return s.chars().all(|c| c.is_digit(16));
}

#[cfg(test)]
mod tests {
    use super::*;

    const APP_ID: &str = "970CA35de60c44645bbae8a215061b33";
    const APP_CERT: &str = "5CFd2fd1755d40ecb72977518be15d3b";
    const CHANNEL_NAME: &str = "7d72365eb983485397e3e3f9d460bdda";
    const UID: &str = "2882341273";
    const USER_ID: &str = "test_user";
    const EXPIRE: u32 = 600;
    const SALT: u32 = 1;
    const ISSUE_TS: u32 = 1111111;

    /// Creates a token with deterministic timestamp and salt values.
    fn deterministic_token() -> AccessToken {
        let mut token = new_access_token(APP_ID, APP_CERT, EXPIRE);
        token.issue_ts = ISSUE_TS;
        token.salt = SALT;
        token
    }

    /// Adds a deterministic RTC service to a token.
    fn add_rtc_service(token: &mut AccessToken, channel_name: &str, uid: &str, expire: u32) {
        let mut service = new_service_rtc(channel_name, uid);
        service.service.add_privilege(PRIVILEGE_JOIN_CHANNEL, expire);
        token.add_service(Box::new(service));
    }

    /// Verifies token generation rejects an empty service list.
    #[test]
    fn test_build_rejects_empty_services() {
        let error = deterministic_token().build().unwrap_err();

        assert_eq!("no service added", error.to_string());
    }

    /// Verifies deterministic RTC token generation remains unchanged.
    #[test]
    fn test_service_rtc() {
        let mut access_token = deterministic_token();
        add_rtc_service(&mut access_token, CHANNEL_NAME, UID, EXPIRE);

        assert_eq!("007eJwBigB1/yAAFqC4TFpegsv3T7gT0J9ZxUvaycBhIFgFOayXV46VixogADk3MENBMzVkZTYwYzQ0NjQ1YmJhZThhMjE1MDYxYjMzR/QQAFgCAAABAAAAAQABAAEAAQBYAgAAIAA3ZDcyMzY1ZWI5ODM0ODUzOTdlM2UzZjlkNDYwYmRkYQoAMjg4MjM0MTI3M8JqJOM=", access_token.build().unwrap());
    }

    /// Parses an old Token007 token and exposes its RTC service fields.
    #[test]
    fn test_parse_old_token() {
        let mut access_token = create_access_token();
        let token = "007eJwBigB1/yAAFqC4TFpegsv3T7gT0J9ZxUvaycBhIFgFOayXV46VixogADk3MENBMzVkZTYwYzQ0NjQ1YmJhZThhMjE1MDYxYjMzR/QQAFgCAAABAAAAAQABAAEAAQBYAgAAIAA3ZDcyMzY1ZWI5ODM0ODUzOTdlM2UzZjlkNDYwYmRkYQoAMjg4MjM0MTI3M8JqJOM=";

        let res = access_token.parse(token).unwrap();
        let rtc_services = access_token.get_services(SERVICE_TYPE_RTC);
        let service_rtc = rtc_services[0];

        assert!(res);
        assert_eq!(APP_ID, access_token.app_id);
        assert_eq!(EXPIRE, access_token.expire);
        assert_eq!(SALT, access_token.salt);
        assert_eq!(ISSUE_TS, access_token.issue_ts);
        assert_eq!(SERVICE_TYPE_RTC, service_rtc.get_service_type());
        assert!(access_token.verify_signature(APP_CERT));

        if let Some(service_rtc_downcast) = service_rtc.as_any().downcast_ref::<ServiceRtc>() {
            assert_eq!(CHANNEL_NAME, service_rtc_downcast.channel_name);
            assert_eq!(UID, service_rtc_downcast.uid);
            assert_eq!(EXPIRE, service_rtc_downcast.service.privileges[&PRIVILEGE_JOIN_CHANNEL]);
        } else {
            panic!("expected RTC service");
        }
    }

    /// Preserves repeated service types and their insertion order after parsing.
    #[test]
    fn test_repeated_service_types() {
        let mut access_token = deterministic_token();

        let mut rtm_service = new_service_rtm(USER_ID);
        rtm_service.service.add_privilege(PRIVILEGE_LOGIN, EXPIRE + 50);
        access_token.add_service(Box::new(rtm_service));
        add_rtc_service(&mut access_token, CHANNEL_NAME, UID, EXPIRE);

        let mut stream_service = new_service_rtc("stream-channel", "stream-user");
        stream_service.service.add_privilege(PRIVILEGE_JOIN_CHANNEL, EXPIRE + 100);
        stream_service.service.add_privilege(PRIVILEGE_PUBLISH_DATA_STREAM, EXPIRE + 100);
        access_token.add_service(Box::new(stream_service));

        assert_eq!(SERVICE_TYPE_RTM, access_token.services[0].get_service_type());
        assert_eq!(2, access_token.get_services(SERVICE_TYPE_RTC).len());

        let mut parsed = create_access_token();
        assert!(parsed.parse(&access_token.build().unwrap()).unwrap());
        let rtc_services = parsed.get_services(SERVICE_TYPE_RTC);
        assert_eq!(2, rtc_services.len());

        let first_rtc = rtc_services[0].as_any().downcast_ref::<ServiceRtc>().unwrap();
        let second_rtc = rtc_services[1].as_any().downcast_ref::<ServiceRtc>().unwrap();
        assert_eq!(CHANNEL_NAME, first_rtc.channel_name);
        assert_eq!("stream-channel", second_rtc.channel_name);
        assert_eq!(EXPIRE + 100, second_rtc.service.privileges[&PRIVILEGE_PUBLISH_DATA_STREAM]);
        assert_eq!(1, parsed.get_services(SERVICE_TYPE_RTM).len());
        assert!(parsed.verify_signature(APP_CERT));
        assert!(!parsed.verify_signature("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"));
    }

    /// Keeps known services parsed before an unknown service type.
    #[test]
    fn test_unknown_service_after_known_service() {
        let mut access_token = deterministic_token();
        add_rtc_service(&mut access_token, CHANNEL_NAME, UID, EXPIRE);

        let mut unknown_service = new_service(999);
        unknown_service.add_privilege(1, EXPIRE);
        access_token.add_service(Box::new(unknown_service));

        let mut parsed = create_access_token();
        assert!(parsed.parse(&access_token.build().unwrap()).unwrap());
        assert_eq!(1, parsed.get_services(SERVICE_TYPE_RTC).len());
        assert!(parsed.get_services(999).is_empty());
        assert!(parsed.verify_signature(APP_CERT));
    }

    /// Stops before known services that follow an unknown service payload.
    #[test]
    fn test_unknown_service_before_known_service() {
        let mut access_token = deterministic_token();
        add_rtc_service(&mut access_token, CHANNEL_NAME, UID, EXPIRE);

        let mut unknown_service = new_service(0);
        unknown_service.add_privilege(1, EXPIRE);
        access_token.add_service(Box::new(unknown_service));

        let mut parsed = create_access_token();
        assert!(parsed.parse(&access_token.build().unwrap()).unwrap());
        assert!(parsed.get_services(SERVICE_TYPE_RTC).is_empty());
        assert!(parsed.verify_signature(APP_CERT));
    }

    /// Sorts a packing copy without changing the public service insertion order.
    #[test]
    fn test_stable_service_type_ordering() {
        let mut reverse_order = deterministic_token();
        let mut rtm_service = new_service_rtm(USER_ID);
        rtm_service.service.add_privilege(PRIVILEGE_LOGIN, EXPIRE);
        reverse_order.add_service(Box::new(rtm_service));
        add_rtc_service(&mut reverse_order, CHANNEL_NAME, UID, EXPIRE);

        let mut numeric_order = deterministic_token();
        add_rtc_service(&mut numeric_order, CHANNEL_NAME, UID, EXPIRE);
        let mut rtm_service = new_service_rtm(USER_ID);
        rtm_service.service.add_privilege(PRIVILEGE_LOGIN, EXPIRE);
        numeric_order.add_service(Box::new(rtm_service));

        assert_eq!(reverse_order.build().unwrap(), numeric_order.build().unwrap());
        assert_eq!(SERVICE_TYPE_RTM, reverse_order.services[0].get_service_type());
    }

    /// Replaces services from an earlier parse when parsing an old token.
    #[test]
    fn test_parse_clears_previous_services() {
        let mut generated = deterministic_token();
        let mut rtm_service = new_service_rtm(USER_ID);
        rtm_service.service.add_privilege(PRIVILEGE_LOGIN, EXPIRE);
        generated.add_service(Box::new(rtm_service));

        let mut parsed = create_access_token();
        assert!(parsed.parse(&generated.build().unwrap()).unwrap());
        assert_eq!(1, parsed.get_services(SERVICE_TYPE_RTM).len());

        let old_token = "007eJwBigB1/yAAFqC4TFpegsv3T7gT0J9ZxUvaycBhIFgFOayXV46VixogADk3MENBMzVkZTYwYzQ0NjQ1YmJhZThhMjE1MDYxYjMzR/QQAFgCAAABAAAAAQABAAEAAQBYAgAAIAA3ZDcyMzY1ZWI5ODM0ODUzOTdlM2UzZjlkNDYwYmRkYQoAMjg4MjM0MTI3M8JqJOM=";
        assert!(parsed.parse(old_token).unwrap());
        assert_eq!(1, parsed.services.len());
        assert_eq!(1, parsed.get_services(SERVICE_TYPE_RTC).len());
        assert!(parsed.get_services(SERVICE_TYPE_RTM).is_empty());
        assert!(parsed.verify_signature(APP_CERT));
    }

    /// Rejects signature verification before parsing or with invalid certificates.
    #[test]
    fn test_verify_signature_preconditions() {
        let mut parsed = create_access_token();
        assert!(!parsed.verify_signature(APP_CERT));
        assert!(!parsed.parse("006invalid").unwrap());

        let mut generated = deterministic_token();
        add_rtc_service(&mut generated, CHANNEL_NAME, UID, EXPIRE);
        assert!(parsed.parse(&generated.build().unwrap()).unwrap());
        assert!(!parsed.verify_signature("invalid"));
        assert!(!parsed.verify_signature("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"));
        assert!(parsed.verify_signature(APP_CERT));

        assert!(!parsed.parse("006invalid").unwrap());
        assert!(!parsed.verify_signature(APP_CERT));
        assert!(parsed.services.is_empty());
    }
}
