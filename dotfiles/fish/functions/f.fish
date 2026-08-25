function f --description "RipGrep (with Paging)"
    rg -p $argv | less -R -q
end
