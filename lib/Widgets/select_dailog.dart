library select_dialog;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:select_dialog/multiple_items_bloc.dart';
import 'package:select_dialog/select_bloc.dart';

typedef SelectOneItemBuilderType<T> = Widget Function(
    BuildContext context, T item, bool isSelected);

typedef ErrorBuilderType<T> = Widget Function(
    BuildContext context, dynamic exception);
typedef ButtonBuilderType = Widget Function(
    BuildContext context, VoidCallback onPressed);

class SelectDialog1<T> extends StatefulWidget {
  T? selectedValue;
  final List<T>? multipleSelectedValues;
  final List<T>? itemsList;

  ///![image](https://user-images.githubusercontent.com/16373553/80187339-db365f00-85e5-11ea-81ad-df17d7e7034e.png)
  final bool showSearchBox;
  final void Function(T)? onChange;
  final void Function(List<T>)? onMultipleItemsChange;
  final Future<List<T>> Function(String text)? onFind;
  final SelectOneItemBuilderType<T>? itemBuilder;
  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? loadingBuilder;

  ///![image](https://user-images.githubusercontent.com/16373553/94357272-d599e500-006d-11eb-9bcb-5f067943011e.png)
  final ButtonBuilderType? okButtonBuilder;
  final ErrorBuilderType? errorBuilder;
  final bool autofocus;
  final bool alwaysShowScrollBar;
  final int searchBoxMaxLines;
  final int searchBoxMinLines;

  ///![image](https://user-images.githubusercontent.com/16373553/80187339-db365f00-85e5-11ea-81ad-df17d7e7034e.png)
  final InputDecoration? searchBoxDecoration;
  @Deprecated("Use 'hintText' property from searchBoxDecoration")
  final String? searchHint;

  ///![image](https://user-images.githubusercontent.com/16373553/80187103-72e77d80-85e5-11ea-9349-e4dc8ec323bc.png)
  final TextStyle? titleStyle;

  ///|**Max width**: 90% of screen width|**Max height**: 70% of screen height|
  ///|---|---|
  ///|![image](https://user-images.githubusercontent.com/16373553/80189438-0a020480-85e9-11ea-8e63-3fabfa42c1c7.png)|![image](https://user-images.githubusercontent.com/16373553/80190562-e2ac3700-85ea-11ea-82ef-3383ae32ab02.png)|
  final BoxConstraints? constraints;
  final TextEditingController? findController;
  final bool? isBack;
  final bool? matchId;

  SelectDialog1({
    Key? key,
    this.itemsList,
    this.showSearchBox = true,
    this.onChange,
    this.onMultipleItemsChange,
    this.selectedValue,
    this.multipleSelectedValues,
    this.onFind,
    this.itemBuilder,
    this.searchBoxDecoration,
    this.searchHint,
    this.titleStyle,
    this.emptyBuilder,
    this.okButtonBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.constraints,
    this.autofocus = false,
    this.alwaysShowScrollBar = false,
    this.searchBoxMaxLines = 1,
    this.searchBoxMinLines = 1,
    this.findController,
    this.isBack,
    this.matchId
  }) : super(key: key);

  static Future<T?> showModal<T>(
      BuildContext context,
      {List<T>? items,
      String? label,
      T? selectedValue,
      List<T>? multipleSelectedValues,
      bool showSearchBox = true,
      Future<List<T>> Function(String text)? onFind,
      SelectOneItemBuilderType<T>? itemBuilder,
      void Function(T)? onChange,
      void Function(List<T>)? onMultipleItemsChange,
      InputDecoration? searchBoxDecoration,
      @Deprecated("Use 'hintText' property from searchBoxDecoration")
          String? searchHint,
      Color? backgroundColor,
      TextStyle? titleStyle,
      WidgetBuilder? emptyBuilder,
      ButtonBuilderType? okButtonBuilder,
      WidgetBuilder? loadingBuilder,
      ErrorBuilderType? errorBuilder,
      BoxConstraints? constraints,
      bool autofocus = false,
      bool alwaysShowScrollBar = false,
      int searchBoxMaxLines = 1,
      int searchBoxMinLines = 1,
      TextEditingController? findController,
      bool useRootNavigator = false,
      bool isBack = true,bool matchId = false}) {
    return showDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (context) {
        return AlertDialog(
          insetPadding:const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          contentPadding: const EdgeInsets.fromLTRB(10, 10.0, 10.0, 10.0),
          backgroundColor: backgroundColor,
          title: Text(label ?? "", style: const TextStyle(fontSize: 16)),
          content: SelectDialog1<T>(
            selectedValue: selectedValue,
            multipleSelectedValues: multipleSelectedValues,
            itemsList: items,
            onChange: onChange,
            onMultipleItemsChange: onMultipleItemsChange,
            onFind: onFind,
            showSearchBox: showSearchBox,
            itemBuilder: itemBuilder,
            searchBoxDecoration: searchBoxDecoration,
            searchHint: searchHint,
            titleStyle: titleStyle,
            emptyBuilder: emptyBuilder,
            okButtonBuilder: okButtonBuilder,
            loadingBuilder: loadingBuilder,
            errorBuilder: errorBuilder,
            constraints: constraints,
            autofocus: autofocus,
            alwaysShowScrollBar: alwaysShowScrollBar,
            searchBoxMaxLines: searchBoxMaxLines,
            searchBoxMinLines: searchBoxMinLines,
            findController: findController,
            isBack: isBack,
            matchId: matchId,
          ),
        );
      },
    );
  }

  @override
  _SelectDialog1State<T> createState() => _SelectDialog1State<T>(
        itemsList,
        onChange,
        onMultipleItemsChange,
        multipleSelectedValues?.toList(),
        onFind,
        findController,
      );
}

class _SelectDialog1State<T> extends State<SelectDialog1<T>> {
  late SelectOneBloc<T> bloc;
  late MultipleItemsBloc<T> multipleItemsBloc;
  void Function(T)? onChange;

  _SelectDialog1State(
      List<T>? itemsList,
      this.onChange,
      void Function(List<T>)? onMultipleItemsChange,
      List<T>? multipleSelectedValues,
      Future<List<T>> Function(String text)? onFind,
      TextEditingController? findController) {
    bloc = SelectOneBloc(itemsList, onFind, findController);
    multipleItemsBloc =
        MultipleItemsBloc(multipleSelectedValues, onMultipleItemsChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.autofocus) {
      FocusScope.of(context).requestFocus(bloc.focusNode);
    }
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  bool get isWeb =>
      MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

  bool get isMultipleItems => widget.onMultipleItemsChange != null;

  BoxConstraints get webDefaultConstraints =>
      const BoxConstraints(maxWidth: 250, maxHeight: 500);

  BoxConstraints get mobileDefaultConstraints => BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.9,
      maxHeight: MediaQuery.of(context).size.height * 0.5);

  SelectOneItemBuilderType<T> get itemBuilder =>
      widget.itemBuilder ??
      (context, item, isSelected) => ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          // trailing: isSelected ? Icon(Icons.done,color: AppColors.APP_THEME_COLOR,): Container(width: 20.w,),
          title: Text(
            item.toString(),
            style: const TextStyle(fontSize: 14),
          ),
          dense: true,
          selected: isSelected);

  ButtonBuilderType get okButtonBuilder =>
      widget.okButtonBuilder ??
      (context, onPressed) =>
          ElevatedButton(child: const Text("Ok"), onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      constraints: widget.constraints ??
          (isWeb ? webDefaultConstraints : mobileDefaultConstraints),
      child: Column(
        children: <Widget>[
          if (widget.showSearchBox)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: bloc.findController,
                focusNode: bloc.focusNode,
                maxLines: widget.searchBoxMaxLines,
                minLines: widget.searchBoxMinLines,
                decoration: widget.searchBoxDecoration?.copyWith(
                        hintText: widget.searchHint ??
                            widget.searchBoxDecoration!.hintText) ??
                    InputDecoration(
                        hintText: widget.searchHint ?? "Find",
                        contentPadding: const EdgeInsets.all(2.0)),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<T>?>(
              stream: bloc.filteredListOut,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return widget.errorBuilder?.call(context, snapshot.error) ??
                      Center(child: Text("Oops. \n${snapshot.error}"));
                } else if (!snapshot.hasData) {
                  return widget.loadingBuilder?.call(context) ??
                      const Center(child: CircularProgressIndicator());
                } else if (snapshot.data!.isEmpty) {
                  return widget.emptyBuilder?.call(context) ??
                      const Center(child: Text("No data found"));
                }
                return SingleChildScrollView(
                  controller: bloc.scrollController,
                  // isAlwaysShown: widget.alwaysShowScrollBar,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        controller: bloc.scrollController,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {

                          var item = snapshot.data![index];

                          bool isSelected;
                          if(widget.matchId!){
                            isSelected =
                                multipleItemsBloc.selectedItems.map((e) => e.toString()).contains(item.toString());
                          }else{
                             isSelected = multipleItemsBloc.selectedItems.contains(item);
                          }

                          isSelected =
                              isSelected || item == widget.selectedValue;
                          return InkWell(
                            child: itemBuilder(context, item, isSelected),
                            onTap: () {
                              if (isMultipleItems) {

                                setState(() => (isSelected)

                                    ? widget.matchId ?? false ?  multipleItemsBloc.selectedItems.removeWhere((element) => element.toString()== item.toString()) : multipleItemsBloc.unselectItem(item)
                                    : multipleItemsBloc.selectItem(item));
                              } else {
                                setState(() {
                                  if (isSelected) {
                                    widget.selectedValue = null;
                                  } else {
                                    widget.selectedValue = item;
                                  }
                                });
                                onChange?.call(item);
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (!isMultipleItems) closeButton(),
          if (isMultipleItems)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                okButtonBuilder(context, () {
                  multipleItemsBloc.onSelectButtonPressed();
                  Navigator.pop(context);
                }),
                closeButton()
              ],
            )
        ],
      ),
    );
  }
}

Widget closeButton() {
  return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.black54, fontSize: 14),
          )));
}

Widget ChooseButton(VoidCallback onPressed) {
  return Align(
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: InkWell(
          onTap: onPressed,
          child: Text(
            "Select",
            style: TextStyle(color: APP_THEME_COLOR),
            textAlign: TextAlign.end,
          )),
    ),
  );
}

// For simple massage pass
showMassageDialogBox(BuildContext context, String massage) {
  var dialog = AlertDialog(
    title: const Text("Massage"),
    content: SizedBox(
      height: 50,
      child: Center(
        child: Text(massage),
      ),
    ),
    actions: [
      Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            child: const Text("close"),
            onPressed: () => Navigator.pop(context),
          ))
    ],
  );
  showDialog(context: context, builder: (context) => dialog);
}
