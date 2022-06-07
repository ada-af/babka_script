import osproc
import terminal
import strformat

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
echo ansiResetCode

if l == hosts.len:
    stdout.setForegroundColor(fgCyan)
    echo fmt"{l}/{hosts.len} проверок успешны"
    stdout.setForegroundColor(fgGreen)
    echo "Интернет работает"
if (0 < l) and (l < hosts.len):
    stdout.setForegroundColor(fgCyan)
    echo fmt"{l}/{hosts.len} проверок успешны"
    stdout.setForegroundColor(fgYellow)
    echo "Интернет работает с проблемами"
if l == 0:
    stdout.setForegroundColor(fgRed)
    echo fmt"{l}/{hosts.len} проверок успешны"
    echo "Интернет не работает"
echo ansiResetCode
echo "Нажмите любую клавишу для продолжения..."
discard getch()