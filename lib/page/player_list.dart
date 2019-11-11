import 'package:flutter/material.dart';
import 'package:gobang/page/pvp/Invite_fighting_listen.dart';

class PlayerListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _PlayerListPageState();
  }

}

class _PlayerListPageState extends InviteFightingConfirmWidgetState<PlayerListPage>{


  @override
  Widget buildView(BuildContext context) {
    return Container();
  }

  @override
  Future<bool> onBackspacePress() {
    return Future.value(true);
  }
}
