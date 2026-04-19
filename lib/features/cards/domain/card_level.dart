class CardLevel {
  final int level;
  final int bp;
  final int? coresRequired;

  const CardLevel({
    required this.level,
    required this.bp,
    this.coresRequired,
  });

  factory CardLevel.fromJson(Map<String, dynamic> json) => CardLevel(
        level: json['level'],
        bp: json['bp'],
        coresRequired: json['coresRequired'],
      );

  Map<String, dynamic> toJson() => {
        'level': level,
        'bp': bp,
        'coresRequired': coresRequired,
      };
}
