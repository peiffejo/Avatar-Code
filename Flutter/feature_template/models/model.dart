abstract class ElementModel<T, V> {
  int elementId;
  String name;
  String type;
  DateTime lastChanged;

  ElementModel(this.elementId, this.name, this.type, this.lastChanged);

  Function? getHandler(T data);
  Function setHandler(V data);
}

class ROSElement extends ElementModel {
  String topic;
  String dataType;
  ROSElement(int elementId, String name, String type, DateTime lastChanged,
      this.topic, this.dataType)
      : super(elementId, name, type, lastChanged);

  @override
  Function getHandler(data) {
    // TODO: implement getHandler
    throw UnimplementedError();
  }

  @override
  Function setHandler(data) {
    // TODO: implement setHandler
    throw UnimplementedError();
  }
}

abstract class WidgetElement extends ElementModel {
  String topic;
  String dataType;
  WidgetElement(int elementId, String name, String type, DateTime lastChanged,
      this.topic, this.dataType)
      : super(elementId, name, type, lastChanged);
}