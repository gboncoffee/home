import XMonad
import Data.Monoid
import System.Exit

import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor

import XMonad.Actions.CycleRecentWS
import XMonad.Actions.DwmPromote
import XMonad.Actions.FloatKeys

import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ShowWName
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog

import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Renamed

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import qualified XMonad.DBus as D

myPink   = "#ff79c6"
myBlue   = "#bd93f9"
myCyan   = "#8be9fd"
myRed    = "#ff5555"
myGray   = "#44475a"
myYellow = "#f1fa8c"
myGreen  = "#50fa7b"
myBg     = "#282a36"
myFg     = "#f8f8f2"

myTerminal           = "st"
myBorderWidth        = 3
myModMask            = mod4Mask
myWorkspaces         = ["dev","web","doc","mat","sys","vid","mail","net","chat"]
myNormalBorderColor  = myBg
myFocusedBorderColor = myBlue

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- applications
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm, xK_n),      spawn "firefox")
    , ((modm, xK_e),      spawn "thunderbird")
    , ((modm, xK_c),      spawn $ myTerminal ++ " -c floating -e python")
    , ((modm, xK_s),      spawn $ myTerminal ++ " -c floating -e pulsemixer")
    , ((modm, xK_m),      spawn $ myTerminal ++ " -c floating -e ncmpcpp")
    , ((modm, xK_f),      spawn $ myTerminal ++ " -e nnn")

    , ((modm,                 xK_p), spawn "flameshot gui")
    , ((modm .|. controlMask, xK_c), spawn "dunstctl close")

    -- dmenu
    , ((modm,                 xK_a), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    , ((modm,                 xK_b), spawn "dmenu_web")
    , ((modm .|. controlMask, xK_b), spawn "dmenu_bluetooth")
    , ((modm .|. controlMask, xK_d), spawn "monitors")
    , ((modm .|. controlMask, xK_p), spawn "passmenu")
    , ((modm,                 xK_q), spawn "dmenu_shutdown")

    -- audio
    , ((mod1Mask .|. controlMask, xK_k), spawn "pulsemixer --change-volume +1")
    , ((mod1Mask .|. controlMask, xK_j), spawn "pulsemixer --change-volume -1")
    , ((mod1Mask .|. controlMask, xK_m), spawn "pulsemixer --toggle-mute")
    , ((mod1Mask .|. controlMask, xK_m), spawn "pulsemixer --toggle-mute")
    , ((mod1Mask .|. controlMask, xK_l), spawn "mpc next")
    , ((mod1Mask .|. controlMask, xK_h), spawn "mpc prev")
    , ((mod1Mask .|. controlMask, xK_p), spawn "mpc toggle")

    --
    -- window management
    --
    , ((modm,               xK_w), kill)
    , ((modm .|. shiftMask, xK_t), withFocused $ windows . W.sink)

    -- focus
    , ((modm,               xK_j),      windows W.focusDown)
    , ((modm,               xK_k),      windows W.focusUp)
    , ((modm .|. shiftMask, xK_Return), dwmpromote)
    , ((modm .|. shiftMask, xK_j),      windows W.swapDown)
    , ((modm .|. shiftMask, xK_k),      windows W.swapUp)

    -- layout
    , ((modm,               xK_h),     sendMessage Shrink)
    , ((modm,               xK_l),     sendMessage Expand)
    , ((modm,               xK_space), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_h),     sendMessage (IncMasterN 1))
    , ((modm .|. shiftMask, xK_l),     sendMessage (IncMasterN (-1)))
    , ((modm .|. shiftMask, xK_b),     sendMessage ToggleStruts)

    -- float keys
    , ((modm,               xK_Left),  withFocused $ keysMoveWindow ((-10), 0))
    , ((modm,               xK_Right), withFocused $ keysMoveWindow   (10,  0))
    , ((modm,               xK_Down),  withFocused $ keysMoveWindow   (0,  10))
    , ((modm,               xK_Up),    withFocused $ keysMoveWindow   (0,(-10)))
    , ((modm .|. shiftMask, xK_Left),  withFocused $ keysResizeWindow ((-10),0) (1/2,1/2))
    , ((modm .|. shiftMask, xK_Right), withFocused $ keysResizeWindow (10,0)    (1/2,1/2))
    , ((modm .|. shiftMask, xK_Down),  withFocused $ keysResizeWindow (0,(-10)) (1/2,1/2))
    , ((modm .|. shiftMask, xK_Up),    withFocused $ keysResizeWindow (0,10)    (1/2,1/2))

    , ((modm, xK_Tab), cycleRecentNonEmptyWS [xK_Super_L] xK_Tab xK_grave)

    , ((modm .|. shiftMask, xK_r), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++
    -- workspace binds
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

myLayout = avoidStruts $ renamed [CutWordsLeft 1] $ smartBorders $ smartSpacing 7 $ tiled ||| full
  where
    tiled   = renamed [Replace "[]="] $ Tall 1 (3/100) (1/2)
    full    = renamed [Replace "[M]"] $ Full

myManageHook = composeAll
    [ className =? "MPlayer"        --> doCenterFloat
    , className =? "vlc"            --> doCenterFloat
    , className =? "Gimp"           --> doCenterFloat
    , className =? "floating"       --> doCenterFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

myEventHook = mempty

myDbus dbus = def
    { ppOutput = D.send dbus
    , ppCurrent = wrap ("%{F" ++ myCyan ++ "}[") "]%{F-}"
    , ppVisible = wrap ("%{F" ++ myCyan ++ "}[") "]%{F-}"
    , ppUrgent = wrap ("%{F" ++ myRed ++ "} ") " %{F-}"
    , ppHidden = wrap " " " "
    , ppHiddenNoWindows = wrap ("%{F" ++ myGray ++ "} ") " %{F-}"
    , ppWsSep = ""
    , ppSep = " "
    , ppLayout = wrap ("%{F" ++ myPink ++ "}") "%{F-}"
    , ppTitle = (wrap ("%{B" ++ myBlue ++ "}%{F" ++ myBg ++ "} ") " %{F-}%{B-}") . shorten 65
    }

myLogHook = showWNameLogHook def
          { swn_font    = "xft:CaskaydiaCove Nerd Font-38"
          , swn_bgcolor = myBg
          , swn_color   = myFg
          , swn_fade    = (2/3) 
          }

myStartupHook = do
    spawnOnce "picom"
    spawnOnce "luabatmon"
    spawnOnce "lxqt-policykit-agent"
    spawnOnce "unclutter --timeout --jitter --start-hidden"
    spawnOnce "feh --no-fehbg --bg-fill ~/.config/wallpaper"
    spawnOnce "polybar"
    setDefaultCursor xC_left_ptr

main = do
    dbus <- D.connect
    D.requestAccess dbus
    xmonad $ docks . ewmhFullscreen . ewmh $ def
         { terminal           = myTerminal
         , focusFollowsMouse  = myFocusFollowsMouse
         , borderWidth        = myBorderWidth
         , modMask            = myModMask
         , workspaces         = myWorkspaces
         , normalBorderColor  = myNormalBorderColor
         , focusedBorderColor = myFocusedBorderColor
         -- bindings
         , keys               = myKeys
         , mouseBindings      = myMouseBindings
         -- hooks and layouts
         , layoutHook         = myLayout
         , manageHook         = myManageHook
         , handleEventHook    = myEventHook
         , logHook            = myLogHook <+> dynamicLogWithPP (myDbus dbus)
         , startupHook        = myStartupHook
         }
