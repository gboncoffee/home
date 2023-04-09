import readline, sys, os
from math import *

readline.write_history_file = lambda *args: None

sys.ps1 = "> "
sys.ps2 = ": "

print("\033[1;35mmath is at the global namespace. sys and os are imported too.\033[m")
