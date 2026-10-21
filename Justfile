set default-list := true
set shell := ["bash", "-euo", "pipefail", "-c"]

# `emacs` in an interactive shell is an alias, which `just` cannot see.
emacs := env("EMACS", "/opt/homebrew/bin/emacs")

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
