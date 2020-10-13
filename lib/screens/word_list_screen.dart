import 'package:flutter/material.dart';
import 'package:notebook/helpers/database_helper.dart';
import 'package:notebook/model/word_model.dart';
import 'package:notebook/screens/add_word_screen.dart';

class WordListScreen extends StatefulWidget {
  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  Future<List<Word>> _wordList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateWordList();
  }

  void _updateWordList() {
    setState(() {
      _wordList = DatabaseHelper.instance.getWordList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddWordScreen(
              word: null,
              updateWordList: _updateWordList,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _wordList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 80),
            itemCount: 1 + snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Words',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              }
              return _buildWord(snapshot.data[index - 1]);
            },
          );
        },
      ),
    );
  }

  Widget _buildWord(Word word) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: Colors.grey[300]),
                  child: Center(
                    child: Text(
                      word.english,
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: Colors.grey[300]),
                  child: Center(
                    child: Text(
                      word.persian,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddWordScreen(
              updateWordList: _updateWordList,
              word: word,
            ),
          ),
        ),
      ),
    );
  }
}
