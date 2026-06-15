import sys

def fix_dot(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = content.splitlines()
    fixed_lines = []
    in_copy = False
    
    for line in lines:
        stripped = line.strip('\r\n')
        
        if stripped.startswith('COPY ') and 'FROM stdin;' in stripped:
            if in_copy: # if we were already in a copy, we missed a dot!
                fixed_lines.append('\\.')
            in_copy = True
            fixed_lines.append(stripped)
        elif in_copy:
            # check if end of block
            if stripped == '\\.' or stripped == ' ' or stripped == '':
                fixed_lines.append('\\.')
                in_copy = False
            elif stripped.startswith('--'):
                # just in case it hit comments without ending
                fixed_lines.append('\\.')
                in_copy = False
                fixed_lines.append(stripped)
            else:
                fixed_lines.append(stripped)
        else:
            if stripped == '\\.' or stripped == ' ':
                continue # ignore rogue dots or spaces outside COPY blocks
            fixed_lines.append(stripped)

    if in_copy:
        fixed_lines.append('\\.')

    with open(file_path, 'w', encoding='utf-8', newline='\n') as f:
        f.write('\n'.join(fixed_lines) + '\n')

if __name__ == "__main__":
    fix_dot('f:\\qlyphongtro\\sql\\backups.sql')
