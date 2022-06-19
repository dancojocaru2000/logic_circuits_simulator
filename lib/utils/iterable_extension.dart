extension IndexedMap<T> on Iterable<T> {
  Iterable<O> indexedMap<O>(O Function(int, T) toElement) {
    int index = 0;
    return map((e) => toElement(index++, e));
  }

  Iterable<O> zipWith<O>(Iterable<Iterable<T>> otherIterables, O Function(List<T>) toElement, {bool allowUnequalLengths = false}) sync* {
    final iterators = [this].followedBy(otherIterables).map((e) => e.iterator).toList();
    while (true) {
      int ends = iterators.map((it) => it.moveNext()).where((e) => e == false).length;
      if (ends != 0) {
        // At least one iterator finished
        if (ends != iterators.length && !allowUnequalLengths) {
          throw Exception('While zipping, $ends iterators ended early');
        }
        else {
          return;
        }
      }

      yield toElement(iterators.map((it) => it.current).toList(growable: false));
    }
  }
}