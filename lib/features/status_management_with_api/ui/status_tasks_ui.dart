import 'package:click_up/core/framework/bloc_provider.dart';
import 'package:click_up/features/status_management_with_api/bloc/status_management_with_api_bloc.dart';
import 'package:click_up/features/status_management_with_api/model/status_management_model.dart';
import 'package:click_up/features/status_management_with_api/ui/create_task_ui.dart';
import 'package:click_up/theme/app_style.dart';
import 'package:click_up/ui_kit/loading_indicator.dart';
import 'package:flutter/material.dart';

class StatusTasksUI extends StatefulWidget {
  @override
  _StatusTasksUIState createState() => _StatusTasksUIState();
}

class _StatusTasksUIState extends State<StatusTasksUI> {
  StatusManagementWithApiBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<StatusManagementWithApiBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.requestStatusTaskListData();
    });
    return Scaffold(
      backgroundColor: AppStyle.white,
      appBar: _buildNavigationBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          return await _bloc.requestStatusTaskListData();
        },
        child: Stack(
          children: [_buildStatusList(), _buildAddTaskFloatingActionButton()],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return AppBar(
      backgroundColor: AppStyle.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppStyle.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: StreamBuilder(
          stream: _bloc.statusDetailNavigationTitleRequestPipe.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              String title = snapshot.data;
              return Text(
                title,
                style: AppStyle.bodySizeMediumRegular
                    .copyWith(color: AppStyle.black),
              );
            }
            return Container();
          }),
    );
  }

  Widget _buildStatusList() {
    return StreamBuilder<List<SingleTaskModel>>(
        stream: _bloc.statusDetailTaskListRequestPipe.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<SingleTaskModel> _taskList = snapshot.data;
            return ListView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: true,
              itemCount: _taskList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildTaskCard(_taskList[index]);
              },
            );
          }
          return LoadingIndicator.show();
        });
  }

  Widget _buildTaskCard(SingleTaskModel taskCardModel) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: taskCardModel.statusColor, width: 2.0),
          color: AppStyle.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: taskCardModel.statusColor,
              blurRadius: 2.0,
              offset: new Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                taskCardModel.name,
                style: AppStyle.bodySizeMediumRegular
                    .copyWith(color: taskCardModel.statusColor),
              ),
              _buildTagsList(taskCardModel.tags)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagsList(List<String> tagsList) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: SizedBox(
        height: 28,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: tagsList.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildTag(tagsList[index]);
          },
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppStyle.gray, width: 1.0),
          color: AppStyle.white,
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(tag, style: AppStyle.bodySizeSmallRegular),
        )),
      ),
    );
  }

  Widget _buildAddTaskFloatingActionButton() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: AppStyle.black,
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => CreateTaskUI(),
              ));

          _bloc.requestStatusTaskListData();
        },
        child: Icon(Icons.add, color: AppStyle.white, size: 24),
      ),
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(16.0),
    );
  }
}
