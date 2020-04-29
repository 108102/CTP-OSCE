Source: https://www.corelan.be/index.php/2009/09/21/exploit-writing-tutorial-part-6-bypassing-stack-cookies-safeseh-hw-dep-and-aslr/

You can manually change the dynamicbase bit in a compiled library to make it ASLR aware 
(set 0×40 DllCharacteristics in the PE Header 
– you can use a tool such as PE Explorer to open the library & see 
if this DllCharacteristics field contains 0x40 in order to determine whether it is ASLR aware or not).

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
Bypassing ASLR : partial EIP overwrite


ASLR will randomize only part of the address. 
only the high order bytes of an address are randomized. 

When an address is saved in memory, take for example 0x12345678, it is stored like this :
LOW   HIGH
87 65 43 21

When ASLR is enabled, Only “43” and “21” would be randomized. 
Under certain circumstances, this could allow a hacker to exploit / trigger arbitrary code execution.

Scenario:

Gpt EIP? The original saved EIP is placed on the stack by the operating system. 

If ASLR is enabled, the correct ASLR randomized address will be placed on the stack. 
Let’s say saved EIP is 0x12345678 

(where 0x1234 is the randomized part of the address, and 5678 points to the actual saved EIP). 

What if we could find some interesting code (such as jump esp, or something else useful) in the addres space 0x1234XXXX 
(where 1234 is randomized, 


The only thing we could do is try to find something that will do a 
jmp edx or push ebp/ret inside the address range of 0x011eXXXX – 
which is the saved EIP before the BOF occurs), 
and then only overwrite the 2 low bytes of saved EIP instead of overwriting saved EIP entirely. 
In this example, no such instruction exists.

There is a second issue with this example. Even if a usable instruction like that exists,
ou would notice that overwriting the 2 low bytes would not work because when you overwrite the 2 low bytes, 
a string terminator (00 – null bytes) are added, 
overwriting half of the high bytes as well… 
So the exploit would only work if you can find an address that will do the jmp edx/… in the address space 0x011e00XX. 
And that limits us to a maximum of 255 addresses in the 0x011e range 

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
Bypassing ASLR : using an address from a non-ASLR enabled module

A second technique that can be used to bypass ASLR is to find a module that does not randomize addresses.


Bypass ASLR (direct RET overwrite)

In case of a direct RET overwrite, we overwrite EIP after offset 260 , 
and a jmp esp (or call esp or push esp/ret) would do the trick.


ASLR Bypass : SEH based exploits

Find modules that are not aslr protected, find an address that does what you want it to do, and sploit… 
Let’s pretend that we need to bypass safeseh as well, for the phun of it.

Modules without safeseh : (!pvefindaddr nosafeseh)
Modules without safeseh and not ASLR aware : (!pvefindaddr nosafesehaslr)

So a pop pop ret from any of these modules (or, alternatively, a jmp/call dword[reg+nn] would work too)
