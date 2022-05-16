import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

T useProvider<T>() {
  final context = useContext();
  return Provider.of<T>(context);
}
