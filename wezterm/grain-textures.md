# Grain Texture Generation

ImageMagick commands for generating film grain textures for wezterm backgrounds.

## Coral Shore Theme

Colors from `coral/palettes/shore.lua`:
- `#F5EFE6` - depth (dry sand, main background)
- `#E3D9CA` - twilight (wet sand)
- `#E8E0D4` - intermediate tone
- `#C9BCAA` - current (shadow on sand)

### shore_v6 - Dark speckles on light base

```bash
magick -size 660x440 xc:'#F5EFE6' \
  \( -size 660x440 xc: +noise Random -channel G -separate +channel -threshold 65% \) \
  -compose Multiply -composite \
  -fill '#E8E0D4' -opaque black \
  -fill '#F5EFE6' -opaque white \
  coral_shore_grain_v6.png
```

### shore_v9 - Light speckles on darker base (inverted)

```bash
magick -size 660x440 xc:'#E8E0D4' \
  \( -size 660x440 xc: +noise Random -channel G -separate +channel -threshold 75% \) \
  -compose Multiply -composite \
  -fill '#F5EFE6' -opaque black \
  -fill '#E8E0D4' -opaque white \
  coral_shore_grain_v9.png
```

## How it works

1. Create base color canvas: `xc:'#COLOR'`
2. Generate random noise, extract green channel, threshold to binary: `+noise Random -channel G -separate +channel -threshold N%`
   - Higher threshold = sparser speckles
3. Multiply composite the noise onto the base
4. Replace black pixels with grain color, white with base color

## Parameters to adjust

- **Size**: `-size WxH` - match your terminal dimensions or use a tileable size
- **Threshold**: `-threshold N%` - higher = fewer/sparser speckles (65-75% works well)
- **Colors**: Swap the `-fill` colors to invert light/dark speckles
