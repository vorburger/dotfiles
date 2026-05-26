# venv is (must be) a function instead of a bash or fish script,
# because it has to source the venv activate script which sets
# environment variables that need to be kept visible.

function venv -a DIR -d "Create or Enter Python Virtual Environment"
  if not set -q argv[1]
    set DIR ".venv"
  end

  if [ ! -d "$DIR" ]
    python3 -m venv "$DIR"
  end

  source "$DIR/bin/activate.fish"
end

function venv_activate_try -a DIR
  # echo Checking if "$DIR/bin/activate.fish" exists...
  if [ -e "$DIR/bin/activate.fish" ]
    set -l abs_dir (realpath "$DIR")
    if not set -q VIRTUAL_ENV; or [ "$VIRTUAL_ENV" != "$abs_dir" ]
      set_color -i -u -d magenta
      echo "Activating Python 🥽 Virtual Env for Fish Shell"
      source "$DIR/bin/activate.fish"
    end
  end
end

# NOT: function on_pwd_venv --on-variable PWD
function on_fish_prompt_venv --on-event fish_prompt
  venv_activate_try "$PWD/🥽"
  venv_activate_try "$PWD/.venv"
end
