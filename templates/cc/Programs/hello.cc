#include "globals.hh"

#include "TString.h"

#include <iostream>

int main(int argc, char** argv) {
  std::cout << Form("c=%.8lfm/s", u::c) << std::endl;
  return 0;
}
