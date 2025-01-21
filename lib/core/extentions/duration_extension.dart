extension on Duration {
  /// ref: https://stackoverflow.com/a/54775297/8183034
  String printDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(inMinutes.abs().remainder(60));
    final twoDigitSeconds = twoDigits(inSeconds.abs().remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
