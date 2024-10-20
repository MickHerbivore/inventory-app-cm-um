import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? url;
  const ProductImage({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            offset: Offset(0, 3),
            blurRadius: 20,
          )
        ]
      ),
      width: double.infinity,
      height: 250,
      child: ClipRRect(
        
        child: url == null
            ? const Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.fitWidth,
              )
            : FadeInImage(
                placeholder: const AssetImage('assets/loading.gif'),
                image: NetworkImage(url!),
                fit: BoxFit.cover,
              ),
      )
    );
  }
}
