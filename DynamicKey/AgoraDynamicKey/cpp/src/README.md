- **RtcTokenBuilder.h**: Source code for generating a token for the following SDKs:
  - Agora Native SDK v2.1+

  - Agora Web SDK v2.4+

  - Agora Recording SDK v2.1+

  - Agora RTSA SDK

> The Agora RTSA SDK supports joining multiple channels. If you join multiple channels at the same time, then you MUST generate a specific token for each channel you join. 

- **RtmTokenBuilder.h**: Source code for generating a token for the Agora RTM SDK. 
- **AccessToken.h**: Implements all the underlying algorithms for generating a token. Both **RtcTokenBuilder.h** and **RtmTokenBuilder.h** are a wrapper of **AccessToken.h** and have much easier-to-use APIs. We recommend using **RtcTokenBuilder.h** for generating an RTC token or **RtmTokenBuilder.h** for an RTM token.
