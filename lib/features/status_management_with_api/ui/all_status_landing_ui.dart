import 'package:click_up/core/framework/bloc_provider.dart';
import 'package:click_up/features/status_management_with_api/bloc/status_management_with_api_bloc.dart';
import 'package:click_up/features/status_management_with_api/model/status_management_model.dart';
import 'package:click_up/features/status_management_with_api/ui/status_tasks_ui.dart';
import 'package:click_up/theme/app_style.dart';
import 'package:click_up/ui_kit/loading_indicator.dart';
import 'package:click_up/ui_kit/size_config.dart';
import 'package:flutter/material.dart';

class AllStatusLandingUI extends StatefulWidget {
  @override
  _AllStatusLandingUIState createState() => _AllStatusLandingUIState();
}

class _AllStatusLandingUIState extends State<AllStatusLandingUI> {
  StatusManagementWithApiBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<StatusManagementWithApiBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.requestSpaceData();
    });
    return Scaffold(
      backgroundColor: AppStyle.white,
      body: LayoutBuilder(builder: (context, constraints) {
        SizeConfig().init(constraints);
        return Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: CustomScrollView(
              slivers: <Widget>[
                _buildClickUpImage(),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => Column(
                            children: <Widget>[
                              _buildSpaceName(),
                              _buildStatusGrid(),
                            ],
                          ),
                      childCount: 1),
                )
              ],
            ));
      }),
    );
  }

  Widget _buildClickUpImage() {
    return SliverAppBar(
      backgroundColor: AppStyle.white,
      expandedHeight: MediaQuery.of(context).size.width * .55,
      iconTheme: IconThemeData.fallback(),
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Opacity(
            opacity: .9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  "assets/images/clickup_logo.png",
                  fit: BoxFit.scaleDown,
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildSpaceName() {
    return StreamBuilder<String>(
        stream: _bloc.allStatusLandingSpaceNameRequestPipe.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            String spaceName = snapshot.data;
            return Text(spaceName, style: AppStyle.titleSizeLargeRegular);
          }
          return Container();
        });
  }

  Widget _buildStatusGrid() {
    return StreamBuilder<List<SingleStatusModel>>(
        stream: _bloc.allStatusLandingStatusesRequestPipe.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<SingleStatusModel> _statusList = snapshot.data;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width * .005),
              padding: EdgeInsets.only(top: 20),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _statusList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildStatusCard(_statusList[index]);
              },
            );
          }
          return LoadingIndicator.show();
        });
  }

  Widget _buildStatusCard(SingleStatusModel statusCardModel) {
    return GestureDetector(
      onTap: () {
        _bloc.updateSelectedStatusPipe.sink.add(statusCardModel.name);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StatusTasksUI(),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: statusCardModel.color, width: 2.0),
            color: AppStyle.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: statusCardModel.color,
                blurRadius: 5.0,
                offset: new Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Center(
              child: Text(
            statusCardModel.name,
            style: AppStyle.bodySizeMediumRegular
                .copyWith(color: statusCardModel.color),
          )),
        ),
      ),
    );
  }
}
