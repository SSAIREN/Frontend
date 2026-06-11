class Guardian {
  const Guardian({
    required this.name,
    required this.relationship,
    this.isActive = false,
  });

  final String name;
  final String relationship;
  final bool isActive;
}
