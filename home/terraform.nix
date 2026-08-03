{
  home.file = {
    ".terraformrc".text = ''
      plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
    '';

    # Terraform requires the plugin cache directory to exist before `init`.
    ".terraform.d/plugin-cache/.keep".text = "";
  };
}
