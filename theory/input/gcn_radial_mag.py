"""

    the radial feed from gcn sticks is not hypotenuse/theta but adjacent/opposite
    the angle/force is deduced from basic trig

    however this means the amount of angles is not just 0-255.
"""

import math

dist : int = 128

def v256(radian : float, magntiude : float) -> tuple:
    radian += math.pi / 2               # zerobase it, theta now lies between 0:pi (r)
    radian += math.pi * (magntiude < 0) # arctangent is only so useful, signature of magnitude fills in for half a circle

    assert radian >= 0

    # 0 < theta < 2pir
    return int((128 * radian) / math.pi), min(abs(int(magntiude)), 128)

class arraymap():
    content : dict = {}
    def init(self):
        self.content : dict = {}
    
    def add(self, key : object, value : object) -> None:
        if key not in self.content:
            self.content[key] = []
        
        elif value in self.content[key]:
            return
        
        self.content[key].append(value)

results : arraymap = arraymap()

for adj in range(-dist, dist):
    for opp in range(-dist, dist):
        if adj or opp:
            if not adj: 
                radian : float = (math.pi/2) + math.pi if adj < 0 else 0
                magnitude : float = float(adj)
                results.add(radian, abs(opp))
            elif not opp: 
                radian : float = (math.pi/2) + math.pi if opp < 0 else 0
                magnitude : float = float(opp)
                results.add(radian, abs(adj)) 

            # in the above situations, theta is resolved without trig from signatures
            else:
                radian : float = math.atan(opp/adj); magnitude : float = opp/math.sin(radian)
                radian, magnitude = v256(radian, magnitude)
                results.add(radian, magnitude)
                
        # where adj and opp are 0, there is no theta.

payload : str = str()

for elem in results.content.values(): elem.sort()
output : dict = {}

for rad in range(256): 
    if rad in results.content.keys():
        output[rad] = results.content[rad]
del results


for rad, mags in output.items():
    payload += f"{rad:02x} :"
    for mag in mags:
        payload += f" {mag:02x}, "
    payload = payload[:-2] + "\n"

with open("radial_dispersion.txt", "w") as f:
    f.write(payload)


"""
lda LX
beq @nox

ldx LY
beq @noy

copyaddr LX FUNCTION_MATH_DIVIDE_OUTPUT
copyaddr LY FUNCTION_MATH_DIVIDE_DIVISOR

jsr math::divide

lda ATAN, x
sta radian

tax
lda SIN, x

.ifdef math::divide_8
    sta FUNCTION_MATH_DIVIDE8_DIVISOR
    lda LY
    abs
    sta FUNCITON_MATH_DIVIDE8_BASE
    jsr math::divide_8
.else
    sta temp
    copyaddr temp FUNCTION_MATH_DIVIDE_DIVISOR
    lda LY
    abs
    sta FUNCTION_MATH_DIVIDE_DIVISOR
    jsr math::divide
.endif

sta magnitude
; data is already in degrees due to 256deg ATAN table, SIN frac *should* be signed val/bits
rts

; as long as LX/LY is zp we can use bit branch
@noy:
    lax LX
    nob
@nox:
    lax LY
    and #$80
    sta radian
    txa
    and #$7f
    sta magnitude
    rts

"""