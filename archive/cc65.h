#include <stdint.h>
typedef uint8_t BIASING_RLE_RETURN_WIDTH;

namespace function{
    namespace math{
        namespace trig{

        }

        namespace random {

        }

        namespace biasing {
            uint8_t __cdecl__ rle(BIASING_RLE_RETURN_WIDTH* table_ptr, uint8_t peek);
        }

        void* __cdecl__ multiply(void* multiplicant_ptr, void* multiplier_ptr, uint8_t input_width, uint8_t output_width, void* output_location);
    }
}