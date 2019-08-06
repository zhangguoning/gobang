package cn.gobang.server.socket;

import com.google.gson.Gson;

import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

public class Command {

    public static final String QUERY_PLAYERS = "%query_players%";

    public static final String SET_USERINFO = "%set_userinfo%";

}

enum CommandParser{

   INSTANCE;

    private static Gson gson = new Gson();

    public String filterCmd(Socket socket ,String data){
        if(data == null || data.length() <= 0){
            return "";
        }

        if(data.startsWith(Command.QUERY_PLAYERS)){
            return getPlayerList(socket);
        }else if(data.startsWith(Command.SET_USERINFO)){
            return setUserName(socket,data);
        }

        return "fail";
    }

    private String setUserName(Socket socket ,String data){
        if(!GobangServer.alivePlayer.isEmpty()){
            String newUserInfo = data.replaceFirst(Command.SET_USERINFO + ":", "");
            Player newPlayerInfo = gson.fromJson(newUserInfo, Player.class);

            for (Player p : GobangServer.alivePlayer){
                if(p.getSocket() == socket){
                    p.updatePlayer(newPlayerInfo);
                    System.out.println("客户端["+socket.getInetAddress().getHostAddress() +"]已更新信息:" + newPlayerInfo.toString());
                    break;
                }
            }

            return "success";
        }
        return "error";
    }


    private String getPlayerList(Socket currentSocket){

        List<Player> otherPlayer = new ArrayList<Player>();
        Player player = getCurrentPlayer(currentSocket);
        if(GobangServer.alivePlayer.size() > 1){
            for(Player s : GobangServer.alivePlayer){
                if(player!=s){
                    otherPlayer.add(s);
                }
            }
            if(!otherPlayer.isEmpty()){
                return gson.toJson(new PlayerList(otherPlayer));
            }

        }
        return "{}";
    }

    private Player getCurrentPlayer(Socket socket){
        for(Player p : GobangServer.alivePlayer){
            if(p.getSocket() == socket){
                return p;
            }
        }
        return null;
    }

}