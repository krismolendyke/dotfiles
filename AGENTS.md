# Agent Guidelines for `dotfiles`

This repository contains literate programming dotfiles created and maintained in Emacs Org mode. The main entry point for macOS configuration is `index.org`.

## Architecture & Editing Principles

- **Primary Source of Truth**: All configuration logic resides in `index.org` (and `linux.org` for Linux-specific setups).
- **Never Modify Tangled Files Directly**: Do not directly edit files generated in home directories (e.g., `~/.bashrc`, `~/.gitconfig`, `~/.config/*`). Always apply edits to `index.org` within the appropriate Org mode header block and source code blocks.
- **Org Mode Tangling**: Subtrees in `index.org` use properties like `:tangle <path>` and `:mkdirp yes` to define output locations when tangled (`C-c C-v t` in Emacs or via headless command `emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "index.org")'`).
- **Org Mode HTML Export**: Exporting `index.org` to HTML generates `index.html` for GitHub Pages.

## Environment & Tooling Context

- **OS**: macOS
- **Shell**: Homebrew Bash (`/opt/homebrew/bin/bash`), loaded via `~/.bash_profile` -> `~/.bashrc` -> `~/.bashrc.d/*.bash`.
- **Version Control**: Jujutsu (`jj`), colocated with Git. Alias `j="jj"`.
- **Package Management**: Homebrew (`brew bundle`), tangled to `~/.Brewfile`.
- **Editors**: Zed (`zed`) and Emacs (`emacsclient` / `emacs`).
- **Diff Tool**: `difftastic` (`difft`).
- **Secrets**: Stored in `~/.bashrc.d/secret/` (git-ignored).

## AI Agent Configurations Defined in `index.org`

- **Antigravity (AGY)**: Skill distribution to `~/.gemini/config/skills/`.
- **ECA (Editor Code Assistant)**: Configured at `~/.config/eca/config.json` using OpenRouter and Google Gemini providers.
- **Gemini CLI**: Configured at `~/.gemini/settings.json` and `~/.gemini/GEMINI.md`.
- **Claude CLI**: Configured via alias in `~/.bashrc.d/111-claude.bash`.
- **Agent Skills Sync**: `k20e_agent_skills_sync` in `~/.bashrc.d/109-skills.bash` synchronizes skills to Claude, ECA, Gemini CLI, and Antigravity.

## Jujutsu (jj) Guidelines for AI Agents

- **Always prioritize Jujutsu (`jj`)**: This repository uses Jujutsu colocated with Git.
- **Do NOT run raw mutating Git commands**: Avoid `git commit`, `git checkout`, `git rebase`, `git merge`, or `git reset`, which can create detached states or desync with `jj`.
- **Standard JJ Workflow**:
  - Check status: `jj status`
  - View changes: `jj --no-pager diff --git`
  - Describe current revision: `jj desc -m "imperative commit message"`
  - Create new change: `jj new`

## Guidelines for Making Changes

1. **Locate the Target Section**: Find the relevant Org headline in `index.org` corresponding to the tool or shell configuration.
2. **Update Source Blocks**: Edit or append `#+begin_src ... #+end_src` blocks within that Org section.
3. **Verify Header Arguments**: Ensure header args (`:tangle` and `:mkdirp`) match the target destination file paths.
4. **Linting & Validation (Quality Gate)**:
   - Shell scripts and completion snippets should pass `shellcheck`.
   - YAML files should pass `yamllint`.
   - JSON configurations should validate with `jq .`.
5. **Org HTML Export (Required)**:
   - An `(org-export-dispatch &optional ARG)` to HTML of the `index.org` file (generating `index.html`) MUST accompany any and all edits to `index.org` after the quality gate has been passed and immediately before `jj commit` / describing the revision.
   - Interactive (Emacs): `C-c C-e h h`
   - Headless CLI:
     ```bash
     emacs --batch --eval "(require 'org)" --eval "(require 'ox-html)" --eval '(find-file "index.org")' --eval '(org-html-export-to-html)'
     ```
