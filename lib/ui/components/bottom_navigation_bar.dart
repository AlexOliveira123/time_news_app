part of '../search_page.dart';

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar();

  @override
  State<_BottomNavigationBar> createState() => __BottomNavigationBarState();
}

class __BottomNavigationBarState extends State<_BottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CubitSearchPresenter>();
    return BlocBuilder<CubitSearchPresenter, SearchState>(
      bloc: bloc,
      builder: (context, state) {
        return BottomNavigationBar(
          onTap: bloc.onTabChanged,
          currentIndex: bloc.currentTab,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(bloc.currentTab == 0 ? Icons.favorite_border_outlined : Icons.favorite),
              label: 'Favorites',
            ),
          ],
        );
      },
    );
  }
}
