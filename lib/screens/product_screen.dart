import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluxstore/custom_widget/custom_raiting_bar.dart';
import 'package:fluxstore/global/colors.dart';

class ProductScreen extends StatefulWidget {
  final DocumentSnapshot document;

  const ProductScreen({Key key, this.document}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    Widget _appBar() {
      return SliverAppBar(
        backgroundColor: c_primary,
        expandedHeight: MediaQuery.of(context).size.height * 0.65,
        elevation: 0,
        floating: false,
        pinned: true,
        snap: false,
        stretch: true,
        flexibleSpace: FlexibleSpaceBar(
          stretchModes: [
            StretchMode.zoomBackground,
            StretchMode.blurBackground,
          ],
          background: Stack(
            children: [
              Container(
                color: c_background,
                height: double.infinity,
                width: double.infinity,
              ),
              Hero(
                tag: widget.document.data['productCode'],
                child: CachedNetworkImage(
                  height: double.infinity,
                  width: double.infinity,
                  imageUrl: widget.document.data['imageHigh'],
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        backgroundColor: c_primary,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _dropdownButton() {
      String size;
      String color;

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(4, 15, 15, 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
            ),
            child: DropdownButtonFormField(
                decoration: InputDecoration.collapsed(hintText: ''),
                isExpanded: true,
                value: size ?? widget.document.data['sizes'][0],
                icon: Icon(Icons.keyboard_arrow_down),
                items: widget.document.data['sizes']
                    .map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem(
                    value: '$value',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Size",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => size = val);
                }),
          ),
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.fromLTRB(4, 15, 15, 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
            ),
            child: DropdownButtonFormField(
                decoration: InputDecoration.collapsed(hintText: ''),
                isExpanded: true,
                value: color ?? widget.document.data['colors'][0],
                icon: Icon(Icons.keyboard_arrow_down),
                items: widget.document.data['colors']
                    .map<DropdownMenuItem<String>>((value) {
                  List<String> splitColor = value.split('#');

                  return DropdownMenuItem(
                    value: '$value',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Color",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              color: Color(int.parse(splitColor[0])),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                splitColor[1],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => color = val);
                }),
          ),
        ],
      );
    }

    Widget _addToCart() {
      String count;

      return Row(
        children: [
          Expanded(
            flex: 75,
            child: SizedBox(
              height: 55,
              child: FlatButton(
                onPressed: () {},
                color: c_primary,
                child: Text(
                  'ADD TO CART',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 25,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration.collapsed(hintText: ''),
                isExpanded: false,
                value: count ?? "1",
                icon: Icon(Icons.keyboard_arrow_down),
                items: <String>['1', '2', '3', '4', '5', '6', '7']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: t_primary),
                    ),
                  );
                }).toList(),
                onChanged: (String val) {
                  setState(() {
                    count = val;
                  });
                },
              ),
            ),
          ),
        ],
      );
    }

    Widget _productCharacteristics() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.document.data['title'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              widget.document.data['discountPrice'] != ""
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        '\$ ${widget.document.data['mainPrice']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.black54,
                        ),
                      ),
                    )
                  : SizedBox(),
              Text(
                '\$ ${widget.document.data['discountPrice'] != "" ? widget.document.data['discountPrice'] : widget.document.data['mainPrice']}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          widget.document.data['rating'] != null
              ? Row(
                  children: [
                    StarRating(
                      size: 20,
                      colorPrimary: c_primary,
                      colorSecondary: Colors.black,
                      starCount: 5,
                      rating: widget.document.data['rating'].toDouble(),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '(${widget.document.data['ratingCount']})',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(height: 30),
          _dropdownButton(),
          SizedBox(height: 40),
          _addToCart(),
        ],
      );
    }

    Widget _productDescription() {
      TextStyle primaryStyle = TextStyle(
        color: t_primary,
        fontSize: 15.0,
        fontWeight: FontWeight.w300,
      );

      TextStyle secondaryStyle = TextStyle(
        color: t_primary,
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
      );

      return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: EdgeInsets.only(top: 20),
          title: Text(
            "Description",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
          childrenPadding: EdgeInsets.only(top: 20),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.document.data['description'],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    text: 'Product Code:\t\t',
                    style: primaryStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.document.data['productCode'],
                        style: secondaryStyle,
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Category:\t\t',
                    style: primaryStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.document.data['category'],
                        style: TextStyle(
                          fontSize: 15,
                          color: c_primary,
                          fontWeight: FontWeight.w300,
                          decoration: TextDecoration.underline,
                          decorationColor: c_primary,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Material:\t\t',
                    style: primaryStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.document.data['material'],
                        style: secondaryStyle,
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Country:\t\t',
                    style: primaryStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.document.data['country'],
                        style: secondaryStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _productScreen() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 42.0, 16.0, 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _productCharacteristics(),
            _productDescription(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: c_background,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          _appBar(),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[_productScreen()]),
          )
        ],
      ),
    );
  }
}
