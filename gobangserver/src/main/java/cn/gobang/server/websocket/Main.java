package cn.gobang.server.websocket;

import java.util.ArrayList;
import java.util.List;

public class Main {

    public static void main(String[] args) {
        ServerSocket serverSocket = new ServerSocket(9893);
        serverSocket.start();
//        OOMException();

    }

    private static void OOMException(){
        int i = 0 ;
        try {
            List list = new ArrayList();
            String str = "str";
            for(i = 0;i < Integer.MAX_VALUE;i++) {
                String temp = str + i;
                str = temp;
                list.add(temp.intern());
            }
        }catch (OutOfMemoryError error){
            System.out.println("i = " + i);
            throw  error;
        }

    }

    public static void test(){
        //-(7.5^2 + 7.5^2) = -112.5
        double max = 0 ;
        for(int x = 0 ; x <= 15 ; x ++){
            for(int y = 0; y <=15 ;y++){
                double z = -(Math.pow(x - 7.5 ,2) + Math.pow(y - 7.5 ,2)) + 112.5 ;
                max = z > max ? z : max;
                System.out.println("("+ x +"," + y + ") = " + z);
            }
        }
        System.out.println("max = " + max);
    }
}
