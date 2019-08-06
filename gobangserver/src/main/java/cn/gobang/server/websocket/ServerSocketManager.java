package cn.gobang.server.websocket;

import org.java_websocket.WebSocket;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

import cn.gobang.server.websocket.bean.User;

public enum  ServerSocketManager {
    INSTANCE;

    private static final int PORT = 9893;
    private ServerSocket serverSocket;

    private List<WebSocket> connectSockets = new LinkedList<WebSocket>();

    private List<User> users = new LinkedList<User>();

    ServerSocketManager(){
        serverSocket = new ServerSocket(PORT);
    }

    public void addConnectSocket(WebSocket webSocket){
        if(!connectSockets.contains(webSocket)){
            connectSockets.add(webSocket);
            users.add(socket2User(webSocket));
        }
    }

    public void removeConnectSocket(WebSocket webSocket){
        connectSockets.remove(webSocket);
        users.remove(socket2User(webSocket));
    }

    private User socket2User(WebSocket socket){
        ///FIXME :
        return  new User();
    }



    public void startServer(){
        serverSocket.start();
    }

    public void stopServer(){
        try {
            serverSocket.stop();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }


}
