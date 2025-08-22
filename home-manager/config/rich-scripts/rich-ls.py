#!/usr/bin/env python3
"""
Enhanced ls command with Rich formatting
"""
import os
import sys
from pathlib import Path
from datetime import datetime
from rich.console import Console
from rich.table import Table
from rich.text import Text
from rich import box

console = Console()

def format_size(size):
    """Format file size in human-readable format"""
    for unit in ['B', 'KB', 'MB', 'GB']:
        if size < 1024.0:
            return f"{size:.1f}{unit}"
        size /= 1024.0
    return f"{size:.1f}TB"

def get_file_icon(path):
    """Get icon based on file type"""
    if path.is_dir():
        return "📁"
    
    suffix = path.suffix.lower()
    icons = {
        '.py': '🐍',
        '.js': '📜',
        '.ts': '📘',
        '.nix': '❄️',
        '.md': '📝',
        '.txt': '📄',
        '.json': '📊',
        '.yaml': '⚙️',
        '.yml': '⚙️',
        '.sh': '🔧',
        '.bash': '🔧',
        '.git': '🔀',
        '.png': '🖼️',
        '.jpg': '🖼️',
        '.jpeg': '🖼️',
        '.gif': '🖼️',
        '.mp3': '🎵',
        '.mp4': '🎥',
        '.zip': '📦',
        '.tar': '📦',
        '.gz': '📦',
        '.pdf': '📕',
        '.rs': '🦀',
        '.go': '🐹',
        '.cpp': '⚡',
        '.c': '⚡',
        '.h': '⚡',
    }
    return icons.get(suffix, '📄')

def rich_ls(directory="."):
    """List directory contents with rich formatting"""
    path = Path(directory)
    
    if not path.exists():
        console.print(f"[red]Error: {directory} does not exist[/red]")
        return
    
    table = Table(title=f"📂 {path.absolute()}", box=box.ROUNDED)
    table.add_column("Type", style="cyan", no_wrap=True)
    table.add_column("Name", style="bold")
    table.add_column("Size", justify="right", style="green")
    table.add_column("Modified", style="yellow")
    table.add_column("Permissions", style="blue")
    
    items = sorted(path.iterdir(), key=lambda x: (not x.is_dir(), x.name.lower()))
    
    for item in items:
        try:
            stat = item.stat()
            
            # Icon
            icon = get_file_icon(item)
            
            # Name with color coding
            name = item.name
            if item.is_dir():
                name_text = Text(name, style="bold blue")
            elif item.is_symlink():
                name_text = Text(name, style="cyan")
            elif stat.st_mode & 0o111:  # Executable
                name_text = Text(name, style="bold green")
            else:
                name_text = Text(name)
            
            # Size
            size = format_size(stat.st_size) if item.is_file() else "-"
            
            # Modified time
            mtime = datetime.fromtimestamp(stat.st_mtime).strftime("%Y-%m-%d %H:%M")
            
            # Permissions
            mode = stat.st_mode
            perms = ''.join([
                'r' if mode & 0o400 else '-',
                'w' if mode & 0o200 else '-',
                'x' if mode & 0o100 else '-',
                'r' if mode & 0o040 else '-',
                'w' if mode & 0o020 else '-',
                'x' if mode & 0o010 else '-',
                'r' if mode & 0o004 else '-',
                'w' if mode & 0o002 else '-',
                'x' if mode & 0o001 else '-',
            ])
            
            table.add_row(icon, name_text, size, mtime, perms)
            
        except (PermissionError, OSError):
            table.add_row("❌", Text(item.name, style="red"), "?", "?", "?")
    
    console.print(table)
    
    # Summary
    dirs = sum(1 for x in path.iterdir() if x.is_dir())
    files = sum(1 for x in path.iterdir() if x.is_file())
    console.print(f"\n[dim]{dirs} directories, {files} files[/dim]")

if __name__ == "__main__":
    directory = sys.argv[1] if len(sys.argv) > 1 else "."
    rich_ls(directory)