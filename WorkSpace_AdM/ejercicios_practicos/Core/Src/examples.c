/*
 * examples.c
 *
 *  Created on: Apr 7, 2022
 *      Author: alex
 */

#include "examples.h"

/**
 *
 */
void zeros(uint32_t * vector, uint32_t longitud)
{
	for (uint32_t i = 0; i < longitud; i++)
	{
		*(vector + i) = 0;
	}
}

/**
 *
 */
void productoEscalar32(uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar)
{
	for (uint32_t i = 0; i < longitud; i++)
	{
		*(vectorOut + i) = (*(vectorIn + i))*escalar;
	}
}

/**
 *
 */
void productoEscalar16(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar)
{
	for (uint32_t i = 0; i < longitud; i++)
	{
		*(vectorOut + i) = (*(vectorIn + i))*escalar;
	}
}

/**
 *
 */
void productoEscalar12(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitud, uint16_t escalar)
{
	for (uint32_t i = 0; i < longitud; i++)
	{
		*(vectorOut + i) = (*(vectorIn + i))*escalar;
	}
}


