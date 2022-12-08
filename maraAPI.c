/* This simulates the API MaraDNS uses for its HalfSipHash13 (1-3) code */

#include "halfsiphash.h"
#include "siphash.h"
#include "vectors.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

uint32_t HalfSip13(uint8_t *str, int32_t l, 
		uint32_t sipKey1, uint32_t sipKey2) {
  uint8_t out[16], k[16];
  uint32_t ret = 0;
  if(str == NULL) {
    return 0; 
  }
  k[0] = sipKey1 & 0xff;
  k[1] = (sipKey1 >> 8) & 0xff;
  k[2] = (sipKey1 >> 16) & 0xff;
  k[3] = (sipKey1 >> 24) & 0xff;
  k[4] = sipKey2 & 0xff;
  k[5] = (sipKey2 >> 8) & 0xff;
  k[6] = (sipKey2 >> 16) & 0xff;
  k[7] = (sipKey2 >> 24) & 0xff;
  halfsiphash(str, l, k, out, 4);
  ret |= out[0];
  ret |= out[1] << 8;
  ret |= out[2] << 16;
  ret |= out[3] << 24;
  return ret; 
}

int main() {
        uint8_t test1[66];
        int counter;
        printf("Test #1: Reference vectors\n");
        printf("See https://github.com/samboy/HalfSipTest for ref code\n");
        for(counter = 0; counter < 64; counter++) {
                test1[counter] = counter;
                printf("%08x\n",
                       HalfSip13(test1,counter,0x03020100, 0x07060504));
        }
}
