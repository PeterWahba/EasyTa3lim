import 'dart:io';

import 'package:academy_app/constants.dart';
import 'package:academy_app/providers/misc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as html_widget;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

Widget PaymentInstructionsBottomSheet({required BuildContext context, required paymentInstructions, required coursePrice, required courseId, String? authToken}) {
  // // show a bottom sheet with payment instructions message and button to upload payment
  late XFile? image = null;
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView(
        children: [
          SizedBox(height: 10),
          Text('Payment Instructions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryColor)),
          SizedBox(height: 10),
          html_widget.HtmlWidget(paymentInstructions),
          SizedBox(height: 10),
          image == null
              ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  height: 190,
                  child: InkWell(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          image = image;
                        });
                      }
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/images/upload.svg'),
                          const SizedBox(height: 12),
                          const Text(
                            'Attach Payment Proof',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ))
              : Container(
                  width: double.infinity,
                  height: 190,
                  child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(image!.path), fit: BoxFit.cover)),
                ),
          SizedBox(height: 10),
          Text('Total Price: $coursePrice', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          MaterialButton(
            // set height
            height: 50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: kPrimaryColor,
            onPressed: () async {
              if (image == null) {
                Fluttertoast.showToast(msg: 'ارفع ايصال الدفع أولاً');
                return;
              }

              String requestResult = await sendOfflinePaymentRequest(courseId, authToken, image);
              if (requestResult == 'success') {
                Fluttertoast.showToast(msg: 'تم رفع ايصال الدفع بنجاح');
                Navigator.of(context).pop();
              } else if (requestResult == 'duplicate') {
                Fluttertoast.showToast(msg: 'لقد قمت برفع ايصال الدفع من قبل');
              } else {
                Fluttertoast.showToast(msg: 'حدث خطأ أثناء رفع ايصال الدفع');
              }
            },
            child: Text(
              'Upload Payment Proof',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  });
}
