/*
 *  TU Eindhoven
 *  Eindhoven, The Netherlands
 *
 *  Name            :   stdio-wrapper.h
 *
 *  Author          :   Francesco Comaschi (f.comaschi@tue.nl)
 *
 *  Date            :   November 12, 2012
 *
 *  Function        :   Wrapper for Microblaze implementation
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

#ifndef STDIO_WRAPPER_INCLUDED
#define STDIO_WRAPPER_INCLUDED

#define VERBOSE

#ifdef microblaze
# include <sysace_stdio.h>

# define  FILE	 SYSACE_FILE
# define  fopen  sysace_fopen
# define  fclose sysace_fclose
# define  fread  sysace_fread
# define  fwrite sysace_fwrite
# define  ftell  sysace_ftell
# define  fseek  sysace_fseek
# define  fgetc  sysace_fgetc
# define  putc   sysace_putc
# define  fputc   sysace_putc
# define  fgets  sysace_fgets
# define  fputs	 sysace_fputs
# define  feof	 sysace_feof
# define  printf  xil_printf
# define  fprintf  xil_printf

int sysace_fgetc(SYSACE_FILE *stream);
int sysace_putc(int c, SYSACE_FILE *stream);
char * sysace_fgets(char *buf, int bsize, SYSACE_FILE *fp);
int sysace_fputs(const char *s, SYSACE_FILE *iop);
int sysace_feof(SYSACE_FILE *stream);
long sysace_ftell(SYSACE_FILE *stream );
int sysace_fseek(SYSACE_FILE *stream, long offset, int whence );

#else
#include <stdio.h>
# define SYSACE_FILE   FILE
# define sysace_fopen  fopen
# define sysace_fclose fclose
# define sysace_fread  fread
# define sysace_fwrite fwrite
# define sysace_ftell  ftell
# define sysace_fseek  fseek
# define sysace_fgetc  fgetc
# define sysace_putc   putc
# define sysace_fgets  fgets
# define sysace_fputs  fputs
# define sysace_feof   feof
# define xil_printf    printf
#endif

#endif /* STDIO_WRAPPER_INCLUDED */

