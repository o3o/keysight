import std.socket, std.stdio;
import core.time: dur;
void main(string[] args) {
   if (args.length > 1) {
      switch (args[1]) {
         case "1":
            fun1();
            break;
         case "2":
            fun2();
            break;
         case "3":
            fun3();
            break;
         default:
            writeln("Invalid args ", args[1]);
            break;
      }
   }  else {
      writeln("No args");
   }
}

void fun1() {
   writeln("=== fun1 sendTo receiveFrom");

   Address addr = parseAddress("192.168.72.3", 5025);
   auto sock = new TcpSocket(addr);
   //auto sock = new TcpSocket();
   sock.setOption(SocketOptionLevel.SOCKET, SocketOption.RCVTIMEO, dur!"msecs"(2000));

   char[2048] buffer;
   foreach(line; stdin.byLine) {
      writeln("send ", line);

      sock.sendTo(line ~ '\n', addr);
      long len = sock.receiveFrom(buffer, addr);
      if (len > 0) {
         writeln("Server said: ", buffer[0 .. len]);
      } else {
         writeln("TIMEOUT");
      }
   }
}

void fun2() {
   writeln("=== fun2 send receive  (A. Ruppe) ===");
   auto socket = new Socket(AddressFamily.INET,  SocketType.STREAM);
   char[2048] buffer;
   socket.connect(new InternetAddress("192.168.72.3", 5025));
   socket.setOption(SocketOptionLevel.SOCKET, SocketOption.RCVTIMEO, dur!"msecs"(2000));

   foreach(line; stdin.byLine) {
      writeln("send ", line);

      socket.send(line ~ '\n');
      long len = socket.receive(buffer);
      if (len > 0) {
         writeln("Server said: ", buffer[0 .. len]);
      } else {
         writeln("TIMEOUT");
      }
   }
}

void fun3() {
   writeln("=== fun3 send receive (A. Ruppe)  + TcpSocket ===");
   Address addr = parseAddress("192.168.72.3", 5025);
   auto socket = new TcpSocket(addr);
   char[2048] buffer;
   socket.setOption(SocketOptionLevel.SOCKET, SocketOption.RCVTIMEO, dur!"msecs"(2000));

   foreach(line; stdin.byLine) {
      writeln("send ", line);

      socket.send(line ~ '\n');
      long len = socket.receive(buffer);
      if (len > 0) {
         writeln("Server said: ", buffer[0 .. len]);
      } else {
         writeln("TIMEOUT");
      }
   }
}
