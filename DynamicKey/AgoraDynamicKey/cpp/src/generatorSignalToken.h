#ifndef __GENERATORSIGNALTOKEN_H__
#define __GENERATORSIGNALTOKEN_H__

#include <stdio.h>
#include <string.h>
#include "utils.h"


struct  CGeneSignalToken
{
	static std::string generateSignallingToken(const std::string &account, const std::string &appId, const std::string appCertificateId, int expiredTsInSeconds)
	{
		CString md5StrSrc;
		md5StrSrc.Format(_T("%s%s%s%d"), CString(account.c_str()), CString(appId.c_str()), CString(appCertificateId.c_str()), expiredTsInSeconds);
		
		std::string sgbk = CStringA(md5StrSrc.GetBuffer());
		md5StrSrc.ReleaseBuffer();
		std::string str;
		if (sgbk.c_str() != NULL)
		{
			int len = MultiByteToWideChar(936, 0, sgbk.data(), -1, NULL, 0);
			std::wstring strW;

			strW.resize(len);

			MultiByteToWideChar(936, 0, sgbk.data(), -1, (LPWSTR)strW.data(), len);

			len = WideCharToMultiByte(CP_UTF8, 0, strW.data(), len - 1, NULL, 0, NULL, NULL);

			str.resize(len);

			WideCharToMultiByte(CP_UTF8, 0, strW.data(), -1, (LPSTR)str.data(), len, NULL, NULL);
		}

		std::string md5StrDest = agora::tools::md5(str);
		CString tokenStr;
		tokenStr.Format(_T("1:%s:%d:%s"), CString(appId.c_str()), expiredTsInSeconds, CString(md5StrDest.c_str()));
		std::string md5DestStr = CStringA(tokenStr.GetBuffer()).GetBuffer();
		tokenStr.ReleaseBuffer();

		return md5DestStr;
	}
};

#endif