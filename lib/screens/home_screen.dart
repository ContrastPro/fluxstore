import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxstore/custom_widget/custom_product_item.dart';
import 'package:fluxstore/custom_widget/custom_container.dart';
import 'package:fluxstore/custom_widget/custom_fade_route.dart';
import 'package:fluxstore/global/colors.dart';
import 'package:fluxstore/screens/product_screen.dart';
import 'package:fluxstore/screens/sign_in_up_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _goToDetailScreen({BuildContext context, DocumentSnapshot document}) {
    Navigator.push(
      context,
      FadeRoute(
        page: ProductScreen(document: document),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _sortField() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 35.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app,
                  color: Colors.black12,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Tap & hold the product to add to cart',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    FlatButton.icon(
                      onPressed: () => _addItem(),
                      icon: Text(
                        "SORT  BY",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: t_primary,
                        ),
                      ),
                      label: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.compare_arrows,
                          size: 18,
                          color: t_secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              height: 2,
              color: Colors.black12,
              endIndent: 16,
            ),
          ],
        ),
      );
    }

    Widget _clothingList() {
      return StreamBuilder(
        stream: Firestore.instance
            .collection('Fluxstore')
            .orderBy('createdAt', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.hasData) {
            return GridView.builder(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 20.0,
              ),
              itemCount: snapshot.data.documents.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                childAspectRatio: 0.50,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _goToDetailScreen(
                    context: context,
                    document: snapshot.data.documents[index],
                  ),
                  child: CustomProductItem(
                    document: snapshot.data.documents[index],
                  ),
                );
              },
            );
          }
          return SizedBox();
        },
      );
    }

    Widget _homeScreen({String title}) {
      return Scaffold(
        backgroundColor: c_primary,
        appBar: AppBar(
          backgroundColor: c_primary,
          elevation: 0,
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {},
            ),
          ],
        ),
        body: CustomContainer(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              _sortField(),
              _clothingList(),
            ],
          ),
        ),
      );
    }

    Widget _anotherPage({String title}) {
      return Scaffold(
        backgroundColor: c_primary,
        appBar: AppBar(
          backgroundColor: c_primary,
          elevation: 0,
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {},
            ),
          ],
        ),
        body: CustomContainer(
          child: Center(child: Text(title)),
        ),
      );
    }

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: c_background,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: _anotherPage(title: 'Home'),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: _homeScreen(title: 'Dresses'),
              );
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: _anotherPage(title: 'Cart'),
              );
            });
          case 3:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: SignInUpScreen(signIn: true),
              );
            });
          default:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: _homeScreen(title: 'Dresses'),
              );
            });
        }
      },
    );
  }

  _addItem() {
    CollectionReference item = Firestore.instance.collection('Fluxstore');
    List<String> sizes = ["XS", "S", "M", "L", "XL"];
    List<String> colors = [
      "0xff565C66#Salute Tight Loops - Blue",
      "0xffB2BCDD#Colony - Blue",
      "0xffF8CCCC#Blush - Red",
      "0xfffcd179#Gold Coast - Yellow",
      "0xffE1D99D#Oasis - Green",
    ];

    Future<void> addItem() {
      return item
          .add({
            'imageLow':
                "https://lsco.scene7.com/is/image/lsco/361360045-front-pdp?fmt=jpeg&qlt=70,1&op_sharpen=0&resMode=sharp2&op_usm=0.8,1,10,0&fit=crop,0&wid=450&hei=600",
            //261x500
            'imageHigh':
                "https://lsco.scene7.com/is/image/lsco/361360045-front-pdp?fmt=jpeg&qlt=70,1&op_sharpen=0&resMode=sharp2&op_usm=0.8,1,10,0&fit=crop,0&wid=1155&hei=1540",
            //630x1200
            'title': "Scaridian dress",
            'mainPrice': "${Random().nextInt(800) + 200}.00",
            'discountPrice': "${Random().nextInt(100) + 99}.00",
            'rating': Random().nextInt(5),
            'ratingCount': Random().nextInt(20),
            'remain': "2 days 10h:24m",
            'description':
                "The Karissa V-Neck Tee features a semi-fitted shape that's flattering for every figure. You can hit the gym with confidence while it hugs curves and hides common \"problem\" areas. Find stunning women's cocktail dresses and party dresses.",
            'sizes': sizes,
            'colors': colors,
            'productCode':
                "${Random().nextInt(9999)}${Random().nextInt(999)}-${Random().nextInt(99)}",
            'category': "Sweatshirts",
            'material': "Cotton",
            'country': "Germany",
            'createdAt': Timestamp.now(),

          })
          .then((value) => print("Item Added"))
          .catchError((error) => print("Failed to add item: $error"));
    }

    return addItem();
  }
}
