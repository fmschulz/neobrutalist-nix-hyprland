{ config, pkgs, lib, ... }:

{
  programs.yazi = {
    enable = true;
    enableBashIntegration = false;  # We handle this in custom bashrc
  };
  
  # Create yazi configuration files manually to avoid home-manager compatibility issues
  home.file = {
    ".config/yazi/yazi.toml".text = ''
      [mgr]
      show_hidden = false
      sort_by = "alphabetical"
      sort_sensitive = false
      sort_reverse = false
      sort_dir_first = true
      linemode = "none"
      show_symlink = true
      
      [preview]
      tab_size = 2
      max_width = 1000
      max_height = 1000
    '';
    
    ".config/yazi/keymap.toml".text = ''
      [[manager.prepend_keymap]]
      on = ["<C-n>"]
      run = "shell 'touch \"$0\"' --confirm"
      desc = "Create a new file"
      
      [[manager.prepend_keymap]]
      on = ["a"]
      run = "shell 'mkdir \"$0\"' --confirm"
      desc = "Create a new directory"
      
      [[manager.prepend_keymap]]
      on = ["<C-p>"]
      run = "shell 'glow \"$0\"' --block --confirm"
      desc = "Preview markdown file"
      
      [[manager.prepend_keymap]]
      on = ["<Enter>"]
      run = "plugin --sync smart-enter"
      desc = "Enter the child directory, or open the file"
      
      [[manager.prepend_keymap]]
      on = ["e"]
      run = "shell 'nano \"$0\"' --block --confirm"
      desc = "Edit with nano"
    '';
    
    ".config/yazi/theme.toml".text = ''
      [mgr]
      cwd = { fg = "#FFFFFF", bg = "#4D4D4D", bold = true }
      
      hovered = { fg = "#2D2D2D", bg = "#06FFA5", bold = true }
      preview_hovered = { underline = true }
      
      find_keyword = { fg = "#2D2D2D", bg = "#06FFA5", bold = true }
      find_position = { fg = "#06FFA5", bg = "#4D4D4D", bold = true }
      
      marker_selected = { fg = "#06FFA5", bg = "#2D2D2D", bold = true }
      marker_copied = { fg = "#FFB700", bg = "#2D2D2D", bold = true }
      marker_cut = { fg = "#FF006E", bg = "#2D2D2D", bold = true }
      
      tab_active = { fg = "#FFFFFF", bg = "#FF006E", bold = true }
      tab_inactive = { fg = "#FFFFFF", bg = "#4D4D4D" }
      tab_width = 1
      
      border_symbol = "│"
      border_style = { fg = "#FFFFFF" }
      
      [status]
      separator_open = ""
      separator_close = ""
      separator_style = { fg = "#FFFFFF", bg = "#4D4D4D" }
      
      mode_normal = { fg = "#FFFFFF", bg = "#4D4D4D", bold = true }
      mode_select = { fg = "#FFFFFF", bg = "#FF006E", bold = true }
      mode_unset = { fg = "#FFFFFF", bg = "#3185FC", bold = true }
      
      progress_label = { bold = true }
      progress_normal = { fg = "#06FFA5", bg = "#2D2D2D" }
      progress_error = { fg = "#FF006E", bg = "#2D2D2D" }
      
      permissions_t = { fg = "#3185FC" }
      permissions_r = { fg = "#FFB700" }
      permissions_w = { fg = "#FF006E" }
      permissions_x = { fg = "#06FFA5" }
      permissions_s = { fg = "#B14AFF" }
      
      [input]
      border = { fg = "#FF006E" }
      title = { fg = "#FF006E" }
      value = { fg = "#FFFFFF" }
      selected = { bg = "#4D4D4D" }
      
      [select]
      border = { fg = "#FF006E" }
      active = { fg = "#FF006E" }
      inactive = { fg = "#FFFFFF" }
      
      [tasks]
      border = { fg = "#FF006E" }
      title = { fg = "#FF006E" }
      hovered = { underline = true }
      
      [which]
      mask = { bg = "#000000" }
      cand = { fg = "#06FFA5" }
      rest = { fg = "#B14AFF" }
      desc = { fg = "#FF006E" }
      separator_style = { fg = "#4D4D4D" }
      
      [help]
      on = { fg = "#06FFA5" }
      exec = { fg = "#3185FC" }
      desc = { fg = "#000000" }
      hovered = { bg = "#FFB700", bold = true }
      footer = { fg = "#000000", bg = "#FFBE0B" }
      
      [filetype]
      rules = [
        { mime = "image/*", fg = "#06FFA5" },
        { mime = "video/*", fg = "#B14AFF" },
        { mime = "audio/*", fg = "#FFB700" },
        { mime = "application/zip", fg = "#FF006E" },
        { mime = "application/gzip", fg = "#FF006E" },
        { mime = "application/x-bzip", fg = "#FF006E" },
        { mime = "application/x-bzip2", fg = "#FF006E" },
        { mime = "application/x-tar", fg = "#FF006E" },
        { mime = "application/x-7z-compressed", fg = "#FF006E" },
        { mime = "application/x-rar", fg = "#FF006E" },
        
        { name = "*", is = "orphan", fg = "#FF006E" },
        { name = "*", is = "link", fg = "#3185FC" },
        { name = "*", is = "block", fg = "#FFB700", bg = "#000000" },
        { name = "*", is = "char", fg = "#06FFA5", bg = "#000000" },
        { name = "*", is = "fifo", fg = "#B14AFF", bg = "#000000" },
        { name = "*", is = "sock", fg = "#FF006E", bg = "#000000" },
        { name = "*", is = "sticky", fg = "#FFB700" },
        { name = "*", is = "exec", fg = "#06FFA5", bold = true },
        
        { name = "*/", fg = "#3185FC", bold = true },
      ]
    '';
    
    ".config/yazi/open.toml".text = ''
      # Text files
      [[open.rules]]
      mime = "text/*"
      use = "edit"
      
      # Image files
      [[open.rules]]
      mime = "image/*"
      use = "image"
      
      # PDF files
      [[open.rules]]
      mime = "application/pdf"
      use = "pdf"
      
      # Video files
      [[open.rules]]
      mime = "video/*"
      use = "video"
      
      # Audio files
      [[open.rules]]
      mime = "audio/*"
      use = "audio"
      
      [open.opener.edit]
      run = 'nano "$@"'
      block = true
      
      [open.opener.image]
      run = 'imv "$@"'
      orphan = true
      
      [open.opener.pdf]
      run = 'zathura "$@"'
      orphan = true
      
      [open.opener.video]
      run = 'mpv "$@"'
      orphan = true
      
      [open.opener.audio]
      run = 'mpv "$@"'
      orphan = true
    '';
  };
}