class Guardian {
  const Guardian({
    required this.name,
    this.relationship = '',
    this.phoneNumber = '',
    this.isActive = false,
  });

  final String name;
  final String relationship;
  final String phoneNumber;
  final bool isActive;
}
