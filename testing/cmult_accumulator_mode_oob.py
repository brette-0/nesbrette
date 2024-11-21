from ctypes import c_ubyte as byte
from PIL import Image

"""

    Tests the behavior of passing immense multipliers into the cmult macro using accumulator mode
    It is NOT reccomended to do this, as this behavior is unstable.

"""    
    
def mssb(n : byte) -> byte:
    for i in range(8):
        if n >> (7 - i): return 7 - i

def lssb(n : byte) -> byte:
    for i in range(8):
        if n & (1 << i): return i


def cmult(variable : byte, constant : byte) -> byte:
    if not constant:
        return 0

    a : byte = variable
    t : byte = 0

    t = a = a << lssb(constant)
    for i in range(mssb(constant) - lssb(constant)):
        t <<= 1
        if constant >> (i + lssb(constant)):
            a += t
    return a




def __main__():
    data : list = [[((v * c) - cmult(v, c)) & 0xff for c in range(256)] for v in range(256)]

    # Ensure the input array is 256x256
    assert len(data) == 256 and len(data[0]) == 256, "Array dimensions must be 256x256."

    # Create a new image with mode 'RGB'
    img = Image.new('RGBA', (256, 256))

    # Normalize the array values to be between 0 and 255
    max_val = max(max(row) for row in data)
    min_val = min(min(row) for row in data)
    range_val = max_val - min_val if max_val != min_val else 1  # Avoid division by zero

    # Convert each value to a red intensit6y based on its normalized value
    for y in range(256):
        for x in range(256):
            normalized_value = int(255 * (data[y][x] - min_val) / range_val)
            # Set the pixel color: (red intensity, 255 - red intensity, 255 - red intensity)
            img.putpixel((x, y), (0, normalized_value, 0))


    img.resize((1024, 1024), Image.NEAREST)
    img.save("testing/results/cmult_accumulator_mode_oob.bmp")
    img.show()

    # Convert each value to a red intensit6y based on its normalized value
    for y in range(256):
        for x in range(256):
            normalized_value = int(255 * (data[y][x] - min_val) / range_val)
            # Set the pixel color: (red intensity, 255 - red intensity, 255 - red intensity)
            img.putpixel((x, y), (0, normalized_value, 0, 255 if normalized_value == 0 else 0))


    img.resize((1024, 1024), Image.NEAREST)
    img.save("testing/results/cmult_accumulator_mode_oob_mask.png")
    img.show()

    return

if __name__ == "__main__": __main__()