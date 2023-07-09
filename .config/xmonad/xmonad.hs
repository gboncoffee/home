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

import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myPink   = "#ff79c6"
myBlue   = "#bd93f9"
myCyan   = "#8be9fd"
myRed    = "#ff5555"
myGray   = "#44475a"
myYellow = "#f1fa8c"
myGreen  = "#50fa7b"
myBg     = "#282a36"
myFg     = "#f8f8f2"

myFont = "xft:monospace-"

myTerminal           = "alacritty"
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
    , ((modm, xK_n),      spawn "$BROWSER")
    , ((modm, xK_e),      spawn "thunderbird")
    , ((modm, xK_c),      spawn $ myTerminal ++ " --class floating -e python")
    , ((modm, xK_s),      spawn $ myTerminal ++ " --class floating -e pulsemixer")
    , ((modm, xK_m),      spawn $ myTerminal ++ " --class floating -e ncmpcpp")
    , ((modm, xK_f),      spawn $ myTerminal ++ " -e nnn")

    , ((modm,                 xK_p), spawn "flameshot gui")
    , ((modm .|. controlMask, xK_c), spawn "dunstctl close")

    -- dmenu
    , ((modm,                 xK_a), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    , ((modm,                 xK_b), spawn "dmenu_web")
    , ((modm .|. controlMask, xK_b), spawn "dmenu_bluetooth")
    , ((modm .|. controlMask, xK_d), spawn "monitors")
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
    , ((modm,                 xK_h),     sendMessage Shrink)
    , ((modm,                 xK_l),     sendMessage Expand)
    , ((modm,                 xK_space), sendMessage NextLayout)
    , ((modm .|. shiftMask,   xK_h),     sendMessage (IncMasterN 1))
    , ((modm .|. shiftMask,   xK_l),     sendMessage (IncMasterN (-1)))
    , ((modm .|. shiftMask,   xK_b),     sendMessage ToggleStruts)
    , ((modm .|. controlMask, xK_k),     sendMessage MirrorExpand)
    , ((modm .|. controlMask, xK_j),     sendMessage MirrorShrink)

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

myLayout = avoidStruts $ lessBorders OnlyScreenFloat $ tiled ||| Mirror tiled ||| tab
  where
    tiled  = spacingWithEdge 3 $ ResizableTall 1 (3/100) (1/2) []
    tab    = tabbedBottom shrinkText $ def
           { activeColor         = myBlue
           , activeBorderColor   = myBlue
           , activeTextColor     = myBg
           , inactiveColor       = myBg
           , inactiveBorderColor = myBg
           , inactiveTextColor   = myFg
           , urgentColor         = myRed
           , urgentBorderColor   = myRed
           , urgentTextColor     = myFg
           , fontName            = myFont ++ "16"
           , decoHeight          = 27
           }

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFullFloat
    , className =? "Gimp"           --> doCenterFloat
    , className =? "floating"       --> doCenterFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen                  --> doFullFloat
    ]

myEventHook = mempty

myLogHook = showWNameLogHook def
          { swn_font    = myFont ++ "42"
          , swn_bgcolor = myBg
          , swn_color   = myFg
          , swn_fade    = (2/3) 
          }

myStartupHook = do
    spawnOnce "picom"
    spawnOnce "luabatmon"
    spawnOnce "lxqt-policykit-agent"
    spawnOnce "unclutter --timeout --jitter --start-hidden --noevents"
    spawnOnce "feh --no-fehbg --bg-fill ~/.config/wallpaper"
    spawnOnce "polybar"
    setDefaultCursor xC_left_ptr
    spawn "xsetroot -cursor_name left_ptr"

main = xmonad $ docks . ewmhFullscreen . ewmh $ def
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
         , logHook            = myLogHook
         , startupHook        = myStartupHook
         }
