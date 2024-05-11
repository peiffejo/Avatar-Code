abstract class ElementModel<T, V> {
  int elementId;
  String name;
  String type;
  DateTime lastChanged;

  ElementModel(this.elementId, this.name, this.type, this.lastChanged);

  Function? getHandler(T data);
  Function setHandler(V data);
}
