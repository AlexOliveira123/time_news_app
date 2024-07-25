part of '../search_page.dart';

class _SourceTitle extends StatelessWidget {
  const _SourceTitle(this.sourceKey);

  final String sourceKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Text(
        sourceKey,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
