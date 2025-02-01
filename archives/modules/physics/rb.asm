/*

    Brette's Partial RigidBody Module (nesbrette)

*/

.macro apply_force base_force, applied_force
    base_magnitude      = base_force
    base_angle          = base_force + 1

    applied_magnitude   = applied_force
    applied_angle       = applied_force + 1


    .endmacro