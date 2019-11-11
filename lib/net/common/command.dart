class Command{

  static const String REGISTER = "%register%:";

  static const String QUERY_PLAYERS = "%query_players%:";

  static const String FIGHTING = "%fighting%:";

  static const String INVITE_FIGHTING = "%invite_fighting%:";

  static const String CANCEL_INVITE_FIGHTING = "%cancel_invite_fighting%:";

  static const String SEND_CHESSMAN = "%send_chessman%:";

  static const String ACCEPT_FIGHTING = "%accept_fighting%:";

  static const String START_GAME = "%start_game%:";

  static const String QUIT_GAME = "%quit_game%:";

  /////////////////////服务器主动下发消息所使用指令///////////////////////
  static const String CALLBACK_INVITE_FIGHTING_CONFIRM = "%callback_invite_fighting_confirm%:";

  static const String CALLBACK_INVITE_FIGHTING_RESULT = "%callback_invite_fighting_result%:";

  static const String CALLBACK_RECEIVED_CHESSMAN = "%callback_received_chessman%:";

  static const String CALLBACK_START_GAME = "%callback_start_game%:";

  static const String CALLBACK_QUIT_GAME = "%callback_quit_game%:";

  static const String CALLBACK_GAME_OVER = "%callback_game_over%:";


}

class ResultConstant{

  static const String UNKNOWN_COMMAND = "@unknown_command@";

  static const String NO_DATA = "@no_data@";

  static const String ERROR = "@_error@";


}

