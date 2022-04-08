/*
 * examples.h
 *
 *  Created on: Apr 7, 2022
 *      Author: alex
 */

#ifndef INC_EXAMPLES_H_
#define INC_EXAMPLES_H_

#include <stdio.h>
#include <stdint.h>

void zeros(uint32_t * vector, uint32_t longitud);
void productoEscalar32(uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar);
void productoEscalar16(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);
void productoEscalar12(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar);

#endif /* INC_EXAMPLES_H_ */
