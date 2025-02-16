class EWasteCenter {
  final String industryName;
  final String categories;
  final String name;
  final String email;
  final String phoneNumber;
  final String district;
  final String address;

  EWasteCenter({
    required this.industryName,
    required this.categories,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.district,
    required this.address,
  });

  factory EWasteCenter.fromJson(Map<String, dynamic> json) {
    return EWasteCenter(
      industryName: json["Industry Name"],
      categories: json["Categories"],
      name: json["Name"],
      email: json["Email"],
      phoneNumber: json["Phone Number"],
      district: json["District"],
      address: json["Address"],
    );
  }
}
