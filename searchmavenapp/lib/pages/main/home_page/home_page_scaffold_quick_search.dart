import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:searchmavenapp/page_components/text_field_clear_button.dart';

class HomePageScaffoldQuickSearch extends StatefulWidget {
  final GlobalKey<FormState> formStateKey;
  final TextEditingController quickSearchTextController;
  final Function submitSearch;

  const HomePageScaffoldQuickSearch({
    Key? key,
    required this.formStateKey,
    required this.quickSearchTextController,
    required this.submitSearch,
  }) : super(key: key);

  @override
  State<HomePageScaffoldQuickSearch> createState() =>
      _HomePageScaffoldQuickSearchState();
}

class _HomePageScaffoldQuickSearchState
    extends State<HomePageScaffoldQuickSearch>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    // so the clear button only shows when there is text in the text field
    widget.quickSearchTextController.addListener(() => setState(() {}));
  }

  @override
  bool get wantKeepAlive => true;

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  //  Build Method - High Level Layout
  //     https://pub.dev/packages/keyboard_dismisser
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) => KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
        ],
        child: Scaffold(
          body: Form(
            key: widget.formStateKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextFormFieldQuickSearch(context),
                  // const SizedBox(
                  //   height: 96,
                  // ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      _buildTextButtonClear(),
                      _buildElevatedButtonSearch(context)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  //  Build Method Widgets for Look & Feel
  /////////////////////////////////////////////////////////////////////////////////////////////////////

  ElevatedButton _buildElevatedButtonSearch(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.submitSearch();
      },
      child: const Icon(Icons.search),
    );
  }

  TextButton _buildTextButtonClear() {
    return TextButton(
      onPressed: () {
        debugPrint("clear button pressed");
        widget.quickSearchTextController.clear();
      },
      child: const Text("CLEAR"),
    );
  }

  TextFormField _buildTextFormFieldQuickSearch(BuildContext context) {
    return TextFormField(
      controller: widget.quickSearchTextController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        labelText: 'Quick Search',
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        suffixIcon: widget.quickSearchTextController.text.isEmpty
            ? Container(width: 0)
            : MyTextFieldClearButton(
                onPressed: () {
                  widget.quickSearchTextController.clear();
                },
              ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Search term is required';
        }
        return null;
      },
      onFieldSubmitted: (value) {
        widget.submitSearch();
      },
    );
  }
}
