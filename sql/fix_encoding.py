with open('backups_inserts.sql', 'rb') as f:
    raw_data = f.read()

# Decode with replacement
text = raw_data.decode('utf-8', errors='replace')

# The replacement character is usually \ufffd.
# Let's replace "Ph\ufffdng" with "Phòng"
text = text.replace('Ph\ufffdng', 'Phòng')
text = text.replace('M\ufffdy', 'Máy')
text = text.replace('t\ufffdnh', 'tính')

# In case there are other \ufffd characters, let's just leave them or they will still be valid UTF-8
with open('backups_inserts_fixed.sql', 'w', encoding='utf-8') as f:
    f.write(text)
