#pragma once

#include <openssl/hmac.h>
#include <openssl/evp.h>
#include <cctype>
#include <cstddef>
#include <cstdlib>
#include <cstring>
#include <iomanip>
#include <sstream>
#include <stdexcept>
#include <string>
#include <random>

#include "Packer.h" 

namespace agora {
namespace tools {

const uint32_t HMAC_LENGTH = 20;
const uint32_t HMAC_SHA256_LENGTH = 32;
const uint32_t SIGNATURE_LENGTH = 40;
const uint32_t APP_ID_LENGTH = 32;
const uint32_t UNIX_TS_LENGTH = 10;
const uint32_t RANDOM_INT_LENGTH = 8;
const uint32_t UID_LENGTH = 10;
const uint32_t VERSION_LENGTH = 3;
const std::string RECORDING_SERVICE = "ARS";
const std::string PUBLIC_SHARING_SERVICE = "APSS";
const std::string MEDIA_CHANNEL_SERVICE = "ACS";

template <typename T>
inline std::string Pack(const T& x) {
  Packer p;
  p << x;
  return p.pack().body();
}

template <typename T>
inline void Unpack(const std::string& data, T& x) {
  Unpacker u(data.data(), data.length());
  u >> x;
}

inline bool IsUUID(const std::string& v) {
  if (v.length() != 32) {
    return false;
  }

  for (char x : v) {
    if (!isxdigit(x)) {
      return false;
    }
  }

  return true;
}

inline uint32_t GenerateSalt()
{
    std::random_device r;
    return r();
}

// HMAC
inline std::string HmacSign(const std::string& appCertificate,
                              const std::string& message, uint32_t signSize) {
  if (appCertificate.empty()) {
    return "";
  }
  unsigned char md[EVP_MAX_MD_SIZE];
  uint32_t md_len = 0;
  HMAC(EVP_sha1(), (const unsigned char*)appCertificate.data(),
       appCertificate.length(), (const unsigned char*)message.data(),
       message.length(), &md[0], &md_len);
  return std::string(reinterpret_cast<char*>(md), signSize);
}

inline std::string HmacSign2(const std::string& appCertificate,
                              const std::string& message, uint32_t signSize) {
  if (appCertificate.empty()) {
    return "";
  }
  unsigned char md[EVP_MAX_MD_SIZE];
  uint32_t md_len = 0;
  HMAC(EVP_sha256(), (const unsigned char*)appCertificate.data(),
       appCertificate.length(), (const unsigned char*)message.data(),
       message.length(), &md[0], &md_len);
  return std::string(reinterpret_cast<char*>(md), signSize);
}


inline std::string toupper(const std::string& in) {
  std::string out;
  for (char x : in) {
    int u = std::toupper(x);
    out.push_back((char)u);
  }
  return out;
}

inline std::string stringToHEX(const std::string& in) {
  static const char hexTable[] = "0123456789ABCDEF";

  if (in.empty()) {
    return std::string();
  }
  std::string out(in.size() * 2, '\0');
  for (uint32_t i = 0; i < in.size(); ++i) {
    out[i * 2 + 0] = hexTable[(in[i] >> 4) & 0x0F];
    out[i * 2 + 1] = hexTable[(in[i]) & 0x0F];
  }
  return out;
}

inline std::string stringToHex(const std::string& in) {
  static const char hexTable[] = "0123456789abcdef";

  if (in.empty()) {
    return std::string();
  }
  std::string out(in.size() * 2, '\0');
  for (uint32_t i = 0; i < in.size(); ++i) {
    out[i * 2 + 0] = hexTable[(in[i] >> 4) & 0x0F];
    out[i * 2 + 1] = hexTable[(in[i]) & 0x0F];
  }
  return out;
}

inline std::string hexDecode(const std::string& hex) {
  if (hex.length() % 2 != 0) {
    return "";
  }

  size_t count = hex.length() / 2;
  std::string out(count, '\0');
  for (size_t i = 0; i < count; ++i) {
    std::string one = hex.substr(i * 2, 2);
    out[i] = ::strtol(one.c_str(), 0, 16);
  }
  return out;
}

static const char base64_chars[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "abcdefghijklmnopqrstuvwxyz"
    "0123456789+/";

inline char* base64_encode(const unsigned char* input, int length) {
  /* http://www.adp-gmbh.ch/cpp/common/base64.html */
  int i = 0, j = 0, s = 0;
  unsigned char char_array_3[3], char_array_4[4];

  int b64len = (length + 2 - ((length + 2) % 3)) * 4 / 3;
  char* b64str = new char[b64len + 1];

  while (length--) {
    char_array_3[i++] = *(input++);
    if (i == 3) {
      char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
      char_array_4[1] =
          ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
      char_array_4[2] =
          ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
      char_array_4[3] = char_array_3[2] & 0x3f;

      for (i = 0; i < 4; i++) b64str[s++] = base64_chars[char_array_4[i]];

      i = 0;
    }
  }
  if (i) {
    for (j = i; j < 3; j++) char_array_3[j] = '\0';

    char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
    char_array_4[1] =
        ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
    char_array_4[2] =
        ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
    char_array_4[3] = char_array_3[2] & 0x3f;

    for (j = 0; j < i + 1; j++) b64str[s++] = base64_chars[char_array_4[j]];

    while (i++ < 3) b64str[s++] = '=';
  }
  b64str[b64len] = '\0';

  return b64str;
}

inline bool is_base64(unsigned char c) {
  return (isalnum(c) || (c == '+') || (c == '/'));
}

inline unsigned char* base64_decode(const char* input, int length,
                                    int* outlen) {
  int i = 0;
  int j = 0;
  int r = 0;
  int idx = 0;
  unsigned char char_array_4[4], char_array_3[3];
  unsigned char* output = new unsigned char[length * 3 / 4];

  while (length-- && input[idx] != '=') {
    // skip invalid or padding based chars
    if (!is_base64(input[idx])) {
      idx++;
      continue;
    }
    char_array_4[i++] = input[idx++];
    if (i == 4) {
      for (i = 0; i < 4; i++)
        char_array_4[i] = strchr(base64_chars, char_array_4[i]) - base64_chars;

      char_array_3[0] =
          (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
      char_array_3[1] =
          ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
      char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

      for (i = 0; (i < 3); i++) output[r++] = char_array_3[i];
      i = 0;
    }
  }

  if (i) {
    for (j = i; j < 4; j++) char_array_4[j] = 0;

    for (j = 0; j < 4; j++)
      char_array_4[j] = strchr(base64_chars, char_array_4[j]) - base64_chars;

    char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
    char_array_3[1] =
        ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
    char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

    for (j = 0; (j < i - 1); j++) output[r++] = char_array_3[j];
  }

  *outlen = r;

  return output;
}

inline std::string base64Encode(const std::string& data) {
  char* r = base64_encode((const unsigned char*)data.data(), data.length());
  std::string s(r);
  delete[] r;
  return s;
}

inline std::string base64Decode(const std::string& data) {
  int length = 0;
  const unsigned char* r = base64_decode(data.data(), data.length(), &length);
  std::string s((const char*)r, (size_t)length);
  delete[] r;
  return s;
}
}
}
