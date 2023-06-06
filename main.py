import re
import os

# Open the input file and read its contents
with open('hw03.md', 'r') as f:
    input_text = f.read()

# Find all code blocks
code_blocks = re.findall(r'##(.+?)```(.+?)```', input_text, flags=re.DOTALL)

# Filter out code blocks that have the TESTING string in their title
code_blocks = [code.strip() for title, code in code_blocks if 'TESTING' not in title]

# Concatenate the remaining code blocks into a single script
script = '\n'.join(code_blocks)

# Write the script to a file
with open('script.sh', 'w') as f:
    f.write(script)

# Make the script executable
os.chmod('script.sh', 0o755)
