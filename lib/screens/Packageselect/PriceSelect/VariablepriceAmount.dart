import 'package:aradhana/Constants/Constants.dart';
import 'package:aradhana/Util/Utils.dart';
import 'package:aradhana/Widget/ButtonWidget.dart';
import 'package:aradhana/model/Schemeaddmodel.dart';
import 'package:aradhana/model/schemeAmountListmodel.dart';
import 'package:aradhana/service/postSchemeService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_string/random_string.dart';

class VariablePriceAmount extends StatefulWidget {
  final SchemeAmountListmodel data;
  final int schemeid;

  const VariablePriceAmount({Key key, this.data, this.schemeid})
      : super(key: key);
  @override
  _VariablePriceAmountState createState() => _VariablePriceAmountState();
}

class _VariablePriceAmountState extends State<VariablePriceAmount> {
  List colorArr = [
    0xffDAFFD7,
    0xffD1F8F7,
    0xffDCD7FF,
    0xffFFE1E1,
    0xffFFDDD2,
    0xffCDF0EA,
    0xffD7C0AE,
    0xff90C8AC,
    0xffFAF4B7,
    0xffB1BCE6,
  ];

  bool terms = false;
  int priceid;
  List<int> pricelist = [];
  var _isCheckeded;
  int termindex = 0;
  int termsid;

  tick(int index) {
    setState(() {
      _isCheckeded.clear();
      _isCheckeded = List<bool>.filled(widget.data.data.varient.length, false,
          growable: true);
      _isCheckeded.remove(index);
      _isCheckeded.insert(index, true);
      priceid = pricelist.elementAt(index);
      termsid = widget.data.data.fixed.elementAt(index).termsId;

      print(priceid);
    });

    for (int i = 0; i < widget.data.data.termsandcondtion.length; i++) {
      if (widget.data.data.termsandcondtion.elementAt(i).id ==
          widget.data.data.varient.elementAt(index).termsId) {
        termindex = i;
      }
    }
    print("```````termsid```````");
    print(termsid);
    print("````````termsid````````");
  }

  @override
  void initState() {
    _isCheckeded = List<bool>.filled(widget.data.data.varient.length, false,
        growable: true);
    widget.data.data.varient.forEach((element) {
      pricelist.add(element.id);
    });
    super.initState();
  }

  String _chosenValue = "Gold";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.data.data.varient.length == 0
          ? const Center(
              child: Text("No Schemes Available.", style: size14_400W))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.data.data.varient.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [shadow],
                                border: Border.all(color: Colors.black12),
                                color: Color(
                                    colorArr[int.parse(randomNumeric(1))]),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: InkWell(
                              onTap: () {
                                tick(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 10, top: 15, bottom: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      rs +
                                          widget.data.data.varient
                                              .elementAt(index)
                                              .amount
                                              .split('.')[0] +
                                          " - " +
                                          rs +
                                          widget.data.data.varient
                                              .elementAt(index)
                                              .amountTo
                                              .split('.')[0],
                                      style: font(
                                          14, Colors.black, FontWeight.w600),
                                    ),
                                    const Spacer(),
                                    _isCheckeded.elementAt(index)
                                        ? IconButton(
                                            icon: const FaIcon(
                                              FontAwesomeIcons.checkCircle,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              tick(index);
                                            })
                                        : IconButton(
                                            icon: const FaIcon(
                                                FontAwesomeIcons.circle,
                                                color: Colors.grey),
                                            onPressed: () {
                                              tick(index);
                                            }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.black,
                          ),
                          child: Checkbox(
                            value: terms,
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                            onChanged: (val) {
                              setState(() {
                                terms = val;
                              });
                            },
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        child: newButton("Ok", () {
                                          Navigator.pop(context);
                                        }),
                                      )
                                    ],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    elevation: 16,
                                    title: const Text("Terms and conditions"),
                                    titleTextStyle:
                                        font(15, Colors.black, FontWeight.w500),
                                    content: Scrollbar(
                                      child: ListView(
                                        children: [
                                          Html(
                                            data: widget
                                                .data.data.termsandcondtion
                                                .elementAt(termindex)
                                                .description,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                bottom: 2, // Space between underline and text
                              ),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.blue,
                                width: 1.0, // Underline thickness
                              ))),
                              child: const Text(
                                "Terms and conditions",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: newButton("Select", () {
                        if (!terms) {
                          showToast("Please agree to our terms conditions");
                        } else if (priceid == null) {
                          showToast("Please select a payment option");
                        } else {
                          selectScheme();

                          // Navigator.pushNamed(
                          //   context,
                          //   HomeTabs.routeName,
                          // );
                        }
                      }),
                    ),
                    // NeumorphicButton(
                    //     style: NeumorphicStyle(
                    //       //   depth: 8,
                    //       //   lightSource: LightSource.topLeft,
                    //       // shadowLightColor: Color.fromRGBO(71, 77, 110, 1),
                    //       // shadowDarkColor: Color.fromRGBO(71, 77, 110, 1),
                    //       color: HexColor("#720755"),
                    //       shape: NeumorphicShape.concave,
                    //       boxShape:
                    //           NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
                    //     ),
                    //     padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                    //     child: Icon(
                    //       Icons.check_outlined,
                    //       size: 35.0,
                    //       color: Colors.white,
                    //     ),
                    //     onPressed: () {
                    //       if (!terms) {
                    //         showToast("Please agree to our terms conditions");
                    //       } else if (priceid == null) {
                    //         showToast("Please select a payment option");
                    //       } else {
                    //         selectScheme();
                    //
                    //         // Navigator.pushNamed(
                    //         //   context,
                    //         //   HomeTabs.routeName,
                    //         // );
                    //       }
                    //     }),
                    const SizedBox(
                      height: 20,
                    )
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 20.0),
                    //   child: Buttonwidget(
                    //     click: () {
                    //       if (!terms) {
                    //         showToast("Please agree to our terms conditions");
                    //       } else if (priceid == null) {
                    //         showToast("Please select a payment option");
                    //       } else {
                    //         _showRedeemOption();

                    //         // Navigator.pushNamed(
                    //         //   context,
                    //         //   HomeTabs.routeName,
                    //         // );
                    //       }
                    //     },
                    //     label: "Select",
                    //     labelcolors: Colorsapps.buttonTextcolor,
                    //     height: 50,
                    //     width: 150,
                    //     colors: Colorsapps.buttonColor,
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
    );
  }

  void selectScheme() async {
    DateTime now = new DateTime.now();
    //  DateTime date = new DateTime(now.day, now.month, now.year);

    Map details = {
      "SchemeId": widget.schemeid,
      "SchemeAmountId": priceid,
      "UserId": await getSavedObject("roleid") == 3
          ? await getSavedObject("customerid")
          : await getSavedObject("userid"),
      "StartDate": now.toString().substring(0, 10),
      // "redeem_type": _chosenValue.compareTo("Gold") == 0 ? "0" : "1",
      "subscription_type": "1",
      "termsId": termsid
    };
    try {
      print(details);
      EasyLoading.show(status: 'Loading...');
      //    showLoading(context);
      Schemeaddmodel datas = await PostSchemeService.postService(details);
      //  Navigator.of(context).pop(true);
      // showLoading(context);
      setState(() {
        EasyLoading.dismiss();
        // data = datas;
        // print(data);
        //  test();
      });
      if (datas.success) {
        if (await getSavedObject("roleid") == 2 ||
            await getSavedObject("roleid") == 4) {
          //Navigator.popUntil(context, ModalRoute.withName('/SelectScheme'));
          // Navigator.popUntil(context, ModalRoute.withName('/SelectScheme'));
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/SelectScheme', (Route<dynamic> route) => false);
        } else {
          Navigator.popUntil(
              context, ModalRoute.withName('/Customerschemedetails'));
        }
      }
    } catch (e) {
      // showErrorMessage(e);
      EasyLoading.dismiss();
      //  Navigator.pop(context);
    }

    print(details);
  }

  // void _showRedeemOption() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return AlertDialog(
  //             title: new Text("Gold redeem option"),
  //             content: Container(
  //               width: 200,
  //               child: ListView(
  //                 shrinkWrap: true,
  //                 children: <Widget>[
  //                   new Text("Please select any option"),
  //                   SizedBox(
  //                     height: 15,
  //                   ),
  //                   InputDecorator(
  //                     decoration: const InputDecoration(
  //                         border: OutlineInputBorder(),
  //                         contentPadding: EdgeInsets.only(
  //                             left: 10, right: 10, top: 0, bottom: 0)),
  //                     child: DropdownButtonHideUnderline(
  //                       child: new DropdownButton<String>(
  //                         value: _chosenValue,
  //                         underline: Container(),
  //                         items: <String>["Gold", "Cash"].map((String value) {
  //                           return new DropdownMenuItem<String>(
  //                             value: value,
  //                             child: new Text(
  //                               value,
  //                               style: TextStyle(fontWeight: FontWeight.w500),
  //                             ),
  //                           );
  //                         }).toList(),
  //                         onChanged: (String value) {
  //                           setState(() {
  //                             _chosenValue = value;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 15,
  //                   ),
  //                   Buttonwidget(
  //                     click: () {
  //                       selectScheme();

  //                       // Navigator.pushNamed(
  //                       //   context,
  //                       //   HomeTabs.routeName,
  //                       // );
  //                     },
  //                     label: "Select",
  //                     labelcolors: Colorsapps.buttonTextcolor,
  //                     height: 50,
  //                     width: 150,
  //                     colors: Colorsapps.buttonColor,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

//   void showRedeemType() {
//       List<String> _locations = ['A', 'B', 'C', 'D']; // Option 2
//   String dropdownValue;
//     showGeneralDialog(
//       barrierLabel: "Barrier",
//       barrierDismissible: true,
//       barrierColor: Colors.black.withOpacity(0.5),
//       transitionDuration: Duration(milliseconds: 700),
//       context: context,
//       pageBuilder: (_, __, ___) {
//         return Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: 350,
//             child: ListView(
//               shrinkWrap: true,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 20.0,left: 30,right: 30),
//                   child: Buttonwidget(
//                     click: () {
//                       selectScheme();

//                       // Navigator.pushNamed(
//                       //   context,
//                       //   HomeTabs.routeName,
//                       // );
//                     },
//                     label: "Select",
//                     labelcolors: Colorsapps.buttonTextcolor,
//                     height: 50,
//                     width: 150,
//                     colors: Colorsapps.buttonColor,
//                   ),
//                 ),

// DropdownButton<String>(
//       value: dropdownValue,
//       onChanged: (String newValue) {
//         setState(() {
//           dropdownValue = newValue;
//         });
//       },
//       items: <String>['One', 'Two', 'Free', 'Four']
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     ),

//               ],
//             ),
//             margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(40),
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (_, anim, __, child) {
//         return SlideTransition(
//           position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
//           child: child,
//         );
//       },
//     );
//   }
}
