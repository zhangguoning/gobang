import 'package:gobang/bean/accept_fighting.dart';
import 'package:gobang/bean/fighting.dart';
import 'package:gobang/bean/fighting_confirm.dart';
import 'package:gobang/bean/invite_fighting.dart';
import 'package:gobang/bean/player_list.dart';
import 'package:gobang/bean/response.dart';
import 'package:gobang/bean/bool_result.dart';
import 'package:gobang/bean/chessman.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/bean/send_chessman.dart';


abstract class Api{

  Future<PlayerList> queryPlayers();

  Future<PlayerList> register(Player player);

  Future<BoolResult> sendChessman(SendChessman sendChessman);

  Future<FightingConfirm> inviteFighting(InviteFighting inviteFighting);

  Future<BoolResult> cancelInviteFighting(FightingConfirm fightingConfirm);

  Future<InviteFightingResult> acceptFighting(FightingConfirm confirm);

  Future<InviteFightingResult> refuseFighting(FightingConfirm confirm);

  Future<BoolResult> startGame(InviteFightingResult result);

  Future<BoolResult> quitGame(Fighting fighting);

}