import 'dart:convert';

import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Config/utils/colors.dart';

class FullImageViewPage extends StatefulWidget {
  final List<String> list;
  final int index;
  final String? title;
  FullImageViewPage({required this.list, required this.index,this.title});

  @override
  _FullImageViewState createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageViewPage> {
  PageController? pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Image img = Image.network('assets/logo.png');

  @override
  Widget build(BuildContext context) {
    pageController = PageController(initialPage: widget.index);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.TRANSPARENT,
          title: Text(capitalizeFirstLetter(widget.title??""),style: semiBoldTextStyle(fontSize: 16,txtColor: AppColors.white_color)),
          centerTitle: false,
          leading: IconButton(
            padding: EdgeInsets.all(0),
            onPressed: (){
              Get.back();
            },

            icon: Icon(Icons.arrow_back,color: white,size: 25),
            splashColor: AppColors.TRANSPARENT,
            highlightColor:AppColors.TRANSPARENT,
            hoverColor: AppColors.TRANSPARENT,
          ),
        ),
        backgroundColor: AppColors.BLACK,
        body: Stack(
          children: [
            Container(
                child: PhotoViewGallery.builder(
                  pageController: pageController,
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    int mainindex=index % widget.list.length;
                    return PhotoViewGalleryPageOptions(
                      // imageProvider: NetworkImage(widget.list[index].trim()),
                      // imageProvider: img.image,
                      // imageProvider: Image.network(widget.list[index].trim(),
                      imageProvider: Image.network(widget.list[mainindex].trim(),
                        errorBuilder: (context,url,check){
                          return Container();
                        },
                      ).image,
                      basePosition: Alignment.center,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 1.5,
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                      heroAttributes: PhotoViewHeroAttributes(tag: (index + 1).toString()),


                    );
                  },
                  // itemCount: widget.list.length,
                  itemCount: 999,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      child: CircularProgressIndicator(
                        color: AppColors.WHITE,
                        value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                      ),
                    ),
                  ),

                )),
            Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: pageController!,
                    count: widget.list.length,
                    effect: ColorTransitionEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                      dotColor: Colors.grey,
                      activeDotColor: AppColors.WHITE,
                      // radius: 10
                    ),
                  ),
                )),

          ],
        ));
  }
}

class ZoomableImage extends StatefulWidget {
  final String imageUrl;

  ZoomableImage({required this.imageUrl});

  @override
  _ZoomableImageState createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColors.TRANSPARENT,
        leading: IconButton(
          padding: EdgeInsets.all(0),
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back,color: white,size: 25),
          splashColor: AppColors.TRANSPARENT,
          highlightColor:AppColors.TRANSPARENT,
          hoverColor: AppColors.TRANSPARENT,
        ),),
      body: Container(
        // color: Colors.black,
        child: PhotoView(
          imageProvider: NetworkImage(widget.imageUrl),
        ),
      ),
    );
  }
}