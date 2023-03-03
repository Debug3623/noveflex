// import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
//
//
// class PdfScreen extends StatefulWidget {
//   String? url;
//   String? name;
//   PdfScreen({required this.url, required this.name});
//
//   @override
//   State<PdfScreen> createState() => _PdfScreenState();
// }
//
// class _PdfScreenState extends State<PdfScreen> {
//
//   bool _isLoading = true;
//   PDFDocument? document;
//   bool _usePDFListView = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//     changePDF();
//   }
//
//   changePDF() async {
//     setState(() => _isLoading = true);
//       document = await PDFDocument.fromURL(
//           widget.url.toString());
//     setState(() => _isLoading = false);
//   }
//
//   @override
//   void dispose() {
//     document = null;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var _height = MediaQuery.of(context).size.height;
//     var _width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body:Center(
//               child: _isLoading
//                   ? const Center(
//                       child: CupertinoActivityIndicator(
//                       ),
//                     )
//                   : SafeArea(
//                       child: Stack(
//                         children: [
//                           PDFViewer(
//                             document: document!,
//                             zoomSteps: 1,
//                             indicatorBackground: const Color(0xFF256D85),
//                             lazyLoad: false,
//                             scrollDirection: Axis.horizontal,
//                             showPicker: true,
//                             pickerButtonColor: const Color(0xFF256D85),
//                             showNavigation: true,  navigationBuilder:
//                             (context, page, totalPages, jumpToPage, animateToPage) {
//                           return Container(
//                             color: Colors.white,
//                             child: ButtonBar(
//
//                               alignment: MainAxisAlignment.spaceEvenly,
//                               children: <Widget>[
//                                 IconButton(
//                                   icon: Icon(Icons.first_page,color: const Color(0xFF256D85),),
//                                   onPressed: () {
//                                     // jumpToPage()(page: 0);
//                                     // _pdfViewerController
//                                     //     .jumpToPage(int.parse(_controller!.text.toString()));
//                                     // _controller!.clear();
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.arrow_back_ios,color: const Color(0xFF256D85),),
//                                   onPressed: () {
//                                     // animateToPage(page: page - 2);
//                                   },
//                                 ),
//                                 // IconButton(
//                                 //   icon: Container(
//                                 //       child: Icon(Icons.print),),
//                                 //   onPressed: () {
//                                 //     // animateToPage(page: page - 2);
//                                 //   },
//                                 // ),
//                                 IconButton(
//                                   icon: Icon(Icons.arrow_forward_ios,color: const Color(0xFF256D85),),
//                                   onPressed: () {
//                                     animateToPage(page: page);
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.last_page,color: const Color(0xFF256D85),),
//                                   onPressed: () {
//                                     // jumpToPage(page: totalPages - 1);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                           ),
//                           Positioned(
//                               top: _height * 0.03,
//                               left: _width * 0.05,
//                               child: GestureDetector(
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: Icon(
//                                     Icons.arrow_back_ios,
//                                     color: Color(0xFF256D85),
//                                   )))
//                         ],
//                       ),
//                     ),
//             )
//
//     );
//   }
// }
