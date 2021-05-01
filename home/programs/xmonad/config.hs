import XMonad
import XMonad.Actions.CycleWS
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.Paste
import System.IO

-- Imports for Polybar --
import qualified Codec.Binary.UTF8.String              as UTF8
import qualified DBus                                  as D
import qualified DBus.Client                           as D
import           XMonad.Hooks.DynamicLog

main :: IO ()
main = mkDbusClient >>= main'

main' :: D.Client -> IO ()
main' dbus = do
  --h <- spawnPipe "xmobar -d"
  xmonad $ docks def {
    terminal = "alacritty"
    , manageHook = manageDocks <+> myManageHook <+> manageHook def
    , modMask = mod4Mask
    , borderWidth = 1
    , focusedBorderColor = "Dark Blue"
    , workspaces = myWorkspaces
    , layoutHook = myLayoutHook
    , logHook = myPolybarLogHook dbus
    } `additionalKeys` myAdditionalKeys

--toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

myWorkspaces = ["Sys", "Msg", "1", "2", "3", "4", "Log"]
workSpaceShortcuts = [xK_y, xK_u, xK_i, xK_o, xK_p, xK_bracketleft, xK_bracketright]

myAdditionalKeys = 
  [ ((mod4Mask, xK_w), spawn "qutebrowser")
  , ((mod4Mask, xK_s), spawn ("rofi-pass"))
  , ((mod4Mask, xK_d), spawn ("rofi -modi drun,ssh,window -show drun -show-icons"))
  , ((mod4Mask, xK_f), spawn ("popupCommands"))
  , ((mod4Mask, xK_g), spawn ("alacritty -e nvim -c ':terminal'"))
  , ((mod4Mask, xK_c), spawn ("popupStatus"))
  , ((mod4Mask, xK_comma), sendMessage Shrink)
  , ((mod4Mask, xK_period), sendMessage Expand)
  , ((mod4Mask, xK_h), prevWS)
  , ((mod4Mask, xK_l), nextWS)
  , ((mod4Mask, xK_v ), kill)
  , ((mod4Mask, xK_equal), togglePolybar)
  ] ++ 
  [((m .|. mod4Mask, k), windows $ f i)
    | (i, k) <- zip myWorkspaces workSpaceShortcuts     
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    
togglePolybar = spawn "polybar-msg cmd toggle &"

myLayoutHook = avoidStruts $ spacingRaw True (Border 0 10 10 10) True (Border 10 10 10 10) True $ layoutHook def

------------------------------------------------------------------------
-- Polybar settings (needs DBus client).
--
mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") opts
  return dbus
 where
  opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
  let opath  = D.objectPath_ "/org/xmonad/Log"
      iname  = D.interfaceName_ "org.xmonad.Log"
      mname  = D.memberName_ "Update"
      signal = D.signal opath iname mname
      body   = [D.toVariant $ UTF8.decodeString str]
  in  D.emit dbus $ signal { D.signalBody = body }

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                  | otherwise  = mempty
      blue   = "#2E9AFE"
      gray   = "#7F7F7F"
      orange = "#ea4300"
      purple = "#9058c7"
      red    = "#722222"
  in  def { ppOutput          = dbusOutput dbus
          , ppCurrent         = wrapper blue
          , ppVisible         = wrapper gray
          , ppUrgent          = wrapper orange
          , ppHidden          = wrapper gray
          , ppHiddenNoWindows = wrapper red
          , ppTitle           = wrapper purple . shorten 90
          }

myPolybarLogHook dbus = dynamicLogWithPP (polybarHook dbus)

------------------------------------------------------------------------

--myManageHook = isDialog --> doF W.shiftMaster <+> doF W.swapDown
--myManageHook = composeAll []
myManageHook = composeOne
  [ return True -?> doF W.swapDown
  ]
