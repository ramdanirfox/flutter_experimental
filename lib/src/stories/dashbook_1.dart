import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_experimental/src/features/appbar/appbar_widget.dart';
import 'package:flutter_experimental/src/features/dropdownsearch_pkg_widget/dropdownsearch_pkg_widget.dart';

import '../features/bottombar1/bottombar1_widget.dart';
import '../features/bottombar2/bottombar2.dart';
import '../features/face_analysis/face_analysis_widget.dart';
import '../features/fraud_analysis/fraud_analysis_widget.dart';

  /// Adds stories for the widgets in this library to the given [Dashbook].
  void addWidgetStoriesPart1(Dashbook dashbook) {
    dashbook.storiesOf('AppBar')
    .add('contoh', (ctx) {
      return AppBarWidget();
    });

    dashbook.storiesOf('Icon').add('add', (ctx) {
      return Icon(
        Icons.add,
          size: 100 * ctx.sliderProperty("Ukuran", 0.2),
          color: ctx.colorProperty("Warna", Color.fromRGBO(0, 0, 0, 1.0),
          tooltipMessage: "Atur Warna Ikon"
        )
      );
    });

    dashbook.storiesOf('BottomBar')
    .add('contoh', (ctx) { 
      return BottomNavigationBarExampleApp1();
    })
    .add('Animated', (ctx) {
      return BottomNavigationBarExampleApp2();
    });

    dashbook.storiesOf("Autocomplete")
    .add("simple", (ctx) {
      return const DropdownSearchPkgWidget();
    });
    
    dashbook.storiesOf("Fraud Detection")
    .add('detections', (ctx) {
      ctx.action('Buka Metode Deteksi', (context) {
        showDialog(
          context: context,
          builder: (_) => FraudDialog(),
        );
      });
      

      // return SizedBox();
      return ElevatedButton(child: Text('Lihat Info'), onPressed: () {});
    }, info: "Tekan tombol > di pojok untuk buka aksi", pinInfo: true)
    .add('face analysis', (ctx) {
      ctx.action('Buka Analisis', (context) {
        showDialog(
          context: context,
          builder: (_) => FaceAnalysisDialog(),
        );
      });
      

      // return SizedBox();
      return ElevatedButton(child: Text('Lihat Info'), onPressed: () {});
    }, info: "Tekan tombol > di pojok untuk buka aksi", pinInfo: true);
    
  }
