// #include <CLI/CLI.hpp>
// #include <iostream>

#include <ftxui/dom/elements.hpp>
#include <ftxui/dom/node.hpp>
#include <ftxui/screen/color.hpp>
#include <ftxui/screen/screen.hpp>

int main(int argc, char** argv) {
  auto cell = [](const char* t) { return ftxui::text(t) | ftxui::border; };
  auto document = ftxui::gridbox({
      {
          cell("north-west"),
          cell("north"),
          cell("north-east"),
      },
      {
          cell("center-west"),
          ftxui::gridbox({{
                              cell("center-north-west"),
                              cell("center-north-east"),
                          },
                          {
                              cell("center-south-west"),
                              cell("center-south-east"),
                          }}),
          cell("center-east"),
      },
      {
          cell("south-west"),
          cell("south"),
          cell("south-east"),
      },
  });

  auto screen = ftxui::Screen::Create(ftxui::Dimension::Fit(document));
  ftxui::Render(screen, document);
  screen.Print();
  getchar();

  return 0;
}
