import 'dart:io';

import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/DocumentController/AddDocumentController.dart';
import 'package:Repeople/Model/Document/Document_List_Model.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';

import '../../Config/Function.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/Strings.dart';
import '../../Config/utils/colors.dart';
import '../../Widgets/CommonBackButtonFor5theme.dart';
import '../../Widgets/CustomDecoration.dart';
import '../../Widgets/TextEditField.dart';
class add_document extends StatefulWidget {
  String title;
  String id;
  add_document({ required this.title,required this.id});

  @override
  _add_documentState createState() => new _add_documentState();
}
class _add_documentState extends State<add_document> {

  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  AddDocumentController cnt_AddDocument = Get.put(AddDocumentController());

  void initState() {
    super.initState();
    cnt_AddDocument.arrImageList.clear();
    cnt_AddDocument.arrFileList.clear();
    cnt_AddDocument.arrImageAndFileList.clear();
    cnt_AddDocument.DocumentNamecntr.clear();
    cnt_AddDocument.DocumentTypeId.value=widget.id.toString();
    cnt_AddDocument.DocumentTypeName.value=widget.title.toString();
    cnt_AddDocument.txtdocumentNew.value?.text="";
  }
  _imgFromCamera() async {
    File image = (await ImagePicker().pickImage(
        source: ImageSource.camera, imageQuality: 50
    )) as File;

    setState(() {
      cnt_AddDocument.arrDocCategoryList.add(Doc_List_Model(img: Image.file(image),title:image.path));
    }
    );
  }

  _imgFromGallery() async {
    File image = (await  ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50
    )) as File;

    setState(() {
      cnt_AddDocument.arrDocCategoryList.add(Doc_List_Model(img: Image.file(image),title:image.path));
    }
    );
  }

  _crop_image(File data) async{
    try{var cropped =await ImageCropper().cropImage(sourcePath: data.path,
        aspectRatio: CropAspectRatio(ratioX: 2.0, ratioY: 1.0));
    if(cropped!= null){
      setState(() {

        cnt_AddDocument.arrDocCategoryList.add(Doc_List_Model(img: Image.file(data),title:data.path));
      }
      );

    }}catch(ex){
     // Toast.show('Error', context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_AddDocument.GlobalAddDocumentScreenkey,
        endDrawer: CustomDrawer(
          animatedOffset: Offset(1.0, 0),
        ),
        drawer: CustomDrawer(
          animatedOffset: Offset(-1.0, 0),
        ),
      body: SafeArea(
    child:
    Obx((){
      return
        Form(
        key: cnt_AddDocument.formKey,
        child:Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
                child: Padding(
                  //padding: EdgeInsets.all(10),
                  padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 8.0, top: APPBAR_HEIGHT),
                  child: Material
                    (  // elevation: 5.0,
                    color: AppColors.BACKGROUND_WHITE,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        simpleTextFieldNewWithCustomization(
                            hintText: "Sample Document",
                            imageIcon: IMG_PROFILEUSER_SVG_DASHBOARD,
                            controller: cnt_AddDocument.txtdocumentNew,
                            labelText: "Document Name*",
                            // inputformat: [UpperCaseTextFormatter()],
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) =>
                                validation(value, "Please enter document name")),
                        SizedBox(height: 10,),
                        AttachementWidget(),
                      ],),),)),
            cnt_CommonHeader.commonAppBar("Document", cnt_AddDocument.GlobalAddDocumentScreenkey,color: white),
            Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20,bottom: 20,top: 20),
                  decoration: BoxDecoration(
                    color: AppColors.BACKGROUND_WHITE,
                    boxShadow:
                    [
                      BoxShadow(color:
                      hex("266CB5").withOpacity(0.1),offset: Offset(1,1),blurRadius: 5,spreadRadius: 3),],
                  ),
                  child: SubmitButton_4(),
                )
            ),

          ],
        ),);
    })

    )


    );

  }
  Widget SubmitButton_4() {
    return OnTapButton(
        onTap: (){
          if (cnt_AddDocument.formKey.currentState!.validate()) {
            if(cnt_AddDocument.arrImageAndFileList.length==0){
              ErrorMsg("Please select a file",title: "Error");
            }else {
              cnt_AddDocument.AddDocumentData();
            }
          }
        },
        height: 40,
        decoration:
        CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit",
        style: TextStyle(color: white, fontSize: 14,fontWeight: FontWeight.w600)
    );
  }

  Widget SubmitButton_1() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: 30, bottom: 30),
      decoration: BoxDecoration(
          color: APP_THEME_COLOR,
          borderRadius:
          BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Center(
        child: OnTapButton(
            onTap: (){
              if (cnt_AddDocument.formKey.currentState!.validate()) {
                // If the form is valid, display a Snackbar.
                SuccessMsg( SuccessMsg("Submitted successfully", title: "Success"));
                // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            width: 120,
            height: 40,
            text: "Submit",
            decoration: CustomDecorations().backgroundlocal(white, cornarradius, 0, white),
            style: TextStyle(color: APP_FONT_COLOR)),
      ),
    );
  }
  Widget SubmitButton([double? width]){
    return OnTapButton(
        onTap: (){
          if (cnt_AddDocument.formKey.currentState!.validate()) {
                    // If the form is valid, display a Snackbar.
SuccessMsg( SuccessMsg("Submitted successfully", title: "Success"));
                    // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                  }

        },
        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit",
        width: width,
        height: 45,
        style: TextStyle(color: white)
    );
  }
  TextEditingController userController=new TextEditingController();

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[

                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library',),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera',),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  ImagePicker imagePicker = ImagePicker();

  OnSelectDialog(){
    showCupertinoModalPopup(context: Get.context!, builder: (context){
      return CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          child: Text("Close"),
          onPressed: (){
            Get.back();
          },
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: (){
              Get.back();
              CameraSelect();
              setState((){});

            },
            child: Text("Camera",style:
            TextStyle(color: APP_FONT_COLOR,fontSize: 16, fontWeight:FontWeight.normal),),
          ),
          CupertinoActionSheetAction(
            onPressed: (){
              Get.back();
              ChooseImage();
              setState((){});
            },
            child: Text("Choose Photo",style:
            TextStyle(color: APP_FONT_COLOR,fontSize: 16, fontWeight:FontWeight.normal),),
          ),
          CupertinoActionSheetAction(
            onPressed: (){
              Get.back();
              FileChoose();
              setState((){});
            },
            child: Text("File",style: TextStyle(color: APP_FONT_COLOR,fontSize: 16, fontWeight:FontWeight.normal),),
          ),
        ],
      );
    });
  }

  // Camera file type = 1;
  void CameraSelect()async{
    try{
      var response = await imagePicker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front
      );
      if(response != null){
        cnt_AddDocument.fileType= 1;
        cnt_AddDocument.arrFileList.clear();
        PlatformFile platformFile = PlatformFile(name: response.path, size: 50,path: response.path);
        cnt_AddDocument.arrImageList.add(platformFile);

        setState((){
          cnt_AddDocument.arrImageAndFileList = cnt_AddDocument.arrImageList;

        });
        // cnt_AddDocument.arrImageAndFileList = cnt_AddDocument.arrImageList;
        cnt_AddDocument.update();
      }
      else{
        print("No image selected");
      }
    }
    catch(e){
      print("Error :--- \n $e");
    }

  }

  // Storage photo file type = 1
  void ChooseImage() async{
    try{
      var response = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if(response!=null){
        cnt_AddDocument.fileType = 1;
        cnt_AddDocument.arrFileList.clear();
        PlatformFile platformFile = PlatformFile(name: response.path, size: 50,path: response.path);
        cnt_AddDocument.arrImageList.add(platformFile);
        setState((){
          cnt_AddDocument.arrImageAndFileList = cnt_AddDocument.arrImageList;

        });

        cnt_AddDocument.update();
      }
      else{
        print("No Image Selected");
      }
    }
    catch(e){
      print("Error :--- \n $e");
    }
  }

  void FileChoose()async{
    try{
      FilePickerResult? response = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'txt',
          'pdf',
          'xls',
          'xlsx',
          'docx',
          'ppt',
          'doc',
          'ppt',
          'pptx'
        ],
      );

      if(response!=null){
        cnt_AddDocument.fileType = 0;
        cnt_AddDocument.arrImageList.clear();
        cnt_AddDocument.arrFileList.addAll(response.files);
        setState((){
          cnt_AddDocument.arrImageAndFileList = cnt_AddDocument.arrFileList;

        });

        cnt_AddDocument.update();
      }
      else{
        print("No Selected any File");
      }
    }catch(e){
      print("Error :--- \n $e");
    }

  }

  Widget AttachementWidget([double leftPadding = 0 , bool labelOpen = true]){
    return GestureDetector(
        onTap: (){
          OnSelectDialog();
          setState((){});
        },
        child: Container(
          child: Column(
            children: [
              Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            labelOpen?
                            Text("File*",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.7),fontSize: 12),)
                        :Container(),
                           SizedBox(height: 10,),
                            Container(
                                child: cnt_AddDocument.arrImageAndFileList.length!=0?
                                Container(
                                  // height: cnt_AddDocument.arrImageAndFileList.length !=0?300:10,
                                  child:
                                  GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount:
                                      cnt_AddDocument.arrImageAndFileList.length > 0
                                          ? cnt_AddDocument.arrImageAndFileList.length
                                          : 0,
                                      itemBuilder: (context, i) {
                                        return FileBlock(i);
                                      },
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5,
                                      childAspectRatio: 1.4
                                    ),),
                                ):Container(
                                  height: labelOpen?null:50,
                                  width: labelOpen?null:120,
                                  alignment: Alignment.centerLeft,
                                  child: Text("Attach your ${widget.title ?? "file"}" , style: TextStyle(fontSize: 15, color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.bold),),
                                )
                            ),


                          ],
                        ),
                      )
                    ],
                  )
              ),
              SizedBox(height: 10,),
              Divider(color: APP_FONT_COLOR,thickness: 0.2,),
            ],
          ),
        ),
      );

  }

  String _setImage(String extension) {
    if (extension == "txt") {
      return IMG_FILEICON;
    } else if (extension == "pdf") {
      return IMG_PDFICON;
    } else if (extension == "xls" || extension == "xlsx") {
      return IMG_XLSICON;
    } else if (extension == "doc" || extension == "docx") {
      return IMG_DOCICON;
    } else if (extension == "ppt" || extension == "pptx") {
      return IMG_PPTICON;
    } else {
      return IMG_FILEICON;
    }
  }

  Widget FileBlock(int index){

    print(cnt_AddDocument.arrImageList.length);
    print(cnt_AddDocument.arrFileList.length);

    if (cnt_AddDocument.fileType == 1) {
      cnt_AddDocument.fileImage = File(cnt_AddDocument.arrImageList[index].path!);
    } else {
      cnt_AddDocument.fileImage = File(cnt_AddDocument.arrFileList[index].path!);
      cnt_AddDocument.imgPdf = _setImage(cnt_AddDocument.arrFileList[index].extension!);
    }

    return Stack(
      children: [
        Container(
            margin: EdgeInsets.all(5),
            height: 90,
            width: 160,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(color: APP_FONT_COLOR,width: 0.5,style: BorderStyle.solid)
            ),
            clipBehavior: Clip.hardEdge,
            child: cnt_AddDocument.fileType== 1
                ? Image.file(
              cnt_AddDocument.fileImage!,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            )
                : Image.asset(cnt_AddDocument.imgPdf!, height: 100, width: 100)),
        Positioned(
          top: -2.0,
          right: 10.0,
          child: new IconButton(
            // color: APP_THEME_COLOR,
              padding: EdgeInsets.all(0.0),
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.cancel,
              ),
              onPressed: () {
                setState((){
                  if (cnt_AddDocument.fileType == 1) {
                    cnt_AddDocument.arrImageList.removeAt(index);
                    if (cnt_AddDocument.arrImageList.length == 0) {
                      cnt_AddDocument.fileType= -1;
                    }
                  } else if (cnt_AddDocument.fileType == 0) {
                    cnt_AddDocument.arrFileList.removeAt(index);
                    if (cnt_AddDocument.arrFileList.length == 0) {
                      cnt_AddDocument.fileType = -1;
                    }
                  }
                  cnt_AddDocument.update();

                });

              }),
        )
      ],
    );
  }

}
