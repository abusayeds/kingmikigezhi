from pathlib import Path
from PIL import Image

folder = Path(r"C:\Alithim\Event-Sharing\docs\testing_report\screenshots\user")
for name in [
    "Screenshot_20261029_171557.png",
    "Screenshot_20261029_171603.png",
    "Screenshot_20261029_171623.png",
    "Screenshot_20261029_171719.png",
    "Screenshot_20261029_171351.png",
    "Screenshot_20261029_171342.png",
    "Screenshot_20261029_171335.png",
]:
    p = folder / name
    if p.exists():
        im = Image.open(p)
        print(f"{name}\t{im.size}\t{p.stat().st_size}")
    else:
        print(f"MISSING {name}")
