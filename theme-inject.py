#!/usr/bin/env python3
"""Modern CSS injection for Typst HTML export."""

import sys

def inject_theme(html_file, css_file, output_file):
    # Read HTML and CSS
    with open(html_file, 'r') as f:
        html = f.read()
    
    with open(css_file, 'r') as f:
        css = f.read()
    
    # Inject CSS into HTML head
    styled_html = html.replace(
        '</head>',
        f'  <style>\n{css}\n  </style>\n</head>'
    )
    
    # Write themed HTML
    with open(output_file, 'w') as f:
        f.write(styled_html)
    
    print(f'✨ Modern theme applied: {output_file}')

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print('Usage: python3 theme-inject.py input.html theme.css output.html')
        sys.exit(1)
    
    inject_theme(sys.argv[1], sys.argv[2], sys.argv[3])