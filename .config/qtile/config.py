# Gb's Qtile config UwU
#
# <3

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile import hook

import os
import subprocess

mod = "mod4"
terminal = "alacritty"
browser = os.getenv("BROWSER")
home = os.getenv("HOME")

@hook.subscribe.startup_once
def autostart():
    subprocess.Popen(["picom"])
    subprocess.Popen(["mpd"])
    subprocess.Popen(["/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"])
    subprocess.Popen(["unclutter", "--timeout", "--jitter", "--start-hidden"])
    subprocess.Popen(["luabatmon"])
    subprocess.Popen(["dunst"])
    subprocess.Popen(["feh", "--no-fehbg", "--bg-fill", f"{home}/.config/wallpaper"])


keys = [
    # monadtall
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),

    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

    Key([mod, "shift"], "a", lazy.layout.grow()),
    Key([mod, "shift"], "s", lazy.layout.shrink()),

    # general
    Key([mod], "w", lazy.window.kill()),
    Key([mod, "shift"], "t", lazy.window.toggle_floating()),
    Key([mod, "shift"], "f", lazy.window.toggle_fullscreen()),
    Key([mod, "control"], "r", lazy.reload_config()),
    Key([mod], "space", lazy.widget["keyboardlayout"].next_keyboard()),
    Key([mod], "Tab", lazy.next_layout()),

    Key([mod], "return", lazy.spawn(terminal)),
    Key([mod], "n", lazy.spawn(browser)),
    Key([mod], "m", lazy.spawn(f"{terminal} --class music-panel,music-panel -e ncmpcpp")),
    Key([mod], "s", lazy.spawn(f"{terminal} --class pulse-panel,pulse-panel -e pulsemixer")),
    Key([mod], "c", lazy.spawn(f"{terminal} --class calculator,calculator -e julia")),
    Key([mod], "f", lazy.spawn(f"{terminal} -e lf")),
    Key([mod], "t", lazy.spawn(f"{terminal} -e htop")),
    Key([mod], "p", lazy.spawn("screenshotter")),
    Key([mod, "shift"], "p", lazy.spawn("screenshotter select")),

    # dmenu/rofi
    Key([mod], "a", lazy.spawn("rofi -show run")),
    Key([mod], "q", lazy.spawn("dmenu_shutdown")),
    Key([mod, "control"], "p", lazy.spawn("passmenu --type")),
    Key([mod], "b", lazy.spawn("dmenu_web")),
    Key([mod, "control"], "b", lazy.spawn("dmenu_bluetooth")),
    Key(["mod1", "control"], "d", lazy.spawn("monitors")),

    # audio
    Key(["mod1", "control"], "k", lazy.spawn("pulsemixer --change-volume +1")),
    Key(["mod1", "control"], "j", lazy.spawn("pulsemixer --change-volume -1")),
    Key(["mod1", "control"], "m", lazy.spawn("pulsemixer --toggle-mute")),
    Key(["mod1", "control"], "p", lazy.spawn("mpc toggle")),
    Key(["mod1", "control"], "l", lazy.spawn("mpc next")),
    Key(["mod1", "control"], "h", lazy.spawn("mpc prev")),
    Key(["mod1", "control"], "equal", lazy.spawn("mpc volume +10")),
    Key(["mod1", "control"], "minus", lazy.spawn("mpc volume -10"))
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
            ),
        ]
    )

colors = dict(
    bg="#282a36",
    fg="#f8f8f2",
    magenta="#ff79c6",
    yellow="#f1fa8c",
    cyan="#8be9fd",
    green="#50fa7b",
    red="#ff5555",
    grey="#6272a4"
)

monad_tall_config = dict(
    border_focus=colors["magenta"],
    border_normal=colors["bg"],
    border_width=2,
    margin=10,
    ratio=0.5,
    single_border_width=0,
    single_margin=0,
    new_client_position="top"
)
floating_config = dict(
    border_focus=colors["magenta"],
    border_normal=colors["bg"],
    border_width=2
)
max_config = dict(
    border_width=0,
    margin=0
)

layouts = [
    layout.MonadTall(**monad_tall_config),
    layout.Max()
]

widget_defaults = dict(
    font="Caskaydia Cove Nerd Font",
    fontsize=12,
    background=colors["bg"],
    foreground=colors["fg"],
    margin=0
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                # mpd
                widget.TextBox("󰘧", fontsize=18),
                widget.Mpd2(
                    idle_format="Nothing",
                    no_connection="MPD is",
                    status_format="{artist}",
                    foreground=colors["cyan"]
                ),
                widget.Mpd2(
                    idle_format="playing",
                    no_connection="not running",
                    status_format="{title}",
                    foreground=colors["magenta"]
                ),
                widget.Mpd2(
                    idle_format="",
                    no_connection="",
                    status_format="{play_status}",
                ),
                widget.Spacer(),
                # sys
                widget.KeyboardLayout(
                    foreground=colors["green"],
                    configured_keyboards=["us", "br"],
                    display_map={"us": "American", "br": "Brazilian"},
                    fmt="Latin flavour: {}"
                ),
                widget.Memory(
                    foreground=colors["yellow"],
                    format="Chaos: {MemUsed:.0f} Mb"
                ),
                widget.DF(
                    foreground=colors["cyan"],
                    format="Animes: {f}/{s} Gb",
                    visible_on_warn=False
                ),
                widget.ThermalZone(
                    format="Coffee: {temp}.0 ºC",
                    format_crit="Coffee: {temp}.0 ºC TOO HOT!",
                    fgcolor_normal=colors["magenta"],
                    fgcolor_high=colors["yellow"],
                    fgcolor_crit=colors["red"],
                ),
                widget.Battery(
                    battery=1,
                    foreground=colors["cyan"],
                    low_foreground=colors["red"],
                    low_percentage=0.2,
                    show_short_text=False,
                    format="Sleep: {percent:2.0%}"
                ),
                widget.TextBox("|", foreground=colors["grey"]),
                # clock
                widget.Clock(
                    format="%a %b %d",
                    foreground=colors["red"]
                ),
                widget.Clock(
                    format="%H:%M",
                    foreground=colors["yellow"]
                )
            ],
            18,
            background=colors["bg"]
        ),
        bottom=bar.Bar(
            [
                widget.GroupBox(
                    this_current_screen_border=colors["magenta"],
                    margin_y=3
                ),
                widget.TaskList(
                    highlight_method="block",
                    markup=True,
                    markup_focused='<span foreground="#282a36">{}</span>',
                    icon_size=11,
                    border=colors["magenta"]
                ),
                widget.Spacer(),
                widget.Systray(icon_size=11)
            ],
            18,
            background=colors["bg"]
        ),
    )
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start = lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start = lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules  = []  # type: list
follow_mouse_focus = True
bring_front_click  = False
cursor_warp        = False
floating_layout    = layout.Floating(
    float_rules = [
        *layout.Floating.default_float_rules,
        Match(title    = "pinentry"),
        Match(title    = "Open File"),
        Match(wm_class = "feh"),
        Match(wm_class = "Gimp"),
        Match(wm_class = "Xfce-polkit"),
        Match(wm_class = "calculator"),
        Match(wm_class = "music-panel"),
        Match(wm_class = "pulse-panel"),
        Match(wm_class = "QjackCtl"),
        Match(wm_class = "Guitarix"),
        Match(wm_class = "MPlayer"),
        Match(wm_class = "mpv")
    ], **floating_config
)
auto_fullscreen            = True
focus_on_window_activation = "smart"
reconfigure_screens        = True
auto_minimize              = False
wmname = "Kawaii Desu Gb's Qute Window Manager"
