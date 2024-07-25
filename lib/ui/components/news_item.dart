part of '../search_page.dart';

Key newsItemKey(String key) => Key('SearchPage::_NewsItem_$key');

class _NewsItem extends StatelessWidget {
  final ArticleEntity article;
  final bool isFavorite;
  final VoidCallback onPressed;

  const _NewsItem(
    this.article, {
    this.isFavorite = true,
    required this.onPressed,
  });

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<DetailPage>(
        builder: (context) => DetailPage(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: newsItemKey(article.title),
      children: [
        Container(
          width: (MediaQuery.of(context).size.width - 32),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(article.description, maxLines: 4, overflow: TextOverflow.ellipsis),
                    ),
                    Row(
                      children: [
                        Flexible(child: Text(DateFormatter.format(article.publishedAt))),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: onPressed,
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_outline,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 152,
                      height: 152,
                      child: article.urlToImage.isEmpty ? const Center(child: Text('No image')) : Image.network(article.urlToImage, fit: BoxFit.fill),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _navigateToDetail(context),
                    child: const Row(
                      children: [
                        Text('View details'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 12),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
