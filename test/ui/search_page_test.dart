import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_news_app/domain/entities/entities.dart';
import 'package:time_news_app/presentation/presentation.dart';
import 'package:time_news_app/ui/ui.dart';

import '../core/factories/factories.dart';

class SpySearchPresenter extends MockCubit<SearchState> implements CubitSearchPresenter {}

class FakeArticleEntity extends Fake implements ArticleEntity {}

class FakeFavoriteArticleEntity extends Fake implements FavoriteArticleEntity {}

void main() {
  late CubitSearchPresenter presenter;
  late ArticleEntity articleEntity;
  late FavoriteArticleEntity favoriteArticleEntity;

  void mockInitialState() {
    when(() => presenter.state).thenReturn(SearchInitialState());
    when(() => presenter.currentTab).thenReturn(0);
    when(() => presenter.groupedNews).thenReturn({});
    when(() => presenter.groupedFavoriteNews).thenReturn({});
  }

  void mockErrorState() {
    whenListen(
      presenter,
      Stream.fromIterable([SearchErrorState('any_message')]),
      initialState: SearchInitialState(),
    );
  }

  void mockLoadingState() {
    whenListen(
      presenter,
      Stream.fromIterable([SearchLoadingState()]),
      initialState: SearchInitialState(),
    );
  }

  void mockSuccessState() {
    whenListen(
      presenter,
      Stream.fromIterable([SearchSuccessState()]),
      initialState: SearchInitialState(),
    );
    when(() => presenter.groupedNews).thenReturn({
      articleEntity.sourceName: [articleEntity]
    });
    when(() => presenter.groupedFavoriteNews).thenReturn({
      favoriteArticleEntity.sourceName: [favoriteArticleEntity]
    });
  }

  setUp(() {
    presenter = SpySearchPresenter();
    articleEntity = makeArticleEntity();
    favoriteArticleEntity = makeFavoriteArticleEntity();
    mockInitialState();
  });

  setUpAll(() {
    HttpOverrides.global = null;
    registerFallbackValue(FakeArticleEntity());
    registerFallbackValue(FakeFavoriteArticleEntity());
  });

  Future<void> loadPage(WidgetTester tester) async {
    final page = BlocProvider<CubitSearchPresenter>.value(
      value: presenter,
      child: MaterialApp(home: SearchPage(presenter: presenter)),
    );
    await tester.pumpWidget(page);
  }

  testWidgets('Should load the page with correct widgets', (tester) async {
    await loadPage(tester);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('No news.'), findsOneWidget);
  });

  testWidgets('Should call onKeywordChanged when typed into the TextField', (tester) async {
    await loadPage(tester);
    await tester.enterText(find.byType(TextField), 'search');
    verify(() => presenter.onKeywordChanged(any()));
  });

  testWidgets('Should call getNews when typed into the TextField and wait for 500ms', (tester) async {
    when(() => presenter.getNews()).thenAnswer((_) => Future.value());
    await loadPage(tester);
    await tester.enterText(find.byType(TextField), 'search');
    await tester.pump(const Duration(milliseconds: 500));
    verify(() => presenter.getNews());
  });

  testWidgets('Should call onTabChanged when BottomNavigationBarIem was tapped', (tester) async {
    mockSuccessState();
    await loadPage(tester);
    await tester.pumpAndSettle();
    final favoriteIcon = find.byIcon(Icons.favorite_border_outlined);
    expect(favoriteIcon, findsOneWidget);
    await tester.tap(favoriteIcon);
    verify(() => presenter.onTabChanged(any()));
  });

  testWidgets('Should show favorites content when current tab was 1', (tester) async {
    when(() => presenter.currentTab).thenReturn(1);
    await loadPage(tester);
    await tester.pumpAndSettle();
    expect(find.text('Favorites'), findsWidgets);
    expect(find.text('No favorite news.'), findsOneWidget);
  });

  testWidgets('Should show a SnackBar when [SearchErrorState] was emitted', (tester) async {
    mockErrorState();
    await loadPage(tester);
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('any_message'), findsOneWidget);
  });

  testWidgets('Should show a CircularProgressIndicator when [SearchLoadingState] was emitted', (tester) async {
    mockLoadingState();
    await loadPage(tester);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should show a ListView when [SearchSuccessState] was emitted', (tester) async {
    mockSuccessState();
    await loadPage(tester);
    expect(find.byKey(searchContentKey), findsOneWidget);
  });

  testWidgets('Should find an item with article', (tester) async {
    mockSuccessState();
    await loadPage(tester);
    expect(find.byKey(newsItemKey(articleEntity.title)), findsOneWidget);
  });

  testWidgets('Should call addFavorite when favorite icon was tapped', (tester) async {
    when(() => presenter.addFavorite(any())).thenAnswer((_) => Future.value());
    mockSuccessState();
    await loadPage(tester);
    final iconButton = find.byIcon(Icons.favorite_outline);
    final icon = find.ancestor(matching: find.byType(GestureDetector), of: iconButton);
    await tester.tap(icon);
    verify(() => presenter.addFavorite(any()));
  });

  testWidgets('Should call removeFavorite when favorite icon of NewsItem widget was tapped', (tester) async {
    when(() => presenter.currentTab).thenReturn(1);
    when(() => presenter.removeFavorite(any())).thenAnswer((_) => Future.value());
    mockSuccessState();
    await loadPage(tester);
    final iconButton = find.byIcon(Icons.favorite).at(0);
    final icon = find.ancestor(matching: find.byType(GestureDetector), of: iconButton);
    await tester.tap(icon);
    verify(() => presenter.removeFavorite(any()));
  });
}
