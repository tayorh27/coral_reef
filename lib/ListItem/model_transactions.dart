
class Transactions {
  String id,
      user_uid, created_date, reason, type,transaction_hash, transaction_id;
  dynamic amount;
  dynamic timestamp;

  Transactions(this.id, this.user_uid, this.amount, this.reason, this.created_date, this.timestamp, this.transaction_hash, this.transaction_id, this.type);

  Map<String, dynamic> toJSON() {
    return {
      'id':id,
      'user_uid':user_uid,
      'created_date':created_date,
      'reason':reason,
      'transaction_hash':transaction_hash,
      'type':type,
      'transaction_id':transaction_id,
      'timestamp':timestamp,
      'amount':amount,
    };
  }

  Transactions.fromSnapshot(dynamic data) {
    id = data['id'];
    user_uid = data['user_uid'];
    reason = data['reason'];
    type = data['type'];
    created_date = data['created_date'];
    amount = data['amount'];
    timestamp = data['timestamp'];
    transaction_hash = data['transaction_hash'];
    transaction_id = data['transaction_id'];
  }
}