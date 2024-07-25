part of '../search_page.dart';

const searchContentKey = Key('SearchPage::_SearchContent');

class _SearchContent extends StatelessWidget {
  const _SearchContent();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CubitSearchPresenter>();
    return BlocBuilder<CubitSearchPresenter, SearchState>(
      bloc: bloc,
      builder: (_, __) {
        final newsQuantity = bloc.groupedNews.length;
        if (newsQuantity > 0) {
          return ListView.builder(
            key: searchContentKey,
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: bloc.groupedNews.length,
            itemBuilder: (context, index) {
              final sourceKeys = bloc.groupedNews.keys.toList();
              final sourceKey = sourceKeys[index];
              final newsList = bloc.groupedNews[sourceKey]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SourceTitle(sourceKey),
                  _PageView(newsList),
                ],
              );
            },
          );
        } else {
          return const Center(
            child: Text('No news.'),
          );
        }
      },
    );
  }
}
