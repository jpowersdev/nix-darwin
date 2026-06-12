{ ... }:
{
  xdg.configFile."ghostty/config".text = ''
    # Navigate Ghostty splits with Ctrl+h/j/k/l (Vim directions)
    keybind = ctrl+h=goto_split:left
    keybind = ctrl+j=goto_split:down
    keybind = ctrl+k=goto_split:up
    keybind = ctrl+l=goto_split:right

    # Create Ghostty splits
    keybind = ctrl+shift+l=new_split:right
    keybind = ctrl+shift+j=new_split:down

    # Close current Ghostty split
    keybind = ctrl+shift+w=close_surface
  '';
}
