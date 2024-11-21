def speed_bct_optimisation(i : int, o : int, iw : int, ow : int) -> int:
    time = 4

    if not i:
        time += 19
        return time
    time += 4

    if (i - 1) ^ i == 0:
        time += 13
        time += len(f"{i:0b}") * 21
        return time
    
    time += 18
    if (o & 0xff00) == 0:
        time += 12
        if bct(o) > bct(i):
            i, o = o, i
            time += 21
        else:
            time += 11
    else:
        time += 8
    
    it = i
    while it:
        time += 5
        if it & 1:
            time += 32
        time += 17
        it >>= 1
    time += 5
    return time

data = [[speed_bct_optimisation(i, o, 1, 2) for i in range(256)] for o in range(256)]

# below is gpt generated

from PIL import Image

def array_to_image(array):
    # Ensure the input array is 256x256
    assert len(array) == 256 and len(array[0]) == 256, "Array dimensions must be 256x256."

    # Create a new image with mode 'RGB'
    img = Image.new('RGB', (256, 256))

    # Normalize the array values to be between 0 and 255
    max_val = max(max(row) for row in array)
    min_val = min(min(row) for row in array)
    range_val = max_val - min_val if max_val != min_val else 1  # Avoid division by zero

    # Convert each value to a red intensit6y based on its normalized value
    for y in range(256):
        for x in range(256):
            normalized_value = int(255 * (array[y][x] - min_val) / range_val)
            # Set the pixel color: (red intensity, 255 - red intensity, 255 - red intensity)
            img.putpixel((x, y), (0, normalized_value, 0))
    return img


print(f"max : {max(max(data[x]) for x in range(256))}")

image = array_to_image(data)
image.resize((1024, 1024), Image.NEAREST)
image.save("multiply_speedchart.bmp")
image.show()