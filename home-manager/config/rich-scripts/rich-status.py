#!/usr/bin/env python3
"""
System status dashboard with Rich
"""
import psutil
import platform
from datetime import datetime
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich.layout import Layout
from rich.progress import Progress, BarColumn, TextColumn
from rich.text import Text
from rich import box

console = Console()

def get_size(bytes):
    """Convert bytes to human readable format"""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes < 1024.0:
            return f"{bytes:.2f}{unit}"
        bytes /= 1024.0
    return f"{bytes:.2f}PB"

def create_progress_bar(percentage, width=20):
    """Create a text-based progress bar"""
    filled = int(width * percentage / 100)
    bar = '█' * filled + '░' * (width - filled)
    if percentage >= 80:
        color = "red"
    elif percentage >= 60:
        color = "yellow"
    else:
        color = "green"
    return Text(f"{bar} {percentage:.1f}%", style=color)

def system_info():
    """Get system information"""
    uname = platform.uname()
    boot_time = datetime.fromtimestamp(psutil.boot_time())
    
    table = Table(show_header=False, box=None)
    table.add_column("Key", style="cyan")
    table.add_column("Value", style="white")
    
    table.add_row("System", f"{uname.system} {uname.release}")
    table.add_row("Node", uname.node)
    table.add_row("Machine", uname.machine)
    table.add_row("Processor", platform.processor() or "Unknown")
    table.add_row("Boot Time", boot_time.strftime("%Y-%m-%d %H:%M:%S"))
    table.add_row("Uptime", str(datetime.now() - boot_time).split('.')[0])
    
    return Panel(table, title="🖥️  System Information", border_style="blue")

def cpu_info():
    """Get CPU information"""
    cpu_freq = psutil.cpu_freq()
    cpu_percent = psutil.cpu_percent(interval=1, percpu=True)
    
    table = Table(show_header=False, box=None)
    table.add_column("Metric", style="cyan")
    table.add_column("Value", style="white")
    
    table.add_row("Physical Cores", str(psutil.cpu_count(logical=False)))
    table.add_row("Total Cores", str(psutil.cpu_count(logical=True)))
    table.add_row("Current Frequency", f"{cpu_freq.current:.2f} MHz")
    table.add_row("Min Frequency", f"{cpu_freq.min:.2f} MHz")
    table.add_row("Max Frequency", f"{cpu_freq.max:.2f} MHz")
    
    # Per-core usage
    for i, percentage in enumerate(cpu_percent):
        table.add_row(f"Core {i}", create_progress_bar(percentage))
    
    avg_cpu = sum(cpu_percent) / len(cpu_percent)
    table.add_row("Average", create_progress_bar(avg_cpu))
    
    return Panel(table, title="⚡ CPU Information", border_style="yellow")

def memory_info():
    """Get memory information"""
    svmem = psutil.virtual_memory()
    swap = psutil.swap_memory()
    
    table = Table(show_header=False, box=None)
    table.add_column("Type", style="cyan")
    table.add_column("Usage", style="white")
    
    table.add_row("RAM Total", get_size(svmem.total))
    table.add_row("RAM Used", f"{get_size(svmem.used)} ({svmem.percent}%)")
    table.add_row("RAM Available", get_size(svmem.available))
    table.add_row("RAM", create_progress_bar(svmem.percent))
    
    table.add_row("", "")  # Spacer
    
    table.add_row("Swap Total", get_size(swap.total))
    table.add_row("Swap Used", f"{get_size(swap.used)} ({swap.percent}%)")
    table.add_row("Swap Free", get_size(swap.free))
    table.add_row("Swap", create_progress_bar(swap.percent))
    
    return Panel(table, title="💾 Memory Information", border_style="green")

def disk_info():
    """Get disk information"""
    table = Table(box=box.SIMPLE)
    table.add_column("Mount", style="cyan")
    table.add_column("Total", style="white")
    table.add_column("Used", style="yellow")
    table.add_column("Free", style="green")
    table.add_column("Usage", style="white")
    
    partitions = psutil.disk_partitions()
    for partition in partitions:
        if partition.mountpoint in ['/', '/home', '/boot']:
            try:
                usage = psutil.disk_usage(partition.mountpoint)
                table.add_row(
                    partition.mountpoint,
                    get_size(usage.total),
                    get_size(usage.used),
                    get_size(usage.free),
                    create_progress_bar(usage.percent)
                )
            except PermissionError:
                continue
    
    return Panel(table, title="💿 Disk Usage", border_style="magenta")

def network_info():
    """Get network information"""
    net_io = psutil.net_io_counters()
    
    table = Table(show_header=False, box=None)
    table.add_column("Metric", style="cyan")
    table.add_column("Value", style="white")
    
    table.add_row("Bytes Sent", get_size(net_io.bytes_sent))
    table.add_row("Bytes Received", get_size(net_io.bytes_recv))
    table.add_row("Packets Sent", f"{net_io.packets_sent:,}")
    table.add_row("Packets Received", f"{net_io.packets_recv:,}")
    table.add_row("Errors In", str(net_io.errin))
    table.add_row("Errors Out", str(net_io.errout))
    table.add_row("Drop In", str(net_io.dropin))
    table.add_row("Drop Out", str(net_io.dropout))
    
    return Panel(table, title="🌐 Network Statistics", border_style="cyan")

def main():
    """Main dashboard"""
    console.clear()
    
    # Create layout
    console.print(Panel.fit(
        f"[bold cyan]System Status Dashboard[/bold cyan]\n"
        f"[dim]{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}[/dim]",
        border_style="blue"
    ))
    
    # Display all panels
    console.print(system_info())
    console.print(cpu_info())
    console.print(memory_info())
    console.print(disk_info())
    console.print(network_info())

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        console.print("\n[yellow]Dashboard closed[/yellow]")