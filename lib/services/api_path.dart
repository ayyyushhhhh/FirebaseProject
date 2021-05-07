class APIpath {
  static String job({String uid, String jobID}) {
    return "users/$uid/jobs/$jobID";
  }

  static String jobPath(String uid) => "users/$uid/jobs";
}
