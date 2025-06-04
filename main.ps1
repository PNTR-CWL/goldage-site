$path = "$env:TEMP\wallpaper.jpg"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/PNTR-CWL/flipper-fakemalware/main/wallpaper.jpg" -OutFile $path

Add-Type -TypeDefinition @"
using System.Runtime.InteropServices;
public class Wallpaper {
  [DllImport("user32.dll", SetLastError = true)]
  public static extern bool SystemParametersInfo(int u, int ui, string pv, int f);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $path, 3)
