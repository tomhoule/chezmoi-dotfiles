# edit_command.fish — Ctrl-X Ctrl-E to edit the current command line in $EDITOR
#
# On macOS, fish's default Alt-E / Alt-V bindings for edit_command_buffer are
# unreliable because most terminals (Terminal.app, iTerm2, Ghostty, **Zed**) either
# swallow the Option key or map it to special characters.
#
# Ctrl-X Ctrl-E is the classic bash/readline equivalent and works everywhere.
# It opens the current command line in $EDITOR (set in custom.fish); when you
# save and quit, the edited text replaces the command line.

if status is-interactive
    bind \cx\ce edit_command_buffer
end
