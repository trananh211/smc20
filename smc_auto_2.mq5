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
   int mitigated;
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
   // Gann Wave
   double highEst;
   double lowEst;
   double Highs[];
   double Lows[];
   datetime hightime;
   datetime lowtime;
   datetime HighsTime[];
   datetime LowsTime[];
   int LastSwingMeter;
   int gTrend;

   // Internal Structure
   double intSHighs[];
   double intSLows[];
   datetime intSHighTime[];
   datetime intSLowTime[];
   int LastSwingInternal;
   int iTrend;

   // Array pullback
   double arrTop[];
   double arrBot[];
   datetime arrTopTime[];
   datetime arrBotTime[];
   int mTrend;
   int sTrend;
   datetime arrPbHTime[];
   double arrPbHigh[];
   datetime arrPbLTime[];
   double arrPbLow[];

   // Chopped and Breakout
   double arrChoHigh[];
   double arrChoLow[];
   datetime arrChoHighTime[];
   datetime arrChoLowTime[];
   double arrBoHigh[];
   double arrBoLow[];
   datetime arrBoHighTime[];
   datetime arrBoLowTime[];

   // Major Swing
   int LastSwingMajor;
   datetime lastTimeH;
   datetime lastTimeL;
   double L;
   double H;
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
   PoiZone zArrDecisionalHigh[];
   PoiZone zArrDecisionalLow[];
   
   double arrIdmHigh[];
   double arrIdmLow[];
   datetime arrIdmHBar[];
   datetime arrIdmLBar[];
   double arrLastH[];
   datetime arrLastHBar[];
   double arrLastL[];
   datetime arrLastLBar[];

   // Constructor
   TimeFrameData()
   {
      isTimeframe = 0;
      tfColor = clrGray;
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
      ArrayInitialize(intSHighs, 0.0);
      ArrayInitialize(intSLows, 0.0);
      ArrayInitialize(intSHighTime, 0);
      ArrayInitialize(intSLowTime, 0);
      ArrayInitialize(arrTop, 0.0);
      ArrayInitialize(arrBot, 0.0);
      ArrayInitialize(arrTopTime, 0);
      ArrayInitialize(arrBotTime, 0);
      ArrayInitialize(arrPbHTime, 0);
      ArrayInitialize(arrPbHigh, 0.0);
      ArrayInitialize(arrPbLTime, 0);
      ArrayInitialize(arrPbLow, 0.0);
      ArrayInitialize(arrChoHigh, 0.0);
      ArrayInitialize(arrChoLow, 0.0);
      ArrayInitialize(arrChoHighTime, 0);
      ArrayInitialize(arrChoLowTime, 0);
      ArrayInitialize(arrBoHigh, 0.0);
      ArrayInitialize(arrBoLow, 0.0);
      ArrayInitialize(arrBoHighTime, 0);
      ArrayInitialize(arrBoLowTime, 0);
      ArrayInitialize(arrDecisionalHigh, 0.0);
      ArrayInitialize(arrDecisionalLow, 0.0);
      ArrayInitialize(arrDecisionalHighTime, 0);
      ArrayInitialize(arrDecisionalLowTime, 0);
      
      ZeroMemory(L_bar);
      ZeroMemory(H_bar);
   }
   
   // Helper Methods for Array Management
   
   // Phương thức thêm phần tử vào mảng double
   int AddToDoubleArray(double &array[], double value, int limit = 10)
   {
      // Store value in array[]
      // shift existing elements in array[] to make space for the new value
      ArrayResize(array, MathMin(ArraySize(array) + 1, limit));
      for(int i = ArraySize(array) - 1; i > 0; --i) {
         array[i] = array[i-1];   
      }
      // Store newvalue in arPrice[0], the first position
      array[0] = value;
      
      return ArraySize(array);
   }
   
   // Phương thức thêm phần tử vào mảng datetime
   int AddToDateTimeArray(datetime &array[], datetime value, int limit = 10)
   {
      // Store value in array[]
      // shift existing elements in array[] to make space for the new value
      ArrayResize(array, MathMin(ArraySize(array) + 1, limit));
      for(int i = ArraySize(array) - 1; i > 0; --i) {
         array[i] = array[i-1];   
      }
      // Store newvalue in arPrice[0], the first position
      array[0] = value;
      
      return ArraySize(array);
   }
   
   // Phương thức thêm phần tử vào mảng PoiZone
   int AddToPoiZoneArray(PoiZone &array[], PoiZone &value, int limit = 10)
   {
      // Store value in array[]
      // shift existing elements in array[] to make space for the new value
      ArrayResize(array, MathMin(ArraySize(array) + 1, limit));
      for(int i = ArraySize(array) - 1; i > 0; --i) {
         array[i] = array[i-1];   
      }
      // Store newvalue in arPrice[0], the first position
      array[0] = value;
      
      return ArraySize(array);
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
   void test2(ENUM_TIMEFRAMES timeframe) {
      // Lấy dữ liệu cho khung timeframe
      TimeFrameData* tfData = GlobalVars.GetData(timeframe);
      definedFunction(timeframe);
      gannWave(tfData);
   }
   
   // Ham goi boi OnTick
   void test1(ENUM_TIMEFRAMES timeframe) {
      Print("New "+EnumToString(timeframe)+" bar formed: ", TimeToString(TimeCurrent()));
      // Lấy dữ liệu cho khung timeframe
      TimeFrameData* tfData = GlobalVars.GetData(timeframe);
      //Print("Data tfData: highest = ", tfData.highEst);
   }
   
   private:
   
   // Dinh nghia xac nhan tham so mac dinh timeframe
   void setDefautTimeframe(TimeFrameData &tfData, ENUM_TIMEFRAMES timeframe){
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
   
   void definedFunction(ENUM_TIMEFRAMES timeframe) {
      
      // Lấy dữ liệu cho khung timeframe
      TimeFrameData* tfData = GlobalVars.GetData(timeframe);
      setDefautTimeframe(tfData, timeframe);
      
      // Copy toan bo Lookback = 100 Bar tu Bar hien tai vao mang waveRates
      int copied = CopyRates(_Symbol, timeframe, 0, lookback, waveRates);
      ArrayPrint(waveRates);
      //int firstBar = ArraySize(waveRates) - 1;
      int firstBar = 0;
      MqlRates Bar1 = waveRates[firstBar];
      double firstBarHigh     = waveRates[firstBar].high;
      double firstBarLow      = waveRates[firstBar].low;
      datetime firstBarTime   = waveRates[firstBar].time;
      
      Print("High: "+ (string) firstBarHigh, " - Low: "+ (string) firstBarLow + " - Time: "+ (string) firstBarTime);
      
      tfData.highEst = firstBarHigh;
      tfData.lowEst = firstBarLow;
      tfData.hightime = firstBarTime;
      tfData.lowtime = firstBarTime;
      
      // Gann structure
      tfData.AddToDoubleArray(tfData.Highs, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.HighsTime, firstBarTime);
      tfData.AddToDoubleArray(tfData.Lows, firstBarLow);
      tfData.AddToDateTimeArray(tfData.LowsTime, firstBarTime);
      
      // internal structure
      tfData.AddToDoubleArray(tfData.intSHighs, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.intSHighTime, firstBarTime);
      tfData.AddToDoubleArray(tfData.intSLows, firstBarLow);
      tfData.AddToDateTimeArray(tfData.intSLowTime, firstBarTime);
      
      // pullback structure
      tfData.AddToDoubleArray(tfData.arrTop, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.arrTopTime, firstBarTime);
      tfData.AddToDoubleArray(tfData.arrBot, firstBarLow);
      tfData.AddToDateTimeArray(tfData.arrBotTime, firstBarTime);
      
      // array pullback
      tfData.AddToDoubleArray(tfData.arrPbHigh, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.arrPbHTime, firstBarTime);
      tfData.AddToDoubleArray(tfData.arrPbLow, firstBarLow);
      tfData.AddToDateTimeArray(tfData.arrPbLTime, firstBarTime);
      
      tfData.AddToDoubleArray(tfData.arrChoHigh, 0);
      tfData.AddToDateTimeArray(tfData.arrChoHighTime, firstBarTime);
      tfData.AddToDoubleArray(tfData.arrChoLow, 0);
      tfData.AddToDateTimeArray(tfData.arrChoLowTime, firstBarTime);
      
      tfData.AddToDoubleArray(tfData.arrBoHigh, 0);
      tfData.AddToDateTimeArray(tfData.arrBoHighTime, firstBarTime);
      tfData.AddToDoubleArray(tfData.arrBoLow, 0);
      tfData.AddToDateTimeArray(tfData.arrBoLowTime, firstBarTime);
      
      tfData.AddToDoubleArray(tfData.arrDecisionalHigh, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.arrDecisionalHighTime, firstBarTime);
      tfData.AddToDoubleArray(tfData.arrDecisionalLow, firstBarLow);
      tfData.AddToDateTimeArray(tfData.arrDecisionalLowTime, firstBarTime);
      
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
   void drawPointStructure(TimeFrameData &tfData, int itype, double priceNew, datetime timeNew, int typeStructure, bool del, bool isDraw) { // type: 1 High, -1 Low
      int iWingding;
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
   
   void gannWave(TimeFrameData &tfData){
      MqlRates bar1, bar2, bar3; 
      // danh dau vi tri bat dau
      createObj(waveRates[0].time, waveRates[0].low, 238, -1, tfData.tfColor, "Start");
      
      //for (int j = ArraySize(waveRates) - 3; j >=0; j--){
      for (int j = 0; j <= ArraySize(waveRates) - 3; j++){
         Print("No:" + (string) j);
         
         //Print("First: "+getValueTrend());
         bar1 = waveRates[j];
         bar2 = waveRates[j+1];
         bar3 = waveRates[j+2];
         Print(inInfoBar(bar1, bar2, bar3));
         
         // Neu tim thay Swing High or Swing low
         if ((bar3.high < bar2.high && bar2.high > bar1.high) || (bar3.low > bar2.low && bar2.low < bar1.low)) {
            int resultStructure = drawStructureInternal(tfData, bar1, bar2, bar3, enabledComment);
            updatePointTopBot(tfData, bar1, bar2, bar3, enabledComment);
         } 
         
         
         //// POI
         //getZoneValid();
         //drawZone(bar1);
         
         //Print("\n Final: "+getValueTrend());
         Print(" ------------------------------------------------------ End ---------------------------------------------------------\n");
      }
      // danh dau vi tri ket thuc
      createObj(waveRates[ArraySize(waveRates) - 1].time, waveRates[ArraySize(waveRates) - 1].low, 238, -1, tfData.tfColor, "Stop");
   }
   
   //---
   //--- Ham cap nhat ve cau truc song gann, internal struct, major struct
   //---
   int drawStructureInternal(TimeFrameData &tfData, MqlRates& bar1, MqlRates& bar2, MqlRates& bar3, bool isComment = false) {
      int resultStructure = 0;
      string textGannHigh = "";
      string textGannLow = "";
      
      string textInternalHigh = "";
      string textInternalLow = "";
      
      string textTop = "";
      string textBot = "";
   
   //    swing high
      if (bar3.high < bar2.high && bar2.high > bar1.high) { // tim thay dinh high
         textGannHigh += "\n" + "---> Find High: "+(string) bar2.high+" + Highest: "+ (string) tfData.highEst;
         // set Zone
         PoiZone zone2 = CreatePoiZone(bar2.high, bar2.low, bar2.open, bar2.close, bar2.time);
         // gann finding high
         if (tfData.LastSwingMeter == 1 || tfData.LastSwingMeter == 0) {
            // Add high moi (updatePointStructure), khong xoa Highs 0
            tfData.AddToDoubleArray(tfData.Highs, bar2.high, limit);
            tfData.AddToDateTimeArray(tfData.HighsTime, bar2.time, limit);
            drawPointStructure(tfData, 1, bar2.high, bar2.time, GANN_STRUCTURE, false, enabledDraw);
            tfData.LastSwingMeter = -1;
            // cap nhat Zone. Khong xoa (updatePointZone)
            tfData.AddToPoiZoneArray(tfData.zHighs, zone2, poi_limit);
         }
         // gann finding low
         if (tfData.LastSwingMeter == -1) {
            //    xoa high cu. viet high moi
            if (bar2.high > tfData.highEst) {
               // xoa high cu
               if (ArraySize(tfData.Highs) > 1) deleteObj(tfData.HighsTime[0], tfData.Highs[0], iWingding_gann_high, "");
               //       cap nhat high moi
               tfData.UpdateDoubleArray(tfData.Highs, 0,bar2.high);
               tfData.UpdateDateTimeArray(tfData.HighsTime, 0,bar2.time);
               //updatePointStructure(bar2.high, bar2.time, Highs, HighsTime, true);
               drawPointStructure(tfData, 1, bar2.high, bar2.time, GANN_STRUCTURE, true, enabledDraw);
               tfData.LastSwingMeter = -1;
               // cap nhat Zone. Xoa 0 (updatePointZone)
               tfData.UpdatePoiZoneArray(tfData.zHighs, 0, zone2);
            }
         }
         if (isComment) {
            Print(textGannHigh);
            ArrayPrint(tfData.Highs);
         }
         
         // Internal Structure
         textInternalHigh += "\n"+"---> Find Internal High: "+(string)  bar2.high +" ### So Sanh iTrend: " +(string) tfData.iTrend+", LastSwingInternal: "+(string) tfData.LastSwingInternal+ " , intSHighs[0]: "+ (string) tfData.intSHighs[0];
         textInternalHigh += "\n"+"lastTimeH: "+(string) tfData.lastTimeH+" lastH: "+ (string) tfData.lastH +" <----> "+" intSHighTime[0] "+(string) tfData.intSHighTime[0]+" intSHighs[0] "+ (string) tfData.intSHighs[0];
         // finding High
         
         // DONE 1
         // HH
         if ( (tfData.iTrend == 0 || (tfData.iTrend == 1 && tfData.LastSwingInternal == 1)) && bar2.high > tfData.intSHighs[0]){ // BOS
            // Add new intSHigh.
            tfData.AddToDoubleArray(tfData.intSHighs, bar2.high);
            tfData.AddToDateTimeArray(tfData.intSHighTime, bar2.time);
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            
            tfData.iTrend = 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 1;
            textInternalHigh += "\n"+"## High 1 BOS --> Update: "+ "iTrend: "+(string) tfData.iTrend + ", LastSwingInternal: "+ (string) tfData.LastSwingInternal+", Update intSHighs[0]: "+(string) bar2.high;
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone2, poi_limit);
         }
         
         // HH 2
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.high > tfData.intSHighs[0] && bar2.high > tfData.intSHighs[1]){
            // Delete Label
            if (ArraySize(tfData.intSHighs) > 1) deleteObj(tfData.intSHighTime[0], tfData.intSHighs[0], iWingding_internal_high, "");
            // Update new intSHigh.
            tfData.UpdateDoubleArray(tfData.intSHighs, 0, bar2.high);
            tfData.UpdateDateTimeArray(tfData.intSHighTime, 0, bar2.time);
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
            
            tfData.iTrend = 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 2;
            textInternalHigh += "\n"+"## High 2 --> Update: "+ "iTrend: "+(string) tfData.iTrend + ", LastSwingInternal: "+ (string) tfData.LastSwingInternal+", Update intSHighs[0]: "+(string) bar2.high + ", Xoa intSHighs[0] old: "+(string) tfData.intSHighs[0];
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSHighs, 0, zone2);
            
         }
         
         // DONE 3
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.high > tfData.intSHighs[0]) {  // CHoCH
            // add new intSHigh
            tfData.AddToDoubleArray(tfData.intSHighs, bar2.high);
            tfData.AddToDateTimeArray(tfData.intSHighTime, bar2.time);
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            
            tfData.iTrend = 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 3;
            textInternalHigh += "\n"+"## High 3 CHoCH --> Update: "+ "iTrend: "+(string) tfData.iTrend + ", LastSwingInternal: "+(string)  tfData.LastSwingInternal+", Update intSHighs[0]: "+(string) bar2.high;
            
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone2, poi_limit);
         }
         
         // DONE 4 
         // LH
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.high < tfData.intSHighs[0]) { 
            // Add new intSHigh
            tfData.AddToDoubleArray(tfData.intSHighs, bar2.high);
            tfData.AddToDateTimeArray(tfData.intSHighTime, bar2.time);
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            tfData.iTrend = -1;
            tfData.LastSwingInternal = -1;
            resultStructure = 4;
            textInternalHigh += "\n"+ "## High 4 --> Update: "+ "iTrend: "+(string) tfData.iTrend + ", LastSwingInternal: "+(string)  tfData.LastSwingInternal+", Update intSHighs[0]: "+(string) bar2.high;
            
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone2, poi_limit);
         }
         
         // DONE 5
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == -1 && bar2.high > tfData.intSHighs[0] ) {    // CHoCH
            // Delete prev label
            if (ArraySize(tfData.intSHighs) > 1) deleteObj(tfData.intSHighTime[0], tfData.intSHighs[0], iWingding_internal_high, "");
            // Update new intSHigh.
            tfData.UpdateDoubleArray(tfData.intSHighs, 0, bar2.high);
            tfData.UpdateDateTimeArray(tfData.intSHighTime, 0, bar2.time);
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
                     
            tfData.iTrend = (bar2.high <= tfData.intSHighs[1])? -1 : 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 5;
            textInternalHigh += "\n"+"## High 5 CHoCH --> Update: "+ "iTrend: "+(string) tfData.iTrend + ", LastSwingInternal: "+ (string) tfData.LastSwingInternal+", Update intSHighs[0]: "+(string) bar2.high+", Xoa intSHighs[0] old: "+(string) tfData.intSHighs[0];
            
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSHighs, 0, zone2);
         }
         if( isComment) {
            Print(textInternalHigh);
            ArrayPrint(tfData.intSHighs);
         }
         
      }
   //   
   //   // swing low
      if (bar3.low > bar2.low && bar2.low < bar1.low) { // tim thay dinh low
         textGannLow += "\n"+"---> Find Low: +" +(string) bar2.low+ " + Lowest: "+(string) tfData.lowEst;
         PoiZone zone2 = CreatePoiZone(bar2.high, bar2.low, bar2.open, bar2.close, bar2.time);
         // gann finding low
         if (tfData.LastSwingMeter == -1 || tfData.LastSwingMeter == 0) {
            // cap nhat low moi, khong xoa Lows 0
            tfData.AddToDoubleArray(tfData.Lows, bar2.low);
            tfData.AddToDateTimeArray(tfData.LowsTime, bar2.time);
            drawPointStructure(tfData, -1, bar2.low, bar2.time, GANN_STRUCTURE, false, enabledDraw);
            tfData.LastSwingMeter = 1;
            // Them Zone.
            tfData.AddToPoiZoneArray(tfData.zLows, zone2, poi_limit);
         }
         // gann finding high
         if (tfData.LastSwingMeter == 1) {
            // xoa low cu. viet high moi
            if (bar2.low < tfData.lowEst) {
               // xoa low cu
               if (ArraySize(tfData.Lows) > 1) deleteObj(tfData.LowsTime[0], tfData.Lows[0], iWingding_gann_low, "");
               // cap nhat low moi. Xoa 0
               tfData.UpdateDoubleArray(tfData.Lows, 0, bar2.low);
               tfData.UpdateDateTimeArray(tfData.LowsTime, 0, bar2.time);
               drawPointStructure(tfData, -1, bar2.low, bar2.time, GANN_STRUCTURE, true, enabledDraw);
               tfData.LastSwingMeter = 1;
               // cap nhat Zone
               tfData.UpdatePoiZoneArray(tfData.zLows, 0, zone2);
            }
         }
         if (isComment) {
            Print(textGannLow);
            ArrayPrint(tfData.Lows);
         }
         
         // Internal Structure 
         textInternalLow += "\n"+"---> Find Internal Low: "+ (string) bar2.low +" ### So Sanh iTrend: " +(string) tfData.iTrend+", LastSwingInternal: "+(string) tfData.LastSwingInternal+ " , intSLows[0]: "+ (string) tfData.intSLows[0];
         textInternalLow += "\n"+"lastTimeL: "+(string) tfData.lastTimeL+" lastL: "+(string)  tfData.lastL +" <----> "+" intSLowTime[0] "+(string) tfData.intSLowTime[0]+" intSLows[0] "+ (string) tfData.intSLows[0];
         // finding Low
         // DONE 1
         // LL
         if ((tfData.iTrend == 0 || tfData.iTrend == -1) && tfData.LastSwingInternal == -1 && bar2.low < tfData.intSLows[0]){ // BOS
            // Add new intSLows
            tfData.AddToDoubleArray(tfData.intSLows, bar2.low);
            tfData.AddToDateTimeArray(tfData.intSLowTime, bar2.time);
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
                     
            tfData.iTrend = -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -1;
            textInternalLow += "\n"+("## Low 1 BOS --> Update: "+ "iTrend: "+(string) tfData.iTrend + ", LastSwingInternal: "+ (string) tfData.LastSwingInternal+", Update intSLows[0]: "+(string) bar2.low);
            // Them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSLows, zone2, poi_limit);
         }
         
         // LL
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.low < tfData.intSLows[0] && bar2.low < tfData.intSLows[1]){
            // Delete Label
            if (ArraySize(tfData.intSLows) > 1) deleteObj(tfData.intSLowTime[0], tfData.intSLows[0], iWingding_internal_low, "");
            // Update new intSLows
            tfData.UpdateDoubleArray(tfData.intSLows, 0, bar2.low);
            tfData.UpdateDateTimeArray(tfData.intSLowTime, 0, bar2.time);
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
                     
            tfData.iTrend = -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -2;
            textInternalLow += "\n"+("## Low 2 --> Update: "+ "iTrend: "+(string) tfData.iTrend + ", LastSwingInternal: "+ (string) tfData.LastSwingInternal+", Update intSLows[0]: "+(string) bar2.low +", Xoa intSLows[0] old: "+(string) tfData.intSLows[0]);
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSLows, 0, zone2);
         }
         
         // DONE 3
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.low < tfData.intSLows[0]) { // CHoCH
            // Add new intSLows
            tfData.AddToDoubleArray(tfData.intSLows, bar2.low);
            tfData.AddToDateTimeArray(tfData.intSLowTime, bar2.time);
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            
            tfData.iTrend = -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -3;
            textInternalLow += "\n"+("## Low 3 CHoCH --> Update: "+ "iTrend: "+(string) tfData.iTrend + ", LastSwingInternal: "+ (string) tfData.LastSwingInternal+", Update intSLows[0]: "+(string) bar2.low);
            // Them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSLows, zone2, poi_limit);
         }
         
         // DONE 4
         // Trend Tang. HL
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.low > tfData.intSLows[0]) {
            // Add new intSLows
            tfData.AddToDoubleArray(tfData.intSLows, bar2.low);
            tfData.AddToDateTimeArray(tfData.intSLowTime, bar2.time);
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            tfData.iTrend = 1;
            tfData.LastSwingInternal = 1;
            resultStructure = -4;
            textInternalLow += "\n"+("## Low 4 --> Update: "+ "iTrend: "+(string) tfData.iTrend + ", LastSwingInternal: "+ (string) tfData.LastSwingInternal+", Update intSLows[0]: "+(string) bar2.low);
            // Them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSLows, zone2, poi_limit);
         }
         
         // DONE 5
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == 1 && bar2.low < tfData.intSLows[0] ) {  // CHoCH
            // Delete Label
            if (ArraySize(tfData.intSLows) > 1) deleteObj(tfData.intSLowTime[0], tfData.intSLows[0], iWingding_internal_low, "");
            // Update new intSLows
            tfData.UpdateDoubleArray(tfData.intSLows, 0, bar2.low);
            tfData.UpdateDateTimeArray(tfData.intSLowTime, 0, bar2.time);
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
                     
            tfData.iTrend = (bar2.low >= tfData.intSLows[1]) ? 1 : -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -5;
            textInternalLow += "\n"+("## Low 5 CHoCH --> Update: "+ "iTrend: "+(string) tfData.iTrend + ", LastSwingInternal: "+ (string) tfData.LastSwingInternal+", Update intSLows[0]: "+(string) bar2.low+", Xoa intSLows[0] old: "+(string) tfData.intSLows[0]);
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSLows, 0, zone2);
         }
         if(isComment) {
            Print(textInternalLow);
            ArrayPrint(tfData.intSLows);
         }
      }
      return resultStructure;
   } //--- End Ham cap nhat cau truc song Gann
   
   //---
   //--- Ham cap nhat cau truc thi truong
   //---
   void updatePointTopBot(TimeFrameData &tfData, MqlRates& bar1, MqlRates& bar2, MqlRates& bar3, bool isComment = false){
      string text;
      text += "First: STrend: "+ (string) tfData.sTrend + " - mTrend: "+(string) tfData.mTrend+" - LastSwingMajor: "+(string) tfData.LastSwingMajor+ " findHigh: "+(string) tfData.findHigh+" - idmHigh: "+(string) tfData.idmHigh+" findLow: "+(string) tfData.findLow+" - idmLow: "+(string) tfData.idmLow+" H: "+ (string) tfData.H +" - L: "+(string) tfData.L;
      text += "\n"+inInfoBar(bar1, bar2, bar3);
      PoiZone zone2 = CreatePoiZone(bar2.high, bar2.low, bar2.open, bar2.close, bar2.time);
      
      double barHigh = bar1.high;
      double barLow  = bar1.low;
      datetime barTime = bar1.time;
      
      // Lan dau tien
      if(tfData.sTrend == 0 && tfData.mTrend == 0 && tfData.LastSwingMajor == 0) {
         if (barLow < tfData.arrBot[0]){
            text += "\n 0.-1. barLow < arrBot[0]"+" => "+(string) barLow+" < "+(string) tfData.arrBot[0];
            text += " => Cap nhat idmLow = Highs[0] = "+(string) tfData.Highs[0]+"; sTrend = -1; mTrend = -1; LastSwingMajor = 1;";
            
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.idmLow = tfData.Highs[0];
            tfData.idmLowTime = tfData.HighsTime[0];
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
      
      if (bar3.high < bar2.high && bar2.high > bar1.high) { // tim thay dinh high
         text += "\n 0.2. Find Swing High";
         if (tfData.findHigh == 1 && bar2.high > tfData.H) {
            text += " => findhigh == 1 , H new > H old "+(string) bar2.high+" > "+(string) tfData.H+". Update new High = "+(string) bar2.high;
            
            tfData.H = bar2.high;
            tfData.HTime = bar2.time;
            tfData.H_bar = bar2;
         }
      }
      if (bar3.low > bar2.low && bar2.low < bar1.low) { // tim thay swing low 
         text += "\n 0.-2. Find Swing Low";
         if (tfData.findLow == 1 && bar2.low < tfData.L) {
            text += " => findlow == 1 , L new < L old "+(string) bar2.low+" < "+(string) tfData.L+". Update new Low = "+(string) bar2.low;
            
            tfData.L = bar2.low;
            tfData.LTime = bar2.time;
            tfData.L_bar = bar2;
         }
      }
      
      if(tfData.sTrend == 1 && tfData.mTrend == 1) {
         // continue BOS 
         if (tfData.LastSwingMajor == -1 && bar1.high > tfData.arrTop[0] && tfData.arrTop[0] != tfData.arrBoHigh[0]) {
            text += "\n 1.1. continue BOS, sTrend == 1 && mTrend == 1 && LastSwingMajor == -1 && bar1.high > arrTop[0] : "
            +(string)  bar1.high +" > "+(string) tfData.arrTop[0];
            text += "\n => Cap nhat: findLow = 0, idmHigh = Lows[0] = "+(string) tfData.Lows[0]+" ; sTrend == 1; mTrend == 1; LastSwingMajor == 1;";
            
            // Add new point swing
            tfData.AddToDoubleArray(tfData.arrBoHigh, tfData.arrTop[0]);
            tfData.AddToDateTimeArray(tfData.arrBoHighTime, tfData.arrTopTime[0]);
            tfData.AddToDoubleArray(tfData.arrBot, tfData.intSLows[0]);
            tfData.AddToDateTimeArray(tfData.arrBotTime, tfData.intSLowTime[0]);
            
            // add zone POI Bullish
            tfData.AddToPoiZoneArray(tfData.zArrBot, tfData.zIntSLows[0], poi_limit);
            //updateZoneToZone(tfData.zIntSLows[0], tfData.zArrBot, false, poi_limit);
            // Add Zone
            tfData.AddToPoiZoneArray(tfData.zPoiLow, tfData.zIntSLows[0], poi_limit);
            //updateZoneToZone(tfData.zIntSLows[0], tfData.zPoiLow, false, poi_limit);
            
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = 1;
            tfData.findLow = 0; tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0];
         }
         
         if (bar3.high < bar2.high && bar2.high > bar1.high) { // tim thay dinh high 
            // continue BOS swing high
            if (tfData.LastSwingMajor == 1 && bar2.high > tfData.arrTop[0]) {
               text += "\n 1.2. swing high, sTrend == 1 && mTrend == 1 && LastSwingMajor == 1 && barHigh > arrTop[0]";
               text += "=> Cap nhat: arrTop[0] = bar2.high = "+(string) bar2.high+" ; sTrend == 1; mTrend == 1; LastSwingMajor == -1;";
               // Update Array Top[0]
               if(tfData.arrTop[0] != bar2.high) {
                  // Add new 
                  tfData.AddToDoubleArray( tfData.arrTop, bar2.high);
                  tfData.AddToDateTimeArray( tfData.arrTopTime, bar2.time);
                  
                  // add new Zone
                  tfData.AddToPoiZoneArray( tfData.zArrTop, zone2, poi_limit);
                  //updatePointZone(bar2, tfData.zArrTop, false, poi_limit);
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
                  //updatePointStructure(bar2.high, bar2.time, tfData.arrTop, tfData.arrTopTime, true);
                  // cap nhat Zone
                  tfData.UpdatePoiZoneArray( tfData.zArrTop, 0, zone2);
                  //updatePointZone(bar2, tfData.zArrTop, false, poi_limit);
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
               // add new zone
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, tfData.zArrTop[0], poi_limit); 
               
               
               //updatePointStructure(tfData.arrTop[0], tfData.arrTopTime[0], tfData.arrPbHigh, tfData.arrPbHTime, false);
               // cap nhat Zone
               //updateZoneToZone(zArrTop[0], tfData.zArrPbHigh, false);
            }
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(IDM_TEXT, tfData.idmHighTime, tfData.idmHigh, bar1.time, tfData.idmHigh, 1, IDM_TEXT, clrAliceBlue, STYLE_DOT);
            text += "\n => Cap nhat findLow = 1; L = bar1.low = "+ (string) bar1.low;
            
            // active find Low
            tfData.findLow = 1; 
            tfData.L = bar1.low; tfData.LTime = bar1.time;
            tfData.L_bar = bar1;
            tfData.findHigh = 0; tfData.H = 0;
         }
         
         // CHoCH Low
         if (
            //tfData.LastSwingMajor == 1 && 
            bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n 1.5 sTrend == 1 && mTrend == 1 && LastSwingMajor == random && bar1.low < arrPbLow[0] :" +(string)  bar1.low + "<" + (string) tfData.arrPbLow[0];
            text += "\n => Cap nhat => Ve line. sTrend = -1; mTrend = -1; LastSwingMajor = -1; findHigh = 0; idmLow = Highs[0]= "+ (string) tfData.Highs[0];
            // draw choch Low
            drawLine(CHOCH_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], barTime, tfData.arrPbLow[0], 1, CHOCH_TEXT, clrRed, STYLE_SOLID);

            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);            
         
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
            text += "\n 1.6 Continue Bos UP. sTrend == 1 && mTrend == 1 && LastSwingMajor == random && bar1.high > arrPbHigh && arrPbHigh: "+ (string) tfData.arrPbHigh[0] + " != arrChoHigh[0]: "+(string) tfData.arrChoHigh[0];
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoHigh, tfData.arrPbHigh[0]);
            tfData.AddToDateTimeArray( tfData.arrChoHighTime, tfData.arrPbHTime[0]);
            
            // update Point HL
            if (tfData.L != 0 && tfData.L != tfData.arrPbLow[0]) {
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbLow, tfData.L);
               tfData.AddToDateTimeArray( tfData.arrPbLTime, tfData.LTime);
               // Add new zone
               MqlRates bar_tmp = tfData.L_bar;
               PoiZone zone_tmp = CreatePoiZone(bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, zone_tmp, poi_limit);
            }
            text += "\n => cap nhat : POI Bullish L : "+(string) tfData.L;
            
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(BOS_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, BOS_TEXT, clrAliceBlue, STYLE_SOLID);
            
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.findLow = 0; tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0];
            tfData.L = 0; 
         }
      }
   
      if(tfData.sTrend == 1 && tfData.mTrend == -1) {
         // continue Up, Continue Choch up
         if (tfData.LastSwingMajor == -1 && bar1.high > tfData.arrPbHigh[0] && tfData.arrPbHigh[0] != tfData.arrChoHigh[0]) {
            text += "2.1 CHoCH up. sTrend == 1 && mTrend == -1 && LastSwingMajor == -1 && bar1.high > arrPbHigh[0]";
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoHigh, tfData.arrPbHigh[0]);
            tfData.AddToDateTimeArray( tfData.arrChoHighTime, tfData.arrPbHTime[0]);
            
            if (tfData.L != 0 && tfData.L != tfData.arrPbLow[0]) {
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbLow, tfData.L);
               tfData.AddToDateTimeArray( tfData.arrPbLTime, tfData.LTime);
               // Add new zone
               MqlRates bar_tmp = tfData.L_bar;
               PoiZone zone_tmp = CreatePoiZone(bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, zone_tmp, poi_limit);
               
            }
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(CHOCH_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, CHOCH_TEXT, clrAliceBlue, STYLE_SOLID);
            text += "\n => Cap nhat => POI Bullish : L = "+ (string) tfData.L;
            
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.findLow = 0; tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0];
            tfData.L = 0; 
         }
         // CHoCH DOwn. 
         if (tfData.LastSwingMajor == -1 && bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n 2.2 sTrend == 1 && mTrend == -1 && LastSwingMajor == -1 && bar1.low < arrPbLow[0] : " + (string) bar1.low + "<" + (string) tfData.arrPbLow[0];
            text += "\n => Cap nhat => POI Low. sTrend = -1; mTrend = -1; LastSwingMajor = -1; findHigh = 0; idmLow = Highs[0] = "+(string) tfData.Highs[0];
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            // draw choch low
            drawLine(CHOCH_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], bar1.time, tfData.arrPbLow[0], 1, CHOCH_TEXT, clrRed, STYLE_SOLID);
                     
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = -1;
            tfData.findHigh = 0; tfData.idmLow = tfData.Highs[0]; tfData.idmLowTime = tfData.HighsTime[0];
         }
      }
      
      if(tfData.sTrend == -1 && tfData.mTrend == -1) {
         // continue BOS 
         if (tfData.LastSwingMajor == 1 && bar1.low < tfData.arrBot[0] && tfData.arrBot[0] != tfData.arrBoLow[0]) {
            text += "\n -3.1. continue BOS, sTrend == -1 && mTrend == -1 && LastSwingMajor == 1 && bar1.low < arrBot[0] : "+ (string) bar1.low +" > "+(string) tfData.arrBot[0];
            text += "\n => Cap nhat: findHigh = 0, idmLow = Highs[0] = "+(string) tfData.Highs[0]+" ; sTrend == -1; mTrend == -1; LastSwingMajor == -1;";
                           
            // Add new point
            tfData.AddToDoubleArray( tfData.arrBoLow, tfData.arrBot[0]);
            tfData.AddToDateTimeArray( tfData.arrBoLowTime, tfData.arrBotTime[0]);
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrTop, tfData.intSHighs[0]);
            tfData.AddToDateTimeArray( tfData.arrTopTime, tfData.intSHighTime[0]);
            
            // Add new zone POI Bearish
            tfData.AddToPoiZoneArray( tfData.zArrTop, tfData.zIntSHighs[0], poi_limit); 
            // Add new zone
            tfData.AddToPoiZoneArray( tfData.zPoiHigh, tfData.zIntSHighs[0], poi_limit); 
                     
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = -1;
            tfData.findHigh = 0; tfData.idmLow = tfData.Highs[0]; tfData.idmLowTime = tfData.HighsTime[0];
         }
         
         if (bar3.low > bar2.low && bar2.low < bar1.low) { // tim thay swing low 
            // continue BOS swing low
            if (tfData.LastSwingMajor == -1 && bar2.low < tfData.arrBot[0]) {
               text += "\n -3.2. swing low, sTrend == -1 && mTrend == -1 && LastSwingMajor == -1 && bar2.low < arrBot[0]";
               text += "=> Cap nhat: arrBot[0] = bar2.low = "+(string) bar2.low+" ; sTrend == -1; mTrend == -1; LastSwingMajor == 1;";
               
               // Update ArrayBot[0]
               if(tfData.arrBot[0] != bar2.low) {                                 
                  // Add new point
                  tfData.AddToDoubleArray( tfData.arrBot, bar2.low);
                  tfData.AddToDateTimeArray( tfData.arrBotTime, bar2.time);
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
               // Add new zone
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, tfData.zArrBot[0], poi_limit);
            } 
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(IDM_TEXT, tfData.idmLowTime, tfData.idmLow, bar1.time, tfData.idmLow, -1, IDM_TEXT, clrRed, STYLE_DOT);
            text += "\n => Cap nhat findHigh = 1; H = bar1.high = "+ (string) bar1.high;
            
            // active find High
            tfData.findHigh = 1; 
            tfData.H = bar1.high; tfData.HTime = bar1.time;
            tfData.H_bar = bar1;
            tfData.findLow = 0; tfData.L = 0;
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
            
            // draw choch high
            drawLine(CHOCH_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, CHOCH_TEXT, clrAliceBlue, STYLE_SOLID);
            
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
            text += "\n -3.6 sTrend == -1 && mTrend == -1 & LastSwingMajor == random && bar1.low < arrPbLow[0]";
                        
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            
            // update Point LH         
            if (tfData.H != 0 && tfData.H != tfData.arrPbHigh[0]) {
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbHigh, tfData.H);
               tfData.AddToDateTimeArray( tfData.arrPbHTime, tfData.HTime);
               // Add new zone
               MqlRates bar_tmp = tfData.H_bar;
               PoiZone zone_tmp = CreatePoiZone(bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, zone_tmp, poi_limit);
            }
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(BOS_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], bar1.time, tfData.arrPbLow[0], 1, BOS_TEXT, clrRed, STYLE_SOLID);
            text += "\n => Cap nhat => POI Bearish H:" + (string) tfData.H;
            
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.findHigh = 0; tfData.idmLow = tfData.Highs[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.H = 0;
         }
         
      }
      if (tfData.sTrend == -1 && tfData.mTrend == 1) {
         // continue Down, COntinue Choch down
         if (tfData.LastSwingMajor == 1 && bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n -4.1 sTrend == -1 && mTrend == 1 && LastSwingMajor == 1 && bar1.low < arPbLow[0]";
                          
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            
            if (tfData.H != 0 && tfData.H != tfData.arrPbHigh[0]) {
               
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbHigh, tfData.H);
               tfData.AddToDateTimeArray( tfData.arrPbHTime, tfData.HTime);
               // Add new zone
               MqlRates bar_tmp = tfData.H_bar;
               PoiZone zone_tmp = CreatePoiZone(bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, zone_tmp, poi_limit); 
            }
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(CHOCH_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], bar1.time, tfData.arrPbLow[0], 1, CHOCH_TEXT, clrRed, STYLE_SOLID);
            
            text += "\n => Cap nhat => POI bearish H: "+(string) tfData.H;
            
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.findHigh = 0; tfData.idmLow = tfData.Highs[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.H = 0;
         }
         // CHoCH Up. 
         if (tfData.LastSwingMajor == 1 && bar1.high > tfData.arrPbHigh[0] && tfData.arrPbHigh[0] != tfData.arrChoHigh[0]) {
               
            text += "\n -4.2 sTrend == -1 && mTrend == 1 && LastSwingMajor == 1 && bar1.high > arrPbHigh[0] : " + (string) bar1.high + ">" +(string) tfData.arrPbHigh[0];
            text += "\n => Cap nhat => sTrend = 1; mTrend = 1; LastSwingMajor = 1; findLow = 0; idmHigh = Lows[0] = "+(string) tfData.Lows[0];
            text += "\n => Cap nhat => POI Bullish = arrPbLow[0] : "+ (string) tfData.arrPbLow[0];
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoHigh, tfData.arrPbHigh[0]);
            tfData.AddToDateTimeArray( tfData.arrChoHighTime, tfData.arrPbHTime[0]);
            
            // draw choch low
            drawLine(CHOCH_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, CHOCH_TEXT, clrAliceBlue, STYLE_SOLID);
   
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = 1;
            tfData.findLow = 0; tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0];
         }
      }
      
      if(isComment) {
         text += "\n Last: STrend: "+ (string) tfData.sTrend + " - mTrend: "+(string) tfData.mTrend+" - LastSwingMajor: "+(string) tfData.LastSwingMajor+ " findHigh: "+(string) tfData.findHigh+" - idmHigh: "+(string) tfData.idmHigh+" findLow: "+(string) tfData.findLow+" - idmLow: "+(string) tfData.idmLow+" H: "+ (string) tfData.H +" - L: "+(string) tfData.L;
         Print(text);
         //showComment();
      }
   } //--- End Ham cap nhat cau truc thi truong
   
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
   prewHighTFStruct.test2(highTimeFrame);
   testData(highTimeFrame);
   
   prewLowTFStruct.test2(lowTimeFrame);
   testData(lowTimeFrame);
//---
   
   return(INIT_SUCCEEDED);
}

// OnTick function
void OnTick()
{
   //demoOntick();
   
   // Kiểm tra nến mới cho H1
    if(IsNewBar(highTimeFrame)) {
        highTFStruct.test1(highTimeFrame);
        // Thêm logic xử lý tại đây
        
    }
    
    // Kiểm tra nến mới cho M5
    if(IsNewBar(lowTimeFrame)) {
        lowTFStruct.test1(lowTimeFrame);
        // Thêm logic xử lý tại đây
        
    }
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
   string text = " Bar1 high: "+ (string) bar1.high +" - low: "+ (string) bar1.low + " - vol: "+ (string) bar1.tick_volume +
                  " --- "+" Bar2 high: "+ (string) bar2.high +" - low: "+ (string) bar2.low+ " - vol: "+ (string) bar2.tick_volume +
                  " --- "+" Bar3 high: "+ (string) bar3.high +" - low: "+ (string) bar3.low+" - vol: "+ (string) bar3.tick_volume;
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
void demoInit() {
//   // Lấy dữ liệu cho khung H1
//   TimeFrameData* h1Data = GlobalVars.GetData(PERIOD_H1);
//   
//   // Lấy giá hiện tại
//   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
//   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
//   
//   // Thêm giá trị vào mảng Highs
//   h1Data.AddToDoubleArray(h1Data.Highs, 1.2345);
//   h1Data.AddToDoubleArray(h1Data.Highs, 1.2456);
//   
//   // Thêm thời gian vào mảng HighsTime
//   h1Data.AddToDateTimeArray(h1Data.HighsTime, TimeCurrent());
//   h1Data.AddToDateTimeArray(h1Data.HighsTime, TimeCurrent() - 3600);
//   
//   // Thêm PoiZone vào mảng zHighs
//   PoiZone zone1 = CreatePoiZone(ask + 0.0020, ask - 0.0020, ask, bid, TimeCurrent());
//   h1Data.AddToPoiZoneArray(h1Data.zHighs, zone1);
//   
//   PoiZone zone2 = CreatePoiZone(ask + 0.0015, ask - 0.0015, ask, bid, TimeCurrent());
//   h1Data.AddToPoiZoneArray(h1Data.zHighs, zone2);
//   
//   // Sắp xếp mảng Highs
//   h1Data.SortDoubleArrayDesc(h1Data.Highs);
//   
//   // Thêm giá trị vào mảng Highs của M15
//   GlobalVars.AddToHighs(PERIOD_M15, 1.2300);
//   GlobalVars.AddToHighs(PERIOD_M15, 1.2350);
//   
//   // Thêm PoiZone vào mảng zHighs của M15
//   PoiZone zone3 = CreatePoiZone(ask + 0.0010, ask - 0.0010, ask, bid, TimeCurrent());
//   GlobalVars.AddToZHighs(PERIOD_M15, zone3);
//   
//   // Lấy giá trị cao nhất từ mảng Highs của H1
//   double maxHigh = GlobalVars.GetHighsMax(PERIOD_H1);
//   Print("Max High in H1: ", maxHigh);
//   
//   // Lấy PoiZone mới nhất từ mảng zHighs của H1
//   PoiZone latestZone;
//   if(GlobalVars.GetLatestZHighs(PERIOD_H1, latestZone))
//      PrintPoiZone(latestZone, "Latest: ");
}

void demoOntick() {
//   // Lấy giá hiện tại
//   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
//   
//   // Truy cập dữ liệu H1
//   TimeFrameData* h1Data = GlobalVars.GetData(PERIOD_H1);
//   
//   // Kiểm tra và cập nhật các PoiZone
//   for(int i = ArraySize(h1Data.zHighs) - 1; i >= 0; i--)
//   {
//      if(IsPoiZoneMitigated(h1Data.zHighs[i], bid))
//      {
//         Print("PoiZone mitigated: ", TimeToString(h1Data.zHighs[i].time));
//         h1Data.zHighs[i].mitigated = 1;
//      }
//   }
//   
//   // Dọn dẹp dữ liệu cũ mỗi giờ
//   static datetime lastCleanup = 0;
//   if(TimeCurrent() - lastCleanup >= 3600)
//   {
//      GlobalVars.CleanupOldData(PERIOD_H1, 24); // Giữ dữ liệu 24 giờ
//      lastCleanup = TimeCurrent();
//   }
//   
//   ArrayPrint(h1Data.Highs);
//   ArrayPrint(h1Data.zHighs);
}

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
        