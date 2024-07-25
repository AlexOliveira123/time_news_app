import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helpers/helpers.dart';
import '../domain/entities/entities.dart';
import '../presentation/presentation.dart';
import 'detail_page.dart';
import 'ui.dart';

part 'components/app_bar.dart';
part 'components/bottom_navigation_bar.dart';
part 'components/dots.dart';
part 'components/favorite_content.dart';
part 'components/news_item.dart';
part 'components/page_view.dart';
part 'components/search_content.dart';
part 'components/source_title.dart';

class SearchPage extends StatefulWidget {
  final SearchPresenter presenter;

  const SearchPage({
    super.key,
    required this.presenter,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final CubitSearchPresenter _bloc;
  late final List<Widget> _content;

  void _setUp() {
    _bloc = widget.presenter as CubitSearchPresenter;
    _content = [
      const _SearchContent(),
      const _FavoriteContent(),
    ];
  }

  void _dispose() {
    _bloc.dispose();
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
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        appBar: const _AppBar(),
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: const _BottomNavigationBar(),
        body: BlocConsumer<CubitSearchPresenter, SearchState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is SearchErrorState) SnackBarHelper.show(context, message: state.message);
          },
          builder: (context, state) {
            if (state is SearchLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return _content[_bloc.currentTab];
            }
          },
        ),
      ),
    );
  }
}
