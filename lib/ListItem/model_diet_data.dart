
class WaterData {
  String id, year,month,day,week,hour,min, created_date, glasses_count;
  dynamic timestamp;

  WaterData(this.id, this.year, this.month, this.day, this.week, this.hour,
      this.min, this.created_date, this.glasses_count, this.timestamp);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'year':year,
      'month':month,
      'day':day,
      'week':week,
      'hour':hour,
      'min':min,
      'created_date':created_date,
      'glasses_count':glasses_count,
      'timestamp':timestamp,
    };
  }

  WaterData.fromSnapshot(dynamic data) {
    id = data['id'];
    year = data['year'];
    month = data['month'];
    day = data['day'];
    week = data['week'];
    hour = data['hour'];
    min = data['min'];
    created_date = data['created_date'];
    glasses_count = data['glasses_count'];
    timestamp = data['timestamp'];
  }
}

class WeightData {
  String id, year,month,day,week,hour,min, created_date, weight,bmi,height;
  dynamic timestamp;

  WeightData(this.id, this.year, this.month, this.day, this.week, this.hour,
      this.min, this.created_date, this.weight, this.bmi, this.height, this.timestamp);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'year':year,
      'month':month,
      'day':day,
      'week':week,
      'hour':hour,
      'min':min,
      'created_date':created_date,
      'weight':weight,
      'bmi':bmi,
      'height':height,
      'timestamp':timestamp,
    };
  }

  WeightData.fromSnapshot(dynamic data) {
    id = data['id'];
    year = data['year'];
    month = data['month'];
    day = data['day'];
    week = data['week'];
    hour = data['hour'];
    min = data['min'];
    created_date = data['created_date'];
    weight = data['weight'];
    bmi = data['bmi'];
    height = data['height'];
    timestamp = data['timestamp'];
  }
}