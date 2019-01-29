#include <cstdint>
#include <cinttypes>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

#include "base/log.h"
#include "golem.h"
#include "json_parser.h"

using namespace agora;
using namespace agora::base;
using namespace agora::pstn;

void print_usage() {
  const char *usage =
    "Golem --global_settings <string> --golem_settings <string>\n"
    "OPTIONS:\n"
    "  --global_settings      String which specify the global settings with json format\n"
    "  --golem_settings       string which specify the golem settings with json format\n";
  std::cerr << usage << std::endl;
}

int main(int argc, char *argv[]) {
  std::cout << std::endl;
  if(argc != 5 ||
  std::string("--global_settings") != std::string(argv[1]) ||
  std::string(argv[2]).empty() ||
  std::string("--golem_settings") != std::string(argv[3]) ||
  std::string(argv[4]).empty()
  )
  {
    std::cerr << "Illegal arguments\n";
    print_usage();
    return -1;
  }

  golem Golem(json_parser(argv[2], argv[4]).get_settings());

  return Golem.run();
}

