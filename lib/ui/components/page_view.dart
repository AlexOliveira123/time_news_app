part of '../search_page.dart';

class _PageView extends StatefulWidget {
  final List<ArticleEntity> newsList;

  const _PageView(this.newsList);

  @override
  State<_PageView> createState() => _PageViewState();
}

class _PageViewState extends State<_PageView> {
  late PageController _controller;
  late int _currentArticle;

  void _setUp() {
    _currentArticle = 0;
    _controller = PageController(initialPage: _currentArticle);
  }

  void _dispose() {
    _controller.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentArticle = index;
    });
  }

  @override
  void initState() {
    _setUp();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CubitSearchPresenter>();
    final newsQuantity = widget.newsList.length;
    return Column(
      children: [
        Container(
          height: 264,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            onPageChanged: _onPageChanged,
            itemCount: newsQuantity,
            itemBuilder: (context, index) {
              final article = widget.newsList[index];
              return _NewsItem(
                article,
                onPressed: () {
                  if (article is FavoriteArticleEntity) {
                    bloc.removeFavorite(article);
                  } else {
                    bloc.addFavorite(article);
                  }
                },
                isFavorite: article is FavoriteArticleEntity,
              );
            },
          ),
        ),
        if (newsQuantity > 1)
          _Dots(
            newsQuantity: newsQuantity,
            currentNews: _currentArticle,
          )
      ],
    );
  }
}
