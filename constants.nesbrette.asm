; NESBRETTE CONSTANT LISTING
; THESE VALUES WILL DETERMINE WHAT FEATURES CAN BE USED AND HOW THEY WILL BE USED

.define RELEASE                         0   ; set to 1 for final release (will prevent test crashes)


.define MAPPER                          0


; RAYCASTING
.define USE_FIXED_INTERVAL              1  ; set to 0 to use dynamic interval, RAYCAST_FIXED_INTERVAL will still be the default
.define RAYCAST_FIXED_INTERVAL          8
.define THETA_COEFFICIENT_COMPLEXITY    2  ; how many bits (in modification) theta will have to affect the default interval