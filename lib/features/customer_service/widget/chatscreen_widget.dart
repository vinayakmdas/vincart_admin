class ChatscreenWidget {

  static String generateChatId(String uid1, String uid2) {
  if (uid1.compareTo(uid2) > 0) {
    return "${uid2}_$uid1";
  } else {
    return "${uid1}_$uid2";
  }
}
}