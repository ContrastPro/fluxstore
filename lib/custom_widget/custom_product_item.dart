import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluxstore/custom_widget/custom_raiting_bar.dart';
import 'package:fluxstore/global/colors.dart';

class CustomProductItem extends StatefulWidget {
  final DocumentSnapshot document;

  const CustomProductItem({Key key, this.document}) : super(key: key);

  @override
  _CustomProductItemState createState() => _CustomProductItemState();
}

class _CustomProductItemState extends State<CustomProductItem> {
  List _favourite = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 65,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Hero(
                tag: widget.document.data['productCode'],
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: double.infinity,
                  imageUrl: widget.document.data['imageLow'],
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
              IconButton(
                icon: Icon(
                  _favourite.contains(widget.document.data['productCode'])
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                onPressed: () {
                  if (_favourite
                      .contains(widget.document.data['productCode'])) {
                    _favourite.remove(widget.document.data['productCode']);
                  } else {
                    _favourite.add(widget.document.data['productCode']);
                  }
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        Expanded(
          flex: 35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                widget.document.data['title'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$ ${widget.document.data['discountPrice'] == "" ? widget.document.data['mainPrice'] : widget.document.data['discountPrice']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 5),
                  widget.document.data['discountPrice'] != ""
                      ? Text(
                          '\$ ${widget.document.data['discountPrice'] == "" ? widget.document.data['discountPrice'] : widget.document.data['mainPrice']}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w200,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.black26),
                        )
                      : SizedBox(),
                ],
              ),
              widget.document.data['rating'] != 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          StarRating(
                            size: 16,
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
                      ),
                    )
                  : SizedBox(),
              widget.document.data['remain'] != ""
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Remain: ${widget.document.data['remain']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
