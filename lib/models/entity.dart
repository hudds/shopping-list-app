
abstract class Entity{
  int id = 0;
  Entity(this.id);
  Entity.buildFromMap(Map<String,dynamic> entityMap) { }
  Map<String, dynamic> convertToMap();
  Entity createEntity(Map<String,dynamic> entityMap);
  Entity get copy {
    Map<String, dynamic> map = convertToMap();
    return createEntity(map);
  }
}