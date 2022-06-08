import osproc
import terminal
import strformat
import net
import random

proc ping(host: string): bool =
    var cmd: string
    if hostOS == "windows":
        cmd = "ping -n 1 -w 2000 " & host
    else:
        cmd = "ping -c 1 " & host
    let (output, exitcode) = execCmdEx(cmd)
    result = not ((bool)exitcode)

const hosts = ["1.1.1.1", "8.8.8.8", "77.88.8.8", "ya.ru", "vk.com", "google.com"]

stdout.setForegroundColor(fgCyan)
terminal.writeStyled("Программа работает, подождите\n\n", {styleBright})

var l: int = 0
stdout.setStyle({styleDim})
for i in hosts:
    if ping(i):
        stdout.setForegroundColor(fgGreen)
        echo i & ": Успешно"
        l.inc
    else:
        stdout.setForegroundColor(fgRed)
        echo i & ": Ошибка"
stdout.setForegroundColor(fgWhite)
var internet_status: string

if l == hosts.len:
    stdout.setForegroundColor(fgCyan)
    echo fmt"{l}/{hosts.len} проверок успешны"
    stdout.setForegroundColor(fgGreen)
    echo """


   ____  _  __
  / __ \| |/ /
 | |  | | ' / 
 | |  | |  <  
 | |__| | . \ 
  \____/|_|\_\
              
              


    """
    internet_status = "Интернет работает"
if (0 < l) and (l < hosts.len):

    stdout.setForegroundColor(fgCyan)
    echo fmt"{l}/{hosts.len} проверок успешны"
    stdout.setForegroundColor(fgYellow)
    echo """
    

 __          __     _____  _   _ 
 \ \        / /\   |  __ \| \ | |
  \ \  /\  / /  \  | |__) |  \| |
   \ \/  \/ / /\ \ |  _  /| . ` |
    \  /\  / ____ \| | \ \| |\  |
     \/  \/_/    \_\_|  \_\_| \_|
                                 
                                 


    """
    internet_status = "Интернет работает с проблемами"

if l == 0:
    stdout.setForegroundColor(fgRed)
    echo """

  ______ _____  _____  
 |  ____|  __ \|  __ \ 
 | |__  | |__) | |__) |
 |  __| |  _  /|  _  / 
 | |____| | \ \| | \ \ 
 |______|_|  \_\_|  \_\
                       
                       

    """
    echo fmt"{l}/{hosts.len} проверок успешны"
    internet_status = "Интернет не работает"
stdout.setForegroundColor(fgWhite)

let socket = newSocket()
randomize()
let p_num = rand(40000..50000).int
socket.bindAddr(Port(p_num), "127.0.0.1")
socket.listen()

# echo fmt"Listens on port {p_num}"

var html_c:string = fmt"""
<html>
<body>
<h1>{internet_status}</h1>
</body>
</html>
"""

if hostOS == "windows":
    discard execCmd(fmt"explorer.exe http://localhost:{p_num}/")
else:
    discard execCmd(fmt"xdg-open http://localhost:{p_num}/")

# You can then begin accepting connections using the `accept` procedure.
var client: Socket
var address = ""
socket.acceptAddr(client, address)

var data: auto = " "
data = client.recv(16)

client.send("HTTP/1.1 200 OK\nContent-Type: text/html; charset=utf-8\n\n")
client.send(html_c)
client.close()
socket.close()

discard getch()
