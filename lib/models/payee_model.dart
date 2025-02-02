class Payee {
  String name;
  String contact;
  String desc;
  bool premium;

  Payee(
      {required this.name,
      required this.contact,
      required this.desc,
      required this.premium});

  toJson() {
    return {'name': name, 'contact': contact, 'desc': desc, 'premium': premium};
  }

  fromJson(Map json) {
    return Payee(
        name: json['name'],
        contact: json['contact'],
        desc: json['desc'],
        premium: json['premium']);
  }
}
