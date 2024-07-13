.proc dma_synced_poll
    ldx #1                 ; get put          <- strobe code must take an odd number of cycles total
    stx buttons+0          ; get put get      <- buttons must be in the zeropage
    stx $4016              ; put get put get
    dex                    ; put get
    stx $4016              ; put get put get
    loop:
        lda $4017          ; put get put GET  <- loop code must take an even number of cycles total
        and #3             ; put get
        cmp #1             ; put get
        rol buttons+1, x   ; put get put get put get (X = 0; waste 1 cycle for alignment)
        lda $4016          ; put get put GET
        and #3             ; put get
        cmp #1             ; put get
        rol buttons+0      ; put get put get put
        bcc loop           ; get put [get]    <- this branch must not be allowed to cross a page


; source: https://www.nesdev.org/wiki/Controller_reading_code#DPCM_Safety_using_OAM_DMA