part of '../search_page.dart';

class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  State<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size(0, kToolbarHeight);
}

class _AppBarState extends State<_AppBar> {
  late final Debouncer _debouncer;
  late final TextEditingController _controller;
  late final CubitSearchPresenter _bloc;

  void _setUp() {
    _debouncer = Debouncer(milliseconds: 500);
    _controller = TextEditingController();
    _bloc = context.read<CubitSearchPresenter>();
  }

  void _dispose() {
    _debouncer.cancel();
  }

  void onChanged(String value) {
    _bloc.onKeywordChanged(value);
    _debouncer.run(() => _bloc.getNews());
  }

  @override
  void initState() {
    super.initState();
    _setUp();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CubitSearchPresenter>();
    return BlocBuilder<CubitSearchPresenter, SearchState>(
      bloc: bloc,
      builder: (context, state) {
        return AppBar(
          title: bloc.currentTab == 1
              ? const Text('Favorites')
              : Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search typing four letters...',
                        border: InputBorder.none,
                      ),
                      controller: _controller,
                      onChanged: onChanged,
                    ),
                  ],
                ),
        );
      },
    );
  }
}
