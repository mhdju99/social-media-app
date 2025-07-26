
class SimpleUserModel {
  final String? id;
  final String? userName;
  final String? profileImage;
  final String? fullName;
  final bool? isDoctor;

  SimpleUserModel({
    this.id,
    this.userName,
    this.profileImage,
    this.fullName,
    this.isDoctor,
  });

  factory SimpleUserModel.fromJson(Map<String, dynamic> json) {
    return SimpleUserModel(
      id: json['_id'] as String?,
      userName: json['userName'] as String?,
      profileImage: json['profileImage'] as String?,
      fullName: json['fullName'] as String?,
      isDoctor: json['isDoctor'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userName': userName,
      'profileImage': profileImage,
      'fullName': fullName,
      'isDoctor': isDoctor,
    };
  }


}
