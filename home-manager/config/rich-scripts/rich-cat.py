#!/usr/bin/env python3
"""
Enhanced cat with syntax highlighting using Rich
"""
import sys
from pathlib import Path
from rich.console import Console
from rich.syntax import Syntax
from rich.panel import Panel

console = Console()

def rich_cat(filename):
    """Display file with syntax highlighting"""
    path = Path(filename)
    
    if not path.exists():
        console.print(f"[red]Error: {filename} does not exist[/red]")
        return
    
    if not path.is_file():
        console.print(f"[red]Error: {filename} is not a file[/red]")
        return
    
    try:
        content = path.read_text()
        
        # Determine lexer from file extension
        lexer = "text"
        suffix = path.suffix.lower()
        lexer_map = {
            '.py': 'python',
            '.js': 'javascript',
            '.ts': 'typescript',
            '.nix': 'nix',
            '.sh': 'bash',
            '.bash': 'bash',
            '.zsh': 'zsh',
            '.json': 'json',
            '.yaml': 'yaml',
            '.yml': 'yaml',
            '.md': 'markdown',
            '.rs': 'rust',
            '.go': 'go',
            '.c': 'c',
            '.cpp': 'cpp',
            '.h': 'c',
            '.html': 'html',
            '.css': 'css',
            '.xml': 'xml',
            '.sql': 'sql',
            '.vim': 'vim',
            '.conf': 'ini',
            '.ini': 'ini',
            '.toml': 'toml',
        }
        lexer = lexer_map.get(suffix, 'text')
        
        syntax = Syntax(content, lexer, theme="monokai", line_numbers=True)
        
        console.print(Panel(syntax, title=f"📄 {path.name}", border_style="blue"))
        
    except Exception as e:
        console.print(f"[red]Error reading file: {e}[/red]")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        console.print("[yellow]Usage: rich-cat <filename>[/yellow]")
        sys.exit(1)
    
    for filename in sys.argv[1:]:
        rich_cat(filename)
        if len(sys.argv) > 2:
            console.print()  # Add spacing between files