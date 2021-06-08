
class VitaminsData {
  String id, year,month,day,week,weekValue,hour,min, created_date, vitamin_count, goal;
  dynamic timestamp;

  VitaminsData(this.id, this.year, this.month, this.day, this.week, this.weekValue, this.hour,
      this.min, this.created_date, this.vitamin_count, this.goal, this.timestamp);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'year':year,
      'month':month,
      'day':day,
      'week':week,
      'weekValue':weekValue,
      'hour':hour,
      'min':min,
      'created_date':created_date,
      'vitamin_count':vitamin_count,
      'goal':goal,
      'timestamp':timestamp,
    };
  }

  VitaminsData.fromSnapshot(dynamic data) {
    id = data['id'];
    year = data['year'];
    month = data['month'];
    day = data['day'];
    week = data['week'];
    weekValue = data['weekValue'];
    hour = data['hour'];
    min = data['min'];
    created_date = data['created_date'];
    vitamin_count = data['vitamin_count'];
    goal = data['goal'];
    timestamp = data['timestamp'];
  }
}

class MoodData {
  String id, year,month,day,week,weekValue,hour,min, created_date, mood_type;
  dynamic timestamp;

  MoodData(this.id, this.year, this.month, this.day, this.week, this.weekValue, this.hour,
      this.min, this.created_date, this.mood_type, this.timestamp);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'year':year,
      'month':month,
      'day':day,
      'week':week,
      'weekValue':weekValue,
      'hour':hour,
      'min':min,
      'created_date':created_date,
      'mood_type':mood_type,
      'timestamp':timestamp,
    };
  }

  MoodData.fromSnapshot(dynamic data) {
    id = data['id'];
    year = data['year'];
    month = data['month'];
    day = data['day'];
    week = data['week'];
    weekValue = data['weekValue'];
    hour = data['hour'];
    min = data['min'];
    created_date = data['created_date'];
    mood_type = data['mood_type'];
    timestamp = data['timestamp'];
  }
}

class SleepData {
  String id, year,month,day,week,weekValue,hour,min, created_date, bed_time,wake_up,sleeping_time;
  dynamic timestamp;

  SleepData(this.id, this.year, this.month, this.day, this.week, this.weekValue, this.hour,
      this.min, this.created_date, this.bed_time, this.wake_up, this.sleeping_time, this.timestamp);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'year':year,
      'month':month,
      'day':day,
      'week':week,
      'weekValue':weekValue,
      'hour':hour,
      'min':min,
      'created_date':created_date,
      'bed_time':bed_time,
      'wake_up':wake_up,
      'sleeping_time':sleeping_time,
      'timestamp':timestamp,
    };
  }

  SleepData.fromSnapshot(dynamic data) {
    id = data['id'];
    year = data['year'];
    month = data['month'];
    day = data['day'];
    week = data['week'];
    weekValue = data['weekValue'];
    hour = data['hour'];
    min = data['min'];
    created_date = data['created_date'];
    bed_time = data['bed_time'];
    wake_up = data['wake_up'];
    sleeping_time = data['sleeping_time'];
    timestamp = data['timestamp'];
  }
}