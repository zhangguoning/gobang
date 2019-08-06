package cn.gobang.server.socket;

import com.google.gson.annotations.Expose;

import java.net.Socket;
import java.util.List;

public class PlayerList{

    List<Player> players;

    public PlayerList(List<Player> players) {
        this.players = players;
    }

    public List<Player> getPlayers() {
        return players;
    }

    public void setPlayers(List<Player> players) {
        this.players = players;
    }
}

class Player {
    @Expose
    private Socket socket ;
    private String ip ;
    private String name;
    private String deviceId;

    public Player(Socket socket, String ip, String name) {
        this.socket = socket;
        this.ip = ip;
        this.name = name;
    }

    public Player(Socket socket) {
        this.socket = socket;
        this.ip = socket.getInetAddress().getHostAddress();
        this.name = socket.getInetAddress().getHostAddress();

    }

    public void updatePlayer(Player newPlayer){
        this.setName(newPlayer.getName());
        this.setIp(newPlayer.getIp());
        this.setDeviceId(newPlayer.getDeviceId());
    }

     public String getDeviceId() {
         return deviceId;
     }

     public void setDeviceId(String deviceId) {
         this.deviceId = deviceId;
     }

     public Socket getSocket() {
        return socket;
    }

    public void setSocket(Socket socket) {
        this.socket = socket;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Player{" +
                "ip='" + ip + '\'' +
                ", name='" + name + '\'' +
                ", deviceId='" + deviceId + '\'' +
                '}';
    }
}
