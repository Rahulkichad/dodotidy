#!/usr/bin/env python3
"""
Fix app icon by adding proper macOS padding.
macOS icons should have ~10% padding on each side for proper display in Cmd+Tab and Dock.
"""

from PIL import Image
import os

ICON_DIR = "/Users/gorkemcetin/macos-systemclean/DodoTidy/Resources/Assets.xcassets/AppIcon.appiconset"
SOURCE_ICON = "/Users/gorkemcetin/Desktop/dodotidy.png"

# Icon sizes needed for macOS
SIZES = [
    (16, "icon_16x16.png", 1),
    (32, "icon_16x16@2x.png", 1),  # 16@2x = 32
    (32, "icon_32x32.png", 1),
    (64, "icon_32x32@2x.png", 1),  # 32@2x = 64
    (128, "icon_128x128.png", 1),
    (256, "icon_128x128@2x.png", 1),  # 128@2x = 256
    (256, "icon_256x256.png", 1),
    (512, "icon_256x256@2x.png", 1),  # 256@2x = 512
    (512, "icon_512x512.png", 1),
    (1024, "icon_512x512@2x.png", 1),  # 512@2x = 1024
]

# Padding percentage - macOS icons need significant padding to match system icons
PADDING_PERCENT = 0.08

def create_padded_icon(source_path, output_path, size):
    """Create an icon with proper padding for macOS."""
    # Open source image
    img = Image.open(source_path)

    # Convert to RGBA if needed
    if img.mode != 'RGBA':
        img = img.convert('RGBA')

    # Calculate the size of the actual icon content (with padding removed)
    padding = int(size * PADDING_PERCENT)
    content_size = size - (padding * 2)

    # Resize the source to fit in the content area
    img_resized = img.resize((content_size, content_size), Image.Resampling.LANCZOS)

    # Create new transparent image at full size
    new_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))

    # Paste the resized icon in the center
    new_img.paste(img_resized, (padding, padding))

    # Save
    new_img.save(output_path, 'PNG')
    print(f"Created: {output_path} ({size}x{size})")

def main():
    if not os.path.exists(SOURCE_ICON):
        print(f"Source icon not found: {SOURCE_ICON}")
        return

    print(f"Creating padded icons from: {SOURCE_ICON}")
    print(f"Padding: {PADDING_PERCENT * 100}% on each side")
    print()

    for size, filename, _ in SIZES:
        output_path = os.path.join(ICON_DIR, filename)
        create_padded_icon(SOURCE_ICON, output_path, size)

    print("\nDone! Icons have been updated with proper padding.")

if __name__ == '__main__':
    main()
