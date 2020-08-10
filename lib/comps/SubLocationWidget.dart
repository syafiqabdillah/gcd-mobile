import 'package:flutter/material.dart';
import 'package:general_crowd_detector_app/classes/SubLocation.dart';
import 'package:general_crowd_detector_app/global/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

Widget subLocationWidget(SubLocation subLocation) {
  return Row(
    children: [
      /// color of the dot depending on the crowdness
      Container(
        height: 20,
        width: 20,
        margin: EdgeInsets.all(4),
        decoration: new BoxDecoration(
          color: subLocation.isCrowded
              ? Colors.redAccent[400]
              : Colors.greenAccent[400],
          shape: BoxShape.circle,
        ),
      ),

      /// Horizontal spacing
      SizedBox(
        width: 8,
      ),

      /// name of the sublocation
      Text(
        subLocation.name,
        style: GoogleFonts.poppins(
            color: AppColors.veryLightTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      )
    ],
  );
}
