import glob
import subprocess
import os
import sys

migrations = sorted(glob.glob("migrations/*.sql"))
env = os.environ.copy()
env['PGPASSWORD'] = 'postgres'

for m in migrations:
    print(f"Applying {m}...")
    res = subprocess.run(["psql", "-h", "127.0.0.1", "-p", "54322", "-U", "postgres", "-d", "postgres", "-f", m], env=env, capture_output=True, text=True)
    if res.returncode != 0:
        print(f"Error applying {m}:\n{res.stderr}")
        sys.exit(1)

print("All migrations applied successfully!")
