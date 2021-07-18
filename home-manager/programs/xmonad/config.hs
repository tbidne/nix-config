{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# OPTIONS_GHC -Wall -Werror #-}
{-# OPTIONS_GHC -Wincomplete-uni-patterns -Wmissing-export-lists -Wcompat #-}
{-# OPTIONS_GHC -Wno-deprecations -Wno-missing-signatures -Wno-unused-top-binds #-}
{-# OPTIONS_GHC -Wpartial-fields -Wmissing-home-modules -Widentities #-}
{-# OPTIONS_GHC -Wredundant-constraints -Wincomplete-record-updates #-}

module Main (main) where

import Codec.Binary.UTF8.String qualified as Utf8
import Control.Exception qualified as E
import DBus qualified
import DBus.Client (Client)
import DBus.Client qualified as DClient
import Data.Word (Word32)
import GHC.IO.Handle qualified as GHC.IO
import Graphics.X11.ExtraTypes.XF86 qualified as X11
import System.Exit qualified as Sys
import XMonad (KeyMask, KeySym, X, XConfig (..), (.|.), (|||))
import XMonad qualified as X
import XMonad.Actions.CycleWS (Direction1D (Next, Prev), WSType (AnyWS))
import XMonad.Actions.CycleWS qualified as XCycleWS
import XMonad.Actions.FloatKeys qualified as XFloatKeys
import XMonad.Actions.RotSlaves qualified as XRotSlaves
import XMonad.Hooks.DynamicLog (PP (..))
import XMonad.Hooks.DynamicLog qualified as XDynamicLog
import XMonad.Hooks.EwmhDesktops qualified as XEwmhDesktops
import XMonad.Hooks.FadeInactive qualified as XFadeInactive
import XMonad.Hooks.ManageDocks qualified as XManageDocks
import XMonad.Layout.Gaps (Direction2D (..))
import XMonad.Layout.Gaps qualified as XGaps
import XMonad.Layout.MultiToggle (Toggle (..))
import XMonad.Layout.MultiToggle qualified as XMultiToggle
import XMonad.Layout.MultiToggle.Instances (StdTransformers (NBFULL))
import XMonad.Layout.NoBorders qualified as XNoBorders
import XMonad.Layout.PerWorkspace qualified as XPerWorkspace
import XMonad.Layout.Spacing qualified as XSpacing
import XMonad.Layout.ThreeColumns (ThreeCol (..))
import XMonad.StackSet qualified as XStackSet
import XMonad.Util.NamedActions (NamedAction, (^++^))
import XMonad.Util.NamedActions qualified as XNamedActions
import XMonad.Util.Run qualified as XRun
import XMonad.Util.WorkspaceCompare qualified as XWorkspaceCompare
import XMonad.Wallpaper qualified as XWallpaper

main :: IO ()
main = mkDbusClient >>= withDBus

withDBus :: Client -> IO ()
withDBus dbus = do
  XWallpaper.setRandomWallpaper ["$HOME/Pictures/wallpaper/current"]
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
              logHook = myPolybarLogHook dbus
            }
  _ <- startPolybar
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

type AppName = String

type AppCommand = String

data App
  = ClassApp AppName AppCommand
  | TitleApp AppName AppCommand
  | NameApp AppName AppCommand
  deriving (Show)

getNameCommand :: App -> (AppName, AppCommand)
getNameCommand (ClassApp n c) = (n, c)
getNameCommand (TitleApp n c) = (n, c)
getNameCommand (NameApp n c) = (n, c)

getAppCommand :: App -> AppCommand
getAppCommand = snd . getNameCommand

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
    E.bracket (XRun.spawnPipe $ getAppCommand zenity) GHC.IO.hClose (\h -> GHC.IO.hPutStr h (unlines $ XNamedActions.showKm x))

zenity :: App
zenity = ClassApp "Zenity" "zenity --text-info --font=terminus"

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
      key "Decr  abs size" (modm .|. X.shiftMask, X.xK_d) $ X.withFocused (XFloatKeys.keysAbsResizeWindow (neg10, neg10) (1024, 752)),
      key "Incr  abs size" (modm .|. X.shiftMask, X.xK_s) $ X.withFocused (XFloatKeys.keysAbsResizeWindow (10, 10) (1024, 752))
    ]
  where
    neg10 :: Word32
    neg10 = 4294967286

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

startPolybar :: IO ()
startPolybar = do
  X.spawn "polybar top &"
  X.spawn "polybar bottom &"

startConky :: IO ()
startConky = do
  X.spawn "conky -c ~/Dev/tommy/github/conky/xmonad/conky_clock.conf"

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

wrkWs :: String
wrkWs = "wrk"

-- This type signature is hideous
myLayout =
  XManageDocks.avoidStruts
    . XNoBorders.smartBorders
    . fullScreenToggle
    . wrkLayout
    $ (tiled ||| X.Mirror tiled ||| column3 ||| full)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = gapSpaced 10 $ X.Tall nmaster delta ratio
    full = gapSpaced 5 X.Full
    column3 = gapSpaced 10 $ ThreeColMid 1 (3 / 100) (1 / 2)

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2

    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

    -- Gaps bewteen windows
    myGaps gap = XGaps.gaps [(U, gap), (D, gap), (L, gap), (R, gap)]

    -- TODO: spacing deprecated in favor of spacingRaw
    gapSpaced g = XSpacing.spacing g . myGaps g

    -- Per workspace layout
    wrkLayout = XPerWorkspace.onWorkspace wrkWs (tiled ||| full)

    -- Fullscreen
    fullScreenToggle = XMultiToggle.mkToggle (XMultiToggle.single NBFULL)

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

myLogHook :: X ()
myLogHook = XFadeInactive.fadeInactiveLogHook 0.95

-- Emit a DBus signal on log updates
dbusOutput :: Client -> String -> IO ()
dbusOutput dbus str =
  let opath = DBus.objectPath_ "/org/xmonad/Log"
      iname = DBus.interfaceName_ "org.xmonad.Log"
      mname = DBus.memberName_ "Update"
      signal = DBus.signal opath iname mname
      body = [DBus.toVariant $ Utf8.decodeString str]
   in DClient.emit dbus $ signal {DBus.signalBody = body}
