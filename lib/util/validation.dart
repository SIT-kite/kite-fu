// Rule for student id.
final RegExp reStudentId = RegExp(r'^((\d{9})|(\d{6}[YGHE\d]\d{3}))$');

String? studentIdValidator(String? username) {
  if (username != null && username.isNotEmpty) {
    // When user complete his input (len >= 9), check it.
    final len = username.length;
    if (((len == 9 || len == 10) && !reStudentId.hasMatch(username)) || len > 10) {
      return '学号格式不正确';
    }
  }
  return null;
}
