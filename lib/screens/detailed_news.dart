import 'package:daily_news/api/api_service.dart';
import 'package:daily_news/api/model.dart';
import 'package:daily_news/news.dart';
import 'package:daily_news/responsive.dart';
import 'package:flutter/material.dart';

class DetailedNews extends StatefulWidget {
  final int index;
  const DetailedNews({Key? key, required this.index}) : super(key: key);

  @override
  State<DetailedNews> createState() => _DetailedNewsState();
}

class _DetailedNewsState extends State<DetailedNews> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  void _getData() async {
    await ApiService().getNews();
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive(15),
            vertical: context.responsive(36)),
        child: FutureBuilder<List<Results>?>(
          future: ApiService().getNews(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(snapshot
                      .data![widget.index].media![0].mediaMetadata![2].url
                      .toString()),
                  Text(
                    snapshot.data![widget.index].media![0].caption.toString(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: context.responsive(48),
                  ),
                  Text(
                    'Published on : ${snapshot.data![widget.index].publishedDate.toString()}',
                    style: TextStyle(
                      fontSize: context.responsive(10),
                    ),
                  ),
                  Text(
                    snapshot.data![widget.index].title.toString(),
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: context.responsive(24),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: context.responsive(18),
                  ),
                  Text(
                    news,
                    style: TextStyle(
                      fontSize: context.responsive(12),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }
}
