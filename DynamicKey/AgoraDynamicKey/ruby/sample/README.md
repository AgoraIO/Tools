- **rtc_token_builder.rb**: Source code for generating a token for the following SDKs:
  - Agora Native SDK v2.1+

  - Agora Web SDK v2.4+

  - Agora Recording SDK v2.1+

  - Agora RTSA SDK

> The Agora RTSA SDK supports joining multiple channels. If you join multiple channels at the same time, then you MUST generate a specific token for each channel you join. 
- **rtm_token_builder.rb**: Source code for generating a token for the Agora RTM SDK. 
- **access_token.rb**: Implements all the underlying algorithms for generating a token. Both **rtc_token_builder.rb** and **rtm_token_builder.rb** are a wrapper of **access_token.rb** and have much easier-to-use APIs. We recommend using **rtc_token_builder.rb** for generating an RTC token or **rtm_token_builder.rb** for an RTM token.
