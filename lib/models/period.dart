class PeriodDetail {
  final String userId;
  final String detailsId;
  final String birthYear;
  final String lastPeriod;
  final String length;
  final String cycle;

  PeriodDetail({
    this.userId,
    this.detailsId,
    this.birthYear,
    this.lastPeriod,
    this.length,
    this.cycle,
  });

  Map toMap() {
    return {
      'userId': userId,
      'detailsId': detailsId,
      'birthYear': birthYear,
      'lastPeriod': lastPeriod,
      'length': length,
      'cycle': cycle,
    };
  }

  PeriodDetail.fromFirestore(Map firestore)
      : userId = firestore['userId'],
        detailsId = firestore['detailsId'],
        birthYear = firestore['birthYear'],
        lastPeriod = firestore['lastPeriod'],
        length = firestore['length'],
        cycle = firestore['cycle'];
}
