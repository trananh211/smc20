//+------------------------------------------------------------------+
//|                                                      GlobalVars.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


//#region variable declaration
bool enabledComment = true;
bool disableComment = false;

bool enabledDraw = true;
bool disableDraw = false;

int GANN_STRUCTURE = 1;
int INTERNAL_STRUCTURE = 2;
int INTERNAL_STRUCTURE_KEY = 3;
int MAJOR_STRUCTURE = 4;

//Constant
string IDM_TEXT = "idm";
string IDM_TEXT_LIVE = "idm-l";
string CHOCH_TEXT = "CHoCH";
string I_CHOCH_TEXT = "i-choch";
string BOS_TEXT = "BOS";
string I_BOS_TEXT = "i-bos";
string PDH_TEXT = "PDH";
string PDL_TEXT = "PDL";
string MID_TEXT = "0.5";
string ULTRAVOLUME = " has UltraVolume";
string SWEEPT = "";

int iWingding_gann_high = 159;
int iWingding_gann_low = 159;
int iWingding_internal_high = 225;
int iWingding_internal_low = 226;
int iWingding_internal_key_high = 225;
int iWingding_internal_key_low = 226;

input int _PointSpace = 1000; // space for draw with swing, line
input int poi_limit = 30; // poi limit save to array
int limit = 10; // size of array Swing High, Low
int lookback = 100; // so luong bar tim kiem nguoc tinh tu thoi diem hien tai

// định nghĩa riêng cặp khung thời gian trade
enum pairTF {m1_m15 = 1, m5_h1 = 5, m15_h4 = 15, h1_d1 = 60};
input pairTF pairTimeFrameInput = m5_h1; // Cặp khung thời gian trade: low TimeFrame _ high TimeFrame
int lowPairTF = pairTimeFrameInput;
int highPairTF;
ENUM_TIMEFRAMES lowTimeFrame, highTimeFrame;
input bool isDrawHighTF = true; // Draw Zone HighTimeframe
input bool isDrawLowTF = false; // Draw Zone LowTimeframe
// định nghĩa get tick volume là loại nào. max volume 3 nến liền kề, hay chính volume của cây nến đó
enum isTickVolume {isBar = 1, isMax3Bar = 2};
input isTickVolume typeTickVolume = 1; // 1: is Bar; 2 : largest of 3 adjacent candles

// End #region variale declaration

//+------------------------------------------------------------------+
//| PoiZone structure                                                |
//+------------------------------------------------------------------+
struct PoiZone
{
   double high;
   double low;
   double open;
   double close;
   datetime time;
   int mitigated; // -1 mitigated, 0 not mitigate, 1 mitigating
   double priceKey;
   datetime timeKey;
};

//+------------------------------------------------------------------+
//| TimeFrameData class                                              |
//+------------------------------------------------------------------+
class TimeFrameData
{
public:
   int isTimeframe;
   color tfColor;
   ENUM_TIMEFRAMES timeFrame;
   bool isDraw;
   // Gann Wave
   double highEst;
   double lowEst;
   double Highs[];
   double Lows[];
   datetime hightime;
   datetime lowtime;
   datetime HighsTime[];
   datetime LowsTime[];
   long volHighs[];
   long volLows[];
   
   int LastSwingMeter;
   int gTrend;

   // Internal Structure
   double intSHighs[];
   double intSLows[];
   datetime intSHighTime[];
   datetime intSLowTime[];
   long volIntSHighs[];
   long volIntSLows[];
   
   int LastSwingInternal;
   int iTrend;

   // Array pullback
   double arrTop[];
   double arrBot[];
   datetime arrTopTime[];
   datetime arrBotTime[];
   long volArrTop[];
   long volArrBot[];

   int mTrend;
   int sTrend;
   datetime arrPbHTime[];
   double arrPbHigh[];
   datetime arrPbLTime[];
   double arrPbLow[];
   long volArrPbHigh[];
   long volArrPbLow[];

   // Chopped and Breakout
   double arrChoHigh[];
   double arrChoLow[];
   long volArrChoHigh[];
   long volArrChoLow[];
   datetime arrChoHighTime[];
   datetime arrChoLowTime[];
   
   double arrBoHigh[];
   double arrBoLow[];
   datetime arrBoHighTime[];
   datetime arrBoLowTime[];
   long volArrBoHigh[];
   long volArrBoLow[];

   // Major Swing
   int LastSwingMajor;
   datetime lastTimeH;
   datetime lastTimeL;
   double L; long vol_L;
   double H; long vol_H;

   double idmLow;
   double idmHigh;
   double L_idmLow;
   double L_idmHigh;
   double lastH;
   double lastL;
   double H_lastH;
   double L_lastHH;
   double H_lastLL;
   double L_lastL;
   double motherHigh;
   double motherLow;
   double findHigh;
   double findLow;
   MqlRates L_bar;
   MqlRates H_bar;

   // Time indexes
   datetime idmLowTime;
   datetime idmHighTime;
   datetime L_idmLowTime;
   datetime L_idmHighTime;
   datetime HTime;
   datetime LTime;

   // POI Arrays
   PoiZone zHighs[];
   PoiZone zLows[];
   PoiZone zIntSHighs[];
   PoiZone zIntSLows[];
   PoiZone zArrTop[];
   PoiZone zArrBot[];
   PoiZone zArrPbHigh[];
   PoiZone zArrPbLow[];
   PoiZone zPoiExtremeLow[];
   PoiZone zPoiExtremeHigh[];
   PoiZone zPoiLow[];
   PoiZone zPoiHigh[];
   PoiZone zPoiDecisionalLow[];
   PoiZone zPoiDecisionalHigh[];

   double arrDecisionalHigh[];
   double arrDecisionalLow[];
   datetime arrDecisionalHighTime[];
   datetime arrDecisionalLowTime[];
   long volArrDecisionalHigh[];
   long volArrDecisionalLow[];
   PoiZone zArrDecisionalHigh[];
   PoiZone zArrDecisionalLow[];
   
   //double arrIdmHigh[];
   //double arrIdmLow[];
   //datetime arrIdmHBar[];
   //datetime arrIdmLBar[];
   //double arrLastH[];
   //datetime arrLastHBar[];
   //double arrLastL[];
   //datetime arrLastLBar[];

   // Constructor
   TimeFrameData()
   {
      isTimeframe = 0;
      tfColor = clrGray;
      timeFrame = PERIOD_M1;
      isDraw = false;
      highEst = 0.0;
      lowEst = 0.0;
      hightime = 0;
      lowtime = 0;
      LastSwingMeter = 0;
      gTrend = 0;
      LastSwingInternal = 0;
      iTrend = 0;
      mTrend = 0;
      sTrend = 0;
      LastSwingMajor = 0;
      lastTimeH = 0;
      lastTimeL = 0;
      L = 0.0;
      H = 0.0;
      idmLow = 0.0;
      idmHigh = 0.0;
      L_idmLow = 0.0;
      L_idmHigh = 0.0;
      lastH = 0.0;
      lastL = 0.0;
      H_lastH = 0.0;
      L_lastHH = 0.0;
      H_lastLL = 0.0;
      L_lastL = 0.0;
      motherHigh = 0.0;
      motherLow = 0.0;
      findHigh = 0.0;
      findLow = 0.0;
      idmLowTime = 0;
      idmHighTime = 0;
      L_idmLowTime = 0;
      L_idmHighTime = 0;
      HTime = 0;
      LTime = 0;
      
      ArrayInitialize(Highs, 0.0);
      ArrayInitialize(Lows, 0.0);
      ArrayInitialize(HighsTime, 0);
      ArrayInitialize(LowsTime, 0);
      ArrayInitialize(volHighs, 0.0);
      ArrayInitialize(volLows, 0.0);

      ArrayInitialize(intSHighs, 0.0);
      ArrayInitialize(intSLows, 0.0);
      ArrayInitialize(intSHighTime, 0);
      ArrayInitialize(intSLowTime, 0);
      
      ArrayInitialize(volIntSHighs, 0.0);
      ArrayInitialize(volIntSLows, 0.0);

      ArrayInitialize(arrTop, 0.0);
      ArrayInitialize(arrBot, 0.0);
      ArrayInitialize(arrTopTime, 0);
      ArrayInitialize(arrBotTime, 0);
      ArrayInitialize(volArrTop, 0);
      ArrayInitialize(volArrBot, 0);
      
      ArrayInitialize(arrPbHTime, 0);
      ArrayInitialize(arrPbHigh, 0.0);
      ArrayInitialize(arrPbLTime, 0);
      ArrayInitialize(arrPbLow, 0.0);

      ArrayInitialize(volArrPbHigh, 0);
      ArrayInitialize(volArrPbLow, 0);

      ArrayInitialize(arrChoHigh, 0.0);
      ArrayInitialize(arrChoLow, 0.0);
      ArrayInitialize(arrChoHighTime, 0);
      ArrayInitialize(arrChoLowTime, 0);
      
      ArrayInitialize(volArrChoHigh, 0);
      ArrayInitialize(volArrChoLow, 0);

      ArrayInitialize(arrBoHigh, 0.0);
      ArrayInitialize(arrBoLow, 0.0);
      ArrayInitialize(arrBoHighTime, 0);
      ArrayInitialize(arrBoLowTime, 0);

      ArrayInitialize(volArrBoHigh, 0);
      ArrayInitialize(volArrBoLow, 0);
      
      ArrayInitialize(arrDecisionalHigh, 0.0);
      ArrayInitialize(arrDecisionalLow, 0.0);
      ArrayInitialize(arrDecisionalHighTime, 0);
      ArrayInitialize(arrDecisionalLowTime, 0);

      ArrayInitialize(volArrDecisionalHigh, 0);
      ArrayInitialize(volArrDecisionalLow, 0);
      
      ZeroMemory(L_bar);
      ZeroMemory(H_bar);
   }
   
   // Helper Methods for Array Management

   // Phương thức thêm phần tử vào mảng long
   int AddToLongArray(long &array[], long value, int ilimit = 10)
   {
      //if ( ArraySize(array) > 0 && array[0] == value) return 0;
      // Store value in array[]
      // shift existing elements in array[] to make space for the new value
      ArrayResize(array, MathMin(ArraySize(array) + 1, ilimit));
      for(int i = ArraySize(array) - 1; i > 0; --i) {
         array[i] = array[i-1];   
      }
      // Store newvalue in arPrice[0], the first position
      array[0] = value;
      
      return ArraySize(array);
   }

   // Phương thức thêm phần tử vào mảng double
   int AddToDoubleArray(double &array[], double value, int ilimit = 10)
   {
      //if ( ArraySize(array) > 0 && array[0] == value) return 0;
      // Store value in array[]
      // shift existing elements in array[] to make space for the new value
      ArrayResize(array, MathMin(ArraySize(array) + 1, ilimit));
      for(int i = ArraySize(array) - 1; i > 0; --i) {
         array[i] = array[i-1];   
      }
      // Store newvalue in arPrice[0], the first position
      array[0] = value;
      
      return ArraySize(array);
   }
   
   // Phương thức thêm phần tử vào mảng datetime
   int AddToDateTimeArray(datetime &array[], datetime value, int ilimit = 10)
   {
      //if ( ArraySize(array) > 0 && array[0] == value) return 0;
      // Store value in array[]
      // shift existing elements in array[] to make space for the new value
      ArrayResize(array, MathMin(ArraySize(array) + 1, ilimit));
      for(int i = ArraySize(array) - 1; i > 0; --i) {
         array[i] = array[i-1];   
      }
      // Store newvalue in arPrice[0], the first position
      array[0] = value;
      
      return ArraySize(array);
   }
   
   // Phương thức thêm phần tử vào mảng PoiZone
   int AddToPoiZoneArray(PoiZone &array[], PoiZone &value, int ilimit = 10)
   {
      if ( ArraySize(array) > 0 && array[0].high == value.high && array[0].low == value.low) return 0;
      // Store value in array[]
      // shift existing elements in array[] to make space for the new value
      ArrayResize(array, MathMin(ArraySize(array) + 1, ilimit));
      for(int i = ArraySize(array) - 1; i > 0; --i) {
         array[i] = array[i-1];   
      }
      // Store newvalue in arPrice[0], the first position
      array[0] = value;
      
      return ArraySize(array);
   }
   
   // Phương thức xóa phần tử từ mảng long theo index
   bool RemoveFromLongArray(long &array[], int index)
   {
      int size = ArraySize(array);
      if(index < 0 || index >= size) return false;
      
      for(int i = index; i < size - 1; i++)
         array[i] = array[i + 1];
      
      ArrayResize(array, size - 1);
      return true;
   }

   // Phương thức xóa phần tử từ mảng double theo index
   bool RemoveFromDoubleArray(double &array[], int index)
   {
      int size = ArraySize(array);
      if(index < 0 || index >= size) return false;
      
      for(int i = index; i < size - 1; i++)
         array[i] = array[i + 1];
      
      ArrayResize(array, size - 1);
      return true;
   }
   
   // Phương thức xóa phần tử từ mảng datetime theo index
   bool RemoveFromDateTimeArray(datetime &array[], int index)
   {
      int size = ArraySize(array);
      if(index < 0 || index >= size) return false;
      
      for(int i = index; i < size - 1; i++)
         array[i] = array[i + 1];
      
      ArrayResize(array, size - 1);
      return true;
   }
   
   // Phương thức xóa phần tử từ mảng PoiZone theo index
   bool RemoveFromPoiZoneArray(PoiZone &array[], int index)
   {
      int size = ArraySize(array);
      if(index < 0 || index >= size) return false;
      
      for(int i = index; i < size - 1; i++)
         array[i] = array[i + 1];
      
      ArrayResize(array, size - 1);
      return true;
   }
   
   // Phương thức cập nhật phần tử trong mảng double
   bool UpdateLongArray(long &array[], int index, long value)
   {
      int size = ArraySize(array);
      if(index < 0 || index >= size) return false;
      
      array[index] = value;
      return true;
   }
   
   // Phương thức cập nhật phần tử trong mảng double
   bool UpdateDoubleArray(double &array[], int index, double value)
   {
      int size = ArraySize(array);
      if(index < 0 || index >= size) return false;
      
      array[index] = value;
      return true;
   }
   
   // Phương thức cập nhật phần tử trong mảng datetime
   bool UpdateDateTimeArray(datetime &array[], int index, datetime value)
   {
      int size = ArraySize(array);
      if(index < 0 || index >= size) return false;
      
      array[index] = value;
      return true;
   }
   
   // Phương thức cập nhật phần tử trong mảng PoiZone
   bool UpdatePoiZoneArray(PoiZone &array[], int index, PoiZone &value)
   {
      int size = ArraySize(array);
      if(index < 0 || index >= size) return false;
      
      array[index] = value;
      return true;
   }
   
   // Phương thức tìm kiếm phần tử trong mảng double
   int FindInDoubleArray(double &array[], double value, double tolerance = 0.00001)
   {
      for(int i = 0; i < ArraySize(array); i++)
      {
         if(MathAbs(array[i] - value) <= tolerance)
            return i;
      }
      return -1;
   }
   
   // Phương thức tìm kiếm phần tử trong mảng datetime
   int FindInDateTimeArray(datetime &array[], datetime value)
   {
      for(int i = 0; i < ArraySize(array); i++)
      {
         if(array[i] == value)
            return i;
      }
      return -1;
   }
   
   // Phương thức tìm kiếm phần tử trong mảng PoiZone theo time
   int FindInPoiZoneArrayByTime(PoiZone &array[], datetime time)
   {
      for(int i = 0; i < ArraySize(array); i++)
      {
         if(array[i].time == time)
            return i;
      }
      return -1;
   }
   
   // Phương thức tìm kiếm phần tử trong mảng PoiZone theo priceKey
   int FindInPoiZoneArrayByPrice(PoiZone &array[], double price, double tolerance = 0.00001)
   {
      for(int i = 0; i < ArraySize(array); i++)
      {
         if(MathAbs(array[i].priceKey - price) <= tolerance)
            return i;
      }
      return -1;
   }
   
   // Phương thức sắp xếp mảng double giảm dần
   void SortDoubleArrayDesc(double &array[])
   {
      int size = ArraySize(array);
      for(int i = 0; i < size - 1; i++)
      {
         for(int j = i + 1; j < size; j++)
         {
            if(array[i] < array[j])
            {
               double temp = array[i];
               array[i] = array[j];
               array[j] = temp;
            }
         }
      }
   }
   
   // Phương thức sắp xếp mảng double tăng dần
   void SortDoubleArrayAsc(double &array[])
   {
      int size = ArraySize(array);
      for(int i = 0; i < size - 1; i++)
      {
         for(int j = i + 1; j < size; j++)
         {
            if(array[i] > array[j])
            {
               double temp = array[i];
               array[i] = array[j];
               array[j] = temp;
            }
         }
      }
   }
   
   // Phương thức sắp xếp mảng PoiZone theo time giảm dần
   void SortPoiZoneArrayByTimeDesc(PoiZone &array[])
   {
      int size = ArraySize(array);
      for(int i = 0; i < size - 1; i++)
      {
         for(int j = i + 1; j < size; j++)
         {
            if(array[i].time < array[j].time)
            {
               PoiZone temp = array[i];
               array[i] = array[j];
               array[j] = temp;
            }
         }
      }
   }
   
   // Phương thức sắp xếp mảng PoiZone theo priceKey giảm dần
   void SortPoiZoneArrayByPriceDesc(PoiZone &array[])
   {
      int size = ArraySize(array);
      for(int i = 0; i < size - 1; i++)
      {
         for(int j = i + 1; j < size; j++)
         {
            if(array[i].priceKey < array[j].priceKey)
            {
               PoiZone temp = array[i];
               array[i] = array[j];
               array[j] = temp;
            }
         }
      }
   }
   
   // Phương thức lọc mảng PoiZone theo time range
   int FilterPoiZoneArrayByTime(PoiZone &source[], PoiZone &result[], datetime fromTime, datetime toTime)
   {
      int count = 0;
      for(int i = 0; i < ArraySize(source); i++)
      {
         if(source[i].time >= fromTime && source[i].time <= toTime)
         {
            AddToPoiZoneArray(result, source[i]);
            count++;
         }
      }
      return count;
   }
   
   // Phương thức lọc mảng PoiZone theo price range
   int FilterPoiZoneArrayByPrice(PoiZone &source[], PoiZone &result[], double minPrice, double maxPrice)
   {
      int count = 0;
      for(int i = 0; i < ArraySize(source); i++)
      {
         if(source[i].priceKey >= minPrice && source[i].priceKey <= maxPrice)
         {
            AddToPoiZoneArray(result, source[i]);
            count++;
         }
      }
      return count;
   }
   
   // Phương thức xóa tất cả phần tử trong mảng double
   void ClearDoubleArray(double &array[])
   {
      ArrayResize(array, 0);
   }
   
   // Phương thức xóa tất cả phần tử trong mảng datetime
   void ClearDateTimeArray(datetime &array[])
   {
      ArrayResize(array, 0);
   }
   
   // Phương thức xóa tất cả phần tử trong mảng PoiZone
   void ClearPoiZoneArray(PoiZone &array[])
   {
      ArrayResize(array, 0);
   }
   
   // Phương thức lấy giá trị cao nhất từ mảng double
   double GetMaxFromDoubleArray(double &array[])
   {
      if(ArraySize(array) == 0) return EMPTY_VALUE;
      
      double maxVal = array[0];
      for(int i = 1; i < ArraySize(array); i++)
      {
         if(array[i] > maxVal)
            maxVal = array[i];
      }
      return maxVal;
   }
   
   // Phương thức lấy giá trị thấp nhất từ mảng double
   double GetMinFromDoubleArray(double &array[])
   {
      if(ArraySize(array) == 0) return EMPTY_VALUE;
      
      double minVal = array[0];
      for(int i = 1; i < ArraySize(array); i++)
      {
         if(array[i] < minVal)
            minVal = array[i];
      }
      return minVal;
   }
   
   // Phương thức lấy PoiZone mới nhất từ mảng PoiZone
   bool GetLatestPoiZone(PoiZone &array[], PoiZone &result)
   {
      if(ArraySize(array) == 0) return false;
      
      int latestIndex = 0;
      for(int i = 1; i < ArraySize(array); i++)
      {
         if(array[i].time > array[latestIndex].time)
            latestIndex = i;
      }
      
      result = array[latestIndex];
      return true;
   }
   
   // Phương thức lấy PoiZone cũ nhất từ mảng PoiZone
   bool GetOldestPoiZone(PoiZone &array[], PoiZone &result)
   {
      if(ArraySize(array) == 0) return false;
      
      int oldestIndex = 0;
      for(int i = 1; i < ArraySize(array); i++)
      {
         if(array[i].time < array[oldestIndex].time)
            oldestIndex = i;
      }
      
      result = array[oldestIndex];
      return true;
   }
};

//+------------------------------------------------------------------+
//| Global Variables Manager Class                                   |
//+------------------------------------------------------------------+
class CGlobalVariables
{
private:
   // Array to store timeframe data
   TimeFrameData* m_timeframeData[];
   ENUM_TIMEFRAMES m_timeframes[];
   int m_total;

   // Find index of timeframe in array
   int FindTimeFrameIndex(ENUM_TIMEFRAMES timeframe)
   {
      for(int i = 0; i < m_total; i++)
      {
         if(m_timeframes[i] == timeframe)
            return i;
      }
      return -1;
   }

public:
   // Constructor
   CGlobalVariables()
   {
      m_total = 0;
      ArrayResize(m_timeframeData, 10);
      ArrayResize(m_timeframes, 10);
   }

   // Destructor
   ~CGlobalVariables()
   {
      for(int i = 0; i < m_total; i++)
      {
         if(CheckPointer(m_timeframeData[i]) == POINTER_DYNAMIC)
            delete m_timeframeData[i];
      }
   }

   // Get data for specific timeframe
   TimeFrameData* GetData(ENUM_TIMEFRAMES timeframe)
   {
      int index = FindTimeFrameIndex(timeframe);
      if(index >= 0)
         return m_timeframeData[index];

      // Resize arrays if needed
      if(m_total >= ArraySize(m_timeframeData))
      {
         ArrayResize(m_timeframeData, m_total + 10);
         ArrayResize(m_timeframes, m_total + 10);
      }

      // Create new timeframe data
      m_timeframeData[m_total] = new TimeFrameData();
      m_timeframes[m_total] = timeframe;
      m_total++;

      return m_timeframeData[m_total - 1];
   }

   // Remove timeframe data
   bool RemoveTimeFrame(ENUM_TIMEFRAMES timeframe)
   {
      int index = FindTimeFrameIndex(timeframe);
      if(index < 0)
         return false;

      if(CheckPointer(m_timeframeData[index]) == POINTER_DYNAMIC)
         delete m_timeframeData[index];

      // Shift arrays
      for(int i = index; i < m_total - 1; i++)
      {
         m_timeframeData[i] = m_timeframeData[i + 1];
         m_timeframes[i] = m_timeframes[i + 1];
      }

      m_total--;
      return true;
   }

   // Get all timeframes
   int GetTimeframes(ENUM_TIMEFRAMES &timeframes[])
   {
      ArrayResize(timeframes, m_total);
      for(int i = 0; i < m_total; i++)
         timeframes[i] = m_timeframes[i];
      
      return m_total;
   }
   
   // Helper Methods for easier access
   
   // Thêm giá trị vào mảng Highs của timeframe cụ thể
   int AddToHighs(ENUM_TIMEFRAMES timeframe, double value)
   {
      TimeFrameData* data = GetData(timeframe);
      if(data == NULL) return -1;
      return data.AddToDoubleArray(data.Highs, value);
   }
   
   // Thêm PoiZone vào mảng zHighs của timeframe cụ thể
   int AddToZHighs(ENUM_TIMEFRAMES timeframe, PoiZone &value)
   {
      TimeFrameData* data = GetData(timeframe);
      if(data == NULL) return -1;
      return data.AddToPoiZoneArray(data.zHighs, value);
   }
   
   // Lấy kích thước mảng Highs của timeframe cụ thể
   int GetHighsSize(ENUM_TIMEFRAMES timeframe)
   {
      TimeFrameData* data = GetData(timeframe);
      if(data == NULL) return 0;
      return ArraySize(data.Highs);
   }
   
   // Lấy giá trị từ mảng Highs của timeframe cụ thể
   bool GetHighsValue(ENUM_TIMEFRAMES timeframe, int index, double &value)
   {
      TimeFrameData* data = GetData(timeframe);
      if(data == NULL || index < 0 || index >= ArraySize(data.Highs)) 
         return false;
      
      value = data.Highs[index];
      return true;
   }
   
   // Lấy giá trị cao nhất từ mảng Highs của timeframe cụ thể
   double GetHighsMax(ENUM_TIMEFRAMES timeframe)
   {
      TimeFrameData* data = GetData(timeframe);
      if(data == NULL) return EMPTY_VALUE;
      return data.GetMaxFromDoubleArray(data.Highs);
   }
   
   // Lấy giá trị thấp nhất từ mảng Lows của timeframe cụ thể
   double GetLowsMin(ENUM_TIMEFRAMES timeframe)
   {
      TimeFrameData* data = GetData(timeframe);
      if(data == NULL) return EMPTY_VALUE;
      return data.GetMinFromDoubleArray(data.Lows);
   }
   
   // Lấy PoiZone mới nhất từ mảng zHighs của timeframe cụ thể
   bool GetLatestZHighs(ENUM_TIMEFRAMES timeframe, PoiZone &result)
   {
      TimeFrameData* data = GetData(timeframe);
      if(data == NULL) return false;
      return data.GetLatestPoiZone(data.zHighs, result);
   }
   
   // Xóa tất cả dữ liệu trong mảng Highs của timeframe cụ thể
   void ClearHighs(ENUM_TIMEFRAMES timeframe)
   {
      TimeFrameData* data = GetData(timeframe);
      if(data != NULL)
         data.ClearDoubleArray(data.Highs);
   }
   
   // Xóa tất cả dữ liệu trong mảng zHighs của timeframe cụ thể
   void ClearZHighs(ENUM_TIMEFRAMES timeframe)
   {
      TimeFrameData* data = GetData(timeframe);
      if(data != NULL)
         data.ClearPoiZoneArray(data.zHighs);
   }
   
   // Dọn dẹp dữ liệu cũ theo thời gian
   void CleanupOldData(ENUM_TIMEFRAMES timeframe, int maxHours = 24)
   {
      TimeFrameData* data = GetData(timeframe);
      if(data == NULL) return;
      
      datetime threshold = TimeCurrent() - maxHours * 3600;
      
      // Dọn dẹp mảng HighsTime và Highs
      for(int i = ArraySize(data.HighsTime) - 1; i >= 0; i--)
      {
         if(data.HighsTime[i] < threshold)
         {
            data.RemoveFromDoubleArray(data.Highs, i);
            data.RemoveFromDateTimeArray(data.HighsTime, i);
         }
      }
      
      // Dọn dẹp mảng zHighs
      for(int i = ArraySize(data.zHighs) - 1; i >= 0; i--)
      {
         if(data.zHighs[i].time < threshold)
            data.RemoveFromPoiZoneArray(data.zHighs, i);
      }
   }
};

//+------------------------------------------------------------------+
//| Global instance                                                  |
//+------------------------------------------------------------------+
CGlobalVariables GlobalVars;

//+------------------------------------------------------------------+
//| Utility Functions                                                |
//+------------------------------------------------------------------+
// Hàm tạo PoiZone từ giá
PoiZone CreatePoiZone(double high, double low, double open, double close, datetime time, 
                      int mitigated = 0, double priceKey = -1, datetime timeKey = -1)
{
   PoiZone zone;
   zone.high = high;
   zone.low = low;
   zone.open = open;
   zone.close = close;
   zone.time = time;
   zone.mitigated = mitigated;
   zone.priceKey = (priceKey != -1) ? priceKey : -1;
   zone.timeKey = (timeKey != -1) ? timeKey : 0;
   
   return zone;
}

// Hàm in thông tin PoiZone
void PrintPoiZone(PoiZone &zone, string prefix = "")
{
   Print(prefix, "PoiZone: High=", zone.high, ", Low=", zone.low, ", Time=", TimeToString(zone.time), ", PriceKey=", zone.priceKey);
}

// Hàm kiểm tra xem PoiZone có được mitigate không
bool IsPoiZoneMitigated(PoiZone &zone, double currentPrice, double tolerance = 0.0005)
{
   // Kiểm tra xem giá hiện tại có vượt qua zone không
   if(currentPrice >= zone.high - tolerance || currentPrice <= zone.low + tolerance)
   {
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Example usage                                                    |
//+------------------------------------------------------------------+
struct marketStructs{
   
   MqlRates waveRates[],rates[];
   
   public: 
   // Ham goi boi Init
   void originalDefinition(ENUM_TIMEFRAMES timeframe) {
      // Lấy dữ liệu cho khung timeframe
      TimeFrameData* tfData = GlobalVars.GetData(timeframe);
      definedFunction(tfData, timeframe);
      gannWave(tfData);
   }
   
   // Ham goi boi OnTick
   void realTimeDefinition(ENUM_TIMEFRAMES timeframe) {
      
      // Lấy dữ liệu cho khung timeframe
      TimeFrameData* tfData = GlobalVars.GetData(timeframe);
      //Print("Data tfData: highest = ", tfData.highEst);
      realGannWave(tfData, timeframe);
      
   }
   
   private:
   
   // Dinh nghia xac nhan tham so mac dinh timeframe
   void setDefautTimeframe(TimeFrameData& tfData, ENUM_TIMEFRAMES timeframe){
      // xac dinh cap low high time frame by minutes
      switch(timeframe)
        {
         case  PERIOD_M1:
           tfData.tfColor = clrGray;
           tfData.isTimeframe = 1;
           break;
         case  PERIOD_M5:
           tfData.tfColor = clrSkyBlue;
           tfData.isTimeframe = 5;
           break;
         case  PERIOD_M15:
           tfData.tfColor = clrBlue;
           tfData.isTimeframe = 15;
           break;
         case  PERIOD_H1:
           tfData.tfColor = clrRed;
           tfData.isTimeframe = 60;
           break;
         case  PERIOD_H4:
           tfData.tfColor = clrGold;
           tfData.isTimeframe = 240;
           break;
         case  PERIOD_D1:
           tfData.tfColor = clrPurple;
           tfData.isTimeframe = 1440;
           break;
         default:
            tfData.tfColor = clrGray;
            tfData.isTimeframe = 1;
           break;
        }
   }
   
   void definedFunction(TimeFrameData& tfData, ENUM_TIMEFRAMES timeframe) {
      tfData.timeFrame = timeframe;
      setDefautTimeframe(tfData, timeframe);
      if ( (tfData.isTimeframe == highPairTF && isDrawHighTF == true) || (tfData.isTimeframe == lowPairTF && isDrawLowTF == true)) {
         tfData.isDraw = true;
      }
      
      // Copy toan bo Lookback = 100 Bar tu Bar hien tai vao mang waveRates
      int copied = CopyRates(_Symbol, timeframe, 0, lookback, waveRates);
      //ArrayPrint(waveRates);
      //int firstBar = ArraySize(waveRates) - 1;
      int firstBar = 0;
      MqlRates Bar1 = waveRates[firstBar];
      double firstBarHigh     = waveRates[firstBar].high;
      double firstBarLow      = waveRates[firstBar].low;
      datetime firstBarTime   = waveRates[firstBar].time;
      long firstBarVol        = waveRates[firstBar].tick_volume;
      
      //Print("High: "+ (string) firstBarHigh, " - Low: "+ (string) firstBarLow + " - Time: "+ (string) firstBarTime);
      
      tfData.highEst = firstBarHigh;
      tfData.lowEst = firstBarLow;
      tfData.hightime = firstBarTime;
      tfData.lowtime = firstBarTime;
      
      // Gann structure
      tfData.AddToDoubleArray(tfData.Highs, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.HighsTime, firstBarTime);
      tfData.AddToLongArray(tfData.volHighs, firstBarVol);
      
      tfData.AddToDoubleArray(tfData.Lows, firstBarLow);
      tfData.AddToDateTimeArray(tfData.LowsTime, firstBarTime);
      tfData.AddToLongArray(tfData.volLows, firstBarVol);

      
      // internal structure
      tfData.AddToDoubleArray(tfData.intSHighs, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.intSHighTime, firstBarTime);
      tfData.AddToLongArray(tfData.volIntSHighs, firstBarVol);
      
      tfData.AddToDoubleArray(tfData.intSLows, firstBarLow);
      tfData.AddToDateTimeArray(tfData.intSLowTime, firstBarTime);
      tfData.AddToLongArray(tfData.volIntSLows, firstBarVol);

      
      // pullback structure
      tfData.AddToDoubleArray(tfData.arrTop, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.arrTopTime, firstBarTime);
      tfData.AddToLongArray(tfData.volArrTop, firstBarVol);
      
      tfData.AddToDoubleArray(tfData.arrBot, firstBarLow);
      tfData.AddToDateTimeArray(tfData.arrBotTime, firstBarTime);
      tfData.AddToLongArray(tfData.volArrBot, firstBarVol);
      
      // array pullback
      tfData.AddToDoubleArray(tfData.arrPbHigh, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.arrPbHTime, firstBarTime);
      
      tfData.AddToLongArray(tfData.volArrPbHigh, firstBarVol);
      
      tfData.AddToDoubleArray(tfData.arrPbLow, firstBarLow);
      tfData.AddToDateTimeArray(tfData.arrPbLTime, firstBarTime);
      tfData.AddToLongArray(tfData.volArrPbLow, firstBarVol);
      
      tfData.AddToDoubleArray(tfData.arrChoHigh, 0);
      tfData.AddToDateTimeArray(tfData.arrChoHighTime, firstBarTime);
      tfData.AddToLongArray(tfData.volArrChoHigh, firstBarVol);
      
      tfData.AddToDoubleArray(tfData.arrChoLow, 0);
      tfData.AddToDateTimeArray(tfData.arrChoLowTime, firstBarTime);
      tfData.AddToLongArray(tfData.volArrChoLow, firstBarVol);
      
      tfData.AddToDoubleArray(tfData.arrBoHigh, 0);
      tfData.AddToDateTimeArray(tfData.arrBoHighTime, firstBarTime);
      tfData.AddToLongArray(tfData.volArrBoHigh, firstBarVol);
      
      tfData.AddToDoubleArray(tfData.arrBoLow, 0);
      tfData.AddToDateTimeArray(tfData.arrBoLowTime, firstBarTime);
      tfData.AddToLongArray(tfData.volArrBoLow, firstBarVol);
      
      tfData.AddToDoubleArray(tfData.arrDecisionalHigh, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.arrDecisionalHighTime, firstBarTime);
      tfData.AddToLongArray(tfData.volArrDecisionalHigh, firstBarVol);
      
      tfData.AddToDoubleArray(tfData.arrDecisionalLow, firstBarLow);
      tfData.AddToDateTimeArray(tfData.arrDecisionalLowTime, firstBarTime);
      tfData.AddToLongArray(tfData.volArrDecisionalLow, firstBarVol);
      
      // Thêm PoiZone vào mảng
      PoiZone zone1 = CreatePoiZone(Bar1.high, Bar1.low, Bar1.open, Bar1.close, Bar1.time, 0, -1, -1);
      tfData.AddToPoiZoneArray(tfData.zPoiLow, zone1);
      tfData.AddToPoiZoneArray(tfData.zPoiHigh, zone1);
      tfData.AddToPoiZoneArray(tfData.zPoiExtremeLow, zone1);
      tfData.AddToPoiZoneArray(tfData.zPoiExtremeHigh, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrTop, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrBot, zone1);
      tfData.AddToPoiZoneArray(tfData.zHighs, zone1);
      tfData.AddToPoiZoneArray(tfData.zLows, zone1);
      tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone1);
      tfData.AddToPoiZoneArray(tfData.zIntSLows, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrPbHigh, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrPbLow, zone1);
      tfData.AddToPoiZoneArray(tfData.zPoiDecisionalHigh, zone1);
      tfData.AddToPoiZoneArray(tfData.zPoiDecisionalLow, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrDecisionalHigh, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrDecisionalLow, zone1);
      
      double high = iHigh(_Symbol, timeframe, 1);
      double low = iLow(_Symbol, timeframe, 1);
      datetime time = iTime(_Symbol, timeframe, 1);
      
      double high2 = iHigh(_Symbol, timeframe, 2);
      double low2 = iLow(_Symbol, timeframe, 2);
      datetime time2 = iTime(_Symbol, timeframe, 2);
      
      //high low   
      tfData.lastH = high;
      tfData.lastL = low;
   }
      
   // Ham ve swing point
   void drawPointStructure(TimeFrameData& tfData, int itype, double priceNew, datetime timeNew, int typeStructure, bool del, bool isDraw) { // type: 1 High, -1 Low
      int iWingding = 0;
      color iColor = tfData.tfColor;
      // Color and wingdings
      if (typeStructure == GANN_STRUCTURE) {
         iWingding  = (itype == 1)? iWingding_gann_high : iWingding_gann_low;
         //iColor   = (itype == 1)? clrDeepSkyBlue : clrYellow;
      } else if (typeStructure == INTERNAL_STRUCTURE) {
         iWingding  = (itype == 1)? iWingding_internal_high : iWingding_internal_low;
         //iColor   = (itype == 1)? clrRoyalBlue : clrLightSalmon;
      } else if (typeStructure == INTERNAL_STRUCTURE_KEY){
         iWingding  = (itype == 1)? iWingding_internal_high : iWingding_internal_low;
         //iColor   = (itype == 1)? clrGreen : clrRed;
      }else if (typeStructure == MAJOR_STRUCTURE) {
         iWingding  = (itype == 1)? 116 : 116;
         //iColor   = (itype == 1)? clrForestGreen : clrRed;
      }
      
      string text    = (itype == 1)? "Update High" : "Update Low";
      int iDirection = (itype == 1)? -1 : 1;
      //Print(text +" Type: "+ itype + " , Xoa swing: "+ (string) del);
      
      if (isDraw) {
         createObj(timeNew, priceNew, iWingding, iDirection, iColor, "");
      }
      // update High, Low for gann swing
      if (itype == 1) { // find high
         tfData.highEst = priceNew;
      } else if(itype == -1) { // find low
         tfData.lowEst = priceNew;
      }
      // Update Bartime high, low for BOS, CHOCH internal struct
      if (typeStructure == INTERNAL_STRUCTURE) {
         if (itype == 1) { // find high
            tfData.lastTimeH = timeNew;
            tfData.lastH = priceNew;
         } else if (itype == -1) { // find low
            tfData.lastTimeL = timeNew;
            tfData.lastL = priceNew;
         }
      }
   }
   
   void gannWave(TimeFrameData& tfData){
      MqlRates bar1, bar2, bar3; 
      // danh dau vi tri bat dau
      createObj(waveRates[0].time, waveRates[0].low, 238, -1, tfData.tfColor, "Start");
      
      for (int j = 1; j <= ArraySize(waveRates) - 2; j++){
         Print("TF: "+ (string)tfData.isTimeframe+" No:" + (string) j);
         
         bar1 = waveRates[j+1];
         bar2 = waveRates[j];
         bar3 = waveRates[j-1];
         
         Print(inInfoBar(bar1, bar2, bar3));
         Print("First: "+getValueTrend(tfData));
         
         int resultStructure = drawStructureInternal(tfData, bar1, bar2, bar3, enabledComment);
         updatePointTopBot(tfData, bar1, bar2, bar3, enabledComment);
          
         //// POI
         getZoneValid(tfData);
         drawZone(tfData, bar1);
         
         checkMitigateZone(tfData, bar1);
         
         Print("\nFinal: "+getValueTrend(tfData));
         Print(" ------------ End Gann wave---------------\n");
      }
      // danh dau vi tri ket thuc
      createObj(waveRates[ArraySize(waveRates) - 1].time, waveRates[ArraySize(waveRates) - 1].low, 238, -1, tfData.tfColor, "Stop");
   }
   
   void realGannWave(TimeFrameData& tfData, ENUM_TIMEFRAMES timeframe) {
      Print("-----------------------------------> New "+EnumToString(timeframe)+" bar formed: ", TimeToString(TimeCurrent())+" <------------------------------------");
      int copied = CopyRates(_Symbol, timeframe, 0, 4, rates);
      
      string text = "";
      MqlRates bar1, bar2, bar3;
      bar1 = rates[2];
      bar2 = rates[1];
      bar3 = rates[0];
      
      
      text += "--------------Real Gann Wave----------------";
      text += "\n "+inInfoBar(bar1, bar2, bar3);
      text += "\nFirst: "+getValueTrend(tfData);
      Print(text);
      int resultStructure = drawStructureInternal(tfData, bar1, bar2, bar3, enabledComment);
      updatePointTopBot(tfData, bar1, bar2, bar3, enabledComment);
      
      //// POI
      getZoneValid(tfData);
      drawZone(tfData, bar1);
      
      checkMitigateZone(tfData, bar1);
      
      text = "Final: "+getValueTrend(tfData);
      text += "\n------------ End Real Gann wave---------------";
      Print(text); 
      
      Print("-----------------------------------> END "+EnumToString(timeframe)+" <------------------------------------ \n");
        
   }
   
   // Kiểm tra lần lượt zone đã mitigate hay chưa
   void checkMitigateZone(TimeFrameData& tfData, MqlRates& bar1) {
      getIsMitigatedZone(tfData, bar1, tfData.zArrDecisionalHigh, -1);
      getIsMitigatedZone(tfData, bar1, tfData.zArrDecisionalLow, 1);
      getIsMitigatedZone(tfData, bar1, tfData.zArrPbHigh, -1);
      getIsMitigatedZone(tfData, bar1, tfData.zArrPbLow, 1);
      getIsMitigatedZone(tfData, bar1, tfData.zPoiExtremeHigh, -1);
      getIsMitigatedZone(tfData, bar1, tfData.zPoiExtremeLow, 1);
   }
   
   // Hàm kiểm tra từng zone mitigate hay chưa
   void getIsMitigatedZone(TimeFrameData& tfData, MqlRates& bar1, PoiZone& zone[], int type) {
      // kiem tra xem zone co du lieu hay khong
      if (ArraySize(zone) > 0) {
         // lap du lieu 
         for(int i=0;i < ArraySize(zone);i++) {
            // chi kiem tra zone not mitigate va mitigating
            if (zone[i].mitigated == -1) continue;
            
            // neu dang check bullish zone
            if (type == 1) {
               // Neu gia bat dau mitigate zone
               if (bar1.low <= zone[i].high) {
                  // neu gia van nam trong zone
                  if ( bar1.low >= zone[i].low) {
                     zone[i].mitigated = 1;
                  }
                  
                  // neu gia vuot ra ngoai zone
                  if (bar1.low < zone[i].low) {
                     zone[i].mitigated = -1;
                  }
                  
               }
            } else if (type == -1) { // neu dang check bearish zone
               // Neu gia bat dau mitigate zone
               if (bar1.high <= zone[i].low) {
                  // neu gia van nam trong zone
                  if ( bar1.high <= zone[i].high) {
                     zone[i].mitigated = 1;
                  }
                  
                  // neu gia vuot ra ngoai zone
                  if (bar1.high > zone[i].high) {
                     zone[i].mitigated = -1;
                  }
               }
            }
         }
      }
   }
   
   //---
   //--- Ham cap nhat ve cau truc song gann, internal struct, major struct
   //---
   int drawStructureInternal(TimeFrameData& tfData, MqlRates& bar1, MqlRates& bar2, MqlRates& bar3, bool isComment = false) {
      int resultStructure = 0;
      string textGannHigh = "";
      string textGannLow = "";
      
      string textInternalHigh = "";
      string textInternalLow = "";
      
      string textTop = "";
      string textBot = "";

      long maxVolume = 0;
      
   //    swing high
      if (bar3.high <= bar2.high && bar2.high >= bar1.high) { // tim thay dinh high
         textGannHigh += "--->Gann: Find High: "+(string) bar2.high+" + Highest: "+ (string) tfData.highEst;
         // set Zone
         PoiZone zone2 = CreatePoiZone(bar2.high, bar2.low, bar2.open, bar2.close, bar2.time);
         if (typeTickVolume == 1) {
            maxVolume = bar2.tick_volume;
         } else {
            maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
         }         

         // gann finding high
         if (tfData.LastSwingMeter == 1 || tfData.LastSwingMeter == 0) {
            textGannHigh += "; Gann: LastSwingMeter == 1 or 0 => New Highs= "+(string) bar2.high +"; LastSwingMeter = -1" ;
            // Add high moi (updatePointStructure), khong xoa Highs 0
            tfData.AddToDoubleArray(tfData.Highs, bar2.high, limit);
            tfData.AddToDateTimeArray(tfData.HighsTime, bar2.time, limit);
            tfData.AddToLongArray(tfData.volHighs, maxVolume, limit);

            drawPointStructure(tfData, 1, bar2.high, bar2.time, GANN_STRUCTURE, false, enabledDraw);
            tfData.LastSwingMeter = -1;
            // cap nhat Zone. Khong xoa (updatePointZone)
            tfData.AddToPoiZoneArray(tfData.zHighs, zone2, poi_limit);
            
         }
         // gann finding low
         if (tfData.LastSwingMeter == -1) {
            //    xoa high cu. viet high moi
            if (bar2.high > tfData.highEst) {
               textGannHigh += "; Gann: LastSwingMeter == -1 => Delete Highs[0] = "+(string)tfData.Highs[0]+" ,New Highs= "+(string) bar2.high +"; LastSwingMeter = -1" ;
               // xoa high cu
               if (ArraySize(tfData.Highs) > 1) deleteObj(tfData.HighsTime[0], tfData.Highs[0], iWingding_gann_high, "");
               //       cap nhat high moi
               tfData.UpdateDoubleArray(tfData.Highs, 0, bar2.high);
               tfData.UpdateDateTimeArray(tfData.HighsTime, 0, bar2.time);
               tfData.UpdateLongArray(tfData.volHighs, 0, maxVolume);

               drawPointStructure(tfData, 1, bar2.high, bar2.time, GANN_STRUCTURE, true, enabledDraw);
               tfData.LastSwingMeter = -1;
               // cap nhat Zone. Xoa 0 (updatePointZone)
               tfData.UpdatePoiZoneArray(tfData.zHighs, 0, zone2);
               
            }
         }
         if (isComment) {
            Print(textGannHigh);
            ArrayPrint(tfData.Highs);
            ArrayPrint(tfData.volHighs);
         }
         
         // Internal Structure
         textInternalHigh += "\n"+"---> Find Internal High: "+(string)  bar2.high +" ### So Sanh iTrend: " +(string) tfData.iTrend+", LastSwingInternal: "+(string) tfData.LastSwingInternal+ " , intSHighs[0]: "+ (string) tfData.intSHighs[0];
         textInternalHigh += "\n"+"lastTimeH: "+(string) tfData.lastTimeH+" lastH: "+ (string) tfData.lastH +" <----> "+" intSHighTime[0] "+(string) tfData.intSHighTime[0]+" intSHighs[0] "+ (string) tfData.intSHighs[0];
         // finding High
         
         // DONE 1
         // HH
         if ( (tfData.iTrend == 0 || (tfData.iTrend == 1 && tfData.LastSwingInternal == 1)) && bar2.high > tfData.intSHighs[0]){ // iBOS
            textInternalHigh += "\n"+"## High 1 iBOS --> Update: "+ "iTrend: 1, LastSwingInternal: -1 , New intSHighs[0]: "+(string) bar2.high;
            // Add new intSHigh.
            tfData.AddToDoubleArray(tfData.intSHighs, bar2.high);
            tfData.AddToDateTimeArray(tfData.intSHighTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSHighs, maxVolume);

            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            
            tfData.iTrend = 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 1;
            
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone2, poi_limit);
         }
         
         // HH 2
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.high > tfData.intSHighs[0] && bar2.high > tfData.intSHighs[1]){
            textInternalHigh += "\n"+"## High 2 --> Update: "+ "iTrend: 1, LastSwingInternal: -1, Update intSHighs[0]: "
                                 +(string) bar2.high + ", Xoa intSHighs[0] old: "+(string) tfData.intSHighs[0];
            // Delete Label
            if (ArraySize(tfData.intSHighs) > 1) deleteObj(tfData.intSHighTime[0], tfData.intSHighs[0], iWingding_internal_high, "");
            // Update new intSHigh.
            tfData.UpdateDoubleArray(tfData.intSHighs, 0, bar2.high);
            tfData.UpdateDateTimeArray(tfData.intSHighTime, 0, bar2.time);
            tfData.UpdateLongArray(tfData.volIntSHighs, 0, maxVolume);
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
            
            tfData.iTrend = 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 2;
            
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSHighs, 0, zone2);
            
         }
         
         // DONE 3
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.high > tfData.intSHighs[0]) {  // iCHoCH
            textInternalHigh += "\n"+"## High 3 iCHoCH --> Update: "+ "iTrend: 1, LastSwingInternal: -1, New intSHighs[0]: "+(string) bar2.high;
            // add new intSHighs
            tfData.AddToDoubleArray(tfData.intSHighs, bar2.high);
            tfData.AddToDateTimeArray(tfData.intSHighTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSHighs, maxVolume);
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            
            tfData.iTrend = 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 3;
            
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone2, poi_limit);
         }
         
         // DONE 4 
         // LH
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.high < tfData.intSHighs[0]) { 
            textInternalHigh += "\n"+ "## High 4 --> Update: "+ "iTrend: -1, LastSwingInternal: -1, New intSHighs[0]: "+(string) bar2.high;
            // Add new intSHigh
            tfData.AddToDoubleArray(tfData.intSHighs, bar2.high);
            tfData.AddToDateTimeArray(tfData.intSHighTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSHighs, maxVolume);
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            tfData.iTrend = -1;
            tfData.LastSwingInternal = -1;
            resultStructure = 4;
                        
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone2, poi_limit);
         }
         
         // DONE 5
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == -1 && bar2.high > tfData.intSHighs[0] ) {    // iCHoCH
            textInternalHigh += "\n"+"## High 5 iCHoCH --> Update: LastSwingInternal: -1, Update intSHighs[0]: "+(string) bar2.high+", Xoa intSHighs[0] old: "+(string) tfData.intSHighs[0];
            // Delete prev label
            if (ArraySize(tfData.intSHighs) > 1) deleteObj(tfData.intSHighTime[0], tfData.intSHighs[0], iWingding_internal_high, "");
            // Update new intSHigh.
            tfData.UpdateDoubleArray(tfData.intSHighs, 0, bar2.high);
            tfData.UpdateDateTimeArray(tfData.intSHighTime, 0, bar2.time);
            tfData.UpdateLongArray(tfData.volIntSHighs, 0, maxVolume);
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
                     
            tfData.iTrend = (bar2.high <= tfData.intSHighs[1])? -1 : 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 5;
            
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSHighs, 0, zone2);
            textInternalHigh += ", (?) iTrend: "+(string) tfData.iTrend;
         }
         if( isComment) {
            Print(textInternalHigh);
            ArrayPrint(tfData.intSHighs);
            ArrayPrint(tfData.volIntSHighs);
         }
         
      }
   //   
   //   // swing low
      if (bar3.low >= bar2.low && bar2.low <= bar1.low) { // tim thay dinh low
         textGannLow += "--->Gann: Find Low: +" +(string) bar2.low+ " + Lowest: "+(string) tfData.lowEst;
         PoiZone zone2 = CreatePoiZone(bar2.high, bar2.low, bar2.open, bar2.close, bar2.time);
         if (typeTickVolume == 1) {
            maxVolume = bar2.tick_volume;
         } else {
            maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
         }
         // gann finding low
         if (tfData.LastSwingMeter == -1 || tfData.LastSwingMeter == 0) {
            textGannHigh += "; Gann: LastSwingMeter == -1 or 0 => New Lows[0] = "+(string) bar2.low +"; LastSwingMeter = 1" ;
            // cap nhat low moi, khong xoa Lows 0
            tfData.AddToDoubleArray(tfData.Lows, bar2.low);
            tfData.AddToDateTimeArray(tfData.LowsTime, bar2.time);
            tfData.AddToLongArray(tfData.volLows, maxVolume);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, GANN_STRUCTURE, false, enabledDraw);
            tfData.LastSwingMeter = 1;
            // Them Zone.
            tfData.AddToPoiZoneArray(tfData.zLows, zone2, poi_limit);
         }
         // gann finding high
         if (tfData.LastSwingMeter == 1) {
            // xoa low cu. viet high moi
            if (bar2.low < tfData.lowEst) {
               textGannHigh += "; Gann: LastSwingMeter == 1 => Delete Lows[0] = "+(string)tfData.Lows[0]+" ,New Lows= "+(string) bar2.low +"; LastSwingMeter = 1" ;
               // xoa low cu
               if (ArraySize(tfData.Lows) > 1) deleteObj(tfData.LowsTime[0], tfData.Lows[0], iWingding_gann_low, "");
               // cap nhat low moi.
               tfData.UpdateDoubleArray(tfData.Lows, 0, bar2.low);
               tfData.UpdateDateTimeArray(tfData.LowsTime, 0, bar2.time);
               tfData.UpdateLongArray(tfData.volLows, 0, maxVolume);
               
               drawPointStructure(tfData, -1, bar2.low, bar2.time, GANN_STRUCTURE, true, enabledDraw);
               tfData.LastSwingMeter = 1;
               // cap nhat Zone
               tfData.UpdatePoiZoneArray(tfData.zLows, 0, zone2);
            }
         }
         if (isComment) {
            Print(textGannLow);
            ArrayPrint(tfData.Lows);
            ArrayPrint(tfData.volLows);
         }
         
         // Internal Structure 
         textInternalLow += "\n"+"---> Find Internal Low: "+ (string) bar2.low +" ### So Sanh iTrend: " +(string) tfData.iTrend+", LastSwingInternal: "+(string) tfData.LastSwingInternal+ " , intSLows[0]: "+ (string) tfData.intSLows[0];
         textInternalLow += "\n"+"lastTimeL: "+(string) tfData.lastTimeL+" lastL: "+(string)  tfData.lastL +" <----> "+" intSLowTime[0] "+(string) tfData.intSLowTime[0]+" intSLows[0] "+ (string) tfData.intSLows[0];
         // finding Low
         // DONE 1
         // LL
         if ((tfData.iTrend == 0 || tfData.iTrend == -1) && tfData.LastSwingInternal == -1 && bar2.low < tfData.intSLows[0]){ // iBOS
            textInternalLow += "\n"+("## Low 1 iBOS --> Update: "+ "iTrend: -1, LastSwingInternal: 1, New intSLows[0]: "+(string) bar2.low);
            // Add new intSLows
            tfData.AddToDoubleArray(tfData.intSLows, bar2.low);
            tfData.AddToDateTimeArray(tfData.intSLowTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSLows, maxVolume);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
                     
            tfData.iTrend = -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -1;
            
            // Them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSLows, zone2, poi_limit);
         }
         
         // LL
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.low < tfData.intSLows[0] && bar2.low < tfData.intSLows[1]){
            textInternalLow += "\n"+"## Low 2 --> Update: "+ "iTrend: -1, LastSwingInternal: 1"+
                                 ", Update intSLows[0]: "+(string) bar2.low +", Xoa intSLows[0] old: "+(string) tfData.intSLows[0];
            
            // Delete Label
            if (ArraySize(tfData.intSLows) > 1) deleteObj(tfData.intSLowTime[0], tfData.intSLows[0], iWingding_internal_low, "");
            // Update new intSLows
            tfData.UpdateDoubleArray(tfData.intSLows, 0, bar2.low);
            tfData.UpdateDateTimeArray(tfData.intSLowTime, 0, bar2.time);
            tfData.UpdateLongArray(tfData.volIntSLows, 0, maxVolume);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
                     
            tfData.iTrend = -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -2;
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSLows, 0, zone2);
         }
         
         // DONE 3
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.low < tfData.intSLows[0]) { // iCHoCH
            textInternalLow += "\n"+("## Low 3 iCHoCH --> Update: "+ "iTrend: -1, LastSwingInternal: 1, Update intSLows[0]: "+(string) bar2.low);
            
            // Add new intSLows
            tfData.AddToDoubleArray(tfData.intSLows, bar2.low);
            tfData.AddToDateTimeArray(tfData.intSLowTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSLows, maxVolume);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            
            tfData.iTrend = -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -3;
            // Them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSLows, zone2, poi_limit);
         }
         
         // DONE 4
         // Trend Tang. HL
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.low > tfData.intSLows[0]) {
            textInternalLow += "\n"+("## Low 4 --> Update: "+ "iTrend: 1, LastSwingInternal: 1, New intSLows[0]: "+(string) bar2.low);
            
            // Add new intSLows
            tfData.AddToDoubleArray(tfData.intSLows, bar2.low);
            tfData.AddToDateTimeArray(tfData.intSLowTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSLows, maxVolume);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            tfData.iTrend = 1;
            tfData.LastSwingInternal = 1;
            resultStructure = -4;
            // Them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSLows, zone2, poi_limit);
         }
         
         // DONE 5
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == 1 && bar2.low < tfData.intSLows[0] ) {  // iCHoCH
            textInternalLow += "\n"+("## Low 5 iCHoCH --> Update:  LastSwingInternal: 1, Update intSLows[0]: "+(string) bar2.low+", Xoa intSLows[0] old: "+(string) tfData.intSLows[0]);
            // Delete Label
            if (ArraySize(tfData.intSLows) > 1) deleteObj(tfData.intSLowTime[0], tfData.intSLows[0], iWingding_internal_low, "");
            // Update new intSLows
            tfData.UpdateDoubleArray(tfData.intSLows, 0, bar2.low);
            tfData.UpdateDateTimeArray(tfData.intSLowTime, 0, bar2.time);
            tfData.UpdateLongArray(tfData.volIntSLows, 0, maxVolume);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
                     
            tfData.iTrend = (bar2.low >= tfData.intSLows[1]) ? 1 : -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -5;
            
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSLows, 0, zone2);
            textInternalLow += ", (?) iTrend: "+(string) tfData.iTrend;
         }
         if(isComment) {
            Print(textInternalLow);
            ArrayPrint(tfData.intSLows);
            ArrayPrint(tfData.volIntSLows);
         }
      }
      return resultStructure;
   } //--- End Ham cap nhat cau truc song Gann
   
   //---
   //--- Ham cap nhat cau truc thi truong
   //---
   void updatePointTopBot(TimeFrameData& tfData, MqlRates& bar1, MqlRates& bar2, MqlRates& bar3, bool isComment = false){
      string textall = "----- updatePointTopBot -----\n";
      string text = "";
      //text +=  "First: " + getValueTrend(tfData);
      //text += "\n"+inInfoBar(bar1, bar2, bar3);
      PoiZone zone2 = CreatePoiZone(bar2.high, bar2.low, bar2.open, bar2.close, bar2.time);
      long maxVolume = 0;
      
      double barHigh = bar1.high;
      double barLow  = bar1.low;
      datetime barTime = bar1.time;
      
      // Lan dau tien
      if(tfData.sTrend == 0 && tfData.mTrend == 0 && tfData.LastSwingMajor == 0) { //ok
         if (barLow < tfData.arrBot[0]){
            text += "\n 0.-1. barLow < arrBot[0]"+" => "+(string) barLow+" < "+(string) tfData.arrBot[0];
            text += " => Cap nhat idmLow = Highs[0] = "+(string) tfData.Highs[0]+"; sTrend = -1; mTrend = -1; LastSwingMajor = 1;";
            
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            //tfData.vol_L_idmLow = tfData.vol_idmLow;
            
            tfData.idmLow = tfData.Highs[0];
            tfData.idmLowTime = tfData.HighsTime[0];
            //tfData.vol_idmLow = tfData.volHighs[0];
            
            tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = 1;
            
         } else if (barHigh > tfData.arrTop[0]) { 
            text += "\n 0.1. barHigh > arrTop[0]"+" => "+(string) barHigh+" > "+(string) tfData.arrTop[0];
            text += " => Cap nhat idmHigh = Lows[0] = "+(string) tfData.Lows[0]+"; sTrend = 1; mTrend = 1; LastSwingMajor = -1;";
            
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0];
            tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = -1;
         }
      }
      // End Lan dau tien
      
      if (bar3.high <= bar2.high && bar2.high >= bar1.high) { // tim thay dinh high
         
         if (tfData.findHigh == 1 && bar2.high > tfData.H) {
            text += "\n 0.2. Find Swing High";
            text += " => findhigh == 1 , H new > H old "+(string) bar2.high+" > "+(string) tfData.H+". Update new High = "+(string) bar2.high;
            
            tfData.H = bar2.high;
            tfData.HTime = bar2.time;
            tfData.H_bar = bar2;
            tfData.vol_H = bar2.tick_volume;
         }
      }
      if (bar3.low >= bar2.low && bar2.low <= bar1.low) { // tim thay swing low 
         
         if (tfData.findLow == 1 && bar2.low < tfData.L) {
            text += "\n 0.-2. Find Swing Low";
            text += " => findlow == 1 , L new < L old "+(string) bar2.low+" < "+(string) tfData.L+". Update new Low = "+(string) bar2.low;
            
            tfData.L = bar2.low;
            tfData.LTime = bar2.time;
            tfData.L_bar = bar2;
            tfData.vol_L = bar2.tick_volume;
         }
      }
      
      if(tfData.sTrend == 1 && tfData.mTrend == 1) {
         // continue BOS 
         if (tfData.LastSwingMajor == -1 && bar1.high > tfData.arrTop[0] && tfData.arrTop[0] != tfData.arrBoHigh[0]) { // Done
            text += "\n 1.1. continue BOS, sTrend == 1 && mTrend == 1 && LastSwingMajor == -1 && bar1.high > arrTop[0] : "
            +(string)  bar1.high +" > "+(string) tfData.arrTop[0];
            text += "\n => Cap nhat: findLow = 0, idmHigh = Lows[0] = "+(string) tfData.Lows[0]+" ; sTrend == 1; mTrend == 1; LastSwingMajor == 1;";
            text += "\n => New arrBoHigh = arrTop[0] = " + (string)tfData.arrTop[0] + "; New arrBot = intSLows[0] = " + (string)tfData.intSLows[0];
            // Add new point swing
            tfData.AddToDoubleArray(tfData.arrBoHigh, tfData.arrTop[0]);
            tfData.AddToDateTimeArray(tfData.arrBoHighTime, tfData.arrTopTime[0]);
            tfData.AddToLongArray(tfData.volArrBoHigh, tfData.volArrTop[0]);
            
            tfData.AddToDoubleArray(tfData.arrBot, tfData.intSLows[0]);
            tfData.AddToDateTimeArray(tfData.arrBotTime, tfData.intSLowTime[0]);
            tfData.AddToLongArray(tfData.volArrBot, tfData.volIntSLows[0]);
            
            // add zone POI Bullish
            tfData.AddToPoiZoneArray(tfData.zArrBot, tfData.zIntSLows[0], poi_limit);
            // Add Zone
            tfData.AddToPoiZoneArray(tfData.zPoiLow, tfData.zIntSLows[0], poi_limit);
            
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = 1;
            tfData.findLow = 0; tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0];
         }
         
         if (bar3.high <= bar2.high && bar2.high >= bar1.high) { // tim thay dinh high 
            if (typeTickVolume == 1) {
               maxVolume = bar2.tick_volume;
            } else {
               maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
            }
            // continue BOS swing high
            if (tfData.LastSwingMajor == 1 && bar2.high > tfData.arrTop[0]) {
               text += "\n 1.2. swing high, sTrend == 1 && mTrend == 1 && LastSwingMajor == 1 && bar2.high > arrTop[0]";
               text += "=> Cap nhat: arrTop[0] = bar2.high = "+(string) bar2.high+" ; sTrend == 1; mTrend == 1; LastSwingMajor == -1;";
               // Update Array Top[0]
               if(tfData.arrTop[0] != bar2.high) {
                  // Add new 
                  tfData.AddToDoubleArray( tfData.arrTop, bar2.high);
                  tfData.AddToDateTimeArray( tfData.arrTopTime, bar2.time);
                  tfData.AddToLongArray(tfData.volArrTop, maxVolume);
                  
                  // add new Zone
                  tfData.AddToPoiZoneArray( tfData.zArrTop, zone2, poi_limit);
               } 
               
               tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = -1;
            }
            // HH > HH 
            if (tfData.LastSwingMajor == -1 && bar2.high > tfData.arrTop[0]) {
               text += "\n 1.3. sTrend == 1 && mTrend == 1 && LastSwingMajor == -1 && bar2.high > arrTop[0]";
               text += "=> Xoa label, Cap nhat: arrTop[0] = bar2.high = "+(string) bar2.high+" ; sTrend == 1; mTrend == 1; LastSwingMajor == -1;";
               
               // Update Array Top[0] , conditions : L new != L old
               if(tfData.arrTop[0] != bar2.high) {
                  // update point
                  tfData.UpdateDoubleArray(tfData.arrTop, 0, bar2.high);
                  tfData.UpdateDateTimeArray(tfData.arrTopTime, 0, bar2.time);
                  tfData.UpdateLongArray(tfData.volArrTop, 0, maxVolume);
                  // cap nhat Zone
                  tfData.UpdatePoiZoneArray( tfData.zArrTop, 0, zone2);
               }
               tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = -1;
            }
         }
         
         //Cross IDM
         if (  
            //tfData.LastSwingMajor == 1 && 
            tfData.findLow == 0 && bar1.low < tfData.idmHigh) {
            text += "\n 1.4. Cross IDM Uptrend.  sTrend == 1 && mTrend == 1 && LastSwingMajor == random && bar1.low < idmHigh : " + (string) bar1.low + "<" + (string) tfData.idmHigh;
            // cap nhat arPBHighs
            if(tfData.arrTop[0] != tfData.arrPbHigh[0]) {
               // Add new 
               tfData.AddToDoubleArray( tfData.arrPbHigh, tfData.arrTop[0]);
               tfData.AddToDateTimeArray( tfData.arrPbHTime, tfData.arrTopTime[0]);
               tfData.AddToLongArray( tfData.volArrPbHigh, tfData.volArrTop[0]);
               // add new zone
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, tfData.zArrTop[0], poi_limit); 
            }
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(IDM_TEXT, tfData.idmHighTime, tfData.idmHigh, bar1.time, tfData.idmHigh, 1, IDM_TEXT, tfData.tfColor, STYLE_DOT);
            text += "\n => Cap nhat findLow = 1; L = bar1.low = "+ (string) bar1.low;
            
            // active find Low
            tfData.findLow = 1;
            tfData.L = bar1.low; tfData.LTime = bar1.time; tfData.vol_L = bar1.tick_volume;
            tfData.L_bar = bar1; 
            tfData.findHigh = 0; tfData.H = 0; tfData.vol_H = 0;
         }
         
         // CHoCH Low
         if (
            //tfData.LastSwingMajor == 1 && 
            bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n 1.5 sTrend == 1 && mTrend == 1 && LastSwingMajor == random && bar1.low < arrPbLow[0] :" +(string)  bar1.low + "<" + (string) tfData.arrPbLow[0];
            text += "\n => Cap nhat => Ve line. sTrend = -1; mTrend = -1; LastSwingMajor = -1; findHigh = 0; idmLow = Highs[0]= "+ (string) tfData.Highs[0];
            // draw choch Low
            drawLine(CHOCH_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], barTime, tfData.arrPbLow[0], 1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);

            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            tfData.AddToLongArray( tfData.volArrChoLow, tfData.volArrPbLow[0]);
         
            text += "\n => Cap nhat => POI Bearish : arrPbHigh[0] "+ (string) tfData.arrPbHigh[0];
            
            tfData.LastSwingMajor = -1;
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = -1;
            tfData.findHigh = 0; tfData.idmLow = tfData.Highs[0]; tfData.idmLowTime = tfData.HighsTime[0];
         }
         
         // continue Up, Continue BOS up
         if (
            //tfData.LastSwingMajor == -1 && 
            bar1.high > tfData.arrPbHigh[0] && tfData.arrPbHigh[0] != tfData.arrChoHigh[0]) {
            text += "\n 1.6 Continue Bos UP. sTrend == 1 && mTrend == 1 && LastSwingMajor == random && bar1.high > arrPbHigh && arrPbHigh: "+
                     (string) tfData.arrPbHigh[0] + " != arrChoHigh[0]: "+(string) tfData.arrChoHigh[0];
            text += "\n---> Update: arrChoHigh[0] = "+ (string) tfData.arrPbHigh[0];
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoHigh, tfData.arrPbHigh[0]);
            tfData.AddToDateTimeArray( tfData.arrChoHighTime, tfData.arrPbHTime[0]);
            tfData.AddToLongArray( tfData.volArrChoHigh, tfData.volArrPbHigh[0]);
            
            // update Point HL
            if (tfData.L != 0 && (tfData.L != tfData.arrPbLow[0] || (tfData.L == tfData.arrPbLow[0] && tfData.LTime != tfData.arrPbLTime[0]))) {
               text += "\n----> IF: L != 0 && L != arrPbLow[0]("+(string)tfData.arrPbLow[0]+") => Update: New arrPbLow[0] = "+(string)tfData.L;
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbLow, tfData.L);
               tfData.AddToDateTimeArray( tfData.arrPbLTime, tfData.LTime);
               tfData.AddToLongArray( tfData.volArrPbLow, tfData.vol_L);
               // Add new zone
               MqlRates bar_tmp = tfData.L_bar;
               PoiZone zone_tmp = CreatePoiZone(bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, zone_tmp, poi_limit);
            }
            
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(BOS_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, BOS_TEXT, tfData.tfColor, STYLE_SOLID);
            
            text += "\n--> Cap nhat POI Bullish: L_idmHigh = idmHigh = "+(string)tfData.idmHigh;
                     
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.findLow = 0; tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.L = 0; tfData.vol_L = 0;
            text += ", findLow = 0, idmHigh = "+(string) tfData.Lows[0]+", L = 0";
            
         }
      }
   
      if(tfData.sTrend == 1 && tfData.mTrend == -1) {
         // continue Up, Continue Choch up
         if (tfData.LastSwingMajor == -1 && bar1.high > tfData.arrPbHigh[0] && tfData.arrPbHigh[0] != tfData.arrChoHigh[0]) {
            text += "2.1 CHoCH up. sTrend == 1 && mTrend == -1 && LastSwingMajor == -1 && bar1.high > arrPbHigh[0]";
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoHigh, tfData.arrPbHigh[0]);
            tfData.AddToDateTimeArray( tfData.arrChoHighTime, tfData.arrPbHTime[0]);
            tfData.AddToLongArray( tfData.volArrChoHigh, tfData.volArrPbHigh[0]);
            
            // update Point HL
            if (tfData.L != 0 && (tfData.L != tfData.arrPbLow[0] || (tfData.L == tfData.arrPbLow[0] && tfData.LTime != tfData.arrPbLTime[0]))) {
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbLow, tfData.L);
               tfData.AddToDateTimeArray( tfData.arrPbLTime, tfData.LTime);
               tfData.AddToLongArray( tfData.volArrPbLow, tfData.vol_L);
               // Add new zone
               MqlRates bar_tmp = tfData.L_bar;
               PoiZone zone_tmp = CreatePoiZone(bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, zone_tmp, poi_limit);
               
            }
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(CHOCH_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);
            text += "\n => Cap nhat => POI Bullish : L = "+ (string) tfData.L;
            
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.findLow = 0; tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0];
            tfData.L = 0; tfData.vol_L = 0;
         }
         // CHoCH DOwn. 
         if (tfData.LastSwingMajor == -1 && bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n 2.2 sTrend == 1 && mTrend == -1 && LastSwingMajor == -1 && bar1.low < arrPbLow[0] : " + (string) bar1.low + "<" + (string) tfData.arrPbLow[0];
            text += "\n => Cap nhat => POI Low. sTrend = -1; mTrend = -1; LastSwingMajor = -1; findHigh = 0; idmLow = Highs[0] = "+(string) tfData.Highs[0];
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            tfData.AddToLongArray( tfData.volArrChoLow, tfData.volArrPbLow[0]);
            // draw choch low
            drawLine(CHOCH_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], bar1.time, tfData.arrPbLow[0], 1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);
                     
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = -1;
            tfData.findHigh = 0; tfData.idmLow = tfData.Highs[0]; tfData.idmLowTime = tfData.HighsTime[0];
         }
      }
      
      if(tfData.sTrend == -1 && tfData.mTrend == -1) {
         // continue BOS 
         if (tfData.LastSwingMajor == 1 && bar1.low < tfData.arrBot[0] && tfData.arrBot[0] != tfData.arrBoLow[0]) { // Done
            text += "\n -3.1. continue BOS, sTrend == -1 && mTrend == -1 && LastSwingMajor == 1 && bar1.low < arrBot[0] : "+ (string) bar1.low +" < "+(string) tfData.arrBot[0];
            text += "\n => Cap nhat: findHigh = 0, idmLow = Highs[0] = "+(string) tfData.Highs[0]+" ; sTrend == -1; mTrend == -1; LastSwingMajor == -1;";
            text += "\n => New arrBoLow = arrBot[0] = " + (string)tfData.arrBot[0] + "; New arrTop = intSHighs[0] = " + (string)tfData.intSHighs[0];               
            // Add new point
            tfData.AddToDoubleArray( tfData.arrBoLow, tfData.arrBot[0]);
            tfData.AddToDateTimeArray( tfData.arrBoLowTime, tfData.arrBotTime[0]);
            tfData.AddToLongArray( tfData.volArrBoLow, tfData.volArrBot[0]);
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrTop, tfData.intSHighs[0]);
            tfData.AddToDateTimeArray( tfData.arrTopTime, tfData.intSHighTime[0]);
            tfData.AddToLongArray( tfData.volArrTop, tfData.volIntSHighs[0]);
            
            // Add new zone POI Bearish
            tfData.AddToPoiZoneArray( tfData.zArrTop, tfData.zIntSHighs[0], poi_limit); 
            // Add new zone
            tfData.AddToPoiZoneArray( tfData.zPoiHigh, tfData.zIntSHighs[0], poi_limit); 
                     
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = -1;
            tfData.findHigh = 0; tfData.idmLow = tfData.Highs[0]; tfData.idmLowTime = tfData.HighsTime[0];
         }
         
         if (bar3.low >= bar2.low && bar2.low <= bar1.low) { // tim thay swing low 
            if (typeTickVolume == 1) {
               maxVolume = bar2.tick_volume;
            } else {
               maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
            }
            // continue BOS swing low
            if (tfData.LastSwingMajor == -1 && bar2.low < tfData.arrBot[0]) {
               text += "\n -3.2. swing low, sTrend == -1 && mTrend == -1 && LastSwingMajor == -1 && bar2.low < arrBot[0]";
               text += "=> Cap nhat: arrBot[0] = bar2.low = "+(string) bar2.low+" ; sTrend == -1; mTrend == -1; LastSwingMajor == 1;";
               
               // Update ArrayBot[0]
               if(tfData.arrBot[0] != bar2.low) {                                 
                  // Add new point
                  tfData.AddToDoubleArray( tfData.arrBot, bar2.low);
                  tfData.AddToDateTimeArray( tfData.arrBotTime, bar2.time);
                  tfData.AddToLongArray( tfData.volArrBot, maxVolume);
                  // Add new zone
                  tfData.AddToPoiZoneArray( tfData.zArrBot, zone2, poi_limit); 
               }
               tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = 1;
            }
   
            // LL < LL
            if (tfData.LastSwingMajor == 1 && bar2.low < tfData.arrBot[0]) {
               text += "\n -3.3. sTrend == -1 && mTrend == -1 && LastSwingMajor == 1 && bar2.low < arrBot[0]";
               text += "=> Xoa label, Cap nhat: arrBot[0] = bar2.low = "+(string) bar2.low+" ; sTrend == -1; mTrend == -1; LastSwingMajor == 1;";
               
               // Update ArrayBot[0]
               if(tfData.arrBot[0] != bar2.low) {
                  // Update point
                  tfData.UpdateDoubleArray( tfData.arrBot, 0, bar2.low);
                  tfData.UpdateDateTimeArray( tfData.arrBotTime, 0, bar2.time);
                  tfData.UpdateLongArray( tfData.volArrBot, 0, maxVolume);
                  // Update zone
                  tfData.UpdatePoiZoneArray( tfData.zArrBot, 0, zone2);
               }
               tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = 1;   
            }
         }
      
         //Cross IDM
         if (
            //tfData.LastSwingMajor == -1 && 
            tfData.findHigh == 0 && bar1.high > tfData.idmLow) {
            text += "\n -3.4. Cross IDM Downtrend, sTrend == -1 && mTrend == -1 && LastSwingMajor == random && bar1.high > idmLow :" + (string) bar1.high + ">" + (string) tfData.idmLow;
            // cap nhat arPBLows
            if(tfData.arrBot[0] != tfData.arrPbLow[0]){            
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbLow, tfData.arrBot[0]);
               tfData.AddToDateTimeArray( tfData.arrPbLTime, tfData.arrBotTime[0]);
               tfData.AddToLongArray( tfData.volArrPbLow, tfData.volArrBot[0]);
               // Add new zone
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, tfData.zArrBot[0], poi_limit);
            } 
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(IDM_TEXT, tfData.idmLowTime, tfData.idmLow, bar1.time, tfData.idmLow, -1, IDM_TEXT, tfData.tfColor, STYLE_DOT);
            text += "\n => Cap nhat findHigh = 1; H = bar1.high = "+ (string) bar1.high;
            
            // active find High
            tfData.findHigh = 1; 
            tfData.H = bar1.high; tfData.HTime = bar1.time; tfData.vol_H = bar1.tick_volume;
            tfData.H_bar = bar1;
            tfData.findLow = 0; tfData.L = 0; tfData.vol_L = 0;
         }
         
         // CHoCH High
         if (
            //tfData.LastSwingMajor == -1 && 
            bar1.high > tfData.arrPbHigh[0] && tfData.arrPbHigh[0] != tfData.arrChoHigh[0]) {
            text += "\n -3.5 sTrend == -1 && mTrend == -1 && LastSwingMajor == random && bar1.high > arrPbHigh[0] :" + (string) bar1.high + ">" + (string) tfData.arrPbHigh[0];
            text += "\n => Cap nhat => sTrend = 1; mTrend = 1; LastSwingMajor = 1; findLow = 0; idmHigh = Lows[0] = "+(string) tfData.Lows[0];
            text += "\n => Cap nhat => POI Bullish = arrPbLow[0] : "+ (string) tfData.arrPbLow[0];
                        
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoHigh, tfData.arrPbHigh[0]);
            tfData.AddToDateTimeArray( tfData.arrChoHighTime, tfData.arrPbHTime[0]);
            tfData.AddToLongArray( tfData.volArrChoHigh, tfData.volArrPbHigh[0]);
            
            // draw choch high
            drawLine(CHOCH_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);
            
            tfData.LastSwingMajor = 1;
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = 1;
            tfData.findHigh = 0; tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0];
         }
         
         // continue Down, Continue BOS down
         if (
            //tfData.LastSwingMajor == 1 && 
            bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n -3.6 Continue Bos DOWN. sTrend == -1 && mTrend == -1 & LastSwingMajor == random && bar1.low < arrPbLow[0] ("+(string)tfData.arrPbLow[0]+")"+
                     "&& arrPbLow[0] != arrChoLow[0] ("+(string)tfData.arrChoLow[0]+")";
            text += "\n---> Update: arrChoLow[0] = "+ (string) tfData.arrPbLow[0];
                                    
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            tfData.AddToLongArray( tfData.volArrChoLow, tfData.volArrPbLow[0]);
                        
            // update Point LH         
            if (tfData.H != 0 && (tfData.H != tfData.arrPbHigh[0] || (tfData.H == tfData.arrPbHigh[0] && tfData.HTime != tfData.arrPbHTime[0]))) {
               text += "\n----> IF: H != 0 && H != arrPbHigh[0]("+(string)tfData.arrPbHigh[0]+") => Update: New arrPbHigh[0] = "+(string)tfData.H;
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbHigh, tfData.H);
               tfData.AddToDateTimeArray( tfData.arrPbHTime, tfData.HTime);
               tfData.AddToLongArray( tfData.volArrPbHigh, tfData.vol_H);
               // Add new zone
               MqlRates bar_tmp = tfData.H_bar;
               PoiZone zone_tmp = CreatePoiZone(bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, zone_tmp, poi_limit);
            }
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(BOS_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], bar1.time, tfData.arrPbLow[0], 1, BOS_TEXT, tfData.tfColor, STYLE_SOLID);
            
            text += "\n--> Cap nhat POI Bearish: L_idmLow = idmLow = "+(string)tfData.idmLow;
                     
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.findHigh = 0; tfData.idmLow = tfData.Highs[0]; tfData.idmLowTime = tfData.HighsTime[0]; tfData.H = 0; tfData.vol_H = 0; 
            text += ", findHigh = 0, idmLow = "+(string) tfData.Highs[0]+", H = 0";
            
         }
         
      }
      if (tfData.sTrend == -1 && tfData.mTrend == 1) {
         // continue Down, COntinue Choch down
         if (tfData.LastSwingMajor == 1 && bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n -4.1 sTrend == -1 && mTrend == 1 && LastSwingMajor == 1 && bar1.low < arPbLow[0]";
                          
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            tfData.AddToLongArray( tfData.volArrChoLow, tfData.volArrPbLow[0]);
            
            // update Point LH         
            if (tfData.H != 0 && (tfData.H != tfData.arrPbHigh[0] || (tfData.H == tfData.arrPbHigh[0] && tfData.HTime != tfData.arrPbHTime[0]))) {
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbHigh, tfData.H);
               tfData.AddToDateTimeArray( tfData.arrPbHTime, tfData.HTime);
               tfData.AddToLongArray( tfData.volArrPbHigh, tfData.vol_H);
               // Add new zone
               MqlRates bar_tmp = tfData.H_bar;
               PoiZone zone_tmp = CreatePoiZone(bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, zone_tmp, poi_limit); 
            }
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(CHOCH_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], bar1.time, tfData.arrPbLow[0], 1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);
            
            text += "\n => Cap nhat => POI bearish H: "+(string) tfData.H;
            
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.findHigh = 0; tfData.idmLow = tfData.Highs[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.H = 0; tfData.vol_H = 0;
         }
         // CHoCH Up. 
         if (tfData.LastSwingMajor == 1 && bar1.high > tfData.arrPbHigh[0] && tfData.arrPbHigh[0] != tfData.arrChoHigh[0]) {
               
            text += "\n -4.2 sTrend == -1 && mTrend == 1 && LastSwingMajor == 1 && bar1.high > arrPbHigh[0] : " + (string) bar1.high + ">" +(string) tfData.arrPbHigh[0];
            text += "\n => Cap nhat => sTrend = 1; mTrend = 1; LastSwingMajor = 1; findLow = 0; idmHigh = Lows[0] = "+(string) tfData.Lows[0];
            text += "\n => Cap nhat => POI Bullish = arrPbLow[0] : "+ (string) tfData.arrPbLow[0];
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoHigh, tfData.arrPbHigh[0]);
            tfData.AddToDateTimeArray( tfData.arrChoHighTime, tfData.arrPbHTime[0]);
            tfData.AddToLongArray( tfData.volArrChoHigh, tfData.volArrPbHigh[0]);
            
            // draw choch low
            drawLine(CHOCH_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);
   
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = 1;
            tfData.findLow = 0; tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0];
         }
      }
      
      if(isComment && StringLen(text) > 0) {
         textall += text;
         //text +=  "\n Last: "+getValueTrend(tfData);
         textall += "\n ---------- END updatePointTopBot ------------";
         Print(textall);
         showComment(tfData);
      }
      
   } //--- End Ham cap nhat cau truc thi truong : updatePointTopBot
   
   void showComment(TimeFrameData& tfData) {
      Print("Timeframe: "+ (string) tfData.isTimeframe);
      if (tfData.sTrend == 1 || tfData.sTrend == -1) {
      
         //Print("Lows: "); ArrayPrint(tfData.Lows); 
         //Print("Vol Lows: "); ArrayPrint(tfData.volLows); 
         
         //Print("intSLows: "); ArrayPrint(tfData.intSLows); 
         //Print("Vol intSLows: "); ArrayPrint(tfData.volIntSLows); 
         
         //Print("arrBot: "); ArrayPrint(tfData.arrBot); 
         //Print("Vol arrBot: "); ArrayPrint(tfData.volArrBot);
         
         Print("arrPbLow: "); ArrayPrint(tfData.arrPbLow); 
         Print("Vol arrPbLow: "); ArrayPrint(tfData.volArrPbLow);
         
         //Print("arrDecisionalLow: "); ArrayPrint(tfData.arrDecisionalLow);
         //Print("Vol arrDecisionalLow: "); ArrayPrint(tfData.volArrDecisionalLow);
         
//         Print("arrBoLow: "+(string) tfData.arrBoLow[0]);
//         Print("Vol arrBoLow: "); ArrayPrint(tfData.volArrBoLow);
//         
//         Print("arrChoLow: "+(string) tfData.arrChoLow[0]);
//         Print("Vol arrChoLow: "); ArrayPrint(tfData.volArrChoLow);
         
         //Print(" zLows: "); ArrayPrint(tfData.zLows);
         //Print(" zIntSLows: "); ArrayPrint(tfData.zIntSLows);
         //Print(" zArrBot: "); ArrayPrint(tfData.zArrBot);
         
         //Print("zArrPbLow"); ArrayPrint(tfData.zArrPbLow);
         //Print("zPoiExtremeLow: "); ArrayPrint(tfData.zPoiExtremeLow);
         //Print("zPoiDecisionalLow: "); ArrayPrint(tfData.zPoiDecisionalLow);
      }
      if (tfData.sTrend == -1 || tfData.sTrend == 1) {
         //Print("Highs: "); ArrayPrint(tfData.Highs);
         //Print("Vol Highs: "); ArrayPrint(tfData.volHighs);
         
         //Print("intSHighs: "); ArrayPrint(tfData.intSHighs);
         //Print("Vol intSHighs: "); ArrayPrint(tfData.volIntSHighs);
         
         //Print("arrTop: "); ArrayPrint(tfData.arrTop); 
         //Print("Vol arrTop: "); ArrayPrint(tfData.volArrTop);
         
         Print("arrPbHigh: "); ArrayPrint(tfData.arrPbHigh); 
         Print("Vol arrPbHigh: "); ArrayPrint(tfData.volArrPbHigh);
         
         //Print("arrDecisionalHigh: "); ArrayPrint(tfData.arrDecisionalHigh);
         //Print("Vol arrDecisionalHigh: "); ArrayPrint(tfData.volArrDecisionalHigh);
         
//         Print("arrBoHigh: "+(string) tfData.arrBoHigh[0]);
//         Print("Vol arrBoHigh: "); ArrayPrint(tfData.volArrBoHigh);
//         
//         Print("arrChoHigh: "+(string) tfData.arrChoHigh[0]);
//         Print("Vol arrChoHigh: "); ArrayPrint(tfData.volArrChoHigh);
               
         //Print(" zHighs: "); ArrayPrint(tfData.zHighs);
         //Print(" zIntSHighs: "); ArrayPrint(tfData.zIntSHighs);
         //Print(" zArrTop: "); ArrayPrint(tfData.zArrTop);
         
         //Print("zArrPbHigh"); ArrayPrint(tfData.zArrPbHigh); 
         //Print("zPoiExtremeHigh: "); ArrayPrint(tfData.zPoiExtremeHigh);
         //Print("zPoiDecisionalHigh: "); ArrayPrint(tfData.zPoiDecisionalHigh);
      }
   }  
   
   void getZoneValid(TimeFrameData& tfData) {
      //showComment();
      // Pre arr Decisional
      getDecisionalValue(tfData, disableComment);
      
      //// Extreme Poi
      setValueToZone(tfData, 1, tfData.zArrPbHigh, tfData.zPoiExtremeHigh, enabledComment, "Extreme");
      setValueToZone(tfData, -1, tfData.zArrPbLow, tfData.zPoiExtremeLow, enabledComment, "Extreme");
      //// Decisional Poi
      setValueToZone(tfData, 1, tfData.zArrDecisionalHigh, tfData.zPoiDecisionalHigh, enabledComment, "Decisional");
      setValueToZone(tfData, -1, tfData.zArrDecisionalLow, tfData.zPoiDecisionalLow, enabledComment, "Decisional");
   }      
   
   // Todo: dang setup chua xong, can verify Decisinal POI moi khi chay. Luu gia tri High, Low vao 1 gia tri cố định để so sánh
   // 
   void getDecisionalValue(TimeFrameData& tfData, bool isComment = false) {
      string text = "Function getDecisionalValue:";
      // High
      if (ArraySize(tfData.intSHighs) > 1 && tfData.arrDecisionalHigh[0] != tfData.intSHighs[1]) {
         text += "\n Checking intSHighs[1]: "+ (string) tfData.intSHighs[1];
         // intSHigh[1] not include Extrempoi
         int isExist = -1;
         if (ArraySize(tfData.arrPbHigh) > 0) {
            isExist = checkExist(tfData.intSHighs[1], tfData.arrPbHigh);
            text += ": Tim thay vi tri "+(string) isExist+" trong arrPbHigh. (Extreme)";
         }
         // Neu khong phai la extreme POI. update if isExist == -1
         if (isExist == -1) {
            // add new point
            tfData.AddToDoubleArray(tfData.arrDecisionalHigh, tfData.intSHighs[1]);
            tfData.AddToDateTimeArray(tfData.arrDecisionalHighTime, tfData.intSHighTime[1]);
            // Get Bar Index
            MqlRates iBar;
            int indexH = iBarShift(_Symbol, tfData.timeFrame, tfData.intSHighTime[1], true);
            if (indexH != -1) {
               getValueBar(iBar, tfData.timeFrame,indexH);               
               // Add new zone
               MqlRates bar_tmp = iBar;
               PoiZone zone_tmp = CreatePoiZone(bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrDecisionalHigh, zone_tmp, poi_limit);
            }
         } else {
            text += "\n Da ton tai o vi tri : "+(string) isExist+" trong arrPbHigh. Bo qua.";
         }
      }
      
      // Low
      if (ArraySize(tfData.intSLows) > 1 && tfData.arrDecisionalLow[0] != tfData.intSLows[1]) {
         text += "\n Checking intSLows[1]: "+ (string) tfData.intSLows[1];
         // intSLow[1] not include Extrempoi
         int isExist = -1;
         if (ArraySize(tfData.arrPbLow) > 0) {
            isExist = checkExist(tfData.intSLows[1], tfData.arrPbLow);
            text += ": Tim thay vi tri "+(string) isExist+" trong arrPbLow. (Extreme)";
         }
         // Neu khong phai la extreme POI. update if isExist == -1
         if (isExist == -1) {
            // add new point
            tfData.AddToDoubleArray(tfData.arrDecisionalLow, tfData.intSLows[1]);
            tfData.AddToDateTimeArray(tfData.arrDecisionalLowTime, tfData.intSLowTime[1]);
            // Get Bar Index
            MqlRates iBar;
            int indexL = iBarShift(_Symbol, tfData.timeFrame, tfData.intSLowTime[1], true);
            if (indexL != -1) {
               getValueBar(iBar, tfData.timeFrame, indexL);               
               // Add new zone
               MqlRates bar_tmp = iBar;
               PoiZone zone_tmp = CreatePoiZone(bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrDecisionalLow, zone_tmp, poi_limit);
            }
         } else {
            text += "\n Da ton tai o vi tri : "+(string) isExist+" trong arrPbLow. Bo qua.";
         }
      }
      if (isComment) Print(text);
   }
   
   int checkExist(double value, double& array[]){
      int checkExist = -1;
      if (ArraySize(array) > 0) {
         for(int i=0;i<ArraySize(array);i++) {
            if (array[i] == value) {
               checkExist = i;
               break;
            }
         }
      }
      return checkExist;
   }
   
   void setValueToZone(TimeFrameData& tfData, int _type,PoiZone& zoneDefault[], PoiZone& zoneTarget[], bool isComment = false, string str_poi = ""){
      string text = "";
      // type = 1 is High, -1 is Low
      double priceKey = (_type == 1) ? zoneDefault[0].high : zoneDefault[0].low;
      datetime timeKey = zoneDefault[0].time;
      // check default has new value?? 
      if (ArraySize(zoneDefault) > 1 && priceKey != zoneTarget[0].priceKey && timeKey != zoneTarget[0].timeKey && priceKey != 0) {
         text += ( "--> "+ str_poi +" "+ (( _type == 1)? "High" : "Low") +". Xuat hien value: "+(string)priceKey+" co time: "+(string)timeKey+" moi. them vao Extreme Zone");
         int indexH; 
         MqlRates barH;
         
         int result = -1;
         indexH = iBarShift(_Symbol, tfData.timeFrame, timeKey, true);
         if (indexH != -1) {
            // result = -1 => is nothing; result = 0 => is Default; result = index => update
            result = isFVG(tfData, indexH, _type); // High is type = 1 or Low is type = -1
            // set Value to barH
            if (result != -1) {
               getValueBar(barH, tfData.timeFrame, (result != 0) ? result : indexH);
               
               // Add new zone
               MqlRates bar_tmp = barH;
               PoiZone zone_tmp = CreatePoiZone(bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time, 0, priceKey, timeKey);
               tfData.AddToPoiZoneArray( zoneTarget, zone_tmp, poi_limit);
            }
         } else {
            text += ("Khong lam gi");
         }
         if(isComment) {
            Print(text);
         }
      }
   }
      
   //--- Return position bar on chart
   int isFVG(TimeFrameData& tfData, int index, int type){ // type = 1 is High (Bearish) or type = -1 is Low (Bullish) 
      string text = "-------------- Check FVG";
      int indexOrigin = index;
      int result = -1;
      bool stop = false;
      ENUM_TIMEFRAMES timeframe = tfData.timeFrame;
      MqlRates bar1, bar2, bar3;
      int i = 0;
      while(stop == false && index >=0) {
         text += "\n Number " + (string)i;
         // gia tri lay tu xa ve gan 
         getValueBar(bar1, timeframe, index); // Bar current
         getValueBar(bar2, timeframe, index-1);
         getValueBar(bar3, timeframe, index-2); 
         text += "\n bar 1: "+ " High: "+ (string) bar1.high + " Low: "+ (string) bar1.low;
         text += "\n bar 2: "+ " High: "+ (string) bar2.high + " Low: "+ (string) bar2.low;
         text += "\n bar 3: "+ " High: "+ (string) bar3.high + " Low: "+ (string) bar3.low;
         if (( type == -1 && bar1.high > tfData.arrTop[0]) || (type == 1 && bar1.low < tfData.arrBot[0])) { // gia vuot qua dinh gan nhat. Bo qua
            text += "\n gia vuot qua dinh, day gan nhat. Bo qua";
            result = 0;
            stop = true;
            break;
         }
         if (type == -1) { // Bull FVG
            if (  bar1.low > bar3.high && // has space
                  bar2.close > bar3.high && bar1.close > bar1.open && bar3.close > bar3.open // is Green Bar
               ) {
               result = index;
               stop = true;
               text += "\n Bull FVG: Tim thay nen co FVG. High= "+ (string) bar1.high +" Low= "+(string)  bar1.low;
               break;
            }
         } else if (type == 1) { // Bear FVG 
            if (
               bar1.high < bar3.low && // has space
               bar2.close < bar3.low && bar1.close < bar1.open && bar3.close < bar3.open // is Red Bar
            ) {
               result = index;
               stop = true;
               text += "\n Bear FVG: Tim thay nen co FVG. High= "+ (string) bar1.high +" Low= "+ (string) bar1.low;
               break;
            }
         }
         if (stop == false) {
            i++;
            index--;
         }
      }
      //Print(text);
      return result;
   }
   
   //--- Set all value Index to Bar Default
   void getValueBar(MqlRates& bar, ENUM_TIMEFRAMES Timeframe,int index) {
      bar.high = iHigh(_Symbol, Timeframe, index);
      bar.low = iLow(_Symbol, Timeframe, index);
      bar.open = iOpen(_Symbol, Timeframe, index);
      bar.close = iClose(_Symbol, Timeframe, index);
      bar.time = iTime(_Symbol, Timeframe, index);
      //Print("- Bar -"+index + " - "+ " High: "+ bar.high+" Low: "+bar.low + " Time: "+ bar.time);
   }
   
   void drawZone(TimeFrameData& tfData, MqlRates& bar1) {
      // IDM Live 
      if (tfData.sTrend == 1 && tfData.findLow == 0 && tfData.L_idmHigh != 0) {
         if (tfData.L_idmHigh > 0) {
            deleteObj(tfData.L_idmHighTime, tfData.L_idmHigh, 0, "");
            deleteLine(tfData.L_idmHighTime, tfData.L_idmHigh, IDM_TEXT_LIVE);
            deleteObj(tfData.L_idmHighTime, tfData.L_idmHigh, 0, IDM_TEXT_LIVE);
         }
         drawLine(IDM_TEXT_LIVE, tfData.idmHighTime, tfData.idmHigh, bar1.time, tfData.idmHigh, 1, IDM_TEXT_LIVE, tfData.tfColor, STYLE_DOT);
      }
      if (tfData.sTrend == -1 && tfData.findHigh == 0 && tfData.L_idmLow != 0) {
         if (tfData.L_idmLow > 0) {
            deleteObj(tfData.L_idmLowTime, tfData.L_idmLow, 0, "");
            deleteLine(tfData.L_idmLowTime, tfData.L_idmLow, IDM_TEXT_LIVE);
            deleteObj(tfData.L_idmLowTime, tfData.L_idmLow, 0, IDM_TEXT_LIVE);
         }
         drawLine(IDM_TEXT_LIVE, tfData.idmLowTime, tfData.idmLow, bar1.time, tfData.idmLow, -1, IDM_TEXT_LIVE, tfData.tfColor, STYLE_DOT);
      }
      
      if (tfData.isDraw) {
         // Extreme Zone.
         if (
            //sTrend == 1 && 
            ArraySize(tfData.zPoiExtremeHigh) > 0) { // care PB Low
            for(int i=0;i<ArraySize(tfData.zPoiExtremeHigh) - 1;i++) {
               //Print("zone "+ i);
               drawBox("ePOI", tfData.zPoiExtremeHigh[i].time, tfData.zPoiExtremeHigh[i].low, bar1.time, tfData.zPoiExtremeHigh[i].high,1, clrMaroon, 1);
            }
         }
         
         if (
            //sTrend == -1 && 
            ArraySize(tfData.zPoiExtremeLow) > 0) { // care PB High
            for(int i=0;i<ArraySize(tfData.zPoiExtremeLow) - 1;i++) {
               //Print("zone "+ i);
               drawBox("ePOI", tfData.zPoiExtremeLow[i].time, tfData.zPoiExtremeLow[i].high, bar1.time, tfData.zPoiExtremeLow[i].low,1, clrDarkGreen, 1);
            }
         }  
         
         // Decisional Zone.
         if (
            //sTrend == 1 && 
            ArraySize(tfData.zPoiDecisionalHigh) > 0) { // care PB Low
            for(int i=0;i<ArraySize(tfData.zPoiDecisionalHigh) - 1;i++) {
               //Print("zone "+ i);
               drawBox("dPOI", tfData.zPoiDecisionalHigh[i].time, tfData.zPoiDecisionalHigh[i].low, bar1.time, tfData.zPoiDecisionalHigh[i].high,1, clrSaddleBrown, 1);
            }
         }
         
         if (
            //sTrend == -1 && 
            ArraySize(tfData.zPoiDecisionalLow) > 0) { // care PB High
            for(int i=0;i<ArraySize(tfData.zPoiDecisionalLow) - 1;i++) {
               //Print("zone "+ i);
               drawBox("dPOI", tfData.zPoiDecisionalLow[i].time, tfData.zPoiDecisionalLow[i].high, bar1.time, tfData.zPoiDecisionalLow[i].low,1, clrDarkBlue, 1);
            }
         }  
      }
      
      
   }

}; //--- End marketStructs

marketStructs highTFStruct;
marketStructs lowTFStruct;

marketStructs prewHighTFStruct;
marketStructs prewLowTFStruct;
//+------------------------------------------------------------------+
//| End Market Struct                                                |
//+------------------------------------------------------------------+

// OnInit function
int OnInit()
{   
   defaultGlobal();
//---
   prewHighTFStruct.originalDefinition(highTimeFrame);
   
   prewLowTFStruct.originalDefinition(lowTimeFrame);
//---
   
   return(INIT_SUCCEEDED);
}

// OnTick function
void OnTick()
{
   //demoOntick();
   
   // Kiểm tra nến mới cho M5
    if(IsNewBar(lowTimeFrame)) {
        lowTFStruct.realTimeDefinition(lowTimeFrame);
        // Thêm logic xử lý tại đây
    }
    
   // Kiểm tra nến mới cho H1
    if(IsNewBar(highTimeFrame)) {
        highTFStruct.realTimeDefinition(highTimeFrame);
        // Thêm logic xử lý tại đây
    }
    
    // ham hien thi thong tin struct len chart
    showInfoStruct();
}

// OnDeinit function
void OnDeinit(const int reason)
{
   // Dọn dẹp tất cả dữ liệu
   ENUM_TIMEFRAMES timeframes[];
   int count = GlobalVars.GetTimeframes(timeframes);
   
   for(int i = 0; i < count; i++)
   {
      GlobalVars.RemoveTimeFrame(timeframes[i]);
   }
}

// Dinh nghia va xac nhan bien toan cuc
void defaultGlobal() {
   // xac dinh cap low high time frame by minutes
   switch(lowPairTF)
     {
      case  1:
        highPairTF = 15;
        lowTimeFrame = PERIOD_M1;
        highTimeFrame = PERIOD_M15;
        break;
      case  15:
        highPairTF = 240;
        lowTimeFrame = PERIOD_M15;
        highTimeFrame = PERIOD_H4;
        break;
      case  60:
        highPairTF = 1440;
        lowTimeFrame = PERIOD_H1;
        highTimeFrame = PERIOD_D1;
        break;
      default:
         highPairTF = 60;
         lowTimeFrame = PERIOD_M5;
         highTimeFrame = PERIOD_H1;
        break;
     }
}

// Show info ontick
void showInfoStruct() {
   string comment = ""; 
   comment += getInfoStruct(lowTimeFrame);
   comment += "\n";
   comment += getInfoStruct(highTimeFrame);
   Comment(comment);
}

// In thong tin struct ra ngoai
string getInfoStruct(ENUM_TIMEFRAMES timeframe) {
   string text = "";
   // Lấy dữ liệu cho khung H1
   TimeFrameData* tfData = GlobalVars.GetData(timeframe);
   text += "Timeframe: "+ (string) tfData.timeFrame;
   text += " | Struct is : " + ((tfData.sTrend == 0) ? "Not defined" : ((tfData.sTrend == 1) ? "S UpTrend" : "S DownTrend"));
   text += " | Marjor Struct is : " + ((tfData.mTrend == 0) ? "Not defined" : ((tfData.mTrend == 1) ? "m UpTrend" : "m DownTrend"));
   text += " | Internal is : " + ((tfData.iTrend == 0) ? "Not defined" : ((tfData.iTrend == 1) ? "i UpTrend" : "i DownTrend"));
   //text += " | Gann wave is : " + ((tfData.LastSwingMeter == 0) ? "Not defined" : ((tfData.LastSwingMeter == -1) ? "g UpTrend" : " DownTrend"));
   return text;
}

//+------------------------------------------------------------------+
//| Hàm kiểm tra nến mới cho bất kỳ khung thời gian nào               |
//+------------------------------------------------------------------+
bool IsNewBar(ENUM_TIMEFRAMES timeframe) {
    // Tạo key duy nhất từ symbol + timeframe
    static string _prevKeys[];    // Lưu trữ các key đã kiểm tra
    static datetime _prevTimes[]; // Lưu trữ thời gian mở nến trước đó
    
    string key = _Symbol + "|" + IntegerToString(timeframe);
    
    // Lấy thời gian mở nến hiện tại
    datetime currentTime = iTime(_Symbol, timeframe, 0);
    if(currentTime == 0) return false; // Kiểm tra dữ liệu hợp lệ
    
    // Tìm key trong mảng lưu trữ
    int index = -1;
    for(int i = 0; i < ArraySize(_prevKeys); i++) {
        if(_prevKeys[i] == key) {
            index = i;
            break;
        }
    }
    
    // Xử lý khi gặp khung thời gian mới
    if(index == -1) {
        int newSize = ArraySize(_prevKeys) + 1;
        ArrayResize(_prevKeys, newSize);
        ArrayResize(_prevTimes, newSize);
        
        _prevKeys[newSize-1] = key;
        _prevTimes[newSize-1] = currentTime;
        return false; // Không trả true ở lần đầu tiên
    }
    
    // Kiểm tra nến mới
    if(_prevTimes[index] != currentTime) {
        _prevTimes[index] = currentTime;
        return true;
    }
    //ArrayPrint(_prevKeys);
    //ArrayPrint(_prevTimes);
    return false;
}

string inInfoBar(MqlRates& bar1, MqlRates& bar2, MqlRates& bar3) {
   string text = "Bar1 (R) high: "+ (string) bar1.high +" - low: "+ (string) bar1.low + " - vol: "+ (string) bar1.tick_volume +
                  " --- "+" Bar2 high: "+ (string) bar2.high +" - low: "+ (string) bar2.low+ " - vol: "+ (string) bar2.tick_volume +
                  " --- "+" Bar3 (L) high: "+ (string) bar3.high +" - low: "+ (string) bar3.low+" - vol: "+ (string) bar3.tick_volume;
   return text;
}

//+------------------------------------------------------------------+
void createObj(datetime time, double price, int arrowCode, int direction, color clr, string txt)
  {
   string objName ="";
   StringConcatenate(objName, "Signal@", time, "at", DoubleToString(price, _Digits), "(", arrowCode, ")");

   double ask=SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   double bid=SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double spread=ask-bid;

   if(direction > 0){
      price -= _PointSpace*spread * _Point;
   } else if(direction < 0){
      price += _PointSpace*spread * _Point;
   }

   if(ObjectCreate(0, objName, OBJ_ARROW, 0, time, price))
     {
      ObjectSetInteger(0, objName, OBJPROP_ARROWCODE, arrowCode);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, clr);
      if( direction > 0)
         ObjectSetInteger(0, objName, OBJPROP_ANCHOR, ANCHOR_TOP);
      if(direction < 0)
         ObjectSetInteger(0, objName, OBJPROP_ANCHOR, ANCHOR_BOTTOM);
   }
   string objNameDesc = objName + txt;
   if (ObjectCreate(0, objNameDesc, OBJ_TEXT, 0, time, price)) {
      ObjectSetString(0, objNameDesc, OBJPROP_TEXT, " "+txt);
      ObjectSetInteger(0, objNameDesc, OBJPROP_COLOR, clr);
      if( direction > 0)
         ObjectSetInteger(0, objNameDesc, OBJPROP_ANCHOR, ANCHOR_TOP);
      if(direction < 0)
         ObjectSetInteger(0, objNameDesc, OBJPROP_ANCHOR, ANCHOR_BOTTOM);
   }
}

//+------------------------------------------------------------------+
//| Function to delete objects created by createObj                   |
//+------------------------------------------------------------------+
void deleteObj(datetime time, double price, int arrowCode, string txt) {
   // Create the object name using the same format as createObj
   string objName = "";
   StringConcatenate(objName, "Signal@", time, "at", DoubleToString(price, _Digits), "(", arrowCode, ")");
   
   // Delete the arrow object
   if(ObjectFind(0, objName) != -1) // Check if the object exists
     {
      ObjectDelete(0, objName);
     }
   
   // Create the description object name
   string objNameDesc = objName + txt;
   
   // Delete the text object
   if(ObjectFind(0, objNameDesc) != -1) // Check if the object exists
     {
      ObjectDelete(0, objNameDesc);
     }
}


//+--------------------------------Draw Box ----------------------------------+
void drawBox(string name, datetime time_start, double price_start, datetime time_end, double price_end, int style, color box_color, int width = 1) {
   string objName = name+TimeToString(time_start);
   if(ObjectFind(0, objName) < 0)
      ObjectCreate(0, objName, OBJ_RECTANGLE, 0, time_start, price_start, time_end, price_end);
   //--- set line color
   ObjectSetInteger(0, objName, OBJPROP_COLOR, box_color);
   //--- set line display style
   ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_SOLID);
   //--- enable (true) or disable (false) the mode of filling the rectangle 
   ObjectSetInteger(0,objName,OBJPROP_FILL, true); 
   //--- display in the foreground (false) or background (true) 
   ObjectSetInteger(0,objName,OBJPROP_BACK,true); 
   //--- set line width
   ObjectSetInteger(0, objName, OBJPROP_WIDTH, width);
   
}


//+------------------------------- Draw Line -----------------------------------+
void drawLine(string name, datetime  time_start, double price_start, datetime time_end, double price_end, int direction, string displayName, color iColor, int styleDot){
   string objname = name + TimeToString(time_start);
   if (ObjectFind(0, objname) < 0) {
      ObjectCreate(0, objname, OBJ_TREND, 0, time_start, price_start, time_end, price_end);
      ObjectSetInteger(0, objname, OBJPROP_COLOR, iColor);
      ObjectSetInteger(0, objname, OBJPROP_WIDTH, 1);
      if (styleDot == STYLE_DASH) {
         ObjectSetInteger(0, objname, OBJPROP_STYLE, STYLE_DASH);
      } else if (styleDot == STYLE_DASHDOT) {
         ObjectSetInteger(0, objname, OBJPROP_STYLE, STYLE_DASHDOT);
      } else if (styleDot == STYLE_DASHDOTDOT) {
         ObjectSetInteger(0, objname, OBJPROP_STYLE, STYLE_DASHDOTDOT);
      } else if (styleDot == STYLE_DOT) {
         ObjectSetInteger(0, objname, OBJPROP_STYLE, STYLE_DOT);
      } else if (styleDot == STYLE_SOLID) {
         ObjectSetInteger(0, objname, OBJPROP_STYLE, STYLE_SOLID);
      }
       
      createObj(time_start, price_start, 0, direction, iColor, displayName);
   }
}

//+------------------------------------------------------------------+
//| Function to delete line created by drawline                      |
//+------------------------------------------------------------------+
void deleteLine(datetime time, double price, string name) {
   // Create the object name using the same format as drawline
   string objName = name + TimeToString(time);
   //StringConcatenate(objName, "Signal@", time, "at", DoubleToString(price, _Digits), "(", arrowCode, ")");
   
   // Delete the arrow object
   if(ObjectFind(0, objName) != -1) // Check if the object exists
     {
      ObjectDelete(0, objName);
     }
}

//+------------------------------------------------------------------+
//| Example usage                                                    |
//+------------------------------------------------------------------+ 
//void demoInit() {
////   // Lấy dữ liệu cho khung H1
////   TimeFrameData* h1Data = GlobalVars.GetData(PERIOD_H1);
////   
////   // Lấy giá hiện tại
////   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
////   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
////   
////   // Thêm giá trị vào mảng Highs
////   h1Data.AddToDoubleArray(h1Data.Highs, 1.2345);
////   h1Data.AddToDoubleArray(h1Data.Highs, 1.2456);
////   
////   // Thêm thời gian vào mảng HighsTime
////   h1Data.AddToDateTimeArray(h1Data.HighsTime, TimeCurrent());
////   h1Data.AddToDateTimeArray(h1Data.HighsTime, TimeCurrent() - 3600);
////   
////   // Thêm PoiZone vào mảng zHighs
////   PoiZone zone1 = CreatePoiZone(ask + 0.0020, ask - 0.0020, ask, bid, TimeCurrent());
////   h1Data.AddToPoiZoneArray(h1Data.zHighs, zone1);
////   
////   PoiZone zone2 = CreatePoiZone(ask + 0.0015, ask - 0.0015, ask, bid, TimeCurrent());
////   h1Data.AddToPoiZoneArray(h1Data.zHighs, zone2);
////   
////   // Sắp xếp mảng Highs
////   h1Data.SortDoubleArrayDesc(h1Data.Highs);
////   
////   // Thêm giá trị vào mảng Highs của M15
////   GlobalVars.AddToHighs(PERIOD_M15, 1.2300);
////   GlobalVars.AddToHighs(PERIOD_M15, 1.2350);
////   
////   // Thêm PoiZone vào mảng zHighs của M15
////   PoiZone zone3 = CreatePoiZone(ask + 0.0010, ask - 0.0010, ask, bid, TimeCurrent());
////   GlobalVars.AddToZHighs(PERIOD_M15, zone3);
////   
////   // Lấy giá trị cao nhất từ mảng Highs của H1
////   double maxHigh = GlobalVars.GetHighsMax(PERIOD_H1);
////   Print("Max High in H1: ", maxHigh);
////   
////   // Lấy PoiZone mới nhất từ mảng zHighs của H1
////   PoiZone latestZone;
////   if(GlobalVars.GetLatestZHighs(PERIOD_H1, latestZone))
////      PrintPoiZone(latestZone, "Latest: ");
//}
//
//void demoOntick() {
////   // Lấy giá hiện tại
////   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
////   
////   // Truy cập dữ liệu H1
////   TimeFrameData* h1Data = GlobalVars.GetData(PERIOD_H1);
////   
////   // Kiểm tra và cập nhật các PoiZone
////   for(int i = ArraySize(h1Data.zHighs) - 1; i >= 0; i--)
////   {
////      if(IsPoiZoneMitigated(h1Data.zHighs[i], bid))
////      {
////         Print("PoiZone mitigated: ", TimeToString(h1Data.zHighs[i].time));
////         h1Data.zHighs[i].mitigated = 1;
////      }
////   }
////   
////   // Dọn dẹp dữ liệu cũ mỗi giờ
////   static datetime lastCleanup = 0;
////   if(TimeCurrent() - lastCleanup >= 3600)
////   {
////      GlobalVars.CleanupOldData(PERIOD_H1, 24); // Giữ dữ liệu 24 giờ
////      lastCleanup = TimeCurrent();
////   }
////   
////   ArrayPrint(h1Data.Highs);
////   ArrayPrint(h1Data.zHighs);
//}

//+------------------------------------------------------------------+
//| End Example usage                                                |
//+------------------------------------------------------------------+

void testData(ENUM_TIMEFRAMES timeframe) {
   Print("---- Timeframe : " + EnumToString(timeframe)+ "----");
   // Lấy dữ liệu cho khung timeframe
   TimeFrameData* tfData = GlobalVars.GetData(timeframe);
   Print("tfData.Highs 0 = "+ (string)tfData.Highs[0]); ArrayPrint(tfData.Highs);
   Print("tfData.HighsTime 0 = "+ (string)tfData.HighsTime[0]); ArrayPrint(tfData.HighsTime);
   Print("tfData.Lows 0 = "+ (string)tfData.Lows[0]); ArrayPrint(tfData.Lows);
   Print("tfData.LowsTime 0 = "+ (string)tfData.LowsTime[0]); ArrayPrint(tfData.LowsTime);
   Print("tfData.zHighs"); ArrayPrint(tfData.zHighs);
   Print("tfData.zLows"); ArrayPrint(tfData.zLows);
   Print("----------- END --------------");
}

string getValueTrend(TimeFrameData& tfData) {
   string text =  "| Struct trend = STrend: "+ (string) tfData.sTrend + " - marjor trend = mTrend: "+(string) tfData.mTrend+ " - LastSwingMajor: "+(string) tfData.LastSwingMajor+ 
               " findHigh: "+(string) tfData.findHigh+" - idmHigh: "+(string) tfData.idmHigh+
               " findLow: "+(string) tfData.findLow+" - idmLow: "+(string) tfData.idmLow+
               " | \n | iTrend: "+(string) tfData.iTrend+ " - LastSwingInternal: "+(string) tfData.LastSwingInternal+
               " | | gTrend: "+(string) tfData.gTrend+ " - LastSwingMeter: "+(string) tfData.LastSwingMeter+
               " | | H: "+ (string) tfData.H +" - L: "+(string) tfData.L;  
   return text;
}      