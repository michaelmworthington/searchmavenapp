import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

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

class _HomePageScaffoldAdvancedSearchState
    extends State<HomePageScaffoldAdvancedSearch>
    with AutomaticKeepAliveClientMixin {
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
                    _buildAdvancedFormHeader(context, 'By Coordinate:'),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context,
                      "GroupId",
                      widget.groupIdSearchTextController,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context,
                      "ArtifactId",
                      widget.artifactIdSearchTextController,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context,
                      "Version",
                      widget.versionSearchTextController,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context,
                      "Packaging",
                      widget.packagingSearchTextController,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context,
                      "Classifier",
                      widget.classifierSearchTextController,
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    _buildAdvancedFormHeader(context, 'By Classname:'),
                    const SizedBox(
                      height: 12.0,
                    ),
                    _buildTextFormFieldAdvancedSearch(
                      context,
                      "Classname",
                      widget.classnameSearchTextController,
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

  TextFormField _buildTextFormFieldAdvancedSearch(
    BuildContext context,
    String pFieldLabel,
    TextEditingController pTextController,
  ) {
    return TextFormField(
      controller: pTextController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'Search term is required';
      //   }
      //   return null;
      // },
      onFieldSubmitted: (value) {
        widget.submitSearch();
      },
    );
  }

  Row _buildAdvancedFormHeader(BuildContext context, String pLabel) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Theme.of(context).accentColor))),
            child: Text(
              pLabel,
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Theme.of(context).accentColor),
            ),
          ),
        ),
      ],
    );
  }
}
