import re
import sys

def convert_copy_to_insert(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    out_lines = []
    in_copy = False
    table_name = ""
    columns = ""

    # Regex to match the COPY statement
    copy_re = re.compile(r'^COPY\s+(.+?)\s+\((.+?)\)\s+FROM\s+stdin;')

    for line in lines:
        stripped = line.strip('\r\n')

        if not in_copy:
            match = copy_re.match(stripped)
            if match:
                in_copy = True
                table_name = match.group(1)
                columns = match.group(2)
                # Don't output the COPY line
            else:
                out_lines.append(stripped)
        else:
            if stripped == '\\.':
                in_copy = False
                # Don't output the \. line
            else:
                # Parse the data line
                # Columns are separated by tab
                vals = stripped.split('\t')
                sql_vals = []
                for v in vals:
                    if v == '\\N':
                        sql_vals.append('NULL')
                    else:
                        # In PostgreSQL COPY format, characters are escaped with \
                        # like \n, \t, \\, etc. Single quotes are not escaped.
                        # For INSERT, we can use standard string literals if we escape single quotes.
                        # However, since the string might contain \n or \\ from the COPY format,
                        # we can use PostgreSQL escape string syntax E'...'
                        # First, we escape single quotes for the SQL string
                        v = v.replace("'", "''")
                        # We don't need to unescape COPY's backslashes if we use E'...'
                        # because E'...' will interpret \\ as \ and \n as newline, exactly as COPY did!
                        sql_vals.append(f"E'{v}'")
                
                insert_stmt = f"INSERT INTO {table_name} ({columns}) VALUES ({', '.join(sql_vals)});"
                out_lines.append(insert_stmt)

    with open(output_file, 'w', encoding='utf-8', newline='\n') as f:
        f.write('\n'.join(out_lines) + '\n')
    print(f"Converted file saved to {output_file}")

if __name__ == "__main__":
    convert_copy_to_insert('f:\\qlyphongtro\\sql\\backups.sql', 'f:\\qlyphongtro\\sql\\backups_inserts.sql')
