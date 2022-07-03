import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logic_circuits_simulator/models.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ScriptState extends ChangeNotifier {
  bool? _scriptExists;
  String? _scriptContent;

  bool get loaded => _scriptExists != null;
  bool get scriptExists => _scriptExists ?? false;
  String? get scriptContent => _scriptContent;

  final ProjectEntry project;
  final ComponentEntry component;

  ScriptState({required this.project, required this.component, bool invokeInit = true}) {
    if (invokeInit) {
      init();
    }
  }

  Future<File> _getScriptFile() async {
    final appDir = await getApplicationDocumentsDirectory();
    final componentDir = Directory(path.join(appDir.path, 'LogicCircuitsSimulator', 'projects', project.projectId, 'components', component.componentId));
    if (!await componentDir.exists()) {
      await componentDir.create(recursive: true);
    }
    return File(path.join(componentDir.path, 'script.ht'));
  }

  Future<void> init() async {
    final scriptFile = await _getScriptFile();
    _scriptExists = await scriptFile.exists();
    if (scriptExists) {
      _scriptContent = await scriptFile.readAsString();
    }
    notifyListeners();
  }

  Future<void> setScriptContents(String newContents) async {
    final scriptFile = await _getScriptFile();
    await scriptFile.writeAsString(newContents);
    _scriptContent = newContents;
    _scriptExists = true;
    notifyListeners();
  }

  Future<void> deleteScript() async {
    final scriptFile = await _getScriptFile();
    await scriptFile.delete();
    _scriptContent = null;
    _scriptExists = false;
    notifyListeners();
  }
}
