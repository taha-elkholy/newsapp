import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:my_news_app/models/news_model.dart';
import 'package:my_news_app/modules/webview/news_webview.dart';

Widget buildArticleItem(context, Article article) => InkWell(
      onTap: () {
        if (article.url != null) {
          navigateTo(context, NewsWebView(article.url!));
        } else {
          showSnackBar(context, 'No Url for this Article');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            ConditionalBuilder(
              condition: article.urlToImage != null,
              builder: (context) => CachedNetworkImage(
                imageUrl: article.urlToImage!,
                imageBuilder: (context, imageProvider) => Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter:
                            ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                  ),
                ),
                placeholder: (context, url) => SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(child: CircularProgressIndicator())),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
              fallback: (context) => SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: Icon(
                    Icons.error,
                    size: 30,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 120,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        article.title != null ? '${article.title}' : 'no title',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Text(
                      article.publishedAt != null
                          ? '${article.publishedAt}'
                          : '',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

Widget articleBuilder(List<Article> list, {isSearch = false}) =>
    ConditionalBuilder(
      condition: list.length > 0,
      builder: (context) {
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildArticleItem(
            context,
            list[index],
          ),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
          ),
          itemCount: list.length,
        );
      },
      fallback: (context) => isSearch
          ? Container()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );

Widget defaultTextFormField({
  required TextEditingController controller,
  required String? Function(String? value) validator,
  required TextInputType inputType,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? onSuffixPressed,
  Function()? onTap,
  Function(String s)? onChanged,
  bool obscure = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: inputType,
      cursorColor: Colors.deepOrange,
      obscureText: obscure,
      onTap: onTap,
      onChanged: onChanged,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepOrange),
        prefixIcon: Icon(
          prefix,
          color: Colors.deepOrange,
        ),
        suffixIcon: IconButton(icon: Icon(suffix), onPressed: onSuffixPressed),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.deepOrange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.deepOrange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.deepOrange),
        ),
      ),
      validator: validator,
    );

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void showSnackBar(context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
