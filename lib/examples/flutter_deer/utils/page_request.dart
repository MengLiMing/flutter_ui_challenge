enum PageRequestType {
  // 没有刷新
  none,
  // 下拉刷新
  refresh,
  // 加载更多
  loadMore,
}

class PageResponseWrapper<T> {
  /// 当前请求的页数
  final int page;

  /// 当前请求的类型
  final PageRequestType requestType;

  /// 是否有更多
  final bool hasMore;

  /// 当前请求包含的列表
  final List<T> responseList;

  const PageResponseWrapper({
    required this.page,
    required this.requestType,
    required this.hasMore,
    required this.responseList,
  });
}

mixin PageRequest<T> {
  /// 起始页
  int initPage = 0;

  /// 请求分页数量
  int pageSize = 20;

  /// 存储当前页
  int _page = 0;

  /// 是否正在请求
  bool _isRequesting = false;

  /// 外部提供请求
  Future<PageResponseWrapper<T>> request(
      int page, int pageSize, PageRequestType requestType);

  /// 开始请求
  void startRequest(int page, int pageSize, PageRequestType requestType) {}

  /// 结束请求
  void endRequest(PageResponseWrapper<T> response) {}

  /// 取消之前的请求
  void cancelRequest();

  Future<PageResponseWrapper<T>?> refresh({
    int? page,
    bool force = false,
    int? pageSize,
  }) async {
    if (force) {
      cancelRequest();
      _isRequesting = false;
    }
    if (_isRequesting) return null;
    _isRequesting = true;

    final result = await _sendRequest(
      page: page ?? initPage,
      pageSize: pageSize ?? this.pageSize,
      requestType: PageRequestType.refresh,
    );

    return result;
  }

  Future<PageResponseWrapper<T>?> loadMore({int? pageSize}) async {
    if (_isRequesting) return null;

    _isRequesting = true;

    final result = await _sendRequest(
      page: _page,
      pageSize: pageSize ?? this.pageSize,
      requestType: PageRequestType.loadMore,
    );

    return result;
  }

  Future<PageResponseWrapper<T>?> _sendRequest(
      {required int page,
      required int pageSize,
      required PageRequestType requestType}) async {
    _page = page;

    startRequest(page, pageSize, requestType);
    final result = await request(
      page,
      pageSize,
      requestType,
    );

    endRequest(result);

    if (result.hasMore) {
      _page += 1;
    }

    _isRequesting = false;

    return result;
  }
}
