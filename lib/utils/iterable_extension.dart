extension IndexedMap<T> on Iterable<T> {
  Iterable<O> indexedMap<O>(O Function(int, T) toElement) {
    int index = 0;
    return map((e) => toElement(index++, e));
  }
}