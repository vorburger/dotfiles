# Linux Power / Energy Savings Management

## Background

The Linux Kernel can manage power consumption of the hardware it controls through various knobs.

There are a few popular tools which configure the Kernel appropriately to save power e.g. on a laptop running on battery.

This article is about power when running, [there is another one about suspend](suspend.md).

## Measure Power Consumption

Like any such thing, it's much easier (and fun) to optimize something you can actually measure.

One way to do this is using GNOME's _Power Statistics_ GUI. You can install it using e.g. `sudo dnf install gnome-power-manager` ([source](https://gitlab.gnome.org/GNOME/gnome-power-manager/)). Clicking e.g. on _Laptop battery_ on the left will show you the current _Rate_. The _Energy when full_ -VS- _Energy (design)_ will show you how your "new" battery still is (they degrade over time). (`upower --dump` can show some similar information on the CLI.) On the _History_ tab,the _Graph type: Time to empty_ (for a given _Data length: N hours_) lets you see the predicted battery time remaining; this graph view over time gives a better view than the single "snapshot in time" remaining duration shown on the Power section in the GNOME Setings.

[batstat](https://github.com/Juve45/batstat) is a similar tool for the CLI, and [powerstat](https://github.com/ColinIanKing/powerstat), which can be easily installed [on Fedora using Snap](https://snapcraft.io/install/powerstat/fedora) is another such tool. (It focuses on measuring power consumption while a laptop is on battery; when plugged in it will refuse to start, saying: _"Device is not discharging, cannot measure power usage. Perhaps re-run with -z (ignore zero power) or -R (RAPL)"._ Run it WITHOUT `sudo`, as with it it failed with _socket failed: errno=1 (Operation not permitted)`, for me.)

## power-profile-switcher

To automatically switch Power Settings from Performance to Balanced or Power Saver when on Battery,
install [the GNOME `power-profile-switcher` extension](https://extensions.gnome.org/extension/5575/power-profile-switcher/)
(see [GitHub](https://github.com/eliapasquali/power-profile-switcher), and a [related article](https://fostips.com/auto-switch-cpu-performance-powersaver-linux/)).

Installation [might require](https://gnome.pages.gitlab.gnome.org/gnome-browser-integration/pages/installation-guide.html) Firefox, and not work on Chrome-like Browser.

It's broken on Fedora 42+ because of a too new GNOME version, but maybe fixing that [is as easy as this](https://github.com/eliapasquali/power-profile-switcher/commit/16c45736fad7cbb0c53e4ecc1e4b5e2a2b602cd7)? But fixing it may just lead to https://github.com/eliapasquali/power-profile-switcher/issues/36? (Likely, as I'm also already seeing that error when clicking on its Settings.)

GNOME won't implement this, see https://gitlab.gnome.org/GNOME/gnome-control-center/-/issues/1600.

https://gitlab.com/EikoTsukida/power-profiles-automation is a simple alternative. (TODO integrate into here my dotfiles, make it a Nix config; blog about it.) https://gitlab.gnome.org/gnumdk/power-profile-selector is another, but looks more (too) complicated.

[TLP also does this](https://linrunner.de/tlp/settings/processor.html#cpu-energy-perf-policy-on-ac-bat) anyways.

## auto-cpufreq

TODO To automate CPU speed & power further than _performance/balanced/safer,_ consider using https://github.com/AdnanHodzic/auto-cpufreq?

## Recommended: TLP - Optimize Linux Laptop Battery Life

_TODO, clarify: I used to use this on a Laptop, but ended up removing it, and going back to `power-profiles-daemon` because it seemed to prevent max. CPU frequency even when plugged in and under heavy load?_

[TLP](https://github.com/linrunner/TLP) is easy to [install on many Linux distros](https://linrunner.de/tlp/installation/index.html):

    dnf install tlp
    dnf remove power-profiles-daemon
    sudo systemctl enable --now tlp.service

I've decided not to install / use the [Radio Device Wizard (`tlp-rdw`)](https://linrunner.de/tlp/settings/rdw.html) and keep that manual.

[TLPUI can be installed via Flatpack](https://flathub.org/apps/details/com.github.d4nj1.tlpui) to make tweaks later.

## CPU

```bash
sudo cpupower frequency-info
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
sudo cpupower frequency-set --governor performance
sudo cpupower frequency-set --governor powersave
```

## Graphics GPUs

Intel:

    sudo dnf install igt-gpu-tools
    sudo intel_gpu_top

NVIDIA:

    sudo dnf install nvtop
    nvtop

## Battery Care / re-charging thresholds

* https://www.linrunner.de/tlp/faq/battery.html
* https://linrunner.de/tlp/settings/battery.html
* https://extensions.gnome.org/extension/4798/thinkpad-battery-threshold/
* https://extensions.gnome.org/extension/5724/battery-health-charging/

## Other Tools (Not Recommended / Required)

### Power Profiles

The _Power Saver / Balanced / Performance_ that is available e.g. in GNOME [out-of-the-box e.g. since Fedora 35](https://fedoraproject.org/wiki/Changes/Power_Profiles_Daemon) from the menu in the upper right hand corner of the screen and in GNOME Settings > Power uses the [power-profiles-daemon](https://gitlab.freedesktop.org/hadess/power-profiles-daemon) (over D-Bus) to set these. It's also available on the CLI as `powerprofilesctl`.

These are relatively "coarse grained" profiles - and require a user to remember to manually change them when going on and off charging - which is not ideal. (It would, of course, be possible to script automate this with home made scripts.) They interfere with TLP, and we've disabled them during the installation of TLP above.

### Powertop

[powertop](https://github.com/fenrus75/powertop) shows which processes and Kernel events consume power. (The total Watts is also shown on the Device Info tab.) `sudo powertop --html=report.html` produces a HTML report which can be easily shared.

After `sudo powertop --calibrate`, or just running for a while, Power Estimates in Watt will start to show up.

It has a _Tunables_ section which recommendations for PCIe devices. Powertop is not aware of if the laptop runs on battery or not. Changes made there do not persist over a reboot, but it's possible to launch `powertop --auto-tune` at every system boot, e.g. with systemd:

    sudo systemctl enable --now powertop.service
    sudo systemctl status powertop.service

TLP fixes Powertop's _Tunables_ recommendations ([ignore the _VM writeback timeout_](https://linrunner.de/tlp/faq/powertop.html)).

### fatrace

[fatrace](https://github.com/martinpitt/fatrace) comes with `power-usage-report` which provides similar information to `powertop` but as CSV.

### Laptop Mode Tools

The https://github.com/rickysarraf/laptop-mode-tools,
also documented e.g. on https://wiki.archlinux.org/title/Laptop_Mode_Tools,
are an alternative to TLP.

It's older than TLP, has less Stars on GitHub, and no Fedora package.

### thermald? throttled?

Probably not required / useful anymore with the `intel_pstate` driver.

### konkor/cpufreq

https://github.com/konkor/cpufreq looks neat - but it's manual; automation with `power-profile-switcher` and `auto-cpufreq` is better!

## Further Resources

* https://wiki.archlinux.org/title/Power_management
* https://fedoramagazine.org/saving-laptop-power-with-powertop/
* https://www.thinkwiki.org/wiki/How_to_reduce_power_consumption - outdated

