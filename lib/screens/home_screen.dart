import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxstore/api/authentication_api.dart';
import 'package:fluxstore/custom_widget/custom_product_item.dart';
import 'package:fluxstore/custom_widget/custom_container.dart';
import 'package:fluxstore/custom_widget/custom_fade_route.dart';
import 'package:fluxstore/global/colors.dart';
import 'package:fluxstore/screens/product_screen.dart';
import 'package:fluxstore/screens/sign_in_up_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    /// initializeCurrentUser() - method for checking current User authorization Firebase
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  _goToDetailScreen({BuildContext context, DocumentSnapshot document}) {
    Navigator.push(
      context,

      /// FadeRoute() - custom Navigation route for example, like MaterialPageRoute()
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
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    FlatButton.icon(
                      onPressed: () {},
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
                          color: Colors.black38,
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

    Widget _productList() {
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
              icon: Icon(Icons.tune),
              onPressed: () {},
            ),
          ],
        ),
        body: CustomContainer(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              _sortField(),
              _productList(),
            ],
          ),
        ),
      );
    }

    /// _anotherPage() - TabView page layout

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
              icon: Icon(Icons.tune),
              onPressed: () {},
            ),
          ],
        ),
        body: CustomContainer(
          /// You can add your own widgets here. This could be ListView() for example

          child: Center(child: Text(title)),
        ),
      );
    }



    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: c_background,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(
            icon: Stack(
              children: <Widget>[
                Icon(Icons.shopping_cart),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '10',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
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
}
