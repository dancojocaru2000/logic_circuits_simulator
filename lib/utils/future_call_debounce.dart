class FutureCallDebounce<TParams extends Object> {
  TParams? _params;
  Future? _awaited;
  final Future Function(TParams) futureCall;
  final TParams Function(TParams oldParams, TParams newParams) combiner;

  static TParams _defaultCombiner<TParams>(TParams _, TParams newParams) => newParams;

  FutureCallDebounce({required this.futureCall, required this.combiner});
  FutureCallDebounce.replaceCombiner({required this.futureCall}) : combiner = _defaultCombiner;

  void call(TParams newParams) {
    if (_params != null) {
      _params = combiner(_params!, newParams);
    }
    else {
      _params = newParams;
    }

    _awaited ??= futureCall(_params!).then((value) => _awaited = null);
  }
}
