import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../http/http.dart';

FindArticleByKeyword makeRemoteFindArticleByKeyword() {
  return RemoteFindArticleByKeyword(
    httpClient: makeDioAdapter(),
    url: makeApiUrl('everything'),
  );
}
