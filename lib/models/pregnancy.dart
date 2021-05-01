class PregDetail {
  final String userId;
  final String detailsId;
  final String birthInfo;
  final String activityLevel;
  final String stressLevel;
  final String stressOften;
  final String diet;

  PregDetail({
    this.userId,
    this.detailsId,
    this.birthInfo,
    this.activityLevel,
    this.stressLevel,
    this.stressOften,
    this.diet,
  });

  Map toMap() {
    return {
      'userId': userId,
      'detailsId': detailsId,
      'birthInfo': birthInfo,
      'activityLevel': activityLevel,
      'stressLevel': stressLevel,
      'stressOften': stressOften,
      'diet': diet,
    };
  }

  PregDetail.fromFirestore(Map firestore)
      : userId = firestore['userId'],
        detailsId = firestore['detailsId'],
        birthInfo = firestore['birthInfo'],
        activityLevel = firestore['activityLevel'],
        stressLevel = firestore['stressLevel'],
        stressOften = firestore['stressOften'],
        diet = firestore['diet'];
}
