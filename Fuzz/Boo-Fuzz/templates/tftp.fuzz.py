#!/usr/bin/env python

from boofuzz import *

def main():
    session = Session(
        target=Target(
            connection=SocketConnection("IP", 69, proto='udp')),sleep_time = 3)

    s_initialize("Request")
    s_binary("0002")
    s_string("filename.txt", fuzzable=True)
    s_binary("00")
    s_string("netascii", fuzzable=True)
    s_binary("00")
    
    session.connect(s_get("Request"))
    session.fuzz()
   
if __name__ == "__main__":
    main()
