class StringUtil {
  static bool isEmpty(String? val) {
    return null == val || val.isEmpty;
  }

  static bool isEqual(String? val1, String? val2) {
    if (isEmpty(val1) || isEmpty(val2)) {
      return false;
    }

    return val1 == val2;
  }

  static bool isEqualToLower(String? val1, String? val2) {
    if (isEmpty(val1) || isEmpty(val2)) {
      return false;
    }
    val1 = val1!.toLowerCase();
    val2 = val2!.toLowerCase();
    return isEqual(val1, val2);
  }

  static bool isStartsToLower(String? val1, String? val2) {
    if (isEmpty(val1) || isEmpty(val2)) {
      return false;
    }
    val1 = val1!.toLowerCase();
    val2 = val2!.toLowerCase();
    return val1.startsWith(val2);
  }

  static int getFirstDiffPos(String val1, String val2) {
    int pos = 0;
    int len = val1.length > val2.length ? val2.length : val1.length;
    for (; pos < len; pos++) {
      if (val1[pos] != val2[pos]) {
        return pos;
      }
    }
    return pos;
  }

  static String safeStr(String? val) {
    return isEmpty(val) ? '' : val!;
  }

  static bool isEmail(String? val) {
    if (val == null || val.isEmpty) return false;
    // 邮箱正则
    String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    return RegExp(regexEmail).hasMatch(val);
  }

}
