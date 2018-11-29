/*
 *  TU Eindhoven
 *  Eindhoven, The Netherlands
 *
 *  Name            :   image.c
 *
 *  Author          :   Francesco Comaschi (f.comaschi@tue.nl)
 *
 *  Date            :   November 12, 2012
 *
 *  Function        :   Functions to manage .pgm images and integral images
 *
 *  History         :
 *      12-11-12    :   Initial version.
 *
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program;  If not, see <http://www.gnu.org/licenses/>
 *
 * In other words, you are welcome to use, share and improve this program.
 * You are forbidden to forbid anyone else to use, share and improve
 * what you give them.   Happy coding!
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "image.h"
#include "stdio-wrapper.h"

char* strrev(char* str)
{
	char *p1, *p2;
	if (!str || !*str)
		return str;
	for (p1 = str, p2 = str + strlen(str) - 1; p2 > p1; ++p1, --p2)
	{
		*p1 ^= *p2;
		*p2 ^= *p1;
		*p1 ^= *p2;
	}
	return str;
}

//int chartoi(const char *string)
//{
//	int i;
//	i=0;
//	while(*string)
//	{
//		// i<<3 is equivalent of multiplying by 2*2*2 or 8
//		// so i<<3 + i<<1 means multiply by 10
//		i=(i<<3) + (i<<1) + (*string - '0');
//		string++;
//
//		// Dont increment i!
//
//	}
//	return(i);
//}

int myatoi (char* string)
{
	int sign = 1;
	// how many characters in the string
	int length = strlen(string);
	int i = 0;
	int number = 0;

	// handle sign
	if (string[0] == '-')
	{
		sign = -1;
		i++;
	}

//	for (i; i < length; i++)
	while(i < length)
	{
		// handle the decimal place if there is one
		if (string[i] == '.')
			break;
		number = number * 10 + (string[i]- 48);
		i++;
	}

	number *= sign;

	return number;
}

void itochar(int x, char* szBuffer, int radix)
{
	int i = 0, n, xx;
	n = x;
	while (n > 0)
	{
		xx = n%radix;
		n = n/radix;
		szBuffer[i++] = '0' + xx;
	}
	szBuffer[i] = '\0';
	strrev(szBuffer);
}


int readPgm(char *fileName, MyImage *image)
{
	FILE *in_file;
	char ch;
	int type;
	char version[3];
	char line[100];
	char mystring [20];
	char *pch;
	int i;
	long int position;

	in_file = fopen(fileName, "r");
	if (in_file == NULL)
	{
		printf("ERROR: Unable to open file %s\n\n", fileName);
		return -1;
	}
	printf("\nReading image file: %s\n", fileName);
	// Determine image type (only pgm format is allowed)*/
	ch = fgetc(in_file);
	if(ch != 'P')
	{
		printf("ERROR: Not valid pgm file type\n");
		return -1;
	}

	ch = fgetc(in_file);


	/*convert the one digit integer currently represented as a character to

         an integer(48 == '0')*/

	type = ch - 48;

	if(type != 5)
	{
		printf("ERROR: only pgm raw format is allowed\n");
		return -1;
	}
	// Skip comments
//	char line[100];
	while ((ch = fgetc(in_file)) != EOF && isspace(ch));
	position = ftell(in_file);


	// skip comments
	if (ch == '#')
		{
			fgets(line, sizeof(line), in_file);
			while ((ch = fgetc(in_file)) != EOF && isspace(ch));
			position = ftell(in_file);
		}

	fseek(in_file, position-1, SEEK_SET);

	fgets (mystring , 20, in_file);
	pch = (char *)strtok(mystring," ");
	image->width = atoi(pch);
	pch = (char *)strtok(NULL," ");
	image->height = atoi(pch);
	fgets (mystring , 5, in_file);
	image->maxgrey = atoi(mystring);
	image->data = (unsigned char*)malloc(sizeof(unsigned char)*(image->height*image->width));//new unsigned char[row*col];
	image->flag = 1;
	for(i=0;i<(image->height*image->width);i++)
	{	
		ch = fgetc(in_file);
		image->data[i] = (unsigned char)ch;
	}
	fclose(in_file);
	return 0;
}

int writePgm(char *fileName, MyImage *image)
{
	char parameters_str[5];
	int i;
	const char *format = "P5";
	if (image->flag == 0)
	{
		return -1;
	}
	FILE *fp = fopen(fileName, "w");
	if (!fp)
	{
		printf("Unable to open file %s\n", fileName);
		return -1;
	}
	fputs(format, fp);
	fputc('\n', fp);

	itochar(image->width, parameters_str, 10);
	fputs(parameters_str, fp);
	parameters_str[0] = 0;
	fputc(' ', fp);

	itochar(image->height, parameters_str, 10);
	fputs(parameters_str, fp);
	parameters_str[0] = 0;
	fputc('\n', fp);

	itochar(image->maxgrey, parameters_str, 10);
	fputs(parameters_str, fp);
	fputc('\n', fp);

	for (i = 0; i < (image->width * image->height); i++)
	{
		fputc(image->data[i], fp);
	}
	fclose(fp);
	return 0;
}

int cpyPgm(MyImage* src, MyImage* dst)
{
	int i = 0;
	if (src->flag == 0)
	{
		printf("No data available in the specified source image\n");
		return -1;
	}
	dst->width = src->width;
	dst->height = src->height;
	dst->maxgrey = src->maxgrey;
	dst->data = (unsigned char*)malloc(sizeof(unsigned char)*(dst->height*dst->width));
	dst->flag = 1;
	for (i = 0; i < (dst->width * dst->height); i++)
	{
		dst->data[i] = src->data[i];
	}
}


void createImage(int width, int height, MyImage *image)
{
	image->width = width;
	image->height = height;
	image->flag = 1;
	image->data = (unsigned char *)malloc(sizeof(unsigned char)*(height*width));
}

void createSumImage(int width, int height, MyIntImage *image)
{
	image->width = width;
	image->height = height;
	image->flag = 1;
	image->data = (int *)malloc(sizeof(int)*(height*width));
}

int freeImage(MyImage* image)
{
	if (image->flag == 0)
	{
		printf("no image to delete\n");
		return -1;
	}
	else
	{
//		printf("image deleted\n");
		free(image->data); 
		return 0;
	}
}

int freeSumImage(MyIntImage* image)
{
	if (image->flag == 0)
	{
		printf("no image to delete\n");
		return -1;
	}
	else
	{
//		printf("image deleted\n");
		free(image->data); 
		return 0;
	}
}

void setImage(int width, int height, MyImage *image)
{
	image->width = width;
	image->height = height;
}

void setSumImage(int width, int height, MyIntImage *image)
{
	image->width = width;
	image->height = height;
}
