{-# LANGUAGE ImportQualifiedPost #-}

module Main (main) where

import Control.Exception qualified as E
import GHC.IO.Handle qualified as IO
import XMonad ((.|.), KeyMask, KeySym)
import XMonad qualified as X
import XMonad.Util.NamedActions (NamedAction)
import XMonad.Util.NamedActions qualified as XNamedActions
import XMonad.Util.Run qualified as XRun

main :: IO ()
main = X.xmonad . keybindings $ X.def
  { X.modMask = myModMask
  , X.terminal = myTerminal
  }
  where
    keybindings = XNamedActions.addDescrKeys' ((myModMask, X.xK_F1), showKeybindings) myKeys

type AppName      = String
type AppTitle     = String
type AppClassName = String
type AppCommand   = String

data App
  = ClassApp AppClassName AppCommand
  | TitleApp AppTitle AppCommand
  | NameApp AppName AppCommand
  deriving Show

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = XNamedActions.addName "Show Keybindings" . X.io $
  E.bracket (XRun.spawnPipe $ getAppCommand zenity) IO.hClose (\h -> IO.hPutStr h (unlines $ XNamedActions.showKm x))

getNameCommand :: App -> (AppClassName, AppCommand)
getNameCommand (ClassApp n c) = (n, c)
getNameCommand (TitleApp n c) = (n, c)
getNameCommand (NameApp  n c) = (n, c)

getAppName :: App -> AppClassName
getAppName    = fst . getNameCommand

getAppCommand :: App -> AppCommand
getAppCommand = snd . getNameCommand

zenity :: App
zenity = ClassApp "Zenity" "zenity --text-info --font=terminus"

myModMask :: KeyMask
myModMask = X.mod4Mask -- Use Super instead of Alt

myTerminal :: String
myTerminal   = "konsole"

screenLocker :: String
screenLocker = "betterlockscreen -l dim"

appLauncher :: String
appLauncher  = "rofi -modi drun,ssh,window -show drun -show-icons"

myKeys :: X.XConfig l -> [((X.KeyMask, X.KeySym), XNamedActions.NamedAction)]
myKeys conf@X.XConfig {X.modMask = modm} =
  keySet "Launchers"
    [ key "Terminal"      (modm .|. X.shiftMask  , X.xK_Return  ) $ X.spawn (X.terminal conf)
    , key "Apps (Rofi)"   (modm                , X.xK_p       ) $ X.spawn appLauncher
    , key "Lock screen"   (modm .|. X.controlMask, X.xK_l       ) $ X.spawn screenLocker
    ]
 where
  keySet s ks = XNamedActions.subtitle s : ks
  key n k a = (k, XNamedActions.addName n a)
