import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_course/app/home/models/jobs.dart';
import 'package:firebase_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:firebase_course/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditJobPage extends StatefulWidget {
  final DataBase dataBase;
  final Job job;
  const EditJobPage({Key key, @required this.dataBase, this.job})
      : super(key: key);
  static Future<void> show(BuildContext context,
      {DataBase database, Job job}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
          builder: (context) => EditJobPage(
                dataBase: database,
                job: job,
              ),
          fullscreenDialog: true),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formkey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;
  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.rate;
    }
  }

  bool valiadeAndSaveForm() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _submit() async {
    if (valiadeAndSaveForm() == true) {
      try {
        final jobs = await widget.dataBase.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          showDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Text("Operation Failed"),
                    content: new Text("The Entered Job already exist"),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        onPressed: () => Navigator.pop(context),
                        isDefaultAction: true,
                        child: Text("OK"),
                      ),
                    ],
                  ));
        } else {
          final id = widget.job?.documentId ?? DateTime.now().toIso8601String();
          final Job job = Job(name: _name, rate: _ratePerHour, documentId: id);
          await widget.dataBase.setJob(job);
          Navigator.pop(context);
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: "Operation Failed", exception: e);
      }
    }
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: "Job Name"),
        initialValue: _name,
        onSaved: (value) => _name = value,
        validator: (value) => value.isEmpty ? "Name Can\'t be empty" : null,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Rate Per Hour"),
        initialValue: _ratePerHour != null ? _ratePerHour.toString() : "",
        keyboardType:
            TextInputType.numberWithOptions(decimal: false, signed: false),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        validator: (value) => value.isEmpty ? "Rate Can\'t be empty" : null,
      ),
    ];
  }

  Widget _buildCupertinoForm() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: CupertinoFormSection(header: Text("Job Details"), children: [
        CupertinoFormRow(
          key: _formkey,
          child: CupertinoTextFormFieldRow(
            placeholder: "Job Name",
            prefix: Text("Name"),
          ),
        ),
        CupertinoFormRow(
          child: CupertinoTextFormFieldRow(
            placeholder: "Rate Per Hour",
            prefix: Text("Rate"),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        title: Text(widget.job != null ? "Edit Job" : "New Job"),
        actions: [
          TextButton(
              onPressed: _submit,
              child: Text(
                "Save",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }
}
