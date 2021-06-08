
class WaterData {
  String id, year,month,day,week, weekValue, hour,min, created_date, glasses_count,goal;
  dynamic timestamp;

  WaterData(this.id, this.year, this.month, this.day, this.week, this.weekValue, this.hour,
      this.min, this.created_date, this.glasses_count, this.goal, this.timestamp);

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
      'glasses_count':glasses_count,
      'goal':goal,
      'timestamp':timestamp,
    };
  }

  WaterData.fromSnapshot(dynamic data) {
    id = data['id'];
    year = data['year'];
    month = data['month'];
    day = data['day'];
    week = data['week'];
    weekValue = data['weekValue'];
    hour = data['hour'];
    min = data['min'];
    created_date = data['created_date'];
    glasses_count = data['glasses_count'];
    goal = data['goal'];
    timestamp = data['timestamp'];
  }
}

class WeightData {
  String id, year,month,day,week,weekValue,hour,min, created_date, weight,bmi,height,goal;
  dynamic timestamp;

  WeightData(this.id, this.year, this.month, this.day, this.week, this.weekValue, this.hour,
      this.min, this.created_date, this.weight, this.bmi, this.height, this.goal, this.timestamp);

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
      'weight':weight,
      'bmi':bmi,
      'height':height,
      'goal':goal,
      'timestamp':timestamp,
    };
  }

  WeightData.fromSnapshot(dynamic data) {
    id = data['id'];
    year = data['year'];
    month = data['month'];
    day = data['day'];
    week = data['week'];
    weekValue = data['weekValue'];
    hour = data['hour'];
    min = data['min'];
    created_date = data['created_date'];
    weight = data['weight'];
    bmi = data['bmi'];
    height = data['height'];
    goal = data['goal'];
    timestamp = data['timestamp'];
  }
}