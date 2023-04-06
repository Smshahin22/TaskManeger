class Urls {
  static String baseUrl = 'https://task.teamrabbil.com/api/v1';
  static String loginUrl = '$baseUrl/login';
  static String registrationUrl = '$baseUrl/registration';
  static String createNewTaskUrl = '$baseUrl/createTask';
  static String newTasksUrl = '$baseUrl/listTaskByStatus/New';
  static String completedTasksUrl = '$baseUrl/listTaskByStatus/Completed';
  static String profileUpdateUrl = '$baseUrl/profileUpdate';
  static String cancelledTasksUrl = '$baseUrl/listTaskByStatus/Cancelled';
  static String progressTaskUrl = '$baseUrl/listTaskByStatus/Progress';
  static String resetPasswordUrl = '$baseUrl/RecoverResetPass';
  static String deleteTask(taskId) => '$baseUrl/deleteTask/$taskId';



  static String changeTaskStatus(String taskId, String status) =>
      '$baseUrl/updateTaskStatus/$taskId/$status';

  static String recoverVerifyEmailUrl(String email) =>
      '$baseUrl/RecoverVerifyEmail/$email';

  static String recoverVerifyOTPUrl(String email ,String otp) =>
      '$baseUrl/RecoverVerifyOTP/$email/$otp';



}