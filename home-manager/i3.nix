{
  lib,
  config,
  pkgs,
  ...
}: {

  #creates symlink of i3status-rust.toml into $HOME/.config/i3
  home.file.".config/i3/i3status-rust.toml".source = (config.lib.file.mkOutOfStoreSymlink ./config-files/i3status-rust.toml);

  home.packages = with pkgs; [
    killall
    networkmanagerapplet
    dunst
    speedcrunch
  ];

  xsession.windowManager.i3 = {
    enable = true;
    config = null;
    extraConfig = ''
	set $mod Mod4
	set $alt Mod1

	font pango:monospace 8

	# Use Mouse+$mod to drag floating windows to their wanted position
	floating_modifier $alt
	tiling_drag modifier

        # not needed
	# exec --no-startup-id dex --autostart --environment i3
	# exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork
	set $exe        exec --no-startup-id
	set $exe_always exec_always --no-startup-id

	# start a terminal
	bindsym $mod+Return exec alacritty

	# kill focused window
	bindsym Ctrl+q kill

	# start dmenu (a program launcher)
	bindsym $mod+d exec "rofi window#drun#run#combi#ssh -show drun -sidebar-mode"

	# change focus
	bindsym $mod+h focus left
	bindsym $mod+j focus down
	bindsym $mod+k focus up
	bindsym $mod+l focus right

	# move focused window
	bindsym $mod+Shift+h move left
	bindsym $mod+Shift+j move down
	bindsym $mod+Shift+k move up
	bindsym $mod+Shift+l move right

	# split in horizontal orientation
	bindsym $mod+b split h

	# split in vertical orientation
	bindsym $mod+v split v

	# enter fullscreen mode for the focused container
	bindsym $mod+f fullscreen toggle

	# change container layout (stacked, tabbed, toggle split)
	bindsym $mod+s layout stacking
	bindsym $mod+w layout tabbed
	bindsym $mod+e layout toggle split

	# toggle tiling / floating
	bindsym $mod+Shift+space floating toggle

	# change focus between tiling / floating windows
	bindsym $mod+space focus mode_toggle

	# focus the parent container
	# bindsym $mod+a focus parent

	# focus the child container
	#bindsym $mod+d focus child

	# Define names for default workspaces for which we configure key bindings later on.
	# switch to workspace
	bindsym $mod+1 workspace number 1
	bindsym $mod+2 workspace number 2
	bindsym $mod+3 workspace number 3
	bindsym $mod+4 workspace number 4
	bindsym $mod+5 workspace number 5
	bindsym $mod+6 workspace number 6
	bindsym $mod+7 workspace number 7
	bindsym $mod+8 workspace number 8
	bindsym $mod+9 workspace number 9
	bindsym $mod+0 workspace number 10

	# move focused container to workspace
	bindsym $mod+Shift+1 move container to workspace number 1
	bindsym $mod+Shift+2 move container to workspace number 2
	bindsym $mod+Shift+3 move container to workspace number 3
	bindsym $mod+Shift+4 move container to workspace number 4
	bindsym $mod+Shift+5 move container to workspace number 5
	bindsym $mod+Shift+6 move container to workspace number 6
	bindsym $mod+Shift+7 move container to workspace number 7
	bindsym $mod+Shift+8 move container to workspace number 8
	bindsym $mod+Shift+9 move container to workspace number 9
	bindsym $mod+Shift+0 move container to workspace number 10

	workspace 0 output eDP
	workspace 1 output eDP
	workspace 2 output eDP
	workspace 3 output eDP
	workspace 4 output HDMI-1-0
	workspace 5 output HDMI-1-0
	workspace 6 output HDMI-1-0
	workspace 7 output HDMI-1-0
	workspace 8 output HDMI-1-0
	workspace 9 output HDMI-1-0

	# move to another workspace
	bindsym Ctrl+$alt+l workspace next
	bindsym Ctrl+$alt+h workspace prev
	bindsym Ctrl+$alt+Left workspace next
	bindsym Ctrl+$alt+Right workspace prev

	# reload the configuration file
	bindsym $mod+Shift+c reload

	# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
	bindsym $mod+Shift+r restart

	# Power manager ----- #
	set $Locker i3lock && sleep 1

	set $mode_system System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown
	mode "$mode_system" {
	    bindsym l exec --no-startup-id $Locker, mode "default"
	    bindsym e exec --no-startup-id i3-msg exit, mode "default"
	    bindsym s exec --no-startup-id $Locker && systemctl suspend, mode "default"
	    bindsym h exec --no-startup-id $Locker && systemctl hibernate, mode "default"
	    bindsym r exec --no-startup-id systemctl reboot, mode "default"
	    bindsym Shift+s exec --no-startup-id systemctl poweroff -i, mode "default"  

	    # back to normal: Enter or Escape
	    bindsym Return mode "default"
	    bindsym Escape mode "default"
	}
	bindsym $alt+q mode "$mode_system"

	# resize window (you can also use the mouse for that)
	mode "resize" {
		bindsym h resize shrink width 10 px or 10 ppt
		bindsym j resize grow height 10 px or 10 ppt
		bindsym k resize shrink height 10 px or 10 ppt
		bindsym l resize grow width 10 px or 10 ppt

		# same bindings, but for the arrow keys
		bindsym Left resize shrink width 10 px or 10 ppt
		bindsym Down resize grow height 10 px or 10 ppt
		bindsym Up resize shrink height 10 px or 10 ppt
		bindsym Right resize grow width 10 px or 10 ppt

		# back to normal: Enter or Escape or $mod+r
		bindsym Return mode "default"
		bindsym Escape mode "default"
		bindsym $mod+r mode "default"
	}

	bindsym $mod+r mode "resize"

	# gaps ----- #
	for_window [class=".*"] border pixel 0
	gaps inner 10

	# bar ----- 5
	bar {
	    font pango:Fira Code, Font Awesome 6 Free
	    position bottom
	    status_command ${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3/i3status-rust.toml
	    colors {
		separator #666666
		background #222222
		statusline #dddddd
		focused_workspace #0088CC #0088CC #ffffff
		active_workspace #333333 #333333 #ffffff
		inactive_workspace #333333 #333333 #888888
		urgent_workspace #2f343a #900000 #ffffff
	    }
	}

	# multimedia key binding ----- #
	#rk61 uses ALT + fn
	bindsym Mod1+Mod2+equal $exe pactl -- set-sink-volume 0 +2.5% && $refresh_i3status
	bindsym Mod1+Mod2+minus $exe pactl -- set-sink-volume 0 -2.5% && $refresh_i3status
	bindsym Mod1+Mod2+0 $exe pactl set-sink-mute 0 toggle && $refresh_i3status

	bindsym Mod1+Mod2+9 exec --no-startup-id playerctl next 
	bindsym Mod1+Mod2+8 exec --no-startup-id playerctl play-pause
	bindsym Mod1+Mod2+7 exec --no-startup-id playerctl previous

	bindsym Mod1+Mod2+6 $exe /usr/bin/flameshot gui
	bindsym Mod1+Mod2+5 $exe spotify
	bindsym Mod1+Mod2+4 $exe speedcrunch
	bindsym Mod1+Mod2+2 $exe firefox


	bindsym XF86AudioRaiseVolume $exe pactl -- set-sink-volume 0 +2.5% && $refresh_i3status
	bindsym XF86AudioLowerVolume $exe pactl -- set-sink-volume 0 -2.5% && $refresh_i3status
	bindsym XF86AudioMute $exe pactl set-sink-mute 0 toggle && $refresh_i3status

	bindsym XF86AudioPlay exec --no-startup-id playerctl play-pause
	bindsym XF86AudioNext exec --no-startup-id playerctl next 
	bindsym XF86AudioPrev exec --no-startup-id playerctl previous

	bindsym Print                $exe /usr/bin/flameshot gui
	bindsym XF86MonBrightnessUp $exe xbacklight -inc 10
	bindsym XF86MonBrightnessDown $exe xbacklight -dec 10
	bindsym XF86Search $exe firefox
	bindsym XF86Calculator $exe speedcrunch

# initialization
	$exe_always picom
	$exe_always flameshot
	$exe_always dunst
	$exe_always xset b off
	$exe_always nitrogen --restore
	# side-left
	$exe_always xrandr --output eDP --primary --mode 1920x1080 --pos 1600x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --off --output DisplayPort-4 --off --output DisplayPort-5 --off --output DisplayPort-6 --off --output DisplayPort-7 --off --output HDMI-1-0 --mode 1600x900 --pos 0x0 --rotate normal
	$exe nm-applet
	$exe_always thunar --daemon
	$exe_always setxkbmap -model abnt -layout us -variant intl
	font pango:FiraCode Mono 9
    '';
  };
}






