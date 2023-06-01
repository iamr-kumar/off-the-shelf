int getMinutesFromPage(int page) {
  double minutes = page * 1.5;
  return minutes.toInt();
}

int getPageFromMinutes(int minutes) {
  double page = minutes / 1.5;
  return page.toInt();
}
