/// stepGoal : "10000"

class StepGoalModel {
  String _stepGoal;

  String get stepGoal => _stepGoal;

  StepGoalModel({
      String stepGoal}){
    _stepGoal = stepGoal;
}

  StepGoalModel.fromJson(dynamic json) {
    _stepGoal = json["stepGoal"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["stepGoal"] = _stepGoal;
    return map;
  }

}