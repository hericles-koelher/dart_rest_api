import 'package:mongo_dart/mongo_dart.dart';

abstract class MongoBaseRepository {
  final DbCollection counters;
  final String counterName;

  MongoBaseRepository(this.counters, this.counterName);

  Future<int> getNextSequenceValue() async {
    var sequenceDocument = await counters.findAndModify(
        query: where.eq("_id", counterName),
        update: modify.inc("sequenceValue", 1));

    if (sequenceDocument == null) {
      await counters.insertOne({
        "_id": counterName,
        "sequenceValue": 1,
      });

      return 0;
    }

    return sequenceDocument["sequenceValue"];
  }
}
