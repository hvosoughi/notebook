class Word {
  int id;
  String english;
  String persian;

  Word({this.persian, this.english});
  Word.withId({this.id, this.persian, this.english});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['persian'] = persian;
    map['english'] = english;
    return map;
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word.withId(
      id: map['id'],
      persian: map['persian'],
      english: map['english'],
    );
  }
}
