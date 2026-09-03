# /etc/starship.toml is created in symlink-homefree.sh

test -f /etc/starship.toml && set -gx STARSHIP_CONFIG /etc/starship.toml

command -q starship && starship init fish | source
