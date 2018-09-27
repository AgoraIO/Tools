#pragma once

#include <zlib.h>
#include <cstdlib>
#include <iostream>
#include <map>
#include <string>
#include <utility>
#include "cpp/src/AccessToken.h"

namespace agora {
    namespace tools {

// declaration

        enum Role {
            Role_Attendee = 0,  // for communication
            Role_Publisher = 1, // for live broadcast
            Role_Subscriber = 2,  // for live broadcast
            Role_Admin = 101,
        };

        struct SimpleTokenBuilder {
            SimpleTokenBuilder();
            SimpleTokenBuilder(const std::string& appId, const std::string& appCertificate,
                               const std::string& channelName, uint32_t uid = 0);
            SimpleTokenBuilder(const std::string& appId, const std::string& appCertificate,
                               const std::string& channelName, const std::string& uid = "");

            bool initTokenBuilder(const std::string& originToken);
            bool initPrivileges(Role role);
            void setPrivilege(AccessToken::Privileges privilege, uint32_t expireTimestamp = 0);
            void removePrivilege(AccessToken::Privileges privilege);
            std::string buildToken();

            AccessToken m_tokenCreator;
        };

// implementation

        static const AccessToken::PrivilegeMessageMap attendeePrivileges = {{AccessToken::kJoinChannel, 0}, {AccessToken::kPublishAudioStream, 0}, {AccessToken::kPublishVideoStream, 0}, {AccessToken::kPublishDataStream, 0}};
        static const AccessToken::PrivilegeMessageMap publisherPrivileges = {{AccessToken::kJoinChannel, 0}, {AccessToken::kPublishAudioStream, 0}, {AccessToken::kPublishVideoStream, 0}, {AccessToken::kPublishDataStream, 0}, {AccessToken::kPublishAudiocdn, 0}, {AccessToken::kPublishVideoCdn, 0}, {AccessToken::kInvitePublishAudioStream, 0}, {AccessToken::kInvitePublishVideoStream, 0}, {AccessToken::kInvitePublishDataStream, 0} };
        static const AccessToken::PrivilegeMessageMap subscriberPrivileges = {{AccessToken::kJoinChannel, 0}, {AccessToken::kRequestPublishAudioStream, 0}, {AccessToken::kRequestPublishVideoStream, 0}, {AccessToken::kRequestPublishDataStream, 0}};
        static const AccessToken::PrivilegeMessageMap adminPrivileges = {{AccessToken::kJoinChannel, 0}, {AccessToken::kPublishAudioStream, 0}, {AccessToken::kPublishVideoStream, 0}, {AccessToken::kPublishDataStream, 0}, {AccessToken::kAdministrateChannel, 0}};


        static const std::map<int, AccessToken::PrivilegeMessageMap> g_rolePrivileges = {{Role_Attendee, attendeePrivileges}, {Role_Publisher, publisherPrivileges}, {Role_Subscriber, subscriberPrivileges}, {Role_Admin, adminPrivileges}};

        SimpleTokenBuilder::SimpleTokenBuilder()
        : m_tokenCreator()
        {
        }

        SimpleTokenBuilder::SimpleTokenBuilder(const std::string& appId, const std::string& appCertificate,
                           const std::string& channelName, uint32_t uid)
        : m_tokenCreator(appId, appCertificate, channelName, uid)
        {
        }

        SimpleTokenBuilder::SimpleTokenBuilder(const std::string& appId, const std::string& appCertificate,
                           const std::string& channelName, const std::string& uid)
        : m_tokenCreator(appId, appCertificate, channelName, uid)
        {
        }

        bool SimpleTokenBuilder::initPrivileges(Role role)
        {
            auto it = g_rolePrivileges.find(role);
            if (it == g_rolePrivileges.end()) {
                return false;
            }

            m_tokenCreator.message_.messages = it->second;
            return true;
        }

        bool SimpleTokenBuilder::initTokenBuilder(const std::string& originToken)
        {
            m_tokenCreator.FromString(originToken);
            return true;
        }

        void SimpleTokenBuilder::setPrivilege(AccessToken::Privileges privilege, uint32_t expireTimestamp)
        {
            m_tokenCreator.message_.messages[privilege] = expireTimestamp;
        }

        void SimpleTokenBuilder::removePrivilege(AccessToken::Privileges privilege)
        {
            m_tokenCreator.message_.messages.erase(privilege);
        }

        std::string SimpleTokenBuilder::buildToken()
        {
            return m_tokenCreator.Build();
        }
    }  // namespace tools
}  // namespace agora
