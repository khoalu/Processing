int numOfElements = 200;
int a[];

int steps = 0;

String state;
int l, r, i, j, x;
int top, stackL[], stackR[];
color colorMap[];

boolean fastFoward = true;

void setup()
{
  size(1366, 768);
  //fullScreen();
  //size(1024, 768);
  fill(255);
  stroke(255);
  
  //for quicksort algorithm
  a = new int[numOfElements];
  for(int i = 0; i < numOfElements; i++) a[i] = numOfElements-i;
  for(int i = 0; i < numOfElements; i++) {
    int r = (int)random(0, numOfElements);
    int temp = a[i];
    a[i] = a[r];
    a[r]= temp;
  }
  
  stackL = new int[numOfElements*20];
  stackR = new int[numOfElements*20];
  top = 1;
  stackL[1] = 0;
  stackR[1] = numOfElements-1;
  state = "INIT_VALUE";
  
  //visualize
  colorMap = new int[numOfElements];
}

//void Qsort(int l, int r)
//{
//  int i = l, j = r;
//  int x = a[(l+r)>>1];
//  while (i < j)
//  {  
//    while (a[i] < x) i++;
//    while (a[j] > x) j--;
//    if (i <= j) 
//    {
//      int temp = a[i]; a[i] = a[j]; a[j] = temp;
//      i++; j--;
//    }
//    redraw();
//  }
//  if (l < j) Qsort(l, j);
//  if (i < r) Qsort(i, r);
//}

void printArr(int a[], int n)
{
  String dispString = "";
  for(int i = 0; i < n; i++) dispString += str(a[i]) + " ";
  println(dispString);
}

void SetColorMap()
{
  for(int id = 0; id < numOfElements; id++)
  {
    if (id == l || id == r) // bound
    {
      colorMap[id] = color(0xFF00FF00);
    } else
    if (id == i || id == j) // swapping elements
    {
      colorMap[id] = color(0xFFFD00CA);
    } else
    if (id == x) // pivot element
    {
      colorMap[id] = color(0xFFFF0000);
    } else
      colorMap[id] = color(255);
    //colorMap[id] = 255;
  }
}

void RenderOnScreen()
{
  background(0);
  for(int k = 0; k < numOfElements; k++)
  {
    fill(colorMap[k]);
    stroke(colorMap[k]);
    float h = map(a[k], 0, numOfElements-1,0, height);
    rect(1f*k*width/numOfElements,height-h, 1f*width/numOfElements, h);
  }
  //printArr(a, numOfElements);
}

void Update() 
{
  //println(state);
  switch (state) 
  {
    case "INIT_VALUE":
      l = stackL[top];
      r = stackR[top];
      i = l; j = r;
      x = (l+r) >> 1;
      state = "UPDATE_I";
      break;
    
    case "UPDATE_I":
      if (fastFoward)
      {
        while (a[i] < a[x]) i++;
        state = "UPDATE_J";
      } else
      {
        if (a[i] < a[x]) i++; else
        state = "UPDATE_J";
      }
      break;
    
    case "UPDATE_J":
      if (fastFoward)
      {
        while (a[j] > a[x]) j--;
        state = "SWAP_VALUE";
      } else
      {
        if (a[j] > a[x]) j--; else
        state = "SWAP_VALUE";
      }
      break;
      
    case "SWAP_VALUE":
      redraw();
      if (i <= j)
      {
        if (x == i || x == j) x = x ^ i ^ j;
        int temp = a[i]; a[i] = a[j]; a[j] = temp;
        i++;
        j--;
        
      }
      if (i <= j)
        state = "UPDATE_I";
      else
        state = "PUSH_STACK";
      
      break;
      
    case "PUSH_STACK":
      top--;
      if (l < j) 
      {
        top++;
        stackL[top] = l;
        stackR[top] = j;
      }
      if (i < r)
      {
        top++;
        stackL[top] = i;
        stackR[top] = r;
      }
      if (top == 0) 
        state = "END";
      else
        state = "INIT_VALUE";
      break;
      
    case "END":
      noLoop();
      break;
  }
  //println(state + " l = " + str(l) + ", r = " + str(r) + ", i = " + str(i) + ", j = " + str(j) +  ", x = " + str(x));
}

void draw()
{
  SetColorMap();
  RenderOnScreen();
  Update();
}
