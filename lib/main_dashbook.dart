import 'package:flutter/material.dart';

import 'package:dashbook/dashbook.dart';
import 'package:flutter_experimental/src/features/appbar/appbar_widget.dart';
import 'package:flutter_experimental/src/stories/dashbook_1.dart';

import 'widgets/custom_dialog.dart';

import 'package:google_fonts/google_fonts.dart';

void main() {
  final dashbook = Dashbook(usePreviewSafeArea: false);

  // Adds the Text widget stories
  dashbook
      .storiesOf('Text')
      // Decorators are easy ways to apply a common layout to all of the story chapters, here are using onde of Dashbook's decorators,
      // which will center all the widgets on the center of the screen
      .decorator(CenterDecorator())
      // The Widget story can have as many chapters as needed
      .add('robotoSlab', (ctx) {
    return Container(
        width: 300,
        child: Text(
          ctx.textProperty("text", 
            "Contoh Teks"
          ),
          textAlign: ctx.listProperty(
            "text align",
            TextAlign.center,
            TextAlign.values,
          ),
          textDirection: ctx.listProperty(
            "text direction",
            TextDirection.rtl,
            TextDirection.values,
          ),
          style: GoogleFonts.robotoSlab(
              fontWeight: ctx.listProperty(
                "font weight",
                FontWeight.normal,
                FontWeight.values,
              ),
              fontStyle: ctx.listProperty(
                "font style",
                FontStyle.normal,
                FontStyle.values,
              ),
              fontSize: 100 * ctx.sliderProperty("font size", 0.1)),
        ));
  },
  info: "Silakan sesuaikan tampilan di tombol pensil").add('robotoMono', (ctx) {
    return Container(
        width: 300,
        child: Text(
          ctx.textProperty("text", 
            "Contoh Teks"
          ),
          textAlign: ctx.listProperty(
            "text align",
            TextAlign.center,
            TextAlign.values,
          ),
          textDirection: ctx.listProperty(
            "text direction",
            TextDirection.rtl,
            TextDirection.values,
          ),
          style: GoogleFonts.robotoMono(
              fontWeight: ctx.listProperty(
                "font weight",
                FontWeight.normal,
                FontWeight.values,
              ),
              fontStyle: ctx.listProperty(
                "font style",
                FontStyle.normal,
                FontStyle.values,
              ),
              fontSize: 100 * ctx.sliderProperty("font size", 0.1)),
        ));
  });

  dashbook.storiesOf('ElevatedButton').decorator(CenterDecorator()).add(
      'contoh', (ctx) => ElevatedButton(child: Text('Ok'), onPressed: () {}),
      info: "Itu saja :)");

  dashbook.storiesOf('CustomDialog').add('default', (ctx) {
    ctx.action('Buka Alert', (context) {
      showDialog(
        context: context,
        builder: (_) => CustomDialog(),
      );
    });

    // return SizedBox();
    return ElevatedButton(child: Text('Lihat Info'), onPressed: () {});
  }, info: "Tekan tombol > di pojok untuk buka aksi", pinInfo: true);

  addWidgetStoriesPart1(dashbook);

  // Since dashbook is a widget itself, you can just call runApp passing it as a parameter
  runApp(dashbook);
}
