part of '../search_page.dart';

const favoriteContentKey = Key('SearchPage::_FavoriteContent');

class _FavoriteContent extends StatelessWidget {
  const _FavoriteContent();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CubitSearchPresenter>();
    return BlocBuilder<CubitSearchPresenter, SearchState>(
      bloc: bloc,
      builder: (_, __) {
        final favoriteNewsQuantity = bloc.groupedFavoriteNews.length;
        if (favoriteNewsQuantity > 0) {
          return ListView.builder(
            key: favoriteContentKey,
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: favoriteNewsQuantity,
            itemBuilder: (context, index) {
              final sourceKeys = bloc.groupedFavoriteNews.keys.toList();
              final sourceKey = sourceKeys[index];
              final favoriteNewsList = bloc.groupedFavoriteNews[sourceKey]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SourceTitle(sourceKey),
                  _PageView(favoriteNewsList),
                ],
              );
            },
          );
        } else {
          return const Center(child: Text('No favorite news.'));
        }
      },
    );
  }
}
