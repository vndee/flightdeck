# ~/.config/fish/config.fish — managed by flightdeck (github.com/vndee/flightdeck)

# --- Homebrew (must be early so PATH is correct in all sessions) ---
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

# --- PATH ---
fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/go/bin
fish_add_path -g $HOME/.cargo/bin

# --- Appearance: flightdeck themes follow the macOS light/dark setting ---
# Detected once per shell. bat & nvim re-detect live via OSC 11; fzf, starship,
# and tmux apply the change on the next new shell / pane / session.
set -l _appearance (defaults read -g AppleInterfaceStyle 2>/dev/null)
if test "$_appearance" = Dark
    set -gx FLIGHTDECK_THEME dark
    set -e STARSHIP_CONFIG  # erase any inherited light path → default starship.toml (mocha)
    # eza: Catppuccin Mocha for dirs/exec/symlink (eza's default bold-blue dir
    # maps to a washed-out bright blue — pin solid colors instead).
    set -gx EZA_COLORS "di=38;2;137;180;250:ex=38;2;166;227;161:ln=38;2;148;226;213"
else
    set -gx FLIGHTDECK_THEME light
    set -gx STARSHIP_CONFIG $HOME/.config/starship-light.toml
    # eza: Catppuccin Latte — solid, high-contrast colors on the light base.
    set -gx EZA_COLORS "di=38;2;30;102;245:ex=38;2;64;160;43:ln=38;2;23;146;153"
end

# --- Environment ---
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx MANPAGER 'nvim +Man!'
set -gx HOMEBREW_NO_ENV_HINTS 1
# bat reads its theme from ~/.config/bat/config (--theme-light/--theme-dark) and
# auto-detects appearance via OSC 11 — no BAT_THEME override here.

# fzf: fd as the source; Catppuccin colors matching the active appearance
set -gx FZF_DEFAULT_COMMAND 'fd --hidden --strip-cwd-prefix --exclude .git'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND 'fd --type=d --hidden --strip-cwd-prefix --exclude .git'
if test "$FLIGHTDECK_THEME" = light
    set -gx FZF_DEFAULT_OPTS "\
--height 60% --layout reverse --border --info inline \
--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
--color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
--color=selected-bg:#bcc0cc --multi"
else
    set -gx FZF_DEFAULT_OPTS "\
--height 60% --layout reverse --border --info inline \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a --multi"
end

# --- Interactive-only setup ---
if status is-interactive
    set -g fish_greeting   # silence greeting

    # Tool initialisation
    starship init fish | source
    zoxide init fish | source
    atuin init fish --disable-up-arrow | source   # keep ↑ for fish history, Ctrl-R for atuin
    fzf --fish | source

    # Source machine-local secrets if present (gitignored)
    test -f $HOME/.config/fish/conf.d/secret.fish; and source $HOME/.config/fish/conf.d/secret.fish
end
