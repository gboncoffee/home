-- 
-- Gabriel G. de Brito's functional Xmonad configs
--

-- LIBS {{{
import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.ManageHook

import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor

import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ShowWName

-- Layout modifiers
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import qualified XMonad.Layout.MultiToggle as MT
import qualified XMonad.Layout.Magnifier as MG

import XMonad.Actions.DwmPromote
import XMonad.Actions.FloatKeys
import XMonad.Actions.GridSelect

import Colors
-- }}}

-- VARIABLES {{{
--

colorBack   = colorbg
colorFore   = color5

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myTerminal = "alacritty"

myBorderWidth   = 4
myModMask       = mod4Mask
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
myNormalBorderColor  = colorBack
myFocusedBorderColor = colorFore

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                colorbg_grid
                colorbg_grid
                colorsl_grid
                colorfg_grid
                colorbg_grid

myGridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 400
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = "xft:Delugia:Medium:size=23"
    , gs_bordercolor  = colorBack
    }

-- WINDOW RULES {{{
--

myManageHook = composeAll
    [ className =? "MPlayer"          --> doFullFloat
    , className =? "mpv"              --> doFullFloat
    , className =? "Gimp"             --> doCenterFloat 
    , className =? "Gnome-screenshot" --> doCenterFloat
    , className =? "Xfce-polkit"      --> doCenterFloat
    , className =? "Dunst"            --> doIgnore
    , className =? "Conky"            --> doIgnore
    , className =? "calculator"       --> doCenterFloat
    , className =? "music-panel"      --> doCenterFloat
    ]

-- }}}

-- }}}

-- KEY BINDS {{{
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_a     ), spawn "rofi -show run")

    -- close focused window
    , ((modm,               xK_w     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm .|. shiftMask, xK_r     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), dwmpromote)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm .|. shiftMask, xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm .|. shiftMask, xK_h     ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm .|. shiftMask, xK_l     ), sendMessage (IncMasterN (-1)))

    -- Quit xmonad
    , ((modm .|. controlMask, xK_q   ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. controlMask, xK_r   ), spawn "xmonad --recompile; xmonad --restart")

    -- Float windows resizing
    , ((modm .|. controlMask, xK_l     ), withFocused (keysResizeWindow (30,0) (0,0)))
    , ((modm .|. controlMask, xK_h     ), withFocused (keysResizeWindow (-30,0) (0,0)))
    , ((modm .|. controlMask, xK_j     ), withFocused (keysResizeWindow (0,30) (0,0)))
    , ((modm .|. controlMask, xK_k     ), withFocused (keysResizeWindow (0,-30) (0,0)))
    -- Float windows moving
    , ((modm .|. mod1Mask,    xK_l     ), withFocused $ keysMoveWindow (30, 0))
    , ((modm .|. mod1Mask,    xK_h     ), withFocused $ keysMoveWindow (-30, 0))
    , ((modm .|. mod1Mask,    xK_j     ), withFocused $ keysMoveWindow (0, 30))
    , ((modm .|. mod1Mask,    xK_k     ), withFocused $ keysMoveWindow (0, -30))

    -- Window size stuff
    , ((modm .|. shiftMask,   xK_minus ), sendMessage (MT.Toggle NBFULL))

    -- Window grid
    , ((modm,               xK_Tab   ), goToSelected $ myGridConfig myColorizer)
    , ((modm .|. shiftMask, xK_Tab   ), bringSelected $ myGridConfig myColorizer)

    --
    -- GENERAL
    --

    -- progs
    , ((modm,               xK_n), spawn "$BROWSER")
    , ((modm,               xK_m), spawn (myTerminal ++ " --class music-panel,music-panel -e ncmpcpp"))
    , ((modm,               xK_s), spawn (myTerminal ++ " -t 'Sys Monitor' -e btm"))
    , ((modm,               xK_f), spawn (myTerminal ++ " -t Lf -e lf"))
    , ((modm,               xK_c), spawn (myTerminal ++ " -t Calculator --class calculator,calculator -e julia"))
    , ((modm,               xK_p), spawn "gnome-screenshot -i")

    -- dmenu
    , ((modm .|. controlMask, xK_p), spawn "passmenu --type")
    , ((modm,                 xK_q), spawn "dmenu_shutdown")
    , ((modm,                 xK_b), spawn "dmenu_web")
    , ((modm .|. controlMask, xK_t), spawn "dmenu_themes")

    -- audio
    , ((mod1Mask .|. controlMask, xK_k),     spawn "pulsevolume --increase")
    , ((mod1Mask .|. controlMask, xK_j),     spawn "pulsevolume --decrease")
    , ((mod1Mask .|. controlMask, xK_m),     spawn "pulsevolume --mute")
    , ((mod1Mask .|. controlMask, xK_p),     spawn "mpc toggle")
    , ((mod1Mask .|. controlMask, xK_l),     spawn "mpc next")
    , ((mod1Mask .|. controlMask, xK_h),     spawn "mpc prev")
    , ((mod1Mask .|. controlMask, xK_equal), spawn "mpc volume +10")
    , ((mod1Mask .|. controlMask, xK_minus), spawn "mpc volume -10")

    -- etc
    , ((mod1Mask .|. controlMask, xK_x), spawn "changexmap")
    , ((mod1Mask .|. controlMask, xK_d), spawn "monitors")
    , ((modm     .|. controlMask, xK_c), spawn "dunstctl close")
    , ((modm     .|. controlMask, xK_b), spawn "dmenu_bluetooth")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_comma, xK_period, xK_slash] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- }}}

-- LAYOUTS {{{
--

myLayout = id
    . smartBorders
    . MT.mkToggle (MT.single NBFULL)
      $ MG.magnifier tiled
    ||| tiled
    where
        -- default tilling
        tiled   = Tall nmaster delta ratio
        nmaster = 1
        ratio   = 1/2
        delta   = 3/100
-- }}}

-- EVENT HANDLING {{{
--

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Delugia:Bold:size=70"
    , swn_fade              = 0.3
    , swn_bgcolor           = colorbg
    , swn_color             = color5
    }

myLogHook = showWNameLogHook myShowWNameTheme

myStartupHook :: X ()
myStartupHook = do
    setDefaultCursor xC_left_ptr
    spawnOnce "feh --no-fehbg --bg-fill ~/.config/wallpaper"
    spawnOnce "conky"
    spawnOnce "killall mpd 2> /dev/null ; mpd"
    spawnOnce "killall tasks 2> /dev/null ; tasks"
    spawnOnce "picom"
    spawnOnce "unclutter --start-hidden --jitter 10 --ignore-scrolling"
    spawnOnce "/usr/lib/xfce-polkit/xfce-polkit"
    spawnOnce "killall batterymon 2> /dev/null ; batterymon"
    spawnOnce "dunst"
    spawnOnce "notify-send --expire-time=3000 \"Welcome back, $USER\""

-- }}}

-- ETC {{{

-- Run xmonad
main = xmonad $ ewmhFullscreen . ewmh $ defaults

-- structure with config
defaults = def {
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    keys               = myKeys,

    layoutHook         = myLayout,
    manageHook         = myManageHook,
    handleEventHook    = handleEventHook def,
    logHook            = myLogHook,
    startupHook        = myStartupHook
}
-- }}}
