import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  // =========================
  // SnackBar
  // =========================
  void showSnackBar({
    required String message,
    Color? primaryColor,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    Widget? icon,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    if (!mounted) return;

    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            icon,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: primaryColor ?? Colors.grey.shade900,
      behavior: behavior,
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(12),
      elevation: 6,
      action: actionLabel != null && onActionPressed != null
          ? SnackBarAction(
        label: actionLabel,
        textColor: Colors.white,
        onPressed: onActionPressed,
      )
          : null,
    );

    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  // =========================
  // Navigation
  // =========================

  Future<T?> push<T>(Widget page) {
    return Navigator.push<T>(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<T?> pushReplacement<T, TO>(Widget page) {
    return Navigator.pushReplacement<T, TO>(
      this,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return Navigator.pushAndRemoveUntil<T>(
      this,
      MaterialPageRoute(builder: (_) => page),
          (route) => false,
    );
  }

  void pop<T extends Object?>([T? result]) {
    if (Navigator.canPop(this)) {
      Navigator.pop(this, result);
    }
  }

  void popUntilFirst() {
    Navigator.popUntil(this, (route) => route.isFirst);
  }

  // =========================
  // OK Dialog
  // =========================

  Future<void> showMessageDialog({
    required String message,
    String actionLabel = "OK",
    VoidCallback? onTap,
  }) {
    return showCupertinoDialog(
      context: this,
      builder: (_) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text(actionLabel),
            onPressed: () {
              pop();
              onTap?.call();
            },
          ),
        ],
      ),
    );
  }

  // =========================
  // Confirmation Dialog
  // =========================

  Future<void> showConfirmationDialog({
    required String message,
    String yesText = "Yes",
    String noText = "No",
    VoidCallback? onYes,
    VoidCallback? onNo,
  }) {
    return showCupertinoDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text(noText),
            onPressed: () {
              pop();
              onNo?.call();
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(yesText),
            onPressed: () {
              pop();
              onYes?.call();
            },
          ),
        ],
      ),
    );
  }

  // =========================
  // Loading Dialog
  // =========================

  void showLoadingDialog({String message = "Loading..."}) {
    showCupertinoDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => CupertinoAlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CupertinoActivityIndicator(radius: 14),
            const SizedBox(height: 15),
            Text(message),
          ],
        ),
      ),
    );
  }

  void hideLoadingDialog() {
    if (Navigator.canPop(this)) {
      Navigator.pop(this);
    }
  }

  // =========================
  // Screen Size
  // =========================

  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;
}
