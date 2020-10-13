import 'package:flutter/material.dart';
import 'package:notebook/helpers/database_helper.dart';
import 'package:notebook/model/word_model.dart';

class AddWordScreen extends StatefulWidget {
  final Word word;
  final Function updateWordList;
  AddWordScreen({this.updateWordList, this.word});

  @override
  _AddWordScreenState createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _english;
  String _persian;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.word != null) {
      _english = widget.word.english;
      _persian = widget.word.persian;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.word == null ? 'Add' : 'Edit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            labelText: 'English',
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (input) => input.trim().isEmpty ? """You can't leave it empty.""" : null,
                          onSaved: (input) => _english = input,
                          initialValue: _english,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            labelText: 'Persian',
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (input) => input.trim().isEmpty ? """You can't leave it empty.""" : null,
                          onSaved: (input) => _persian = input,
                          initialValue: _persian,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: FlatButton(
                          child: Text(
                            widget.word == null ? 'Add' : 'Edit',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: _submit,
                        ),
                      ),
                      widget.word == null
                          ? SizedBox.shrink()
                          : Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: FlatButton(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                                onPressed: _delete,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var word = Word(english: _english, persian: _persian);
      if (widget.word == null) {
        DatabaseHelper.instance.insertWord(word);
      } else {
        word.id = widget.word.id;
        DatabaseHelper.instance.updateWord(word);
      }
      widget.updateWordList();
      Navigator.pop(context);
    }
  }

  void _delete() {
    DatabaseHelper.instance.deleteWord(widget.word);
    widget.updateWordList();
    Navigator.pop(context);
  }
}
