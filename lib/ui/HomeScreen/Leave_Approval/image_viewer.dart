
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../Network/api_constants.dart';
class imageviewer extends StatelessWidget {
  var document;
   imageviewer({Key? key, this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('image------------------->${ApiConstants.IMAGE_BASE_URL}${document}');
    return  Container(
        child: PhotoView(
          imageProvider: NetworkImage(ApiConstants.IMAGE_BASE_URL +"${document}"),
        )
    );
  }
}
