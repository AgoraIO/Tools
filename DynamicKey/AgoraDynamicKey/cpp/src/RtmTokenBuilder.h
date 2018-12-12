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

        struct RtmTokenBuilder {
            RtmTokenBuilder();
            RtmTokenBuilder(const std::string& appId, const std::string& appCertificate,
                               const std::string& userId);
            bool initTokenBuilder(const std::string& originToken);

            void setPrivilege(AccessToken::Privileges privilege, uint32_t expireTimestamp = 0);
            void removePrivilege(AccessToken::Privileges privilege);
            std::string buildToken();

            AccessToken m_tokenCreator;
        };

        RtmTokenBuilder::RtmTokenBuilder()
        : m_tokenCreator()
        {
        }

        RtmTokenBuilder::RtmTokenBuilder(const std::string& appId, const std::string& appCertificate,
                           const std::string& userId)
        : m_tokenCreator(appId, appCertificate, userId, "")
        {
        }

        bool RtmTokenBuilder::initTokenBuilder(const std::string& originToken)
        {
            m_tokenCreator.FromString(originToken);
            return true;
        }

        void RtmTokenBuilder::setPrivilege(AccessToken::Privileges privilege, uint32_t expireTimestamp)
        {
            m_tokenCreator.message_.messages[privilege] = expireTimestamp;
        }

        void RtmTokenBuilder::removePrivilege(AccessToken::Privileges privilege)
        {
            m_tokenCreator.message_.messages.erase(privilege);
        }

        std::string RtmTokenBuilder::buildToken()
        {
            return m_tokenCreator.Build();
        }
    }  // namespace tools
}  // namespace agora
