.define int(__string__)\
    ((.strat(__string__, .strlen(__string__) - 1) = '1') * 1)\
                  + ((.strat(__string__, .strlen(__string__) - 1) = '2') * 2)\
                  + ((.strat(__string__, .strlen(__string__) - 1) = '3') * 3)\
                  + ((.strat(__string__, .strlen(__string__) - 1) = '4') * 4)\
                  + ((.strat(__string__, .strlen(__string__) - 1) = '5') * 5)\
                  + ((.strat(__string__, .strlen(__string__) - 1) = '6') * 6)\
                  + ((.strat(__string__, .strlen(__string__) - 1) = '7') * 7)\
                  + ((.strat(__string__, .strlen(__string__) - 1) = '8') * 8)\
                  + ((.strat(__string__, .strlen(__string__) - 1) = '9') * 9)\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 2)) = '1') * 10       * (.strlen(__string__) - 2 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 2)) = '2') * 20       * (.strlen(__string__) - 2 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 2)) = '3') * 30       * (.strlen(__string__) - 2 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 2)) = '4') * 40       * (.strlen(__string__) - 2 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 2)) = '5') * 50       * (.strlen(__string__) - 2 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 2)) = '6') * 60       * (.strlen(__string__) - 2 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 2)) = '7') * 70       * (.strlen(__string__) - 2 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 2)) = '8') * 80       * (.strlen(__string__) - 2 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 2)) = '9') * 90       * (.strlen(__string__) - 2 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 3)) = '1') * 100      * (.strlen(__string__) - 3 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 3)) = '2') * 200      * (.strlen(__string__) - 3 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 3)) = '3') * 300      * (.strlen(__string__) - 3 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 3)) = '4') * 400      * (.strlen(__string__) - 3 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 3)) = '5') * 500      * (.strlen(__string__) - 3 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 3)) = '6') * 600      * (.strlen(__string__) - 3 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 3)) = '7') * 700      * (.strlen(__string__) - 3 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 3)) = '8') * 800      * (.strlen(__string__) - 3 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 3)) = '9') * 900      * (.strlen(__string__) - 3 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 4)) = '1') * 1000     * (.strlen(__string__) - 4 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 4)) = '2') * 2000     * (.strlen(__string__) - 4 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 4)) = '3') * 3000     * (.strlen(__string__) - 4 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 4)) = '4') * 4000     * (.strlen(__string__) - 4 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 4)) = '5') * 5000     * (.strlen(__string__) - 4 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 4)) = '6') * 6000     * (.strlen(__string__) - 4 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 4)) = '7') * 7000     * (.strlen(__string__) - 4 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 4)) = '8') * 8000     * (.strlen(__string__) - 4 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 4)) = '9') * 9000     * (.strlen(__string__) - 4 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 5)) = '1') * 10000    * (.strlen(__string__) - 5 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 5)) = '2') * 20000    * (.strlen(__string__) - 5 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 5)) = '3') * 30000    * (.strlen(__string__) - 5 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 5)) = '4') * 40000    * (.strlen(__string__) - 5 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 5)) = '5') * 50000    * (.strlen(__string__) - 5 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 5)) = '6') * 60000    * (.strlen(__string__) - 5 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 5)) = '7') * 70000    * (.strlen(__string__) - 5 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 5)) = '8') * 80000    * (.strlen(__string__) - 5 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 5)) = '9') * 90000    * (.strlen(__string__) - 5 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 6)) = '1') * 100000   * (.strlen(__string__) - 6 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 6)) = '2') * 200000   * (.strlen(__string__) - 6 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 6)) = '3') * 300000   * (.strlen(__string__) - 6 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 6)) = '4') * 400000   * (.strlen(__string__) - 6 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 6)) = '5') * 500000   * (.strlen(__string__) - 6 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 6)) = '6') * 600000   * (.strlen(__string__) - 6 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 6)) = '7') * 700000   * (.strlen(__string__) - 6 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 6)) = '8') * 800000   * (.strlen(__string__) - 6 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 6)) = '9') * 900000   * (.strlen(__string__) - 6 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 7)) = '1') * 1000000  * (.strlen(__string__) - 7 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 7)) = '2') * 2000000  * (.strlen(__string__) - 7 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 7)) = '3') * 3000000  * (.strlen(__string__) - 7 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 7)) = '4') * 4000000  * (.strlen(__string__) - 7 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 7)) = '5') * 5000000  * (.strlen(__string__) - 7 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 7)) = '6') * 6000000  * (.strlen(__string__) - 7 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 7)) = '7') * 7000000  * (.strlen(__string__) - 7 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 7)) = '8') * 8000000  * (.strlen(__string__) - 7 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 7)) = '9') * 9000000  * (.strlen(__string__) - 7 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 8)) = '1') * 10000000 * (.strlen(__string__) - 8 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 8)) = '2') * 20000000 * (.strlen(__string__) - 8 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 8)) = '3') * 30000000 * (.strlen(__string__) - 8 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 8)) = '4') * 40000000 * (.strlen(__string__) - 8 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 8)) = '5') * 50000000 * (.strlen(__string__) - 8 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 8)) = '6') * 60000000 * (.strlen(__string__) - 8 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 8)) = '7') * 70000000 * (.strlen(__string__) - 8 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 8)) = '8') * 80000000 * (.strlen(__string__) - 8 >= 0))\
                  + ((.strat(__string__, .max(0, .strlen(__string__) - 8)) = '9') * 90000000 * (.strlen(__string__) - 8 >= 0)) 