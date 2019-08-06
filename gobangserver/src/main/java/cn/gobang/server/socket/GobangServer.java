package cn.gobang.server.socket;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;

public class GobangServer {

    public static final int PORT = 8613;
    private static Random random = new Random();

    public static List<Player> alivePlayer = new LinkedList<Player>();

    public static void init() throws IOException {
        ServerSocket ss = new ServerSocket(PORT);
        System.out.println("服务器初始化成功,等待客户端连接...");
        while (true){
            Socket socket = ss.accept();
            System.out.println("客户端已连接, HostName:"+ socket.getInetAddress().getHostAddress());
            new ServerThread(socket).start();
            Player player = new Player(socket);
            alivePlayer.add(player);
        }
    }

   static class ServerThread extends Thread{
        private Socket socket ;
        public ServerThread(Socket socket){
            this.socket = socket;
        }

       @Override
       public void run() {
           try {
               BufferedReader br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
               BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
               new PrintWriter(new OutputStreamWriter(socket.getOutputStream()));
               while (true){
                   String data = br.readLine();
                   String result = CommandParser.INSTANCE.filterCmd(socket, data);
                   if(result!=null && result.length()>0){
                       bw.write(result);
                       bw.flush();
                   }
//
               }

           } catch (IOException e) {
               e.printStackTrace();
           }
       }


       /**
        * @param data
        */








   }


}
