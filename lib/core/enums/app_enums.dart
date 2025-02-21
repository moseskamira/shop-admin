enum AuthStates {
  idle,
  loginLoading,
  loginSuccess,
  loginError,
  wrongCreds,
  signupLoading,
  signupSuccess,
  signupError,
  signupEmailExists,
  resetPasswordLoading,
  resetPasswordError,
  resetPasswordSuccess
}

enum ProfileStates {
  idle,
  updateLoading,
  updateSuccess,
  updateError,
}
