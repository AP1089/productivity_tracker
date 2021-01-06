import 'package:click_up/common/shared_strings.dart';
import 'package:click_up/core/framework/bloc_provider.dart';
import 'package:click_up/features/status_management_with_api/bloc/status_management_with_api_bloc.dart';
import 'package:click_up/theme/app_style.dart';
import 'package:flutter/material.dart';

const _sharedStrings = SharedStrings();

class CreateTaskUI extends StatefulWidget {
  @override
  _CreateTaskUIState createState() => _CreateTaskUIState();
}

class _CreateTaskUIState extends State<CreateTaskUI> {
  StatusManagementWithApiBloc _bloc;
  String taskName = "";
  String taskTags = "";

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<StatusManagementWithApiBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppStyle.white,
      appBar: _buildNavigationBar(),
      body: _buildPage(),
    );
  }

  Widget _buildNavigationBar() {
    return AppBar(
      backgroundColor: AppStyle.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_downward, color: AppStyle.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        _sharedStrings.addTask,
        style: AppStyle.bodySizeMediumRegular.copyWith(color: AppStyle.black),
      ),
    );
  }

  Widget _buildPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTaskNameField(),
            _buildTaskTagsField(),
            _buildCreateTaskButton(),
            _buildTaskCreatedStatus()
          ],
        ),
      ),
    );
  }

  Widget _buildTaskNameField() {
    return TextFormField(
      style: AppStyle.bodySizeSmallRegular,
      decoration: InputDecoration(
          hintText: _sharedStrings.taskName,
          hintStyle: AppStyle.bodySizeSmallRegular),
      onChanged: (value) {
        setState(() {
          taskName = value;
        });
      },
    );
  }

  Widget _buildTaskTagsField() {
    return TextFormField(
      style: AppStyle.bodySizeSmallRegular,
      decoration: InputDecoration(
          hintText: _sharedStrings.tagsSeparatedByCommas,
          hintStyle: AppStyle.bodySizeSmallRegular),
      onChanged: (value) {
        setState(() {
          taskTags = value;
        });
      },
    );
  }

  Widget _buildCreateTaskButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppStyle.gray, width: 2.0),
          color: AppStyle.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: AppStyle.gray,
              blurRadius: 2.0,
              offset: new Offset(0.0, 2.0),
            ),
          ],
        ),
        child: MaterialButton(
            minWidth: 200,
            onPressed: () async {
              _bloc.createTaskDetailsPipe.sink.add({
                _sharedStrings.name: taskName,
                _sharedStrings.tags: taskTags
              });
            },
            child: Text(
              _sharedStrings.createTask,
              style: AppStyle.bodySizeMediumRegular,
            )),
      ),
    );
  }

  Widget _buildTaskCreatedStatus() {
    return StreamBuilder<bool>(
        stream: _bloc.createTaskSuccessStatusPipe.stream,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            bool success = snapshot.data;
            if (success) return _buildCreatedSuccessMessage();
            return _buildCreatedFailedMessage();
          }
          return Container();
        });
  }

  Widget _buildCreatedSuccessMessage() {
    return Text(_sharedStrings.taskCreatedSuccessfully,
        style: AppStyle.bodySizeMediumRegular.copyWith(color: AppStyle.green));
  }

  Widget _buildCreatedFailedMessage() {
    return Text(_sharedStrings.failedToCreate,
        style: AppStyle.bodySizeMediumRegular.copyWith(color: AppStyle.red));
  }
}
