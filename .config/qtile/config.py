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

@lazy.window.function
def resize_floating_window(window, width=0, height=0):
    window.cmd_set_size_floating(window.width + width, window.height + height)


@lazy.window.function
def move_floating_window(window, x=0, y=0):
    window.cmd_set_position_floating(window.float_x + x, window.float_y + y)


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
    Key([mod], "h", lazy.layout.shrink_main()),
    Key([mod], "l", lazy.layout.grow_main()),
    Key([mod], "j", lazy.group.next_window()),
    Key([mod], "k", lazy.group.prev_window()),

    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

    Key([mod, "control"], "h", move_floating_window(x=-20)),
    Key([mod, "control"], "l", move_floating_window(x=20)),
    Key([mod, "control"], "j", move_floating_window(y=20)),
    Key([mod, "control"], "k", move_floating_window(y=-20)),

    Key([mod, "mod1"], "h", resize_floating_window(width=-20)),
    Key([mod, "mod1"], "l", resize_floating_window(width=20)),
    Key([mod, "mod1"], "j", resize_floating_window(height=20)),
    Key([mod, "mod1"], "k", resize_floating_window(height=-20)),

    # general
    Key([mod], "w", lazy.window.kill()),
    Key([mod, "shift"], "t", lazy.window.toggle_floating()),
    Key([mod, "shift"], "f", lazy.window.toggle_fullscreen()),
    Key([mod, "control"], "r", lazy.reload_config()),
    Key([mod, "control"], "c", lazy.spawn("dunstctl close")),
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
    fontsize=14,
    background=colors["bg"],
    foreground=colors["fg"],
    margin=0
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    this_current_screen_border=colors["magenta"],
                    inactive=colors["fg"],
                    margin_y=2,
                    hide_unused=True
                ),
                widget.TextBox("|", foreground=colors["grey"]),
                widget.TaskList(
                    highlight_method="block",
                    markup=True,
                    max_title_width=120,
                    margin_y=2,
                    icon_size=16,
                    markup_focused='<span foreground="#282a36">{}</span>',
                    border=colors["magenta"]
                ),
                widget.Spacer(),
                # mpd
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
                widget.TextBox("|", foreground=colors["grey"]),
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
                    foreground=colors["green"],
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
            28,
            background=colors["bg"],
            opacity=0.95,
        )
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
        Match(title    = "Open File"),
        Match(wm_class = "pinentry-gtk-2"),
        Match(wm_class = "Pinentry-gtk-2"),
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
