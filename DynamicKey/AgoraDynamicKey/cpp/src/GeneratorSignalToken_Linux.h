#ifndef __GENERATORSIGNALTOKEN__linux_H__
#define __GENERATORSIGNALTOKEN__linux_H__

#include <stdio.h>
#include <string.h>
#include "utils.h"


struct  CGeneSignalToken
{
	static std::string generateSignallingToken(const std::string &account, const std::string &appId, const std::string appCertificateId, int expiredTsInSeconds)
	{
		CHAR szBuf[MAX_PATH * 4] = { '\0' };
		sprintf_s(szBuf, "%s%s%s%d", account.c_str(), appId.c_str(), appCertificateId.c_str(), expiredTsInSeconds);

		std::string md5StrDest = agora::tools::md5(szBuf);
		CHAR szToken[MAX_PATH * 4] = { '\0' };
		sprintf_s(szToken, "1:%s:%d:%s", appId.c_str(), expiredTsInSeconds, md5StrDest.c_str());

		return szToken;
	}
};

#endif