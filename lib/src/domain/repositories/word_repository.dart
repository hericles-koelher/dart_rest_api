import 'package:mongo_dart/mongo_dart.dart';

import '../../domain.dart';

class WordRepository {
  final DbCollection words;

  WordRepository(this.words);

  Future<Word> create(String word, String meaning) async {
    validateWord(word);
    validateMeaning(meaning);

    var wordEntity = Word(
      word: word,
      meaning: meaning,
      lastUpdate: DateTime.now(),
    );

    if (await words.findOne(where.eq("word", word)) != null) {
      throw WordValidationException("Word already registered");
    }

    await words.insertOne(wordEntity.toJson());

    return wordEntity;
  }

  Future<List<Word>> getAllWords() async =>
      await words.find().map(Word.fromJson).toList();

  Future<Word> read(String word) async {
    var wordJson = await words.findOne(where.eq("word", word));

    if (wordJson == null) {
      throw WordNotFoundException("Word not found in our database");
    }

    return Word.fromJson(wordJson);
  }

  Future<Word> update(String word, String meaning) async {
    var wordJson = await words.findOne(where.eq("word", word));

    if (wordJson == null) {
      throw WordNotFoundException("Word not found in our database");
    }

    await words.updateOne(
      where.eq("word", word),
      modify.set("meaning", meaning),
    );

    await words.updateOne(
      where.eq("word", word),
      modify.set("lastUpdate", DateTime.now().toString()),
    );

    wordJson = await words.findOne(where.eq("word", word));

    return Word.fromJson(wordJson!);
  }

  Future<void> delete(String word) async {
    await words.deleteOne(where.eq("word", word));
  }
}
