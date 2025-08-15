// ignore_for_file: file_names
import 'package:diyar/core/theme/Color/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


void showSuccesSnackBar(
    {required BuildContext context, required String title}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: ColorApp.blue8D.withOpacity(0.6),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color:  ColorApp.blue8D, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      content: Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Lottie.asset(
              'assets/lottie/Animation - 1712410608562.json',
              width: 50,
              height: 50,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
