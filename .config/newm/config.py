from __future__ import annotations
from typing import Callable, Any

import os
import pwd
import time
import logging
from newm.interpolation import Interpolation

from newm.layout import Layout
from newm.helper import BacklightManager, WobRunner, PaCtl

from pywm import (
    PYWM_MOD_LOGO,
    PYWM_MOD_ALT
)

logger = logging.getLogger(__name__)

##################################################
### Appearance Settings
##################################################

### Background
background = {
    'path': os.path.expanduser('~/Bilder/Hintergründe/DraculaWallpapers/wallpaper-master/arch.png'),
    'anim': True
}

### Window specific rules called in view.rules
def rules(view):
    common_rules = {"float": True, "float_size": (1280, 720), "float_pos": (0.5, 0.5)}
    float_apps = ("pavucontrol", "blueman-manager", "qalculate-gtk") #applications that I want to define as floating
    blur_apps = ("alacritty", "rofi", "waybar") # applications in which I want to have the blur effect
    opacity_apps = ("pavucontrol")
    if view.app_id in float_apps:
        return common_rules
    if view.app_id in blur_apps:
        return {"blur": {"radius": 6, "passes": 4}}
    if view.app_id in opacity_apps:
        return {"opacity": 0.8}
    if view.app_id == "lutris" and view.title == "Lade Datei herunter":
        return common_rules
    ## uncommon configs
    # 
    ## Get App stats
    os.system( f"echo '{view.app_id}, {view.title}, {view.role}' >> ~/.config/newm/apps")
    return None

view = {
    ## Window rules defined above
    'rules': rules,
    ## rounded edges
    'corner_radius': 0,
    ## Gaps
    'padding': 10,
    'fullscreen_padding': 0,
    ## Decorations for floating windows
    'ssd': {
        'enabled': True,
        'width': 2
        },
    ## Opacity, blur and floating settings
    # 'rules': lambda: view: {
    #         'opacity': 0.8,
    #         'blur':4
    #     }
    ## When window sets itself to fullscreen (e.g. YouTube fullscreen), set it to fullscreen (True) or leave it in it's tile
    'accept_fullscreen': False,
    ## Let client know when its set to Fullscreen, e.g. Firefox will hide status bar when toggle_fullscreen is called
    'send_fullscreen': False,
}

### Window Focus (Border) settings
focus = {
    # 'enabled': True,
    'color': '#bd93f9',
    'width': 4,
    'distance': 4,
    ## Window Border Animation when focus changes
    # 'animate_on_change': True,
    # 'anim_time': 0.1,
}

### Animation Time
anim_time = .2

interpolation = {
        # 'size_adjustment': .1,
        }

outputs = [
    { 'name': 'eDP-1' , 'pos_x': 0, 'pos_y': 1080},
    { 'name': 'virt-1', 'pos_x': 0, 'pos_y': 1920, 'width': 1280, 'height': 720 },
    { 'name': 'HDMI-A-1', 'pos_x': 0, 'pos_y': 0}
]

pywm = {
    ## XWayland
    "enable_xwayland": True,
    ## Client Side Decorations (e.g. Firefox Title Bar)
    "encourage_csd": False,
    ## Keyboard Layout, check availabile options with $ less /usr/share/X11/xkb/rules/base.lst
    "xkb_layout": "de",
    "xkb_variant": "us"
}

def on_startup():
    os.system("systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    os.system("hash dbus-update-activation-environment 2>/dev/null && \
        dbus-update-activation-environment --systemd DISPLAY \
        WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    # os.system("waybar &")

# def on_reconfigure():
    # os.system("killall waybar")

# wob_runner = WobRunner("wob -a bottom -M 100")
wob_option = {
    "border": 2,
    "anchor": "top",
    "margin": 100,
    "border-color": "#94E2D5FF",
    "background-color": "#1E1E2EFF",
    "bar-color": "#A6E3A1FF",
    "overflow-border-color": "#F5C2E7FF",
    "overflow-background-color": "#1E1E2EFF",
    "overflow-bar-color": "#F38BA8FF",
}
wob_args = " ".join((f"--{k} {v}" for (k, v) in wob_option.items()))
wob_runner = WobRunner(f"wob {wob_args}")
backlight_manager = BacklightManager(anim_time=1., bar_display=wob_runner)
# kbdlight_manager = BacklightManager(args="--device='*::kbd_backlight'", anim_time=1., bar_display=wob_runner)
def synchronous_update() -> None:
    backlight_manager.update()
    # kbdlight_manager.update()

pactl = PaCtl(0, wob_runner)

def key_bindings(layout: Layout) -> list[tuple[str, Callable[[], Any]]]:
    return [
        ("L-h", lambda: layout.move(-1, 0)),
        ("L-j", lambda: layout.move(0, 1)),
        ("L-k", lambda: layout.move(0, -1)),
        ("L-l", lambda: layout.move(1, 0)),
        ("L-u", lambda: layout.basic_scale(1)),
        ("L-n", lambda: layout.basic_scale(-1)),
        ("L-t", lambda: layout.move_in_stack(1)),

        ("L-H", lambda: layout.move_focused_view(-1, 0)),
        ("L-J", lambda: layout.move_focused_view(0, 1)),
        ("L-K", lambda: layout.move_focused_view(0, -1)),
        ("L-L", lambda: layout.move_focused_view(1, 0)),

        ("L-C-h", lambda: layout.resize_focused_view(-1, 0)),
        ("L-C-j", lambda: layout.resize_focused_view(0, 1)),
        ("L-C-k", lambda: layout.resize_focused_view(0, -1)),
        ("L-C-l", lambda: layout.resize_focused_view(1, 0)),

        ("L-Return", lambda: os.system("alacritty &")),
        ("L-q", lambda: layout.close_focused_view()),

        ("L-p", lambda: layout.ensure_locked(dim=True)),
        ("L-P", lambda: layout.terminate()),
        ("L-C", lambda: layout.update_config()),

        ("L-F", lambda: layout.toggle_fullscreen()),
        ("L-f", lambda: layout.toggle_focused_view_floating()),

        ("L-", lambda: layout.toggle_overview()),

        # ("L-r", lambda: os.system("bash ~/.config/rofi/launchers/type-3/launcher.sh &")),
        ("L-r", lambda: os.system("rofi -show drun &")),

        ("XF86MonBrightnessUp", lambda: backlight_manager.set(backlight_manager.get() + 0.1)),
        ("XF86MonBrightnessDown", lambda: backlight_manager.set(backlight_manager.get() - 0.1)),
        # ("XF86KbdBrightnessUp", lambda: kbdlight_manager.set(kbdlight_manager.get() + 0.1)),
        # ("XF86KbdBrightnessDown", lambda: kbdlight_manager.set(kbdlight_manager.get() - 0.1)),
        ("XF86AudioRaiseVolume", lambda: pactl.volume_adj(5)),
        ("XF86AudioLowerVolume", lambda: pactl.volume_adj(-5)),
        ("XF86AudioMute", lambda: pactl.mute()),

        # Warpd key_bindings
        ("L-x", lambda: os.system("warpd --normal &")),

    ]

# bar = {'enabled': False}

grid = {
    'throw_ps': [2, 10]
}

panels = {
    'lock': {
        'cmd': 'alacritty -e newm-panel-basic lock',
    },
    # 'launcher': {
    #     'cmd': './.config/rofi/launchers/type-3/launcher.sh'
    # },
    'top_bar': {
        "cmd": "waybar",
        # "enabled": False,
        # "visible_normal": False,
        # "visible_fullscreen": False,

        }
    # 'top_bar': {
    #     'native': {
    #         'enabled': True,
    #         'texts': lambda: [
    #             pwd.getpwuid(os.getuid())[0],
    #             time.strftime("%c"),
    #         ],
    #     }
    # },
}

energy = {
    'idle_callback': backlight_manager.callback,
    'idle_times': [300, 600, 900]
}
