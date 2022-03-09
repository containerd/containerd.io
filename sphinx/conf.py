project = 'containerd'
templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']
html_static_path = ['_static']

# Same as our License header.
copyright = 'The contained Authors'
author = 'The containerd Authors'

# MyST (Markedly Structured Text) is a superset of CommonMark.
# https://myst-parser.readthedocs.io/en/latest/
extensions = [ 'myst_parser' ]

# Uses Furo.
# https://github.com/pradyunsg/furo
html_theme = 'furo'