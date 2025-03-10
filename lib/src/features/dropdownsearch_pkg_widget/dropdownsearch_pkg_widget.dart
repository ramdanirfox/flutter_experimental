import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class DropdownSearchPkgWidget extends StatelessWidget {
  const DropdownSearchPkgWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      home: const DropdownSearchPkgWidgetExample(),
    );
  }
}

class DropdownSearchPkgWidgetExample extends StatefulWidget {
  const DropdownSearchPkgWidgetExample({super.key});

  @override
  State<DropdownSearchPkgWidgetExample> createState() => _DropdownSearchPkgWidgetExampleState();
}

class _DropdownSearchPkgWidgetExampleState extends State<DropdownSearchPkgWidgetExample> {
  bool shadowColor = false;
  double? scrolledUnderElevation;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: (f, cs) => ["Item 1", 'Item 2', 'Item 3', 'Item 4'],
      popupProps: PopupProps.menu(
        disabledItemFn: (item) => item == 'Item 3',
        fit: FlexFit.loose
      ),
    );
  }
}