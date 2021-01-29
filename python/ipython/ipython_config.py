c = get_config()

c.InteractiveShell.automagic = False

c.InteractiveShellApp.exec_lines = [
    '%automagic',
    '%automagic',
    '%load_ext autoreload',
    '%autoreload 2',
    'import numpy as np',
    'import matplotlib',
    'matplotlib.use("TkAgg")',
    'import matplotlib.pyplot as plt',
    'import pandas as pd',
    'plt.ion()'
]

c.InteractiveShell.colors = 'LightBG'
c.InteractiveShell.editor = 'nano'
