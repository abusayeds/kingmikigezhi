from pathlib import Path
from PIL import Image

folder = Path(r"C:\Alithim\Event-Sharing\docs\testing_report\screenshots\user")
for p in sorted(folder.glob("*.png")):
    im = Image.open(p)
    print(f"{p.name}\t{im.size}\t{p.stat().st_size}")
