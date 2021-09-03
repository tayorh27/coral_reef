
class ExerciseActivity {
  String id,
      user_uid, activity_type, created_date, time_covered;
  dynamic timestamp, km_covered, time_taken, steps_taken;
  dynamic start_location, end_location;


  ExerciseActivity(this.id, this.user_uid, this.activity_type, this.created_date, this.timestamp,
      this.km_covered, this.time_taken, this.time_covered, this.steps_taken, this.start_location, this.end_location);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'user_uid':user_uid,
      'activity_type':activity_type,
      'created_date':created_date,
      'timestamp':timestamp,
      "km_covered": km_covered,
      "time_taken": time_taken,
      "time_covered": time_covered,
      "steps_taken": steps_taken,
      "start_location": start_location,
      "end_location": end_location
    };
  }

  ExerciseActivity.fromSnapshot(dynamic data) {
    id = data['id'];
    user_uid = data['user_uid'];
    activity_type = data['activity_type'];
    created_date = data['created_date'];
    timestamp = data['timestamp'];
    km_covered = data["km_covered"];
    time_taken = data["time_taken"];
    time_covered = data["time_covered"];
    steps_taken = data["steps_taken"];
    start_location = data["start_location"];
    end_location = data["end_location"];
  }
}