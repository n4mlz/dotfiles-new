-- Hyprland 0.55+ Lua configuration.

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@144",
    position = "0x0",
    scale = 1,
})

local terminal = "alacritty"
local fileManager = "thunar"
local menu = "wofi --show drun"
local lock = "gtklock"
local mainMod = "SUPER"

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("fcitx5")
    hl.exec_cmd("cliphist wipe")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme catppuccin-mocha-sky-standard+default")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("/usr/bin/discord --start-minimized")
    hl.exec_cmd("xdg-mime default firefox.desktop text/html")
    hl.exec_cmd("xdg-mime default firefox.desktop x-scheme-handler/http")
    hl.exec_cmd("xdg-mime default firefox.desktop x-scheme-handler/https")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")

hl.config({
    input = {
        kb_layout = "jp",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0.1,
        touchpad = {
            natural_scroll = true,
        },
    },

    general = {
        gaps_in = 3,
        gaps_out = 4,
        border_size = 0,
        col = {
            active_border = {
                colors = { "rgba(11ccffee)", "rgba(ff77ffee)" },
                angle = 45,
            },
            inactive_border = "rgba(595959aa)",
        },
        layout = "dwindle",
        allow_tearing = false,
    },

    decoration = {
        rounding = 5,
        inactive_opacity = 1,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
    },
})

hl.curve("myBezier", {
    type = "bezier",
    points = {
        { 0.05, 0.9 },
        { 0.1, 1 },
    },
})

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

hl.gesture({
    fingers = 4,
    direction = "horizontal",
    action = "workspace",
})

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + U", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + I", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise 10"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower 10"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise 10"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower 10"))

hl.bind("Print", hl.dsp.exec_cmd(
    [[grim -g "$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | wl-copy && notify-send -a "ScreenShot" "Took Screenshot of the Active Window!"]]
))

hl.bind("CTRL + Print", hl.dsp.exec_cmd(
    [[mkdir -p $HOME/me/pics/screenshot/$(hyprctl -j activewindow | jq -r '"\(.class)"') && grim -g "$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | tee $HOME/me/pics/screenshot/$(hyprctl -j activewindow | jq -r '"\(.class)"')/$(date +%Y%m%d-%H%M%S).png | wl-copy && notify-send -a "ScreenShot" "Saved Screenshot of the Active Window!"]]
))

hl.bind("SHIFT + Print", hl.dsp.exec_cmd(
    [[grim - | wl-copy && notify-send -a "ScreenShot" "Took Fullscreen Screenshot!"]]
))

hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd(
    [[mkdir -p $HOME/me/pics/screenshot/fullscreen && grim - | tee $HOME/me/pics/screenshot/fullscreen/$(date +%Y%m%d-%H%M%S).png | wl-copy && notify-send -a "ScreenShot" "Saved Fullscreen Screenshot!"]]
))

hl.bind("ALT + Print", hl.dsp.exec_cmd(
    [[set -o pipefail && slurp | grim -g - - | wl-copy && notify-send -a "ScreenShot" "Took Screenshot of the Selected Area!"]]
))

hl.bind("CTRL + ALT + Print", hl.dsp.exec_cmd(
    [[set -o pipefail && mkdir -p $HOME/me/pics/screenshot/selected && slurp | grim -g - - | tee $HOME/me/pics/screenshot/selected/$(date +%Y%m%d-%H%M%S).png | wl-copy && notify-send -a "ScreenShot" "Saved Screenshot of the Selected Area!"]]
))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
