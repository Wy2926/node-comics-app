#include "my_application.h"

int main(int argc, char** argv) {
  // Match the desktop entry on both X11 and Wayland.
  g_set_prgname(APPLICATION_ID);
  g_set_application_name("nodelane-comics");
  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
