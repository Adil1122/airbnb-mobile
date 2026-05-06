class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final bool isIdentityVerified;
  final bool isPhoneVerified;
  final String? location;
  final String? work;
  final String? school;
  final String? bornDecade;
  final String? dreamDestination;
  final String? funFact;
  final String? pets;
  final String? timeSpender;
  final String? favSong;
  final String? uselessSkill;
  final String? bioTitle;
  final String? obsessedWith;
  final List<String>? interests;
  final List<String>? travelStamps;
  final bool showStamps;
  final String? hostBio;
  final List<String>? hostLanguages;
  final String? phone;
  final String? mailingAddress;
  final String? emergencyContact;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.isIdentityVerified = false,
    this.isPhoneVerified = false,
    this.location,
    this.work,
    this.school,
    this.bornDecade,
    this.dreamDestination,
    this.funFact,
    this.pets,
    this.timeSpender,
    this.favSong,
    this.uselessSkill,
    this.bioTitle,
    this.obsessedWith,
    this.interests,
    this.travelStamps,
    this.showStamps = false,
    this.hostBio,
    this.hostLanguages,
    this.phone,
    this.mailingAddress,
    this.emergencyContact,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      isIdentityVerified: json['isIdentityVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      location: json['location'],
      work: json['work'],
      school: json['school'],
      bornDecade: json['bornDecade'],
      dreamDestination: json['dreamDestination'],
      funFact: json['funFact'],
      pets: json['pets'],
      timeSpender: json['timeSpender'],
      favSong: json['favSong'],
      uselessSkill: json['uselessSkill'],
      bioTitle: json['bioTitle'],
      obsessedWith: json['obsessedWith'],
      interests: json['interests'] != null ? List<String>.from(json['interests']) : null,
      travelStamps: json['travelStamps'] != null ? List<String>.from(json['travelStamps']) : null,
      showStamps: json['showStamps'] ?? false,
      hostBio: json['hostBio'],
      hostLanguages: json['hostLanguages'] != null ? List<String>.from(json['hostLanguages']) : null,
      phone: json['phone'],
      mailingAddress: json['mailingAddress'],
      emergencyContact: json['emergencyContact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'isIdentityVerified': isIdentityVerified,
      'isPhoneVerified': isPhoneVerified,
      'location': location,
      'work': work,
      'school': school,
      'bornDecade': bornDecade,
      'dreamDestination': dreamDestination,
      'funFact': funFact,
      'pets': pets,
      'timeSpender': timeSpender,
      'favSong': favSong,
      'uselessSkill': uselessSkill,
      'bioTitle': bioTitle,
      'obsessedWith': obsessedWith,
      'interests': interests,
      'travelStamps': travelStamps,
      'showStamps': showStamps,
      'hostBio': hostBio,
      'hostLanguages': hostLanguages,
      'phone': phone,
      'mailingAddress': mailingAddress,
      'emergencyContact': emergencyContact,
    };
  }
}
