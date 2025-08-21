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
input int _PointSpace = 1000; // space for draw with swing, line
input int poi_limit = 30; // poi limit save to array
int limit = 10; 
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

   // Constructor
   TimeFrameData()
   {
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
   int AddToDoubleArray(double &array[], double value)
   {
      int size = ArraySize(array);
      ArrayResize(array, size + 1);
      array[size] = value;
      return size + 1;
   }
   
   // Phương thức thêm phần tử vào mảng datetime
   int AddToDateTimeArray(datetime &array[], datetime value)
   {
      int size = ArraySize(array);
      ArrayResize(array, size + 1);
      array[size] = value;
      return size + 1;
   }
   
   // Phương thức thêm phần tử vào mảng PoiZone
   int AddToPoiZoneArray(PoiZone &array[], PoiZone &value)
   {
      int size = ArraySize(array);
      ArrayResize(array, size + 1);
      array[size] = value;
      return size + 1;
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
                      int mitigated = 0, double priceKey = 0, datetime timeKey = 0)
{
   PoiZone zone;
   zone.high = high;
   zone.low = low;
   zone.open = open;
   zone.close = close;
   zone.time = time;
   zone.mitigated = mitigated;
   zone.priceKey = (priceKey != 0) ? priceKey : ((high + low) / 2);
   zone.timeKey = (timeKey != 0) ? timeKey : time;
   
   return zone;
}

// Hàm in thông tin PoiZone
void PrintPoiZone(PoiZone &zone, string prefix = "")
{
   Print(prefix, "PoiZone: High=", zone.high, ", Low=", zone.low, 
         ", Time=", TimeToString(zone.time), ", PriceKey=", zone.priceKey);
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
   void test2(ENUM_TIMEFRAMES timeframe) {
      
      definedFunction(timeframe);
      
   }
   
   void test1(ENUM_TIMEFRAMES timeframe) {
      Print("New "+EnumToString(timeframe)+" bar formed: ", TimeToString(TimeCurrent()));
      
   }
   
   private:
   
   void definedFunction(ENUM_TIMEFRAMES timeframe) {
   
//      ArraySetAsSeries(waveRates, true);
//      ArraySetAsSeries(rates, true);
//      
//      int copied = CopyRates(_Symbol, timeframe, 0, 10, waveRates);
//      ArrayPrint(waveRates);
//      MqlRates bar1, bar2, bar3;
//      // danh dau vi tri bat dau
//      createObj(waveRates[ArraySize(waveRates) - 1].time, waveRates[ArraySize(waveRates) - 1].low, 238, -1, clrRed, "Start");
//      for (int j = ArraySize(waveRates) - 3; j >=0; j--){
//         
//         Print("No:" + (string) j);
//         Print(inInfoBar(bar1, bar2, bar3));
//         //Print("First: "+getValueTrend());
//         bar1 = waveRates[j];
//         bar2 = waveRates[j+1];
//         bar3 = waveRates[j+2];
//         
////         int resultStructure = drawStructureInternal(bar1, bar2, bar3, enabledComment);
////         updatePointTopBot(bar1, bar2, bar3, enabledComment);
////         
////         // POI
////         getZoneValid();
////         drawZone(bar1);
//         
//         //Print("\n Final: "+getValueTrend());
//         Print(" ------------------------------------------------------ End ---------------------------------------------------------\n");
//      }
//      // danh dau vi tri ket thuc
//      createObj(waveRates[0].time, waveRates[0].low, 238, -1, clrRed, "Stop");
   }
};

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
   //demoInit();
   
   defaultGlobal();
//---
   prewHighTFStruct.test2(highTimeFrame);
   //prewLowTFStruct.test2(lowTimeFrame);
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
        
        // Thêm logic xử lý tại đây
        lowTFStruct.test1(lowTimeFrame);
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
//+------------------------------------------------------------------+
//| Example usage                                                    |
//+------------------------------------------------------------------+ 
void demoInit() {
   // Lấy dữ liệu cho khung H1
   TimeFrameData* h1Data = GlobalVars.GetData(PERIOD_H1);
   
   // Lấy giá hiện tại
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   // Thêm giá trị vào mảng Highs
   h1Data.AddToDoubleArray(h1Data.Highs, 1.2345);
   h1Data.AddToDoubleArray(h1Data.Highs, 1.2456);
   
   // Thêm thời gian vào mảng HighsTime
   h1Data.AddToDateTimeArray(h1Data.HighsTime, TimeCurrent());
   h1Data.AddToDateTimeArray(h1Data.HighsTime, TimeCurrent() - 3600);
   
   // Thêm PoiZone vào mảng zHighs
   PoiZone zone1 = CreatePoiZone(ask + 0.0020, ask - 0.0020, ask, bid, TimeCurrent());
   h1Data.AddToPoiZoneArray(h1Data.zHighs, zone1);
   
   PoiZone zone2 = CreatePoiZone(ask + 0.0015, ask - 0.0015, ask, bid, TimeCurrent());
   h1Data.AddToPoiZoneArray(h1Data.zHighs, zone2);
   
   // Sắp xếp mảng Highs
   h1Data.SortDoubleArrayDesc(h1Data.Highs);
   
   // Thêm giá trị vào mảng Highs của M15
   GlobalVars.AddToHighs(PERIOD_M15, 1.2300);
   GlobalVars.AddToHighs(PERIOD_M15, 1.2350);
   
   // Thêm PoiZone vào mảng zHighs của M15
   PoiZone zone3 = CreatePoiZone(ask + 0.0010, ask - 0.0010, ask, bid, TimeCurrent());
   GlobalVars.AddToZHighs(PERIOD_M15, zone3);
   
   // Lấy giá trị cao nhất từ mảng Highs của H1
   double maxHigh = GlobalVars.GetHighsMax(PERIOD_H1);
   Print("Max High in H1: ", maxHigh);
   
   // Lấy PoiZone mới nhất từ mảng zHighs của H1
   PoiZone latestZone;
   if(GlobalVars.GetLatestZHighs(PERIOD_H1, latestZone))
      PrintPoiZone(latestZone, "Latest: ");
}

void demoOntick() {
   // Lấy giá hiện tại
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   // Truy cập dữ liệu H1
   TimeFrameData* h1Data = GlobalVars.GetData(PERIOD_H1);
   
   // Kiểm tra và cập nhật các PoiZone
   for(int i = ArraySize(h1Data.zHighs) - 1; i >= 0; i--)
   {
      if(IsPoiZoneMitigated(h1Data.zHighs[i], bid))
      {
         Print("PoiZone mitigated: ", TimeToString(h1Data.zHighs[i].time));
         h1Data.zHighs[i].mitigated = 1;
      }
   }
   
   // Dọn dẹp dữ liệu cũ mỗi giờ
   static datetime lastCleanup = 0;
   if(TimeCurrent() - lastCleanup >= 3600)
   {
      GlobalVars.CleanupOldData(PERIOD_H1, 24); // Giữ dữ liệu 24 giờ
      lastCleanup = TimeCurrent();
   }
   
   ArrayPrint(h1Data.Highs);
   ArrayPrint(h1Data.zHighs);
}

//+------------------------------------------------------------------+
//| End Example usage                                                |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

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
   string text = " Bar1 high: "+ (string) bar1.high +" - low: "+ (string) bar1.low + " --- "+" Bar2 high: "+ (string) bar2.high +" - low: "+ (string) bar2.low+ " --- "+" Bar3 high: "+ (string) bar3.high +" - low: "+ (string) bar3.low;
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