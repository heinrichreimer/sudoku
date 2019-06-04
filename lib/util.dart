Iterable<T> distinct<T>(Iterable<T> collection) => Set()..addAll(collection);

bool isDistinct<T>(Iterable<T> collection) =>
    collection.length == distinct(collection).length;
