#include <iostream>
#include "triple.h"

template<class Type>
Type triple(Type x)
{
  Type ret = x * Type(3);
  std::cout << __FILE__ << ':' << __LINE__ << ' ' << ret << std::endl;
  return ret;
}
