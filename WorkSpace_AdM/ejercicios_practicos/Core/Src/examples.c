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
		uint16_t result = (*(vectorIn + i))*escalar;
		if ( result > 0xFFF ){ result = 0xFFF; }
		*(vectorOut + i) = result;
	}
}

/**
 *
 */
void filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn)
{
	if(longitudVectorIn >= 10)
	{
		uint8_t longitudVentana = 10;
		uint16_t suma = 0;
		uint32_t indexVect;
		uint32_t indexVent;

		for (indexVect = 0; indexVect < longitudVectorIn; indexVect++)
		{
			indexVent = indexVect;
			for(uint8_t i = 0; i < longitudVentana; i++)
			{
				indexVent = (indexVent >= longitudVectorIn) ? (indexVent - longitudVectorIn) : (indexVent);
				suma += *(vectorIn + indexVent);
				indexVent++;
			}
			*(vectorOut + indexVect) = suma / longitudVentana;
			suma = 0;
		}
	}
}

/**
 *
 */
void pack32to16 (int32_t * vectorIn, int16_t *vectorOut, uint32_t longitud)
{
	for(uint8_t i = 0; i < longitud; i++)
	{
		*(vectorOut + i) = (int16_t)(*(vectorIn + i) >> 16);
	}
}

/**
 *
 */
int32_t max (int32_t * vectorIn, uint32_t longitud)
{
	int32_t max = INT32_MIN;
	int32_t indexMax = 0;
	for(uint32_t i = 0; i < longitud; i++)
	{
		if(*vectorIn > max)
		{
			max = *vectorIn;
			indexMax = i;
		}
		vectorIn++;
	}
	return indexMax;
}

/**
 *
 */
void downsampleM (int32_t * vectorIn, int32_t * vectorOut, uint32_t longitud, uint32_t N)
{
	for( uint32_t i = 0; i < longitud; i++)
	{
		if (((i + 1) % N) != 0)
		{
			*vectorOut++ = *(vectorIn + i);
		}
	}
}

/**
 *
 */
void invertir (uint16_t * vector, uint32_t longitud)
{
	uint16_t aux;
	for(uint32_t i = 0; i < (longitud / 2); i++)
	{
		aux = *(vector + i);
		*(vector + i) = *(vector + longitud - 1 - i);
		*(vector + longitud - 1 - i) = aux;
	}
}

