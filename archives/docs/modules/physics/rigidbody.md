# Rigidbody
***

On the NES we only have one plane of rotation, two dimensional axis and an 8-bit CPU bus. Because of this, the rigidbody code in `nesbrette::physics::rb` is a simplified rendition better suited to the majority of NES titles (2D Platformers/Fighters). While `OAM` Sprites themselves have no capacity to internally rotate visually and the math to track measurable points from a centre of rotation after rotation is complex and resource intensive, we still offer vector based physics due to the smoothness and freedom within the movement.

A 'force' can have a maximum magnitude of `16` pixels per frame `960` pixels per second NTSC and `800` pixels per second PAL. This is what a force may look like:
```

ppppssss aaaaaaaa
11111111 11111111 = 15.9375 ppf at e: ~-1.4°
00011000 01000000 = 1.5 ppf at e: 90°
00001000 10000000 = 0.5 ppf at e: 180°
00000000 00000000 = 0 ppf at e: 0°

```

The beauty of this solution is that only subpixels are merged into a byte with the most space efficient option, meaning that pixel relocation and angle re-alignment comes at a primative store cost. If your game supports rotating sprites then the read cost is also primative.

```

OAMBUFFER OAMBUFFER MEMORY   MEMORY
yyyy yyyy xxxx xxxx ssssSSSS aaaaaaaa

```