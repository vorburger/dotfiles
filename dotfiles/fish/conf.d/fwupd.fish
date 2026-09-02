if status is-interactive
  # Because checking for updates can add a slight delay to shell startup,
  # we only check once a day.
  set -l today (date +%Y-%m-%d)
  set -l daily_flag_file ~/.daily_fwupd

  # Check if the flag file DOES NOT exist OR the last run date DOES NOT match today's date
  if not test -f $daily_flag_file; or not test (date -r $daily_flag_file +%Y-%m-%d) = $today
    if type -q fwupdmgr
      # fwupdmgr get-updates exits with 0 if updates are available, 2 if not.
      # Do NOT use --json here: with --json, fwupdmgr exits with 0 even when
      # no updates are available (returning an empty JSON object {"Devices": []}).
      # Redirect both stdout and stderr to /dev/null.
      fwupdmgr get-updates --no-authenticate >/dev/null 2>&1
      if test $status -eq 0
        echo
        set_color yellow
        echo "⚠️  Firmware updates are available! Run 'fwupdmgr update' to install them."
        set_color normal
      end
    end

    # Update daily flag file
    date +%Y-%m-%d > $daily_flag_file
  end
end
