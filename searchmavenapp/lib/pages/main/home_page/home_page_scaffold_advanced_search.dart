import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../page_components/form_header.dart';
import '../../../page_components/text_field_clear_button.dart';

class HomePageScaffoldAdvancedSearch extends StatefulWidget {
  final GlobalKey<FormState> formStateKey;
  final TextEditingController groupIdSearchTextController;
  final TextEditingController artifactIdSearchTextController;
  final TextEditingController versionSearchTextController;
  final TextEditingController packagingSearchTextController;
  final TextEditingController classifierSearchTextController;
  final TextEditingController classnameSearchTextController;
  final Function submitSearch;

  const HomePageScaffoldAdvancedSearch({
    Key? key,
    required this.formStateKey,
    required this.groupIdSearchTextController,
    required this.artifactIdSearchTextController,
    required this.versionSearchTextController,
    required this.packagingSearchTextController,
    required this.classifierSearchTextController,
    required this.classnameSearchTextController,
    required this.submitSearch,
  }) : super(key: key);

  @override
  State<HomePageScaffoldAdvancedSearch> createState() =>
      _HomePageScaffoldAdvancedSearchState();
}

// AutomaticKeepAliveClientMixin
//    https://stackoverflow.com/questions/65394643/tabbarview-causes-contents-of-futurebuilder-to-disappear
class _HomePageScaffoldAdvancedSearchState
    extends State<HomePageScaffoldAdvancedSearch>
    with AutomaticKeepAliveClientMixin {
  //https://stackoverflow.com/questions/52150677/how-to-shift-focus-to-next-textfield-in-flutter
  final _artifactIdFocusNode = FocusNode();
  final _versionFocusNode = FocusNode();
  final _packagingFocusNode = FocusNode();
  final _classifierFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // so the clear button only shows when there is text in the text field
    widget.groupIdSearchTextController.addListener(() => setState(() {}));
    widget.artifactIdSearchTextController.addListener(() => setState(() {}));
    widget.versionSearchTextController.addListener(() => setState(() {}));
    widget.packagingSearchTextController.addListener(() => setState(() {}));
    widget.classifierSearchTextController.addListener(() => setState(() {}));
    widget.classnameSearchTextController.addListener(() => setState(() {}));
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 24.0,
                    ),
                    MyFormHeader(pLabel: 'By Coordinate:'),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context: context,
                      pFieldLabel: "GroupId",
                      pTextController: widget.groupIdSearchTextController,
                      autofocus: true,
                      nextFocus: _artifactIdFocusNode,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context: context,
                      pFieldLabel: "ArtifactId",
                      pTextController: widget.artifactIdSearchTextController,
                      focusNode: _artifactIdFocusNode,
                      nextFocus: _versionFocusNode,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context: context,
                      pFieldLabel: "Version",
                      pTextController: widget.versionSearchTextController,
                      focusNode: _versionFocusNode,
                      nextFocus: _packagingFocusNode,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context: context,
                      pFieldLabel: "Packaging",
                      pTextController: widget.packagingSearchTextController,
                      focusNode: _packagingFocusNode,
                      nextFocus: _classifierFocusNode,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context: context,
                      pFieldLabel: "Classifier",
                      pTextController: widget.classifierSearchTextController,
                      focusNode: _classifierFocusNode,
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    MyFormHeader(pLabel: 'By Classname:'),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context: context,
                      pFieldLabel: "Classname",
                      pTextController: widget.classnameSearchTextController,
                    ),
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
        widget.groupIdSearchTextController.clear();
        widget.artifactIdSearchTextController.clear();
        widget.versionSearchTextController.clear();
        widget.packagingSearchTextController.clear();
        widget.classifierSearchTextController.clear();
        widget.classnameSearchTextController.clear();
      },
      child: const Text("CLEAR"),
    );
  }

  bool _doFieldsHaveText() {
    return widget.groupIdSearchTextController.text.isNotEmpty ||
        widget.artifactIdSearchTextController.text.isNotEmpty ||
        widget.versionSearchTextController.text.isNotEmpty ||
        widget.packagingSearchTextController.text.isNotEmpty ||
        widget.classifierSearchTextController.text.isNotEmpty ||
        widget.classnameSearchTextController.text.isNotEmpty;
  }

  TextFormField _buildTextFormFieldAdvancedSearch({
    required BuildContext context,
    required String pFieldLabel,
    required TextEditingController pTextController,
    bool autofocus = false,
    FocusNode? nextFocus,
    FocusNode? focusNode,
  }) {
    Function(String) fSubmitted = (value) {
      widget.submitSearch();
    };

    if (nextFocus != null) {
      fSubmitted = (value) {
        FocusScope.of(context).requestFocus(nextFocus);
      };
    }

    return TextFormField(
      controller: pTextController,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      // autovalidateMode: AutovalidateMode.always,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        labelText: pFieldLabel,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        suffixIcon: pTextController.text.isEmpty
            ? Container(width: 0)
            : MyTextFieldClearButton(
                onPressed: () {
                  pTextController.clear();
                },
              ),
      ),
      validator: (value) {
        if (_doFieldsHaveText() == false) {
          return 'Search term is required';
        }
        return null;
      },
      onFieldSubmitted: fSubmitted,
      autofocus: autofocus,
      focusNode: focusNode,
    );
  }
}
