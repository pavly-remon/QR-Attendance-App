class Member {
  String id = '';
  String name;
  Map<String, String> attendance;
  bool scanned;

  Member({
    this.id = '',
    required this.name,
    required this.attendance,
    this.scanned = false,
  });
  static Member fromJson(Map<String, dynamic> json) {
    String id = json['ID'];
    String name = json['Name'];
    json.remove('ID');
    json.remove('Name');
    return Member(
      id: id,
      name: name,
      attendance: json as Map<String, String>,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, String> json = this.attendance;
    json['ID'] = this.id;
    json['Name'] = this.name;
    return json;
  }
}
