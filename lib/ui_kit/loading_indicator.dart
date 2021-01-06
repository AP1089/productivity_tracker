import 'package:click_up/theme/app_style.dart';
import 'package:flutter/material.dart';

class LoadingIndicator {
  static Widget show() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppStyle.black)),
      ),
    );
  }
}
