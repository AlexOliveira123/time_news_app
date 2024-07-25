part of '../search_page.dart';

class _Dots extends StatelessWidget {
  final int newsQuantity;
  final int currentNews;

  const _Dots({
    required this.newsQuantity,
    required this.currentNews,
  });

  List<Widget> _getDots() {
    final dots = <Widget>[];
    for (int i = 0; i < newsQuantity; i++) {
      dots.add(
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: _Dot(isSelected: i == currentNews),
        ),
      );
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _getDots(),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isSelected;

  const _Dot({
    this.isSelected = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 6,
      width: isSelected ? 12 : 6,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.red.withOpacity(isSelected ? 1 : 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
