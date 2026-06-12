class CallLog {
  const CallLog({
    required this.name,
    required this.phoneNumber,
    required this.calledAt,
    this.isOutgoing = false,
  });

  final String name;
  final String phoneNumber;
  final DateTime calledAt;
  final bool isOutgoing;
}
