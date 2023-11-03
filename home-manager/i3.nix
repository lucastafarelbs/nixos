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

	exec --no-startup-id nm-applet
	
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
	# We use variables to avoid repeating the names in multiple places.
	set $ws1 "1"
	set $ws2 "2"
	set $ws3 "3"
	set $ws4 "4"
	set $ws5 "5"
	set $ws6 "6"
	set $ws7 "7"
	set $ws8 "8"
	set $ws9 "9"
	set $ws10 "10"

	# switch to workspace
	bindsym $mod+1 workspace number $ws1
	bindsym $mod+2 workspace number $ws2
	bindsym $mod+3 workspace number $ws3
	bindsym $mod+4 workspace number $ws4
	bindsym $mod+5 workspace number $ws5
	bindsym $mod+6 workspace number $ws6
	bindsym $mod+7 workspace number $ws7
	bindsym $mod+8 workspace number $ws8
	bindsym $mod+9 workspace number $ws9
	bindsym $mod+0 workspace number $ws10

	# move focused container to workspace
	bindsym $mod+Shift+1 move container to workspace number $ws1
	bindsym $mod+Shift+2 move container to workspace number $ws2
	bindsym $mod+Shift+3 move container to workspace number $ws3
	bindsym $mod+Shift+4 move container to workspace number $ws4
	bindsym $mod+Shift+5 move container to workspace number $ws5
	bindsym $mod+Shift+6 move container to workspace number $ws6
	bindsym $mod+Shift+7 move container to workspace number $ws7
	bindsym $mod+Shift+8 move container to workspace number $ws8
	bindsym $mod+Shift+9 move container to workspace number $ws9
	bindsym $mod+Shift+0 move container to workspace number $ws10

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
	set $mode_system System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown
	mode "$mode_system" {
	  bindsym l exec --no-startup-id i3exit lock, mode "default"
	  bindsym e exec --no-startup-id i3exit logout, mode "default"
	  bindsym s exec --no-startup-id i3exit suspend, mode "default"
	  bindsym h exec --no-startup-id i3exit hibernate, mode "default"
	  bindsym r exec --no-startup-id i3exit reboot, mode "default"
	  bindsym Shift+s exec --no-startup-id i3exit shutdown, mode "default"

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


	# Use pactl to adjust volume in PulseAudio.
	set $refresh_i3status killall -SIGUSR1 i3status-rs
	bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
	bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
	bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
	bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status
    '';
  };
}
