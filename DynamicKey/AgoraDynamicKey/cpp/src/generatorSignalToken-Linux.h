#include <iostream>
#include <string>
#include "md5/md5.h"

struct  CGeneSignalToken
{
   std::string generateSignallingToken(const std::string &account, const std::string &appId, const std::string appCertificateId, int expiredTsInSeconds)
  {
    std::string s_ts = std::to_string(expiredTsInSeconds);
    std::string tmp = account + appId + appCertificateId + s_ts;
    MD5 md(tmp);
    std::string token = std::string("1:") + appId + std::string(":") + s_ts + std::string(":") + md.toStr();
    return token;
  }
};
