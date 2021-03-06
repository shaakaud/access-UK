#WindowsBalloonTip/Tray Tip - Run this program in Windows machine which has python3 and  win32 extension libraries (viz. pywin32-219.win32-py3.4.exe) installed
import socket
import sys
import os
try:
  import win32api
except ImportError:
  print("Import error")
  print("My version:%s"%sys.version)
  print("My sys.path is :%s"%sys.path)
  print("My environ.path is :%s"%os.environ['PATH'])
  a=input("press a key to conitinue")

# -- coding: utf-8 --

from win32api import *
from win32gui import *
import win32con
import sys, os
import struct
import time

# Class
class WindowsBalloonTip:
    def __init__(self, title, msg):
        message_map = { win32con.WM_DESTROY: self.OnDestroy,}

        # Register the window class.
        wc = WNDCLASS()
        hinst = wc.hInstance = GetModuleHandle(None)
        wc.lpszClassName = 'PythonTaskbar'
        wc.lpfnWndProc = message_map # could also specify a wndproc.
        classAtom = RegisterClass(wc)

        # Create the window.
        style = win32con.WS_OVERLAPPED | win32con.WS_SYSMENU
        self.hwnd = CreateWindow(classAtom, "Taskbar", style, 0, 0, win32con.CW_USEDEFAULT, win32con.CW_USEDEFAULT, 0, 0, hinst, None)
        UpdateWindow(self.hwnd)

        # Icons managment
        iconPathName = os.path.abspath(os.path.join( sys.path[0], 'balloontip.ico' ))
        icon_flags = win32con.LR_LOADFROMFILE | win32con.LR_DEFAULTSIZE
        try:
            hicon = LoadImage(hinst, iconPathName, win32con.IMAGE_ICON, 0, 0, icon_flags)
        except:
            hicon = LoadIcon(0, win32con.IDI_APPLICATION)
        flags = NIF_ICON | NIF_MESSAGE | NIF_TIP
        nid = (self.hwnd, 0, flags, win32con.WM_USER+20, hicon, 'Tooltip')

        # Notify
        Shell_NotifyIcon(NIM_ADD, nid)
        Shell_NotifyIcon(NIM_MODIFY, (self.hwnd, 0, NIF_INFO, win32con.WM_USER+20, hicon, 'Balloon Tooltip', msg, 200, title))
        # self.show_balloon(title, msg)
        time.sleep(5)

        # Destroy
        DestroyWindow(self.hwnd)
        classAtom = UnregisterClass(classAtom, hinst)
    def OnDestroy(self, hwnd, msg, wparam, lparam):
        nid = (self.hwnd, 0)
        Shell_NotifyIcon(NIM_DELETE, nid)
        PostQuitMessage(0) # Terminate the app.

# Function
def balloon_tip(title, msg):
    w=WindowsBalloonTip(title, msg)

# Main
if __name__ == '__main__':
    #UDP_IP = "135.227.232.98"   # host ip - Change if windows ip changes
    UDP_IP = "ukwindows.ddns.net"   # host ip
    UDP_PORT = 36000     # port chosen

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((UDP_IP, UDP_PORT))

    while True:
      data, addr = sock.recvfrom(1024)
      udata = data.decode('utf-8','ignore')
      print("Received:%s"%udata)
      balloon_tip("Centos Notification",udata)
