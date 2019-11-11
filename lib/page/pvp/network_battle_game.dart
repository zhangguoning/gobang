
import 'package:flutter/material.dart';
import 'package:gobang/page/pvp/Invite_fighting_listen.dart';

class NetworkBattleGamePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _NetworkBattleGamePageState();
  }

}

class _NetworkBattleGamePageState extends InviteFightingConfirmWidgetState<NetworkBattleGamePage>{
  BuildContext context ;
  @override
  Widget buildView(BuildContext context) {
    this.context = context;
    return _buildNetworkBattleGamePage();
  }

  void invalidate() {
    setState(() {});
  }

  Widget _buildNetworkBattleGamePage(){
    return Scaffold(
      key: Key("_NetworkBattleGamePageState_key"),
      appBar: AppBar(
        title: Text("选择对手"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {

    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        width: 300,
        height: 300,
      ),
    );
  }

  @override
  Future<bool> onBackspacePress() {
    return Future.value(true);
  }

}