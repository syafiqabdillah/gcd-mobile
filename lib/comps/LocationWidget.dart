import 'package:flutter/material.dart';
import 'package:general_crowd_detector_app/classes/Location.dart';
import 'package:general_crowd_detector_app/comps/SubLocationWidget.dart';
import 'package:general_crowd_detector_app/global/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

Widget locationWidget(Location location) {
  return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// location name
              Text(
                location.name,
                style: GoogleFonts.poppins(
                    color: AppColors.darkTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),

              // Vertical spacing
              SizedBox(height: 8),

              /// Row sublocation of that place, depicted with circles
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: location.sublocations.map((sub) {
                  return subLocationWidget(sub);
                }).toList(),
              )
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 1)));
}
