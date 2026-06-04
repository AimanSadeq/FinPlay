from PIL import Image, ImageDraw, ImageFont
import math, os

BASE = "C:/Users/SKC/Desktop/finance-gamification/finplay_flutter"

def draw_gradient_rect(img, x1, y1, x2, y2):
    """Fill a rectangle with a blue-to-teal diagonal gradient."""
    draw = ImageDraw.Draw(img)
    w = x2 - x1
    h = y2 - y1
    for y in range(int(y1), int(y2)):
        for x in range(int(x1), int(x2)):
            ratio = (y - y1) / h
            xr = (x - x1) / w
            diag = (ratio + xr) / 2
            r = max(0, min(255, int(15 + (6 - 15) * diag + 30 * xr)))
            g = max(0, min(255, int(23 + (182 - 23) * diag * 0.9)))
            b = max(0, min(255, int(42 + (212 - 42) * diag * 0.7)))
            img.putpixel((x, y), (r, g, b, 255))

def create_app_icon(size=1024):
    """Modern finance-themed app icon with gradient, chart bars, and dollar symbol."""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw_gradient_rect(img, 0, 0, size, size)

    # Rounded rectangle mask
    mask = Image.new('L', (size, size), 0)
    md = ImageDraw.Draw(mask)
    radius = size // 4
    md.rounded_rectangle([0, 0, size - 1, size - 1], radius=radius, fill=255)

    result = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    result.paste(img, mask=mask)
    draw = ImageDraw.Draw(result)

    # Bar chart - 4 ascending bars
    margin = size * 0.18
    bottom = size * 0.72
    chart_w = size * 0.6
    bar_count = 4
    bar_w = chart_w / (bar_count * 2)
    heights = [0.2, 0.35, 0.28, 0.55]
    bar_color = (255, 255, 255, 180)

    bar_tops = []
    for i, h in enumerate(heights):
        x = margin + i * (chart_w / bar_count)
        bar_h = h * size * 0.42
        y_top = bottom - bar_h
        draw.rounded_rectangle(
            [int(x), int(y_top), int(x + bar_w), int(bottom)],
            radius=max(1, int(bar_w * 0.15)),
            fill=bar_color
        )
        bar_tops.append((int(x + bar_w / 2), int(y_top)))

    # Trend line
    line_pts = [
        (margin + chart_w * 0.05, bottom - size * 0.12),
        (margin + chart_w * 0.3, bottom - size * 0.22),
        (margin + chart_w * 0.55, bottom - size * 0.17),
        (margin + chart_w * 0.85, bottom - size * 0.42),
    ]
    thick = max(2, int(size * 0.012))
    cyan = (34, 211, 238, 255)
    for i in range(len(line_pts) - 1):
        x1, y1 = line_pts[i]
        x2, y2 = line_pts[i + 1]
        for off in range(-thick, thick + 1):
            draw.line([(x1, y1 + off), (x2, y2 + off)], fill=cyan, width=2)

    # Arrow at end
    ax, ay = line_pts[-1]
    a = size * 0.035
    draw.polygon([
        (ax + a, ay - a * 0.8),
        (ax - a * 0.4, ay - a * 0.2),
        (ax - a * 0.1, ay + a * 0.6),
    ], fill=cyan)

    # Dollar circle (top right)
    cx, cy, cr = size * 0.73, size * 0.28, size * 0.1
    draw.ellipse(
        [cx - cr, cy - cr, cx + cr, cy + cr],
        fill=(16, 185, 129, 200),
        outline=(255, 255, 255, 220),
        width=max(1, int(size * 0.008))
    )
    try:
        dfont = ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf", int(cr * 1.2))
    except Exception:
        dfont = ImageFont.load_default()
    draw.text((cx, cy), "$", fill=(255, 255, 255, 255), font=dfont, anchor="mm")

    # FINPLAY text
    try:
        tfont = ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf", int(size * 0.12))
    except Exception:
        tfont = ImageFont.load_default()
    draw.text((size * 0.5, size * 0.88), "FINPLAY", fill=(255, 255, 255, 230), font=tfont, anchor="mm")

    return result


def create_splash_icon(size=512):
    """Clean splash icon with colorful bars and branding."""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    cx, cy = size // 2, size // 2
    total_w = size * 0.7
    bar_count = 5
    bar_w = total_w / (bar_count * 1.5)
    gap = bar_w * 0.5
    start_x = (size - total_w) / 2
    bottom = cy + size * 0.15

    heights = [0.15, 0.25, 0.2, 0.35, 0.5]
    colors = [
        (59, 130, 246),
        (6, 182, 212),
        (16, 185, 129),
        (34, 211, 238),
        (99, 102, 241),
    ]

    for i, (h, color) in enumerate(zip(heights, colors)):
        x = start_x + i * (bar_w + gap)
        bar_h = h * size * 0.6
        y_top = bottom - bar_h
        draw.rounded_rectangle(
            [int(x), int(y_top), int(x + bar_w), int(bottom)],
            radius=max(1, int(bar_w * 0.2)),
            fill=(*color, 230)
        )

    # Trend line
    lx1 = start_x + bar_w * 0.5
    ly1 = bottom - heights[0] * size * 0.6 - size * 0.03
    lx2 = start_x + total_w - bar_w * 0.3
    ly2 = bottom - heights[-1] * size * 0.6 - size * 0.06
    for off in range(-3, 4):
        draw.line([(lx1, ly1 + off), (lx2, ly2 + off)], fill=(255, 255, 255, 200), width=2)

    # Arrow head
    draw.polygon([
        (lx2 + 12, ly2 - 8),
        (lx2 - 4, ly2 - 12),
        (lx2 - 4, ly2 + 4),
    ], fill=(255, 255, 255, 220))

    # Text
    text_y = bottom + size * 0.1
    try:
        tfont = ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf", int(size * 0.1))
        sfont = ImageFont.truetype("C:/Windows/Fonts/arial.ttf", int(size * 0.045))
    except Exception:
        tfont = ImageFont.load_default()
        sfont = ImageFont.load_default()

    draw.text((cx, text_y), "FINPLAY", fill=(15, 23, 42, 255), font=tfont, anchor="mm")
    draw.text((cx, text_y + size * 0.08), "Finance Simulation", fill=(100, 116, 139, 255), font=sfont, anchor="mm")

    return img


def main():
    print("Generating app icon (1024x1024)...")
    app_icon = create_app_icon(1024)
    app_icon.save(f"{BASE}/assets/icons/app_icon.png")
    print("  Saved app_icon.png")

    print("Generating adaptive foreground (1024x1024)...")
    # For adaptive icon, just use the app icon with extra padding
    adaptive = Image.new('RGBA', (1024, 1024), (0, 0, 0, 0))
    draw_gradient_rect(adaptive, 0, 0, 1024, 1024)
    small = create_app_icon(int(1024 * 0.55))
    offset = (1024 - small.width) // 2
    adaptive.paste(small, (offset, offset), small)
    adaptive.save(f"{BASE}/assets/icons/app_icon_adaptive_fg.png")
    print("  Saved app_icon_adaptive_fg.png")

    print("Generating splash icon (512x512)...")
    splash = create_splash_icon(512)
    splash.save(f"{BASE}/assets/icons/splash_icon.png")
    print("  Saved splash_icon.png")

    # Android mipmap sizes
    res_dir = f"{BASE}/android/app/src/main/res"
    android_sizes = {
        'mipmap-mdpi': 48,
        'mipmap-hdpi': 72,
        'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144,
        'mipmap-xxxhdpi': 192,
    }

    for folder, px in android_sizes.items():
        out_dir = f"{res_dir}/{folder}"
        os.makedirs(out_dir, exist_ok=True)
        resized = app_icon.resize((px, px), Image.LANCZOS)
        rgb = Image.new('RGB', (px, px), (15, 23, 42))
        rgb.paste(resized, mask=resized.split()[3])
        rgb.save(f"{out_dir}/ic_launcher.png")
        print(f"  {folder}/ic_launcher.png ({px}x{px})")

    # Android splash drawable sizes
    splash_sizes = {
        'drawable-mdpi': 128,
        'drawable-hdpi': 192,
        'drawable-xhdpi': 256,
        'drawable-xxhdpi': 384,
        'drawable-xxxhdpi': 512,
    }

    for folder, px in splash_sizes.items():
        out_dir = f"{res_dir}/{folder}"
        os.makedirs(out_dir, exist_ok=True)
        resized = splash.resize((px, px), Image.LANCZOS)
        resized.save(f"{out_dir}/splash.png")
        print(f"  {folder}/splash.png ({px}x{px})")

    print("\nAll icons generated successfully!")


if __name__ == "__main__":
    main()
