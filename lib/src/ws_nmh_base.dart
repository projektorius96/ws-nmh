class Message {
  late final String text;

  Message(this.text);

  Message.fromJson(Map<String, dynamic> json){
    text = json['text'] as String;
  }
  Map<String, dynamic> toJson() => {
    'text': text,
  };
}
