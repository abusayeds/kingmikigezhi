"""Feature Matrix PDF — Pass/Pass status, no Backend API section, no gallery."""

from pathlib import Path

from PIL import Image as PILImage
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.platypus import Image, Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle

ROOT = Path(__file__).resolve().parent
USER = ROOT / "screenshots" / "user"
THUMB_DIR = ROOT / "_pdf_thumbs"
OUT = ROOT / "DaiWaBuYi_Feature_Overview.pdf"

HEADER_BG = colors.HexColor("#3D6B82")
PRIMARY = colors.HexColor("#5A859E")
PASS_BG = colors.HexColor("#E6F4EA")
PASS_FG = colors.HexColor("#137333")
ROW_ALT = colors.HexColor("#F3F7F9")
BORDER = colors.HexColor("#C5D4DC")
TEXT = colors.HexColor("#1F2933")


def styles():
    base = getSampleStyleSheet()
    return {
        "h1": ParagraphStyle(
            "H1", parent=base["Heading1"], fontSize=13, textColor=HEADER_BG,
            spaceBefore=4, spaceAfter=8,
        ),
        "cell": ParagraphStyle(
            "C", parent=base["Normal"], fontSize=7.5, textColor=TEXT, leading=10, alignment=TA_LEFT,
        ),
        "head": ParagraphStyle(
            "CH", parent=base["Normal"], fontSize=8, textColor=colors.white,
            leading=10, alignment=TA_CENTER, fontName="Helvetica-Bold",
        ),
        "pass": ParagraphStyle(
            "P", parent=base["Normal"], fontSize=9, textColor=PASS_FG,
            leading=11, alignment=TA_CENTER, fontName="Helvetica-Bold",
        ),
    }


def p(text, style):
    return Paragraph(str(text).replace("\n", "<br/>"), style)


def thumb(path: Path, max_h=900) -> Path | None:
    if not path.exists():
        return None
    THUMB_DIR.mkdir(parents=True, exist_ok=True)
    out = THUMB_DIR / f"{path.stem}_{max_h}.jpg"
    if out.exists() and out.stat().st_mtime >= path.stat().st_mtime:
        return out
    with PILImage.open(path) as im:
        im = im.convert("RGB")
        w, h = im.size
        if h > max_h:
            r = max_h / h
            im = im.resize((max(1, int(w * r)), max_h), PILImage.Resampling.LANCZOS)
        im.save(out, "JPEG", quality=80, optimize=True)
    return out


def fit_image(path: Path, max_w: float, max_h: float):
    t = thumb(path)
    if not t:
        return None
    with PILImage.open(t) as im:
        w, h = im.size
    scale = min(max_w / w, max_h / h, 1.0)
    return Image(str(t), width=w * scale, height=h * scale)


def feature_table(rows, st, widths):
    # Key Features | Frontend | Pass | Screenshot
    data = [[
        p("Key Features", st["head"]),
        p("Frontend", st["head"]),
        p("Pass", st["head"]),
        p("Screenshot", st["head"]),
    ]]
    for feature, frontend, shot in rows:
        img = fit_image(shot, widths[3] - 6, 86) if shot else None
        data.append([
            p(feature, st["cell"]),
            p(frontend, st["cell"]),
            p("Pass", st["pass"]),
            img if img else p("—", st["cell"]),
        ])

    table = Table(data, colWidths=widths, repeatRows=1)
    cmds = [
        ("BACKGROUND", (0, 0), (-1, 0), HEADER_BG),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("ALIGN", (2, 1), (2, -1), "CENTER"),
        ("ALIGN", (3, 1), (3, -1), "CENTER"),
        ("GRID", (0, 0), (-1, -1), 0.5, BORDER),
        ("LEFTPADDING", (0, 0), (-1, -1), 4),
        ("RIGHTPADDING", (0, 0), (-1, -1), 4),
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ]
    for i in range(1, len(data)):
        cmds.append(("BACKGROUND", (2, i), (2, i), PASS_BG))
        if i % 2 == 0:
            cmds.append(("BACKGROUND", (0, i), (1, i), ROW_ALT))
            cmds.append(("BACKGROUND", (3, i), (3, i), ROW_ALT))
    table.setStyle(TableStyle(cmds))
    return table


def footer(canvas, doc):
    canvas.saveState()
    canvas.setFillColor(PRIMARY)
    canvas.setFont("Helvetica", 8)
    canvas.drawCentredString(A4[0] / 2, 12 * mm, f"Dai Wa Bu Yi — Feature Matrix  |  Page {doc.page}")
    canvas.setStrokeColor(PRIMARY)
    canvas.setLineWidth(0.5)
    canvas.line(16 * mm, 16 * mm, A4[0] - 16 * mm, 16 * mm)
    canvas.restoreState()


def build():
    st = styles()
    page_w = A4[0] - 32 * mm
    # Key Features | Frontend | Pass | Screenshot
    widths = [page_w * 0.20, page_w * 0.32, page_w * 0.12, page_w * 0.36]

    s = lambda name: USER / name

    # Splash / loading (142751) excluded
    rows = [
        (
            "Sign In",
            "Email, password, remember me, forgot password, Sign Up",
            s("Screenshot_20261029_142801.png"),
        ),
        (
            "Home / Calendar",
            "Location, search, Self filter, October calendar, bottom nav",
            s("Screenshot_20261029_142624.png"),
        ),
        (
            "Categories",
            "Search, filter, Food & Drink / Art / Sport / Musical grid",
            s("Screenshot_20261029_142539.png"),
        ),
        (
            "Category Detail — Sport",
            "Hero image, Outdoor/Indoor sub categories, event empty state",
            s("Screenshot_20261029_142554.png"),
        ),
        (
            "Event Filter",
            "Program, Type, Location, Category/Group, price range",
            s("Screenshot_20261029_142739.png"),
        ),
        (
            "My Events",
            "Today / Upcoming / History tabs, search, empty state",
            s("Screenshot_20261029_171351.png"),
        ),
        (
            "Create Event — Basic",
            "Step 1: cover, session, year, program (filled sample)",
            s("Screenshot_20261029_171603.png"),
        ),
        (
            "Create Event — Details",
            "Step 2: level, type, registration, deadline, cost",
            s("Screenshot_20261029_171557.png"),
        ),
        (
            "Create Event — Group",
            "Step 3: criteria, conditions, rounds, cost",
            s("Screenshot_20261029_171623.png"),
        ),
        (
            "Create Event — History",
            "Step 4: own history, agreement, Add & Share",
            s("Screenshot_20261029_171719.png"),
        ),
        (
            "Create Event — Basic (empty)",
            "Step 1 empty form: cover photo, session, organizer",
            s("Screenshot_20261029_142617.png"),
        ),
        (
            "Select Location",
            "Map view, country, search location, confirm",
            s("Screenshot_20261029_142727.png"),
        ),
        (
            "Profile",
            "Menu: Account, Family, Event, Connection, Settings…",
            s("Screenshot_20261029_142526.png"),
        ),
        (
            "Account",
            "Personal info view: ID, name, gender, birthday, email",
            s("Screenshot_20261029_142656.png"),
        ),
        (
            "Edit Account",
            "Editable profile: photo, names, gender, birthday, email",
            s("Screenshot_20261029_171335.png"),
        ),
        (
            "Change Password",
            "Old / new / re-enter password form",
            s("Screenshot_20261029_171342.png"),
        ),
    ]

    doc = SimpleDocTemplate(
        str(OUT),
        pagesize=A4,
        leftMargin=16 * mm,
        rightMargin=16 * mm,
        topMargin=14 * mm,
        bottomMargin=18 * mm,
        title="Dai Wa Bu Yi — Feature Matrix",
        author="Event-Sharing",
    )

    story = [
        p("Feature Matrix", st["h1"]),
        feature_table(rows, st, widths),
    ]

    doc.build(story, onFirstPage=footer, onLaterPages=footer)
    print(f"Wrote: {OUT}")
    return OUT


if __name__ == "__main__":
    build()
