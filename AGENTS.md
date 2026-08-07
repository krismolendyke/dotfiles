# Agent Guidelines for `dotfiles`

This repository contains literate programming dotfiles created and maintained in Emacs Org mode. The main entry point for macOS configuration is `index.org`.

## Architecture & Editing Principles

- **Primary Source of Truth**: All configuration logic resides in `index.org` (and `linux.org` for Linux-specific setups).
- **Never Modify Tangled Files Directly**: Do not directly edit files generated in home directories (e.g., `~/.bashrc`, `~/.gitconfig`, `~/.config/*`). Always apply edits to `index.org` within the appropriate Org mode header block and source code blocks.
- **Org Mode Tangling**: Subtrees in `index.org` use properties like `:tangle <path>` and `:mkdirp yes` to define output locations when tangled (`C-c C-v t` in Emacs).

## Environment & Tooling Context

- **OS**: macOS
- **Shell**: Homebrew Bash (`/opt/homebrew/bin/bash`), loaded via `~/.bash_profile` -> `~/.bashrc` -> `~/.bashrc.d/*.bash`.
- **Version Control**: Jujutsu (`jj`), colocated with Git. Alias `j="jj"`.
- **Package Management**: Homebrew (`brew bundle`), tangled to `~/.Brewfile`.
- **Editors**: Zed (`zed`) and Emacs (`emacsclient` / `emacs`).
- **Diff Tool**: `difftastic` (`difft`).
- **Secrets**: Stored in `~/.bashrc.d/secret/` (git-ignored).

## AI Agent Configurations Defined in `index.org`

- **ECA (Editor Code Assistant)**: Configured at `~/.config/eca/config.json` using OpenRouter and Google Gemini providers.
- **Gemini CLI**: Configured at `~/.gemini/settings.json` and `~/.gemini/GEMINI.md`.
- **Claude CLI**: Configured via alias in `~/.bashrc.d/111-claude.bash`.

## Guidelines for Making Changes

1. **Locate the Target Section**: Find the relevant Org headline in `index.org` corresponding to the tool or shell configuration.
2. **Update Source Blocks**: Edit or append `#+begin_src ... #+end_src` blocks within that Org section.
3. **Verify Header Arguments**: Ensure header args (`:tangle` and `:mkdirp`) match the target destination file paths.
4. **Linting**: Shell scripts and completion snippets should pass `shellcheck`.
