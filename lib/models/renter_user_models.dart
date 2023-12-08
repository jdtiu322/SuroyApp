class RenterUserModel {
  final bool? approved;

  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? userId;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? age;
  final String? licenseImageUrl;
  final String? driverLicense; 


  RenterUserModel(
      {required this.approved,
      required this.userId,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.phoneNumber,
      required this.age,
      required this.licenseImageUrl,
      required this.driverLicense,
      });

  RenterUserModel.fromJson(Map<String, Object?> json)
      : this(
          approved: json['approved']! as bool,
          userId: json['userId']! as String,
          firstName: json['firstName']! as String,
          middleName: json['middleName']! as String,
          lastName: json['lastName']! as String,
          email: json['email']! as String,
          password: json['password']! as String,
          phoneNumber: json['phoneNumber']! as String,
          age: json['age']! as String,
          licenseImageUrl: json['licenseImageUrl']! as String,
          driverLicense: json['driverLicense']! as String,
          
        );

    Map<String, Object?> toJson(){
      return{
        'approved': approved,
        'userId': userId,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'age': age,
        'licenseImageUrl': licenseImageUrl,
        'driverLicense': driverLicense,
        
      };
    }
}
