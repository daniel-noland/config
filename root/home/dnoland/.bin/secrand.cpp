// g++ -g3 -ggdb -O0 -DDEBUG -I/usr/include/cryptopp Driver.cpp -o Driver.exe -lcryptopp -lpthread
// g++ -g -O2 -DNDEBUG -I/usr/include/cryptopp Driver.cpp -o Driver.exe -lcryptopp -lpthread

#include "osrng.h"
using CryptoPP::AutoSeededRandomPool;

#include <iostream>
using std::cout;
using std::cerr;
using std::endl;

#include <string>
using std::string;

#include <cstdlib>
using std::exit;

#include "cryptlib.h"
using CryptoPP::Exception;

#include "hex.h"
using CryptoPP::HexEncoder;
using CryptoPP::HexDecoder;

#include "filters.h"
using CryptoPP::StringSink;
using CryptoPP::StringSource;
using CryptoPP::StreamTransformationFilter;

#include "aes.h"
using CryptoPP::AES;

#include "ccm.h"
using CryptoPP::CTR_Mode;

#include "assert.h"

#include <memory>

class RandomStream
{
private:

   using RandomSource = CTR_Mode<AES>::Encryption;
   using UP_RandomSource = std::unique_ptr<RandomSource>;
   UP_RandomSource encryptor;

public:

   void init(void)
   {
      AutoSeededRandomPool prng;
      byte key[CryptoPP::AES::DEFAULT_KEYLENGTH];
      byte iv[CryptoPP::AES::BLOCKSIZE];
      prng.GenerateBlock(key, sizeof(key));
      prng.GenerateBlock(iv, sizeof(iv));
      encryptor->SetKeyWithIV(key, sizeof(key),
                              iv, sizeof(iv));
      prng.GenerateBlock(key, sizeof(key));
      prng.GenerateBlock(iv, sizeof(iv));
   }

   RandomStream()
   {
      encryptor = std::make_unique<RandomSource>();
      this->init();
   }

   RandomStream(RandomStream&) = delete;
   RandomStream(RandomStream const&) = delete;

   ~RandomStream()
   {
      this->init();
   }

   // RandomStream(RandomStream&&) = delete;

   string encrypt(string const& in)
   {
      string cipherText;
      auto* const sink = new StringSink(cipherText);
      auto* const transform = new StreamTransformationFilter(*encryptor, sink);
      StringSource(in, true, transform);
      return cipherText;
   }
};

int main()
{

   auto&& noise = RandomStream();
   string input = "hello world!";
   cout << "in: " << input << endl;
   // string out = noise.encrypt(input);
   cout << "out: " << noise.encrypt(input) << endl;
   return 0;
}
