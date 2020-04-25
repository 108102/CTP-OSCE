#!/usr/bin/env python
from boofuzz import *
def receive_banner(socket):
    socket.recv(1024)
def main():
    s_initialize("user")
    s_static("USER")
    s_static(" ")
    s_group("user", ['user'])
    #s_string("anonymous")
    s_static("\r\n")
    s_initialize("pass")
    s_static("PASS")
    s_static(" ")
    s_group("pass", ['password'])
    #s_string("password")
    s_static("\r\n")
    s_initialize("stor")
    s_static("STOR")
    s_static(" ")
    s_group("stor", ['A1'])
    #s_string("A1")
    s_static("\r\n")
    s_initialize("retr")
    s_static("RETR")
    s_static(" ")
    s_group("retr", ['A2'])
    #s_string("A2")
    s_static("\r\n")
    my_session = sessions.Session(sleep_time=0.2,session_filename='ftpfuzzing') 
    my_connection = SocketConnection("192.168.1.23", 21, proto='tcp')
    my_target = sessions.Target(my_connection)
    my_session.add_target(my_target)
    my_session.pre_send = receive_banner
    my_session.connect(s_get("user")) # fuzz user def
    my_session.connect(s_get("user"), s_get("pass")) # send message with normal user field and muatate password def
    my_session.connect(s_get("pass"), s_get("stor")) # send messages with normal user field and password field and muatate Stor def
    my_session.connect(s_get("pass"), s_get("retr")) # send messages with normal user field and password field and muatate Retr def
    my_session.fuzz()
if __name__ == "__main__":
    main()
