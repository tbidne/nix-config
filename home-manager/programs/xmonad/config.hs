{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wall -Werror #-}
{-# OPTIONS_GHC -Wincomplete-uni-patterns -Wmissing-export-lists -Wcompat #-}
{-# OPTIONS_GHC -Wpartial-fields -Wmissing-home-modules -Widentities #-}
{-# OPTIONS_GHC -Wredundant-constraints -Wincomplete-record-updates #-}

module Main (main) where

import Control.Exception qualified as E
import DBus qualified
import DBus.Client qualified as DClient
import Data.Word (Word32)
import GHC.IO.Handle qualified as GHC.IO
import XMonad (KeyMask, KeySym, X, XConfig (..), (.|.))
import XMonad qualified as X
import XMonad.Actions.CycleWS (Direction1D (Next, Prev), WSType (AnyWS))
import XMonad.Actions.CycleWS qualified as XCycleWS
import XMonad.Actions.DynamicWorkspaces qualified as XDynamicWorkspaces
import XMonad.Actions.FloatKeys qualified as XFloatKeys
import XMonad.Actions.RotSlaves qualified as XRotSlaves
import XMonad.Hooks.DynamicLog (PP (..))
import XMonad.Hooks.DynamicLog qualified as XDynamicLog
import XMonad.Hooks.ManageDocks qualified as XManageDocks
import XMonad.Layout.LayoutModifier qualified as XLayoutModifier
import XMonad.Layout.MultiToggle (Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (NBFULL))
import XMonad.StackSet qualified as XStackSet
import XMonad.Util.NamedActions (NamedAction, (^++^))
import XMonad.Util.NamedActions qualified as XNamedActions
import XMonad.Util.Run qualified as XRun
import XMonad.Util.WorkspaceCompare qualified as XWorkspaceCompare
import XMonad.Wallpaper qualified as XWallpaper

main :: IO ()
main = mkDbusClient >>= withDBus

withDBus :: DClient.Client -> IO ()
withDBus _ = do
  XWallpaper.setRandomWallpaper ["$HOME/Pictures/Wallpaper/Current"]
  let config =
        keybindings $
          X.def
            { modMask = myModMask,
              terminal = myTerminal,
              focusedBorderColor = "#282c73",
              borderWidth = 1
            }
  myXMobar config >>= X.xmonad

mkDbusClient :: IO DClient.Client
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
myTerminal = "alacritty"

screenLocker :: String
screenLocker = "betterlockscreen -l dim"

appLauncher :: String
appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"

-- KEY BINDINGS --

keybindings :: X.XConfig l -> X.XConfig l
keybindings = XNamedActions.addDescrKeys' ((myModMask, X.xK_F1), showKeybindings) myKeys

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x =
  XNamedActions.addName "Show Keybindings" . X.io $
    E.bracket (XRun.spawnPipe $ getAppCommand zenity) GHC.IO.hClose (\h -> GHC.IO.hPutStr h (unlines $ XNamedActions.showKm x))

zenity :: App
zenity = ClassApp "Zenity" "zenity --text-info --font=terminus"

myKeys :: X.XConfig l -> [((X.KeyMask, X.KeySym), XNamedActions.NamedAction)]
myKeys conf@X.XConfig {X.modMask = modm} =
  launchersKeySet conf modm
    ^++^ windowKeySet modm
    ^++^ layoutKeySet modm
    ^++^ workspacesKeySet modm
      ++ switchWsById
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

launchersKeySet :: X.XConfig l -> KeyMask -> KeySet
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
      key "Previous" (modm, X.xK_comma) prevWS',
      key "Remove" (modm .|. X.shiftMask, X.xK_BackSpace) XDynamicWorkspaces.removeWorkspace
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
      --, key "Reset"         (modm .|. X.shiftMask, X.xK_space     ) $ X.setLayout (X.layoutHook conf)
      key "Fullscreen" (modm, X.xK_f) $ X.sendMessage (Toggle NBFULL)
    ]

-- XMOBAR --

myXMobar :: X.LayoutClass l X.Window => XConfig l -> IO (XConfig (XLayoutModifier.ModifiedLayout XManageDocks.AvoidStruts l))
myXMobar = XDynamicLog.statusBar "xmobar" myPP toggleBar

toggleBar :: X.XConfig l -> (KeyMask, KeySym)
toggleBar X.XConfig {modMask} = (modMask, X.xK_b)

myPP :: XDynamicLog.PP
myPP =
  XDynamicLog.xmobarPP
    { ppTitle = XDynamicLog.xmobarColor myTitleColor "" . XDynamicLog.shorten myTitleLength,
      ppCurrent =
        XDynamicLog.xmobarColor myCurrentWSColor ""
          . XDynamicLog.wrap myCurrentWSLeft myCurrentWSRight,
      ppVisible =
        XDynamicLog.xmobarColor myVisibleWSColor ""
          . XDynamicLog.wrap myVisibleWSLeft myVisibleWSRight,
      ppUrgent =
        XDynamicLog.xmobarColor myUrgentWSColor ""
          . XDynamicLog.wrap myUrgentWSLeft myUrgentWSRight
    }
  where
    myTitleColor = "#eeeeee" -- color of window title
    myTitleLength = 80 -- truncate window title to this length
    myCurrentWSColor = "#e6744c" -- color of active workspace
    myVisibleWSColor = "#c185a7" -- color of inactive workspace
    myUrgentWSColor = "#cc0000" -- color of workspace with 'urgent' window
    myCurrentWSLeft = "[" -- wrap active workspace with these
    myCurrentWSRight = "]"
    myVisibleWSLeft = "(" -- wrap inactive workspace with these
    myVisibleWSRight = ")"
    myUrgentWSLeft = "{" -- wrap urgent workspace with these
    myUrgentWSRight = "}"