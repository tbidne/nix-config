{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -Wcompat #-}
{-# OPTIONS_GHC -Werror #-}
{-# OPTIONS_GHC -Widentities #-}
{-# OPTIONS_GHC -Wincomplete-record-updates #-}
{-# OPTIONS_GHC -Wincomplete-uni-patterns #-}
{-# OPTIONS_GHC -Wno-deprecations #-}
{-# OPTIONS_GHC -Wno-partial-type-signatures #-}
{-# OPTIONS_GHC -Wpartial-fields #-}

module Main (main) where

import Codec.Binary.UTF8.String qualified as Utf8
import Control.Concurrent qualified as CC
import Control.Concurrent.Async qualified as Async
import Control.Exception qualified as E
import Control.Monad (void)
import DBus qualified
import DBus.Client (Client)
import DBus.Client qualified as DClient
import GHC.IO.Handle qualified as GHC.IO
import Graphics.X11.ExtraTypes.XF86 qualified as X11
import System.Exit qualified as Sys
import XMonad (KeyMask, KeySym, Window, X, XConfig (..), (.|.), (|||))
import XMonad qualified as X
import XMonad.Actions.CycleWS (Direction1D (Next, Prev), WSType (AnyWS))
import XMonad.Actions.CycleWS qualified as XCycleWS
import XMonad.Actions.FloatKeys qualified as XFloatKeys
import XMonad.Actions.RotSlaves qualified as XRotSlaves
import XMonad.Actions.SpawnOn qualified as XSpawnOn
import XMonad.Core (WorkspaceId)
import XMonad.Hooks.DynamicLog (PP (..))
import XMonad.Hooks.DynamicLog qualified as XDynamicLog
import XMonad.Hooks.EwmhDesktops qualified as XEwmhDesktops
import XMonad.Hooks.ManageDocks (AvoidStruts)
import XMonad.Hooks.ManageDocks qualified as XManageDocks
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.MultiToggle (Toggle (..))
import XMonad.Layout.MultiToggle qualified as XMultiToggle
import XMonad.Layout.MultiToggle.Instances (StdTransformers (NBFULL))
import XMonad.Layout.NoBorders qualified as XNoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Spacing qualified as XSpacing
import XMonad.StackSet qualified as XStackSet
import XMonad.Util.NamedActions (NamedAction, (^++^))
import XMonad.Util.NamedActions qualified as XNamedActions
import XMonad.Util.Run qualified as XRun
import XMonad.Util.WorkspaceCompare qualified as XWorkspaceCompare

main :: IO ()
main = mkDbusClient >>= withDBus

withDBus :: Client -> IO ()
withDBus dbus = do
  setWallpaper
  let config =
        keybindings $
          X.def
            { modMask = myModMask,
              terminal = myTerminal,
              focusedBorderColor = "#ffffff",
              focusFollowsMouse = True,
              normalBorderColor = "#000000",
              borderWidth = 1,
              layoutHook = myLayout,
              logHook = myPolybarLogHook dbus,
              manageHook = XSpawnOn.manageSpawn <> manageHook X.def,
              workspaces = myWorkspaces
            }
  startup
  X.xmonad $
    XManageDocks.docks $
      XEwmhDesktops.ewmh config

mkDbusClient :: IO Client
mkDbusClient = do
  dbus <- DClient.connectSession
  _ <- DClient.requestName dbus (DBus.busName_ "org.xmonad.log") opts
  return dbus
  where
    opts = [DClient.nameAllowReplacement, DClient.nameReplaceExisting, DClient.nameDoNotQueue]

type KeySet = [((KeyMask, KeySym), NamedAction)]

myModMask :: KeyMask
myModMask = X.mod4Mask -- Use Super instead of Alt

myTerminal :: String
myTerminal = "kitty"

screenLocker :: String
screenLocker = "betterlockscreen -l dim"

appLauncher :: String
appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"

-- KEY BINDINGS --

keybindings :: XConfig l -> XConfig l
keybindings = XNamedActions.addDescrKeys' ((myModMask, X.xK_F1), showKeybindings) myKeys

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x =
  XNamedActions.addName "Show Keybindings" . X.io $
    E.bracket (XRun.spawnPipe $ snd zenity) GHC.IO.hClose (\h -> GHC.IO.hPutStr h (unlines $ XNamedActions.showKm x))

zenity :: (String, String)
zenity = ("Zenity", "zenity --text-info --font=terminus")

myKeys :: XConfig l -> [((X.KeyMask, X.KeySym), XNamedActions.NamedAction)]
myKeys conf@XConfig {X.modMask = modm} =
  launchersKeySet conf modm
    ^++^ windowKeySet modm
    ^++^ layoutKeySet modm
    ^++^ workspacesKeySet modm
    ^++^ systemKeySet modm
    ^++^ audioKeySet
    ^++^ brightnessKeySet
    ^++^ polyBarKeySet modm
    <> switchWsById
  where
    action :: KeyMask -> String
    action m = if m == X.shiftMask then "Move to " else "Switch to "

    switchWsById :: KeySet
    switchWsById =
      [ key (action m <> show i) (m .|. modm, k) (X.windows $ f i)
        | (i, k) <- zip (X.workspaces conf) [X.xK_1 .. X.xK_9],
          (f, m) <- [(XStackSet.greedyView, 0), (XStackSet.shift, X.shiftMask)]
      ]

keySet :: String -> KeySet -> KeySet
keySet s ks = XNamedActions.subtitle s : ks

key :: String -> a -> X () -> (a, NamedAction)
key n k a = (k, XNamedActions.addName n a)

-- KEYSETS --

launchersKeySet :: XConfig l -> KeyMask -> KeySet
launchersKeySet conf modm =
  keySet
    "Launchers"
    [ key "Terminal" (modm .|. X.shiftMask, X.xK_Return) $ X.spawn (X.terminal conf),
      key "Apps (Rofi)" (modm, X.xK_p) $ X.spawn appLauncher,
      key "Lock screen" (modm .|. X.controlMask, X.xK_l) $ X.spawn screenLocker
    ]

windowKeySet :: KeyMask -> KeySet
windowKeySet modm =
  keySet
    "Windows"
    [ key "Close focused" (modm, X.xK_BackSpace) X.kill,
      key "Refresh size" (modm, X.xK_n) X.refresh,
      key "Focus next" (modm, X.xK_j) $ X.windows XStackSet.focusDown,
      key "Focus previous" (modm, X.xK_k) $ X.windows XStackSet.focusUp,
      key "Focus master" (modm, X.xK_m) $ X.windows XStackSet.focusMaster,
      key "Swap master" (modm, X.xK_Return) $ X.windows XStackSet.swapMaster,
      key "Swap next" (modm .|. X.shiftMask, X.xK_j) $ X.windows XStackSet.swapDown,
      key "Swap previous" (modm .|. X.shiftMask, X.xK_k) $ X.windows XStackSet.swapUp,
      key "Shrink master" (modm, X.xK_h) $ X.sendMessage X.Shrink,
      key "Expand master" (modm, X.xK_l) $ X.sendMessage X.Expand,
      key "Switch to tile" (modm, X.xK_t) $ X.withFocused (X.windows . XStackSet.sink),
      key "Rotate slaves" (modm .|. X.shiftMask, X.xK_Tab) XRotSlaves.rotSlavesUp,
      key "Decrease size" (modm, X.xK_d) $ X.withFocused (XFloatKeys.keysResizeWindow (neg10, neg10) (1, 1)),
      key "Increase size" (modm, X.xK_s) $ X.withFocused (XFloatKeys.keysResizeWindow (10, 10) (1, 1)),
      key "Decr  abs size" (modm .|. X.shiftMask, X.xK_d) $ X.withFocused (XFloatKeys.keysAbsResizeWindow (neg10, neg10) (1_024, 752)),
      key "Incr  abs size" (modm .|. X.shiftMask, X.xK_s) $ X.withFocused (XFloatKeys.keysAbsResizeWindow (10, 10) (1_024, 752))
    ]
  where
    neg10 :: Int
    neg10 = -10

workspacesKeySet :: KeyMask -> KeySet
workspacesKeySet modm =
  keySet
    "Workspaces"
    [ key "Next" (modm, X.xK_period) nextWS',
      key "Previous" (modm, X.xK_comma) prevWS'
    ]
  where
    filterOutNSP :: X ([X.WindowSpace] -> [XStackSet.Workspace String (X.Layout X.Window) X.Window])
    filterOutNSP =
      let g f xs = filter (\(XStackSet.Workspace t _ _) -> t /= "NSP") (f xs)
       in g <$> XWorkspaceCompare.getSortByIndex

    switchWS :: XCycleWS.Direction1D -> X ()
    switchWS dir =
      XCycleWS.findWorkspace filterOutNSP dir AnyWS 1 >>= X.windows . XStackSet.view

    nextWS' = switchWS Next
    prevWS' = switchWS Prev

layoutKeySet :: KeyMask -> KeySet
layoutKeySet modm =
  keySet
    "Layouts"
    [ key "Next" (modm, X.xK_space) $ X.sendMessage X.NextLayout,
      key "Fullscreen" (modm, X.xK_f) $ X.sendMessage (Toggle NBFULL)
    ]

systemKeySet :: KeyMask -> KeySet
systemKeySet modm =
  keySet
    "System"
    [ key "Logout (quit XMonad)" (modm .|. X.shiftMask, X.xK_q) $ X.io Sys.exitSuccess,
      key "Capture entire screen" (modm, X.xK_Print) $ X.spawn "flameshot full -p ~/Pictures/flameshot/"
    ]

startup :: IO ()
startup =
  startPolybar
    *> startDeadd
    -- delay between deadd and navi, otherwise navi may not properly connect.
    *> CC.threadDelay 2_000_000
    *> startNavi

startPolybar :: IO ()
startPolybar = void $
  Async.async $ do
    -- polybar top needs to start _after_ xmonad to properly interface with
    -- ewmh. This is a problem because apparently the xmonad command needs to
    -- be the _last_ command in main. Naively putting startup after does not
    -- seem to run any of our apps (i.e. deadd, navi, polybar). Thus we run
    -- polybar asynchronously with a delay.
    CC.threadDelay 5_000_000
    X.spawn "polybar top"
    X.spawn "polybar bottom"

startDeadd :: IO ()
startDeadd = X.spawn "deadd-notification-center"

startNavi :: IO ()
startNavi = X.spawn "navi"

setWallpaper :: IO ()
setWallpaper =
  X.spawn $ "feh --bg-scale " <> wpPath
  where
    wpPath = "$HOME/Pictures/wallpaper/current/halloween.png"

audioKeySet :: KeySet
audioKeySet =
  keySet
    "Audio"
    [ key "Mute" (0, X11.xF86XK_AudioMute) $ X.spawn "amixer -q set Master toggle",
      key "Lower volume" (0, X11.xF86XK_AudioLowerVolume) $ X.spawn "amixer -q set Master 5%-",
      key "Raise volume" (0, X11.xF86XK_AudioRaiseVolume) $ X.spawn "amixer -q set Master 5%+"
    ]

polyBarKeySet :: KeyMask -> KeySet
polyBarKeySet modm =
  keySet
    "Polybar"
    [ key "Toggle" (modm, X.xK_equal) toggleStruts
    ]
  where
    togglePolybar = X.spawn "polybar-msg cmd toggle &"
    toggleStruts = togglePolybar >> X.sendMessage XManageDocks.ToggleStruts

brightnessKeySet :: KeySet
brightnessKeySet =
  keySet
    "Brightness"
    [ key "Increase Brightness" (0, X11.xF86XK_MonBrightnessUp) $ X.spawn "brightnessctl -d intel_backlight s +10%",
      key "Decrease Brightness" (0, X11.xF86XK_MonBrightnessDown) $ X.spawn "brightnessctl -d intel_backlight s 10%-"
    ]

-- LAYOUT --

myWorkspaces :: [WorkspaceId]
myWorkspaces =
  [ "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9"
  ]

myLayout :: ModifiedLayout AvoidStruts _ Window
myLayout =
  XManageDocks.avoidStruts
    . XNoBorders.smartBorders
    . fullScreenToggle
    $ defaultLayout
  where
    tiled = gapSpaced 10 $ X.Tall nmaster delta ratio
    full = gapSpaced 5 X.Full
    dev = gapSpaced 10 $ X.Mirror (X.Tall nmaster delta (2 / 3))

    defaultLayout = dev ||| tiled ||| full

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2

    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

    -- Fullscreen
    fullScreenToggle = XMultiToggle.mkToggle (XMultiToggle.single NBFULL)

gapSpaced :: Integer -> l a -> ModifiedLayout Spacing l a
gapSpaced g = XSpacing.spacingRaw False (uniformBorder 0) False (uniformBorder g) True

uniformBorder :: Integer -> Border
uniformBorder i = Border i i i i

-- POLYBAR --

myPolybarLogHook :: Client -> X ()
myPolybarLogHook = XDynamicLog.dynamicLogWithPP . polybarHook

polybarHook :: Client -> PP
polybarHook dbus =
  let wrapper c s
        | s /= "NSP" = XDynamicLog.wrap ("%{F" <> c <> "} ") " %{F-}" s
        | otherwise = mempty
      blue = "#2E9AFE"
      gray = "#7F7F7F"
      orange = "#ea4300"
      purple = "#9058c7"
      red = "#722222"
   in XDynamicLog.def
        { ppOutput = dbusOutput dbus,
          ppCurrent = wrapper blue,
          ppVisible = wrapper gray,
          ppUrgent = wrapper orange,
          ppHidden = wrapper gray,
          ppHiddenNoWindows = wrapper red,
          ppTitle = XDynamicLog.shorten 100 . wrapper purple
        }

-- Emit a DBus signal on log updates
dbusOutput :: Client -> String -> IO ()
dbusOutput dbus str =
  let opath = DBus.objectPath_ "/org/xmonad/Log"
      iname = DBus.interfaceName_ "org.xmonad.Log"
      mname = DBus.memberName_ "Update"
      signal = DBus.signal opath iname mname
      body = [DBus.toVariant $ Utf8.decodeString str]
   in DClient.emit dbus $ signal {DBus.signalBody = body}
