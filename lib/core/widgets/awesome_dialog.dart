import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

Future awesomeDialog({
  required BuildContext context,
  required DialogType dialogType,
  required String title,
  required String desc,
}) {
  return AwesomeDialog(
    context: context,
    dialogType: dialogType,
    title: title,
    desc: desc,
    //btnCancelOnPress: () {},
    //btnOkOnPress: () {},
  ).show();
}


// AwesomeDialog(
                        //   dismissOnTouchOutside: false,
                        //   context: context,
                        //   dialogType: DialogType.info,
                        //   title: 'Dialog Title',
                        //   desc: 'Dialog description here.............',
                        //   btnCancelOnPress: () {},
                        //   btnOkOnPress: () {},
                        // ).show();
