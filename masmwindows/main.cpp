#include <fcntl.h>
#include <io.h>
#include <cstdint>
#include <cstddef>
#include <cmath>
#include <intrin.h>
#include <cstring>

#define CONSOLE_INPUT_FILEDESC 0
#define CONSOLE_OUTPUT_FILEDESC 1
#define CONSOLE_ERROR_FILEDESC 2

#define CONSOLE_WRITE _write
#define CONSOLE_READ _read
#define CONSOLE_FLUSH _commit

// ASCII string type
    #undef StringType
    #define StringType char

    // Default 32 characters string
    #define NBK_STDLIB_STRINGLIB_HEADER
    #undef StringLib
    #undef StringSize
    #define StringLib String32
    #define StringSize 32



    ////////////////////////////////////////////////////////////////////////////
    //  SSE Branchless float minimum                                          //
    //  return : Minimum value between x and y                                //
    ////////////////////////////////////////////////////////////////////////////
    inline float SysFloatMin(float x, float y)
    {
        _mm_store_ss(&x, _mm_min_ss(_mm_set_ss(x), _mm_set_ss(y)));
        return x;
    }

    inline double SysDoubleMin(double x, double y)
    {
        _mm_store_sd(&x, _mm_min_sd(_mm_set_sd(x), _mm_set_sd(y)));
        return x;
    }

    ////////////////////////////////////////////////////////////////////////////
    //  SSE Branchless float maximum                                          //
    //  return : Maximum value between x and y                                //
    ////////////////////////////////////////////////////////////////////////////
    inline float SysFloatMax(float x, float y)
    {
        _mm_store_ss(&x, _mm_max_ss(_mm_set_ss(x), _mm_set_ss(y)));
        return x;
    }

    inline double SysDoubleMax(double x, double y)
    {
        _mm_store_sd(&x, _mm_max_sd(_mm_set_sd(x), _mm_set_sd(y)));
        return x;
    }

    ////////////////////////////////////////////////////////////////////////////
    //  SSE Branchless float clamping                                         //
    //  return : Value clamped between min and max                            //
    ////////////////////////////////////////////////////////////////////////////
    inline float SysFloatClamp(float x, float min, float max)
    {
        _mm_store_ss(&x, _mm_min_ss(_mm_max_ss(
            _mm_set_ss(x), _mm_set_ss(min)), _mm_set_ss(max))
        );
        return x;
    }

    inline double SysDoubleClamp(double x, double min, double max)
    {
        _mm_store_sd(&x, _mm_min_sd(_mm_max_sd(
            _mm_set_sd(x), _mm_set_sd(min)), _mm_set_sd(max))
        );
        return x;
    }



    namespace Math
    {
        // Float precision epsilon
        const float FloatEpsilon = 2.5e-7f;

        // Double precision epsilon
        const double DoubleEpsilon = 5.0e-16;

        // Pi constants
        const float Pi = 3.1415926535897932384626433832795f;
        const float InvPi = 0.31830988618379067153776752674503f;
        const float TwoPi = (Pi*2.0f);
        const float InvTwoPi = (1.0f/TwoPi);
        const float TwoPiThird = ((Pi*2.0f)/3.0f);
        const float PiHalf = (Pi*0.5f);
        const float InvPiHalf = (1.0f/PiHalf);
        const float PiThird = (Pi/3.0f);
        const float PiFourth = (Pi*0.25f);
        const float PiEighth = (Pi*0.125f);
        const float DegToRad = (Pi/180.0f);
        const float RadToDeg = (180.0f/Pi);

        // Square roots constants
        const float SqrtTwo = 1.4142135623730950488016887242097f;
        const float OneSqrtTwo = 0.7071067811865475244008443621048f;

        // Integer constants
        const int64_t OneIntShift = 20;
        const int64_t OneInt = (1 << OneIntShift);
        const int64_t PiInt = 3294198;
        const int64_t TwoPiInt = 6588396;
        const int64_t TwoPiThirdInt = 2196132;
        const int64_t PiHalfInt = 1647099;
        const int64_t PiThirdInt = 1098066;

        // 32bits powers of ten
        const int32_t MaxPowersOfTen32 = 10;
        const int32_t PowersOfTen32[MaxPowersOfTen32] = {
            1, 10, 100, 1000, 10000, 100000,
            1000000, 10000000, 100000000, 1000000000
        };

        // 64bits powers of ten
        const int64_t MaxPowersOfTen64 = 19;
        const int64_t PowersOfTen64[MaxPowersOfTen64] = {
            1l, 10l, 100l, 1000l, 10000l, 100000l, 1000000l, 10000000l,
            100000000l, 1000000000l, 10000000000l, 100000000000l,
            1000000000000l, 10000000000000l, 100000000000000l,
            1000000000000000l, 10000000000000000l, 100000000000000000l,
            1000000000000000000l
        };


        ////////////////////////////////////////////////////////////////////////
        //  Get number sign (-1 or +1)                                        //
        //  return : Sign of the number (-1 or +1)                            //
        ////////////////////////////////////////////////////////////////////////
        inline int32_t sign(int32_t x)
        {
            return ((x >= 0) ? 1 : -1);
        }

        inline int64_t sign(int64_t x)
        {
            return ((x >= 0) ? 1 : -1);
        }

        inline float sign(float x)
        {
            return ((x >= 0.0f) ? 1.0f : -1.0f);
        }

        inline double sign(double x)
        {
            return ((x >= 0.0) ? 1.0 : -1.0);
        }

        ////////////////////////////////////////////////////////////////////////
        //  Get number sign with zero (-1, 0, or +1)                          //
        //  return : Sign of the number with zero (-1, 0, or +1)              //
        ////////////////////////////////////////////////////////////////////////
        inline int32_t signum(int32_t x)
        {
            return ((x > 0) - (x < 0));
        }

        inline int64_t signum(int64_t x)
        {
            return ((x > 0) - (x < 0));
        }

        inline float signum(float x)
        {
            return (((x > 0.0f) - (x < 0.0f))*1.0f);
        }

        inline double signum(double x)
        {
            return (((x > 0.0) - (x < 0.0))*1.0);
        }

        ////////////////////////////////////////////////////////////////////////
        //  Get number positive boolean (0 or +1)                             //
        //  return : Positive boolean of the number (0 or +1)                 //
        ////////////////////////////////////////////////////////////////////////
        inline int32_t positive(int32_t x)
        {
            return ((x >= 0) ? 1 : 0);
        }

        inline int64_t positive(int64_t x)
        {
            return ((x >= 0) ? 1 : 0);
        }

        inline float positive(float x)
        {
            return ((x >= 0.0f) ? 1.0f : 0.0f);
        }

        inline double positive(double x)
        {
            return ((x >= 0.0) ? 1.0 : 0.0);
        }

        ////////////////////////////////////////////////////////////////////////
        //  Get number negative boolean (0 or +1)                             //
        //  return : Negative boolean of the number (0 or +1)                 //
        ////////////////////////////////////////////////////////////////////////
        inline int32_t negative(int32_t x)
        {
            return ((x >= 0) ? 0 : 1);
        }

        inline int64_t negative(int64_t x)
        {
            return ((x >= 0) ? 0 : 1);
        }

        inline float negative(float x)
        {
            return ((x >= 0.0f) ? 0.0f : 1.0f);
        }

        inline double negative(double x)
        {
            return ((x >= 0.0) ? 0.0 : 1.0);
        }

        ////////////////////////////////////////////////////////////////////////
        //  Get the absolute value of x                                       //
        //  return : Absolute value of x                                      //
        ////////////////////////////////////////////////////////////////////////
        inline int32_t abs(int32_t x)
        {
            return ((x >= 0) ? x : -x);
        }

        inline int64_t abs(int64_t x)
        {
            return ((x >= 0) ? x : -x);
        }

        inline float abs(float x)
        {
            return ((x >= 0.0f) ? x : -x);
        }

        inline double abs(double x)
        {
            return ((x >= 0.0) ? x : -x);
        }

        ////////////////////////////////////////////////////////////////////////
        //  Compare two floating points values                                //
        //  return : True if values are nearly equal, false otherwise         //
        ////////////////////////////////////////////////////////////////////////
        inline bool areEqual(float x, float y)
        {
            return (Math::abs(x - y) < Math::FloatEpsilon);
        }

        inline bool areEqual(double x, double y)
        {
            return (Math::abs(x - y) < Math::DoubleEpsilon);
        }


        ////////////////////////////////////////////////////////////////////////
        //  Get the minimum value between x and y                             //
        //  return : Minimum value between x and y                            //
        ////////////////////////////////////////////////////////////////////////
        inline int32_t min(int32_t x, int32_t y)
        {
            return ((x < y) ? x : y);
        }

        inline uint32_t min(uint32_t x, uint32_t y)
        {
            return ((x < y) ? x : y);
        }

        inline int64_t min(int64_t x, int64_t y)
        {
            return ((x < y) ? x : y);
        }

        inline uint64_t min(uint64_t x, uint64_t y)
        {
            return ((x < y) ? x : y);
        }

        inline float min(float x, float y)
        {
            return SysFloatMin(x, y);
        }

        inline double min(double x, double y)
        {
            return SysDoubleMin(x, y);
        }

        ////////////////////////////////////////////////////////////////////////
        //  Get the maximum value between x and y                             //
        //  return : Maximum value between x and y                            //
        ////////////////////////////////////////////////////////////////////////
        inline int32_t max(int32_t x, int32_t y)
        {
            return ((x > y) ? x : y);
        }

        inline uint32_t max(uint32_t x, uint32_t y)
        {
            return ((x > y) ? x : y);
        }

        inline int64_t max(int64_t x, int64_t y)
        {
            return ((x > y) ? x : y);
        }

        inline uint64_t max(uint64_t x, uint64_t y)
        {
            return ((x > y) ? x : y);
        }

        inline float max(float x, float y)
        {
            return SysFloatMax(x, y);
        }

        inline double max(double x, double y)
        {
            return SysDoubleMax(x, y);
        }

        ////////////////////////////////////////////////////////////////////////
        //  Clamp x value between min and max                                 //
        //  return : Clamped value between min and max                        //
        ////////////////////////////////////////////////////////////////////////
        inline int32_t clamp(int32_t x, int32_t min, int32_t max)
        {
            return ((x < max) ? ((x > min) ? x : min) : max);
        }

        inline uint32_t clamp(uint32_t x, uint32_t min, uint32_t max)
        {
            return ((x < max) ? ((x > min) ? x : min) : max);
        }

        inline int64_t clamp(int64_t x, int64_t min, int64_t max)
        {
            return ((x < max) ? ((x > min) ? x : min) : max);
        }

        inline uint64_t clamp(uint64_t x, uint64_t min, uint64_t max)
        {
            return ((x < max) ? ((x > min) ? x : min) : max);
        }

        inline float clamp(float x, float min, float max)
        {
            return SysFloatClamp(x, min, max);
        }

        inline double clamp(double x, double min, double max)
        {
            return SysDoubleClamp(x, min, max);
        }

        ////////////////////////////////////////////////////////////////////////
        //  Divide                                                            //
        //  param x : Left operand                                            //
        //  param n : Right operand                                           //
        //  return : Division (x / n)                                         //
        ////////////////////////////////////////////////////////////////////////
        inline int32_t divide(int32_t x, int32_t n)
        {
            if (n == 0) return 0;
            if (x < 0) { x -= (n-1); }
            return (x/n);
        }

        inline int64_t divide(int64_t x, int64_t n)
        {
            if (n == 0) return 0;
            if (x < 0) { x -= (n-1); }
            return (x/n);
        }

        inline int32_t divide(float x, float n)
        {
            if (n == 0.0f) return 0;
            if (x < 0.0f) { x -= (n-1.0f); }
            return (static_cast<int32_t>(x/n));
        }

        inline int32_t divide(double x, double n)
        {
            if (n == 0.0) return 0;
            if (x < 0.0) { x -= (n-1.0); }
            return (static_cast<int32_t>(x/n));
        }

        ////////////////////////////////////////////////////////////////////////
        //  Integer square root                                               //
        //  param x : Integer to get square root of                           //
        //  return : Integer square root (sqrt(x))                            //
        ////////////////////////////////////////////////////////////////////////
        inline int32_t sqrt(int32_t x)
        {
            return (static_cast<int32_t>(std::sqrt(x)));
        }

        inline int64_t sqrt(int64_t x)
        {
            return (static_cast<int64_t>(std::sqrt(x)));
        }

        ////////////////////////////////////////////////////////////////////////
        //  Integer binary logarithm                                          //
        //  param x : Integer to get binary logarithm of                      //
        //  return : Integer binary logarithm (log2(x))                       //
        ////////////////////////////////////////////////////////////////////////
        inline int8_t log2(int32_t x)
        {
            int8_t result = 0;
            if (x >= 0x10000) { result += 16; x >>= 16; }
            if (x >= 0x100) { result += 8; x >>= 8; }
            if (x >= 0x10) { result += 4; x >>= 4; }
            if (x >= 0x4) { result += 2; x >>= 2; }
            if (x >= 0x2) { result += 1; x >>= 1; }
            return result;
        }

        inline int8_t log2(uint32_t x)
        {
            int8_t result = 0;
            if (x >= 0x10000) { result += 16; x >>= 16; }
            if (x >= 0x100) { result += 8; x >>= 8; }
            if (x >= 0x10) { result += 4; x >>= 4; }
            if (x >= 0x4) { result += 2; x >>= 2; }
            if (x >= 0x2) { result += 1; x >>= 1; }
            return result;
        }

        inline int8_t log2(int64_t x)
        {
            int8_t result = 0;
            if (x >= 0x100000000) { result += 32; x >>= 32; }
            if (x >= 0x10000) { result += 16; x >>= 16; }
            if (x >= 0x100) { result += 8; x >>= 8; }
            if (x >= 0x10) { result += 4; x >>= 4; }
            if (x >= 0x4) { result += 2; x >>= 2; }
            if (x >= 0x2) { result += 1; x >>= 1; }
            return result;
        }

        inline int8_t log2(uint64_t x)
        {
            int8_t result = 0;
            if (x >= 0x100000000) { result += 32; x >>= 32; }
            if (x >= 0x10000) { result += 16; x >>= 16; }
            if (x >= 0x100) { result += 8; x >>= 8; }
            if (x >= 0x10) { result += 4; x >>= 4; }
            if (x >= 0x4) { result += 2; x >>= 2; }
            if (x >= 0x2) { result += 1; x >>= 1; }
            return result;
        }

        ////////////////////////////////////////////////////////////////////////
        //  Integer base 10 logarithm                                         //
        //  param x : Integer to get base 10 logarithm of                     //
        //  return : Integer base 10 logarithm (log10(x))                     //
        ////////////////////////////////////////////////////////////////////////
        inline int8_t log10(int32_t x)
        {
            return static_cast<int8_t>(std::log10(x*1.0));
        }

        inline int8_t log10(uint32_t x)
        {
            return static_cast<int8_t>(std::log10(x*1.0));
        }

        inline int8_t log10(int64_t x)
        {
            return static_cast<int8_t>(std::log10(x*1.0));
        }

        inline int8_t log10(uint64_t x)
        {
            return static_cast<int8_t>(std::log10(x*1.0));
        }

        ////////////////////////////////////////////////////////////////////////
        //  Integer power of ten                                              //
        //  param x : Power of ten exponent                                   //
        //  return : Integer power of ten (10 ^ x)                            //
        ////////////////////////////////////////////////////////////////////////
        inline int32_t power10(int32_t x)
        {
            return PowersOfTen32[Math::clamp(x, 0, (MaxPowersOfTen32-1))];
        }

        inline int64_t power10(int64_t x)
        {
            return PowersOfTen64[Math::clamp(x, 0ll, (MaxPowersOfTen64-1l))];
        }

        ////////////////////////////////////////////////////////////////////////
        //  Linear interpolation                                              //
        //  return : Interpolated value                                       //
        ////////////////////////////////////////////////////////////////////////
        inline float linearInterp(float x, float y, float t)
        {
            return (x + t*(y-x));
        }

        inline double linearInterp(double x, double y, double t)
        {
            return (x + t*(y-x));
        }

        ////////////////////////////////////////////////////////////////////////
        //  Cubic interpolation                                               //
        //  return : Interpolated value                                       //
        ////////////////////////////////////////////////////////////////////////
        inline float cubicInterp(float x, float y, float t)
        {
            return (x + (t*t*(3.0f-2.0f*t))*(y-x));
        }

        inline double cubicInterp(double x, double y, double t)
        {
            return (x + (t*t*(3.0-2.0*t))*(y-x));
        }

        ////////////////////////////////////////////////////////////////////////
        //  Hermit interpolation                                              //
        //  return : Interpolated value                                       //
        ////////////////////////////////////////////////////////////////////////
        inline float hermitInterp(float w, float x, float y, float z, float t)
        {
            return (x + (t*t*(3.0f-2.0f*t))*(y-x) +
                (0.5f*(x-w)+0.5f*(y-x))*(t*t*t-2.0f*t*t+t) +
                (0.5f*(y-x)+0.5f*(z-y))*(t*t*t-t*t));
        }

        inline double hermitInterp(
            double w, double x, double y, double z, double t)
        {
            return (x + (t*t*(3.0-2.0*t))*(y-x) +
                (0.5*(x-w)+0.5*(y-x))*(t*t*t-2.0*t*t+t) +
                (0.5*(y-x)+0.5*(z-y))*(t*t*t-t*t));
        }

    };


    ////////////////////////////////////////////////////////////////////////////
    //  StringLib class definition                                            //
    ////////////////////////////////////////////////////////////////////////////
    class StringLib
    {
        public:
            ////////////////////////////////////////////////////////////////////
            //  StringLib default constructor                                 //
            ////////////////////////////////////////////////////////////////////
            StringLib() :
            m_size(0),
            m_string()
            {
                m_string[0] = 0;
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib string constructor                                  //
            ////////////////////////////////////////////////////////////////////
            StringLib(const StringLib& string) :
            m_size(0),
            m_string()
            {
                memcpy(m_string, string.m_string, (m_size = string.m_size)+1);
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib array constructor                                   //
            ////////////////////////////////////////////////////////////////////
            StringLib(const StringType* array) :
            m_size(0),
            m_string()
            {
                while (((m_string[m_size] = array[m_size]) != 0) &&
                    (m_size < (StringSize-1))) { ++m_size; }
                m_string[(StringSize-1)] = 0;
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib destructor                                          //
            ////////////////////////////////////////////////////////////////////
            ~StringLib()
            {

            }


            ////////////////////////////////////////////////////////////////////
            //  Clear the string                                              //
            ////////////////////////////////////////////////////////////////////
            inline void clear()
            {
                m_size = 0;
                m_string[0] = 0;
            }

            ////////////////////////////////////////////////////////////////////
            //  Erase a substring of the string                               //
            ////////////////////////////////////////////////////////////////////
            inline void erase(int32_t offset, int32_t length)
            {
                (void)offset;
                (void)length;
            }

            ////////////////////////////////////////////////////////////////////
            //  Erase the last character of the string                        //
            ////////////////////////////////////////////////////////////////////
            inline void popback()
            {
                m_size = Math::max(m_size-1, 0);
                m_string[m_size] = 0;
            }

            ////////////////////////////////////////////////////////////////////
            //  Get a substring of the string                                 //
            ////////////////////////////////////////////////////////////////////
            inline StringLib substr(int32_t offset, int32_t length)
            {
                StringLib result;
                (void)offset;
                (void)length;
                return result;
            }

            ////////////////////////////////////////////////////////////////////
            //  Insert a string within the string                             //
            ////////////////////////////////////////////////////////////////////
            inline void insert(int32_t offset, const StringLib& string)
            {
                (void)offset;
                (void)string;
            }

            ////////////////////////////////////////////////////////////////////
            //  Replace a subpart of the string by another string             //
            ////////////////////////////////////////////////////////////////////
            inline void replace(int32_t offset, int32_t length,
                const StringLib& string)
            {
                (void)offset;
                (void)length;
                (void)string;
            }


            ////////////////////////////////////////////////////////////////////
            //  Match a subpart of the string with another string             //
            ////////////////////////////////////////////////////////////////////
            inline bool match(int32_t offset, const StringLib& string)
            {
                (void)offset;
                (void)string;
                return false;
            }

            ////////////////////////////////////////////////////////////////////
            //  Find the first string occurence within the string             //
            ////////////////////////////////////////////////////////////////////
            inline int32_t find(const StringLib& string)
            {
                (void)string;
                return -1;
            }

            ////////////////////////////////////////////////////////////////////
            //  Find the last string occurence within the string              //
            ////////////////////////////////////////////////////////////////////
            inline int32_t rfind(const StringLib& string)
            {
                (void)string;
                return -1;
            }

            ////////////////////////////////////////////////////////////////////
            //  Replace the first occurrence of a string by another string    //
            ////////////////////////////////////////////////////////////////////
            inline void findAndReplace(const StringLib& find,
                const StringLib& string)
            {
                (void)find;
                (void)string;
            }

            ////////////////////////////////////////////////////////////////////
            //  Replace first occurrence of a character by another character  //
            ////////////////////////////////////////////////////////////////////
            inline void findAndReplace(const StringType find,
                const StringType character)
            {
                (void)find;
                (void)character;
            }

            ////////////////////////////////////////////////////////////////////
            //  Replace the first occurrence of a string by another string    //
            ////////////////////////////////////////////////////////////////////
            inline void findAndReplaceAll(const StringLib& find,
                const StringLib& string)
            {
                (void)find;
                (void)string;
            }

            ////////////////////////////////////////////////////////////////////
            //  Replace first occurrence of a character by another character  //
            ////////////////////////////////////////////////////////////////////
            inline void findAndReplaceAll(const StringType find,
                const StringType character)
            {
                (void)find;
                (void)character;
            }


            ////////////////////////////////////////////////////////////////////
            //  Extract a folder path from a path                             //
            ////////////////////////////////////////////////////////////////////
            inline StringLib folderPath()
            {
                StringLib result;
                return result;
            }

            ////////////////////////////////////////////////////////////////////
            //  Extract a parent folder path from a path                      //
            ////////////////////////////////////////////////////////////////////
            inline StringLib parentFolderPath()
            {
                StringLib result;
                return result;
            }

            ////////////////////////////////////////////////////////////////////
            //  Extract a folder name from a path                             //
            ////////////////////////////////////////////////////////////////////
            inline StringLib folderName()
            {
                StringLib result;
                return result;
            }

            ////////////////////////////////////////////////////////////////////
            //  Extract a file name from a path                               //
            ////////////////////////////////////////////////////////////////////
            inline StringLib fileName()
            {
                StringLib result;
                return result;
            }

            ////////////////////////////////////////////////////////////////////
            //  Extract a file extension from a path or a file name           //
            ////////////////////////////////////////////////////////////////////
            inline StringLib fileExt()
            {
                StringLib result;
                return result;
            }


            ////////////////////////////////////////////////////////////////////
            //  Test if the string is empty                                   //
            ////////////////////////////////////////////////////////////////////
            inline bool isEmpty() const
            {
                return (m_size == 0);
            }

            ////////////////////////////////////////////////////////////////////
            //  Get first character of the string                             //
            ////////////////////////////////////////////////////////////////////
            inline StringType& front()
            {
                return m_string[0];
            }

            ////////////////////////////////////////////////////////////////////
            //  Get last character of the string (before \0)                  //
            ////////////////////////////////////////////////////////////////////
            inline StringType& back()
            {
                return m_string[m_size-1];
            }

            ////////////////////////////////////////////////////////////////////
            //  Get sentinel character of the string (\0)                     //
            ////////////////////////////////////////////////////////////////////
            inline StringType& sentinel()
            {
                return m_string[m_size];
            }

            ////////////////////////////////////////////////////////////////////
            //  Get last character of the internal string array               //
            ////////////////////////////////////////////////////////////////////
            inline StringType& last()
            {
                return m_string[StringSize-1];
            }

            ////////////////////////////////////////////////////////////////////
            //  Get string internal string data array pointer                 //
            ////////////////////////////////////////////////////////////////////
            inline StringType* data()
            {
                return m_string;
            }

            ////////////////////////////////////////////////////////////////////
            //  Get string internal string array                              //
            ////////////////////////////////////////////////////////////////////
            inline const StringType* str() const
            {
                return m_string;
            }

            ////////////////////////////////////////////////////////////////////
            //  Get string internal size reference                            //
            ////////////////////////////////////////////////////////////////////
            inline int32_t& size()
            {
                return m_size;
            }

            ////////////////////////////////////////////////////////////////////
            //  Get string length                                             //
            ////////////////////////////////////////////////////////////////////
            inline int32_t length() const
            {
                return m_size;
            }

            ////////////////////////////////////////////////////////////////////
            //  Get maximum allowed size (internal array size)                //
            ////////////////////////////////////////////////////////////////////
            inline int32_t maxSize() const
            {
                return StringSize;
            }


        public:
            ////////////////////////////////////////////////////////////////////
            //  StringLib copy operator                                       //
            ////////////////////////////////////////////////////////////////////
            inline StringLib& operator=(const StringLib& string)
            {
                memcpy(m_string, string.m_string, (m_size = string.m_size)+1);
                return *this;
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib array copy operator                                 //
            ////////////////////////////////////////////////////////////////////
            inline StringLib& operator=(const StringType* array)
            {
                m_size = 0;
                while (((m_string[m_size] = array[m_size]) != 0) &&
                    (m_size < (StringSize-1))) { ++m_size; }
                m_string[(StringSize-1)] = 0;
                return *this;
            }


            ////////////////////////////////////////////////////////////////////
            //  StringLib addition operator                                   //
            ////////////////////////////////////////////////////////////////////
            inline StringLib operator+(const StringLib& string) const
            {
                StringLib result(*this);
                return (result << string);
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib array addition operator                             //
            ////////////////////////////////////////////////////////////////////
            inline StringLib operator+(const StringType* array) const
            {
                StringLib result(*this);
                return (result << array);
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib character addition operator                         //
            ////////////////////////////////////////////////////////////////////
            inline StringLib operator+(const StringType character) const
            {
                StringLib result(*this);
                return (result << character);
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib addition assignment operator                        //
            ////////////////////////////////////////////////////////////////////
            inline StringLib& operator+=(const StringLib& string)
            {
                return ((*this) << string);
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib array addition assignment operator                  //
            ////////////////////////////////////////////////////////////////////
            inline StringLib& operator+=(const StringType* array)
            {
                return ((*this) << array);
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib character addition assignment operator              //
            ////////////////////////////////////////////////////////////////////
            inline StringLib& operator+=(const StringType character)
            {
                return ((*this) << character);
            }


            ////////////////////////////////////////////////////////////////////
            //  StringLib left shift operator                                 //
            ////////////////////////////////////////////////////////////////////
            inline StringLib& operator<<(const StringLib& string)
            {
                int32_t sz = Math::min(string.m_size, (StringSize-m_size-1));
                memcpy(&m_string[m_size], string.m_string, sz);
                m_string[m_size += sz] = 0;
                return *this;
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib array left shift operator                           //
            ////////////////////////////////////////////////////////////////////
            inline StringLib& operator<<(const StringType* array)
            {
                int32_t i = 0;
                while (((m_string[m_size] = array[i++]) != 0) &&
                    (m_size < (StringSize-1))) { ++m_size; }
                m_string[(StringSize-1)] = 0;
                return *this;
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib character left shift operator                       //
            ////////////////////////////////////////////////////////////////////
            inline StringLib& operator<<(const StringType character)
            {
                m_string[m_size] = character;
                m_size = Math::min(m_size+1, (StringSize-1));
                m_string[m_size] = 0;
                return *this;
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib integer left shift operator                         //
            ////////////////////////////////////////////////////////////////////
            StringLib& operator<<(int32_t value)
            {
                // Negative number
                if (value < 0)
                {
                    value = -value;
                    m_string[m_size] = '-';
                    m_size = Math::min(m_size+1, (StringSize-1));
                }

                // Write number digit by digit
                for (int32_t i = Math::log10(value); i >= 0; --i)
                {
                    m_string[m_size] = static_cast<StringType>(
                        48 + ((value / Math::power10(i)) % 10)
                    );
                    m_size = Math::min(m_size+1, (StringSize-1));
                }

                // Last nul character
                m_string[m_size] = 0;
                return *this;
            }

            StringLib& operator<<(int64_t value)
            {
                // Negative number
                if (value < 0)
                {
                    value = -value;
                    m_string[m_size] = '-';
                    m_size = Math::min(m_size+1, (StringSize-1));
                }

                // Write number digit by digit
                for (int64_t i = Math::log10(value); i >= 0; --i)
                {
                    m_string[m_size] = static_cast<StringType>(
                        48 + ((value / Math::power10(i)) % 10)
                    );
                    m_size = Math::min(m_size+1, (StringSize-1));
                }

                // Last nul character
                m_string[m_size] = 0;
                return *this;
            }


            ////////////////////////////////////////////////////////////////////
            //  StringLib array subscript operator []                         //
            ////////////////////////////////////////////////////////////////////
            inline StringType& operator[](int32_t index)
            {
                return m_string[Math::clamp(index, 0, (StringSize-1))];
            }


            ////////////////////////////////////////////////////////////////////
            //  StringLib equal to operator                                   //
            ////////////////////////////////////////////////////////////////////
            inline bool operator==(const StringLib& string) const
            {
                if (m_size != string.m_size) { return false; }
                return (memcmp(m_string, string.m_string, m_size) == 0);
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib array equal to operator                             //
            ////////////////////////////////////////////////////////////////////
            inline bool operator==(const StringType* array) const
            {
                int32_t i = 0;
                while ((m_string[i] == array[i]) && (i <= m_size)) { ++i; }
                return (i == (m_size+1));
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib not equal to operator                               //
            ////////////////////////////////////////////////////////////////////
            inline bool operator!=(const StringLib& string) const
            {
                if (m_size != string.m_size) { return true; }
                return (memcmp(m_string, string.m_string, m_size) != 0);
            }

            ////////////////////////////////////////////////////////////////////
            //  StringLib array not equal to operator                         //
            ////////////////////////////////////////////////////////////////////
            inline bool operator!=(const StringType* array) const
            {
                int32_t i = 0;
                while ((m_string[i] == array[i]) && (i <= m_size)) { ++i; }
                return (i != (m_size+1));
            }


        private:
            int32_t         m_size;                     // String size
            StringType      m_string[StringSize];       // String array
    };


    // Default string
    #undef StringLib
    #undef StringSize


int main()
{
    char ch[8];
    for (int j = 0; j < 8; ++j)
    {
        ch[j] = -1;
    }
    int bytesread = CONSOLE_READ(CONSOLE_INPUT_FILEDESC, ch, 8);
    CONSOLE_WRITE(CONSOLE_OUTPUT_FILEDESC, ch, 8);

    String32 test;
    for (int i = 0; i < 8; ++i)
    {
        test.clear();
        test << (int)ch[i] << ' ';
        CONSOLE_WRITE(CONSOLE_OUTPUT_FILEDESC, test.data(), test.size());
    }
    test.clear();
    test << "bytesread : " << bytesread << '\n';
    CONSOLE_WRITE(CONSOLE_OUTPUT_FILEDESC, test.data(), test.size());
    return 0;
}
