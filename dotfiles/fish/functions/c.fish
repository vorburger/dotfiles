function c --description "Use glow for Markdown files, fallback to bat"
    if test (count $argv) -eq 0
        if command -sq batcat; batcat; else if command -sq bat; bat; else; cat; end
        return
    end

    # Check if all arguments are Markdown files
    set -l all_md true
    for arg in $argv
        if not string match -q -i "*.md" "$arg"
            set all_md false
            break
        end
    end

    if test "$all_md" = true; and command -sq glow
        for arg in $argv
            glow -p "$arg"
        end
    else if command -sq batcat
        batcat $argv
    else if command -sq bat
        bat $argv
    else
        cat $argv
    end
end
