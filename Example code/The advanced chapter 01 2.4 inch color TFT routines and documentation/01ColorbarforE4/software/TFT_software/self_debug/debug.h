#ifndef DEBUG_H_
#define DEBUG_H_

int myprintf(char *format, ...);
int myprintf_hexarray(unsigned char *pHex, int len);
int myprintf_dwordarray(unsigned int *pArray, int nElementCount);

#define ENABLE_STDOUT_DEBUG // turn on all of debug message using standard in/out
//#define ENABLE_UART_DEBUG // turn on debug message using uart

#ifdef ENABLE_STDOUT_DEBUG
    #define DEBUG(x)               {myprintf x;}
//    #define DEBUG_HEX_ARRAY(x)     {myprintf_hexarray x;}
//    #define DEBUG_DWORD_ARRAY(x)   {myprintf_dwordarray x;}
#else                // nothing
    #define DEBUG(x)
    #define DEBUG_HEX_ARRAY(x)
    #define DEBUG_DWORD_ARRAY(x)
#endif

#endif /* DEBUG_H_ */
