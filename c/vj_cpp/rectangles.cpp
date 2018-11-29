#include "haar.h"

int partition(std::vector<MyRect>& _vec, std::vector<int>& labels, float eps);

int myMax(int a, int b)
{
  if (a >= b)
    return a;
  else
    return b;
}

int myMin(int a, int b)
{
  if (a <= b)
    return a;
  else
    return b;
}

inline  int  myRound( float value )
{
  return (int)(value + (value >= 0 ? 0.5 : -0.5));
}

int myAbs(int n)
{
  if (n >= 0)
    return n;
  else
    return -n;
}

int predicate(float eps, MyRect& r1, MyRect& r2)
{
  float delta = eps*(myMin(r1.width, r2.width) + myMin(r1.height, r2.height))*0.5;
  return myAbs(r1.x - r2.x) <= delta &&
    myAbs(r1.y - r2.y) <= delta &&
    myAbs(r1.x + r1.width - r2.x - r2.width) <= delta &&
    myAbs(r1.y + r1.height - r2.y - r2.height) <= delta;
}

void groupRectangles(std::vector<MyRect>& rectList, int groupThreshold, float eps)
{
  if( groupThreshold <= 0 || rectList.empty() )
    return;


  std::vector<int> labels;

  int nclasses = partition(rectList, labels, eps);

  std::vector<MyRect> rrects(nclasses);
  std::vector<int> rweights(nclasses);

  int i, j, nlabels = (int)labels.size();


  for( i = 0; i < nlabels; i++ )
    {
      int cls = labels[i];
      rrects[cls].x += rectList[i].x;
      rrects[cls].y += rectList[i].y;
      rrects[cls].width += rectList[i].width;
      rrects[cls].height += rectList[i].height;
      rweights[cls]++;
    }
  for( i = 0; i < nclasses; i++ )
    {
      MyRect r = rrects[i];
      float s = 1.f/rweights[i];
      rrects[i].x = myRound(r.x*s);
      rrects[i].y = myRound(r.y*s);
      rrects[i].width = myRound(r.width*s);
      rrects[i].height = myRound(r.height*s);

    }

  rectList.clear();

  for( i = 0; i < nclasses; i++ )
    {
      MyRect r1 = rrects[i];
      int n1 = rweights[i];
      if( n1 <= groupThreshold )
	continue;
      /* filter out small face rectangles inside large rectangles */
      for( j = 0; j < nclasses; j++ )
        {
	  int n2 = rweights[j];
	  /*********************************
	   * if it is the same rectangle, 
	   * or the number of rectangles in class j is < group threshold, 
	   * do nothing 
	   ********************************/
	  if( j == i || n2 <= groupThreshold )
	    continue;
	  MyRect r2 = rrects[j];

	  int dx = myRound( r2.width * eps );
	  int dy = myRound( r2.height * eps );

	  if( i != j &&
	      r1.x >= r2.x - dx &&
	      r1.y >= r2.y - dy &&
	      r1.x + r1.width <= r2.x + r2.width + dx &&
	      r1.y + r1.height <= r2.y + r2.height + dy &&
	      (n2 > myMax(3, n1) || n1 < 3) )
	    break;
        }

      if( j == nclasses )
        {
	  rectList.push_back(r1); // insert back r1
        }
    }

}


int partition(std::vector<MyRect>& _vec, std::vector<int>& labels, float eps)
{
  int i, j, N = (int)_vec.size();

  MyRect* vec = &_vec[0];

  const int PARENT=0;
  const int RANK=1;

  std::vector<int> _nodes(N*2);

  int (*nodes)[2] = (int(*)[2])&_nodes[0];

  /* The first O(N) pass: create N single-vertex trees */
  for(i = 0; i < N; i++)
    {
      nodes[i][PARENT]=-1;
      nodes[i][RANK] = 0;
    }

  /* The main O(N^2) pass: merge connected components */
  for( i = 0; i < N; i++ )
    {
      int root = i;

      /* find root */
      while( nodes[root][PARENT] >= 0 )
	root = nodes[root][PARENT];

      for( j = 0; j < N; j++ )
	{
	  if( i == j || !predicate(eps, vec[i], vec[j]))
	    continue;
	  int root2 = j;

	  while( nodes[root2][PARENT] >= 0 )
	    root2 = nodes[root2][PARENT];

	  if( root2 != root )
	    {
	      /* unite both trees */
	      int rank = nodes[root][RANK], rank2 = nodes[root2][RANK];
	      if( rank > rank2 )
		nodes[root2][PARENT] = root;
	      else
		{
		  nodes[root][PARENT] = root2;
		  nodes[root2][RANK] += rank == rank2;
		  root = root2;
		}

	      int k = j, parent;

	      /* compress the path from node2 to root */
	      while( (parent = nodes[k][PARENT]) >= 0 )
		{
		  nodes[k][PARENT] = root;
		  k = parent;
		}

	      /* compress the path from node to root */
	      k = i;
	      while( (parent = nodes[k][PARENT]) >= 0 )
		{
		  nodes[k][PARENT] = root;
		  k = parent;
		}
	    }
	}
    }

  /* Final O(N) pass: enumerate classes */
  labels.resize(N);
  int nclasses = 0;

  for( i = 0; i < N; i++ )
    {
      int root = i;
      while( nodes[root][PARENT] >= 0 )
	root = nodes[root][PARENT];
      /* re-use the rank as the class label */
      if( nodes[root][RANK] >= 0 )
	nodes[root][RANK] = ~nclasses++;
      labels[i] = ~nodes[root][RANK];
    }

  return nclasses;
}


/* draw white bounding boxes around detected faces */
void drawRectangle(MyImage* image, MyRect r)
{
	int i;
	int col = image->width;

	for (i = 0; i < r.width; i++)
	{
		if (col*r.y + r.x + i < image->width * image->height )
      image->data[col*r.y + r.x + i] = 255;
	}
	for (i = 0; i < r.height; i++)
	{
		if (col*(r.y+i) + r.x + r.width < image->width * image->height)
		image->data[col*(r.y+i) + r.x + r.width] = 255;
	}
	for (i = 0; i < r.width; i++)
	{
		if (col*(r.y + r.height) + r.x + r.width - i < image->width * image->height)
		image->data[col*(r.y + r.height) + r.x + r.width - i] = 255;
	}
	for (i = 0; i < r.height; i++)
	{
		if (col*(r.y + r.height - i) + r.x < image->width * image->height )
		image->data[col*(r.y + r.height - i) + r.x] = 255;
	}

}
