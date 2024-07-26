#include <stdio.h>

void sex(const char* person, int nTimes)
{
  printf("sex with %s %i times!\n", person, nTimes);
  return;
}

int main(void)
{
  sex("felix", 31);
  
  return 0;
}
