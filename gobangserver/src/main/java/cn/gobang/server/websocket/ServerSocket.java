package cn.gobang.server.websocket;

import org.java_websocket.WebSocket;
import org.java_websocket.handshake.ClientHandshake;
import org.java_websocket.server.WebSocketServer;

import java.net.InetSocketAddress;

public class ServerSocket extends WebSocketServer {

    public ServerSocket(int port){
        super(new InetSocketAddress(port));
    }

    public void onOpen(WebSocket webSocket, ClientHandshake clientHandshake) {
        System.out.println("onOpen() ==>  webSocket= " + webSocket + ", clientHandshake=" + clientHandshake);
        ServerSocketManager.INSTANCE.addConnectSocket(webSocket);
    }

    public void onClose(WebSocket webSocket, int i, String s, boolean b) {
        System.out.println("onClose() ==> webSocket="+webSocket + ", i="+i+", s="+s + ", b="+b);
        ServerSocketManager.INSTANCE.removeConnectSocket(webSocket);
    }

    public void onMessage(WebSocket webSocket, String s) {
        System.out.println("onMessage() ==> webSocket="+webSocket+", s="+s);
        webSocket.send("嘿嘿");
    }

    public void onError(WebSocket webSocket, Exception e) {
        System.out.println("onError() ==> webSocket="+webSocket+", e="+e);

    }

    public void onStart() {
        System.out.println("onStart()");
    }

}
