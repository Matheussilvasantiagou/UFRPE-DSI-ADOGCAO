import 'package:flutter/material.dart';

class LoginController {
  bool agreeToTerms = false;

  void toggleAgreeToTerms(bool value) {
    agreeToTerms = value;
  }
}
