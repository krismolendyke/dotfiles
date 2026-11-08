set default-list := true
set shell := ["bash", "-euo", "pipefail", "-c"]

# `emacs` in an interactive shell is an alias, which `just` cannot see.
emacs := env("EMACS", "/opt/homebrew/bin/emacs")

# Tangle index.org to generate configuration files
tangle:
    rm -f ~/.bashrc.d/*.bash "$HOME/Library/Application Support/nushell/autoload/"*.nu
    {{ emacs }} --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "index.org")'

# Validate tangled shell, YAML, and JSON configuration files
check:
    shellcheck ~/.bash_profile ~/.bashrc ~/.bashrc.d/*.bash ~/.local/bin/k20e-skills-sync
    yamllint ~/.config/eza/theme.yml ~/Library/Preferences/glow/glow.yml ~/.config/yamllint/config
    jq empty ~/.config/eca/config.json ~/.gemini/antigravity-cli/keybindings.json ~/.gemini/settings.json

# The export config in ~/.emacs.d only sets up the HTML styling, so a batch
# Emacs also needs the packages activated and `nu-ts-mode` registered for
# `nu` blocks.  Without them the major modes for YAML, Markdown, gitignore,
# Nushell, etc. are missing and source blocks lose their syntax highlighting.

# Export index.org to the styled index.html that GitHub Pages serves
publish:
    {{ emacs }} --batch \
        --eval '(package-initialize)' \
        --load ~/.emacs.d/elisp/k20e-org-html-export.el \
        --eval '(require (quote nu-ts-mode) nil t)' \
        --eval '(add-to-list (quote org-src-lang-modes) (quote ("nu" . nu-ts)))' \
        --visit index.org \
        --execute '(org-html-export-to-html)'
