/*
 *  TU Eindhoven
 *  Eindhoven, The Netherlands
 *
 *  Name            :   stdio-wrapper.c
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

#include "stdio-wrapper.h"

#ifdef microblaze
#include <filestatus.h>
#include <sysace_stdio.h>
#include <fat.h>

int sysace_fgetc(SYSACE_FILE *stream)
{
	int ret;
	unsigned char c;

	ret = sysace_fread(&c, 1, 1, stream);
	if( ret != 1 )
		return EOF;

	return (int)c;
}

int sysace_feof(SYSACE_FILE *stream)
{
	int ret;
	unsigned char c;

	ret = sysace_fread(&c, 1, 1, stream);
	if( ret != 1 )
		return -1;

	return 0;
}

int sysace_putc(int c, SYSACE_FILE *stream)
{
	int ret;
	unsigned char b = c;

	ret = sysace_fwrite(&b, 1, 1, stream);
	if( ret != 1 )
		return EOF;

	return c;
}

int sysace_fputs(const char *s, SYSACE_FILE *iop)
   {
       int c;
		 int d;

       while (c = *s++)
		 {
			  d = sysace_putc(c, iop);
			  if (d == EOF)
			     return d;
		 }
			  
		 return 0;	  
       //return ferror(iop) ? EOF : 0;
		 //return feof(iop) ? EOF : 0;
   }

//char * sysace_fgets(char *buf, int bsize, SYSACE_FILE *fp)
 char * sysace_fgets(char *s, int n, SYSACE_FILE *iop)

    {
	    //register int c;
       //register char *cs;
		 int c;
       char *cs;

       cs = s;
       while (--n > 0 && (c = sysace_fgetc(iop)) != EOF)
           if ((*cs++ = c) == '\n')
               break;
       *cs = '\0';
       return (c == EOF && cs == s) ? NULL : s;
//    int i;
//    int c;
//    int done = 0;
//    if (buf == 0 || bsize <= 0 || fp == 0)
//    	return 0;
//
//
//        for (i = 0; !done && i < bsize - 1; i++) {
//        	c = sysace_fgetc(fp);
//
//
//            	if (c == EOF) {
//            	done = 1;
//            	i--;
//
//
//                	} else {
//                	buf[i] = c;
//                	if (c == '\n')
//                		done = 1;
//                	}
//            }
//            buf[i] = '\0';
//            if (i == 0)
//            	return 0;
//            else
//            	return buf;
        }
		  
int sysace_fseek(SYSACE_FILE *stream, long offset, int whence)
{
  int readcount, n;
  int remaining;
  UINT32 sector;
  UINT32 filesize;
  UINT32 nsectors;
  UINT32 sector_offset;
  int byte_offset;
  FileStatus *fs = find_file_status(stream);

  /* Safety check */
  if (fs == 0 || !fs->read || offset < 0 || whence != SEEK_CUR)
    return -1;

  filesize = fs->wd->v.child.FileSize;

  if (fs->PositionInFile >= filesize)
    return -1;

  readcount = 0;

  /* Compute number of bytes left to read - may be limited
   * by size of users buf or by file size */
  remaining = filesize - fs->PositionInFile;
  if (offset < remaining)
    remaining = offset;

  while (fs->PositionInFile < filesize) {
    /* Which sector of this cluster did we leave off at last time ? */
    sector_offset = fs->PositionInCluster / SECTORSIZE;

    /* Which byte of that sector did we leave off at last time ? */
    byte_offset = fs->PositionInCluster % SECTORSIZE;

    /* Sector address to start reading this time */
    sector = starting_sector(fs->CurrentCluster, fs->wd->pi);
    if (sector == 0) {
      /* FAT problem ? */
      return -1;
    }
    sector += sector_offset;

    /* How many sectors left to read in this cluster */
    nsectors = fs->wd->pi->SectorsPerCluster - sector_offset;

    while (nsectors) {
      if (remaining <= (SECTORSIZE - byte_offset)) {
        /* End of file or end of buffer occurs in this sector
         * Read what's left and quit */
        fs->PositionInFile += remaining;
        fs->PositionInCluster += remaining;
        return -1; /* TODO seeking past EOF is not supported in current version */
      }
      /* End of file is beyond this sector */
      n = SECTORSIZE - byte_offset;
      fs->PositionInFile += n;
      fs->PositionInCluster += n;
      readcount += n;
      remaining -= n;

      /* Point to start of next sector in cluster */
      byte_offset = 0;
      sector += 1;
      nsectors -= 1;
    }	/* end of while */

    /* Done with that cluster, advance to the next one */
    fs->CurrentCluster = next_cluster(fs->CurrentCluster, fs->wd->pi);
    if (fs->CurrentCluster == BAD_CLUSTER) {
      /* Bad cluster address - this means that there is a FAT problem,
       * because we should have dtected that this was the last cluster
       * based on filesize. The file system is hosed. */
      return -1;
    }
    /* We are at the start of this new cluster */
    fs->PositionInCluster = 0;
  }

  return 0;
}

long sysace_ftell(SYSACE_FILE *stream)
{
	FileStatus *fs = find_file_status(stream);

	if(fs == NULL) return -1;

	return fs->PositionInFile;
}


#endif

