#include "CLI/CLI.hpp"
#include <CLI/CLI.hpp>
#include <iostream>

int main(int argc,char **argv) {
  CLI::App app{"Watch Nostr posts by a TUI screen...", "nostr-soumen"};

  int p = 0;
  app.add_option("-p", p, "An example CLI parameter");

  CLI11_PARSE(app, argc, argv);

  std::cout << "Parameter value: " << p << std::endl;
  return 0;
}
