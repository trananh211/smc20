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

// Biến global
int digits = Digits();

input group "=== Market Struct Inputs ==="   
input int _PointSpace = 1000; // Khoảng cách để vẽ swing, line so với high và low 
input int poi_limit = 30; // Số lượng mảng POI tối đa để lưu vào hệ thống
int limit = 10; // Khối lượng tối đa để lưu trữ mảng của Swing High, Low
int lookback = 100; // Số lượng thanh Bar được đếm ngược lại so với thời điểm chạy bot
datetime lookback_time = 0; 
int lookback_LTF = 0;
// định nghĩa riêng cặp khung thời gian trade
enum pairTF {m1_m15 = 1, m5_h1 = 5, m15_h4 = 15, h1_d1 = 60};
input pairTF pairTimeFrameInput = m5_h1; // Cặp khung thời gian trade: low TimeFrame _ high TimeFrame
int lowPairTF = pairTimeFrameInput;
int highPairTF;
ENUM_TIMEFRAMES lowTimeFrame, highTimeFrame;
input bool isDrawHighTF = true; // Draw Zone HighTimeframe
input bool isDrawLowTF = false; // Draw Zone LowTimeframe
input group "=== Trade with volume Inputs ==="   
// định nghĩa get tick volume là loại nào. max volume 3 nến liền kề, hay chính volume của cây nến đó
input bool isCHoCHBOSVolume = true; // Bật chế độ CHoCH và BOS theo volume
enum typeBreak {Break_with_wick = 1, Break_with_body = 2};
input typeBreak isTypeBreak = 1; // Định nghĩa phá cấu trúc bằng Râu(wick) hoặc Thân(body) nến
input int percentIsDojiBar = 40; // Định nghĩa số % tối đa thân nến để nến đó không phải là Doji Bar  
enum isTickVolume {isBar = 1, isMax3Bar = 2};
input isTickVolume typeTickVolume = 1; // 1: is Bar; 2 : largest of 3 adjacent candles
input int percentCompare = 100; // Số % Volume quyết định Breakout 1 swing.(70%-100%)
input group "=== Draw target ==="
input bool showTargetHighTF = true; // Hien thi target line o High Timeframe
input bool showTargetLowTF = true; // Hien thi target line o Low Timeframe
input bool isDrawMarjor = true; // Draw target with Marjor Swing
input bool isDrawInteral = true; // Draw target with Internal Swing

input group "=== PoiZone Marjor color High + Low TF ==="
input color color_HTF_Extreme_Bullish_Zone = clrGreen; // High TimeFrame Extreme Bullish color
input color color_HTF_Extreme_Bearish_Zone = clrFireBrick; // High TimeFrame Decisional Bullish color
input color color_HTF_Decisional_Bullish_Zone = clrCornflowerBlue; // High TimeFrame Extreme Bearish color
input color color_HTF_Decisional_Bearish_Zone = clrOrangeRed; // High TimeFrame Decisional Bearish color

input color color_LTF_Extreme_Bullish_Zone = clrLightGreen; // Low TimeFrame Extreme Bullish color
input color color_LTF_Extreme_Bearish_Zone = clrLightPink; // Low TimeFrame Decisional Bullish color
input color color_LTF_Decisional_Bullish_Zone = clrPowderBlue; // Low TimeFrame Extreme Bearish color
input color color_LTF_Decisional_Bearish_Zone = clrMistyRose; // Low TimeFrame Decisional Bearish color

input group "=== PoiZone Internal color High + Low TF ==="
input color color_HTF_Internal_Bullish_Zone = clrMediumSlateBlue; // High Internal bullish
input color color_HTF_Internal_Bearish_Zone = clrPaleVioletRed; // High Internal bearish

input color color_LTF_Internal_Bullish_Zone = clrLavender; // Low Internal bullish
input color color_LTF_Internal_Bearish_Zone = clrLavenderBlush; // Low Internal bearish

input group "=== PoiZone Global POI Trade Zone color ==="
input color color_Global_Internal_Bullish_Zone = clrOliveDrab; // Low Internal bullish
input color color_Global_Internal_Bearish_Zone = clrFireBrick; // Low Internal bearish

// End #region variale declaration

// Settings structure default High Timeframe to LowTimeframe
bool ss_IntScanActive = false;
int ss_ITrend;
int ss_vITrend;
int ss_mitigate_iOrderFlow; // Mặc định = -1 kể cả khi breakout, Khi ss_iTarget được xác định = 0, khi mitigate = 1.
double ss_iStoploss; //
double ss_iOrderBlock;
int ss_mitigate_iOrderBlock; // Mặc định = -1, Khi breakout =0, Khi mitigate thì biến này chuyển thành 1. 
double ss_iTarget;
double ss_iSnR;
datetime ss_iStoplossTime;
datetime ss_iTargetTime;

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
   
   // iTrend
   int iTrend;
   int vITrend;
   int isIComplete; // Hoàn thành 1 vòng trade của iTrend
   double iStoploss; //
   double iTarget;
   double iSnR;
   datetime iStoplossTime;
   
//   int isFvG; // 0 not defind, -1 not Fvg, 1 has FvG
// 
   int isTypeZone; // 1 is Extreme, 2 is Decisional 
   
   // mTrend
   int mTrend;
   int vMTrend;
   int isMComplete; // Hoàn thành 1 vòng trade của mTrend
   double mStoploss; //
   double mTarget;
   double mSnR;
   datetime mStoplossTime;
   
   double priceKey;
   datetime timeKey;
};

// Poi zone low timeframe thuộc vùng trade zone High Timeframe khi High TF breakout
PoiZone zArrPoiZoneLTFBullishBelongHighTF[]; // Poi zone Bullish
PoiZone zArrPoiZoneLTFBearishBelongHighTF[]; // Poi zone Bearish

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
   bool isHighTF;
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
   int vGTrend;
   int waitingHighs; // Chờ nến phá vỡ đỉnh Highs. default = 0;
   int waitingLows; //  Chờ nến phá vỡ đỉnh Lows.  default = 0;

   // Internal Structure
   double intSHighs[];
   double intSLows[];
   datetime intSHighTime[];
   datetime intSLowTime[];
   long volIntSHighs[];
   long volIntSLows[];
   
   int iFindTarget;
   double iStoploss; datetime iStoplossTime;
   double iTarget; datetime iTargetTime;
   double iFullTarget;
   double iSnR;
   
   int LastSwingInternal;
   int iTrend;
   int vItrend;
   int waitingIntSHighs; // Chờ nến phá vỡ đỉnh internal swing highs. default = 0
   int waitingIntSLows;  // Chờ nến phá vỡ đỉnh internal swing lows.  default = 0

   // Array pullback
   double arrTop[];
   double arrBot[];
   datetime arrTopTime[];
   datetime arrBotTime[];
   long volArrTop[];
   long volArrBot[];
   int waitingArrTop; // Chờ nến phá vỡ đỉnh Pullback marjor swing highs. default = 0
   int waitingArrBot;  // Chờ nến phá vỡ đỉnh Publlback marjor swing lows.  default = 0

   int mTrend; // marjor Trend normal
   int sTrend; // struct Trend normal
   int vMTrend; // marjor Trend with volume
   int vSTrend; // struct Trend with volume
   datetime arrPbHTime[];
   double arrPbHigh[];
   datetime arrPbLTime[];
   double arrPbLow[];
   long volArrPbHigh[];
   long volArrPbLow[];
   int waitingArrPbHigh; // Chờ nến phá vỡ đỉnh Pullback marjor swing highs. default = 0
   int waitingArrPbLows;  // Chờ nến phá vỡ đỉnh Publlback marjor swing lows.  default = 0
   
   int mFindTarget;
   double mStoploss; datetime mStoplossTime;
   double mTarget; datetime mTargetTime;
   double mFullTarget;
   double mSnR;
   
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
   long vol_idmLow;
   double idmHigh;
   long vol_idmHigh;
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
   //PoiZone zPoiExtremeLow[];
   //PoiZone zPoiExtremeHigh[];
   PoiZone zPoiLow[];
   PoiZone zPoiHigh[];
   //PoiZone zPoiDecisionalLow[];
   //PoiZone zPoiDecisionalHigh[];

   //double arrDecisionalHigh[];
   //double arrDecisionalLow[];
   //datetime arrDecisionalHighTime[];
   //datetime arrDecisionalLowTime[];
   //long volArrDecisionalHigh[];
   //long volArrDecisionalLow[];
   //PoiZone zArrDecisionalHigh[];
   //PoiZone zArrDecisionalLow[];
   
   PoiZone zArrIntBullish[];
   PoiZone zArrIntBearish[];
   
   PoiZone zArrPoiZoneBullish[];
   PoiZone zArrPoiZoneBearish[];

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
      gTrend = 0; vGTrend = 0;
      LastSwingInternal = 0;
      iTrend = 0; vItrend = 0;
      mTrend = 0; vMTrend = 0;
      sTrend = 0; vSTrend = 0;
      waitingHighs = 0;
      waitingLows = 0;
      waitingIntSHighs = 0;
      waitingIntSLows = 0;
      LastSwingMajor = 0;
      lastTimeH = 0;
      lastTimeL = 0;
      L = 0.0;
      H = 0.0;
      idmLow = 0.0; vol_idmLow = 0;
      idmHigh = 0.0; vol_idmHigh = 0;
      L_idmLow = 0.0;
      L_idmHigh = 0.0;
      lastH = 0.0;
      lastL = 0.0;
      H_lastH = 0.0;
      L_lastHH = 0.0;
      H_lastLL = 0.0;
      L_lastL = 0.0;
      waitingArrTop = 0;
      waitingArrBot = 0;
      waitingArrPbHigh = 0;
      waitingArrPbLows = 0;
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
      
      iFindTarget = 0;
      iStoploss = 0; iStoplossTime = 0;
      iTarget = 0; iTargetTime = 0;
      iFullTarget = 0;
      iSnR = 0;
   
      mFindTarget = 0; 
      mStoploss = 0; mStoplossTime = 0;
      mTarget = 0; mTargetTime = 0;
      mFullTarget = 0;
      mSnR = 0;
      
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
      
//      ArrayInitialize(arrDecisionalHigh, 0.0);
//      ArrayInitialize(arrDecisionalLow, 0.0);
//      ArrayInitialize(arrDecisionalHighTime, 0);
//      ArrayInitialize(arrDecisionalLowTime, 0);
//
//      ArrayInitialize(volArrDecisionalHigh, 0);
//      ArrayInitialize(volArrDecisionalLow, 0);
      
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
   
   // Phương thức sắp xếp mảng double sau khi xoa phần tử 
   void SortDoubleArrayAfterDelete(double& array[]) {
      if (ArraySize(array) > 2) {
         // Sort value in array[]
         for(int i = 0; i < ArraySize(array) - 1; i++) {
            array[i] = array[i+1];   
         }   
      }
   }
   
   // Phương thức sắp xếp mảng Datetime sau khi xoa phần tử 
   void SortDateTimeArrayAfterDelete(datetime& array[]) {
      if (ArraySize(array) > 2) {
         // Sort value in array[]
         for(int i = 0; i < ArraySize(array) - 1; i++) {
            array[i] = array[i+1];   
         }   
      }
   }
   
   // Phương thức sắp xếp mảng long sau khi xoa phần tử 
   void SortLongArrayAfterDelete(long& array[]) {
      if (ArraySize(array) > 2) {
         // Sort value in array[]
         for(int i = 0; i < ArraySize(array) - 1; i++) {
            array[i] = array[i+1];   
         }
      }
   }
   
   // Phương thức sắp xếp mảng long sau khi xoa phần tử 
   void SortPoiZoneArrayAfterDelete(PoiZone& array[]) {
      if (ArraySize(array) > 2) {
         // Sort value in array[]
         for(int i = 0; i < ArraySize(array) - 1; i++) {
            array[i] = array[i+1];   
         }
      }
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
   
   // Todo: Phương thức scan toàn bộ PoiZone theo market struct tại khung thời gian hiện tại
   void scanPoiZoneLastTime(TimeFrameData& tfData, int typeZone) {
      if (tfData.mStoploss == 0 || tfData.mTarget == 0) return;
      
      // Bullish Zone
      if (typeZone == 1) {
         // xoa sach mang Bullish zone
         ClearPoiZoneArray(tfData.zArrPoiZoneBullish);
         ClearPoiZoneArray(tfData.zArrPoiZoneBearish);
         
         beginScanZoneSelected(tfData, tfData.zArrIntBullish, tfData.zArrPoiZoneBullish);
      } else if (typeZone == -1) { // Bearish zone
         // xoa sach mang Bearish zone
         ClearPoiZoneArray(tfData.zArrPoiZoneBearish);
         ClearPoiZoneArray(tfData.zArrPoiZoneBullish);
         
         beginScanZoneSelected(tfData, tfData.zArrIntBearish, tfData.zArrPoiZoneBearish);
      }
   }
   
   // Phương thức duyệt mảng chỉ định làm POI Marjor Zone
   void beginScanZoneSelected(TimeFrameData& tfData, PoiZone& Select_zone[], PoiZone& Target_zone[]){
      int isTypezone = 0;
      // Quét toàn bộ zone intSLows
      for(int i=ArraySize(Select_zone) - 1; i >= 0 ; i--) {
         
         // Kiem tra neu zone khong thuoc thoi gian chi dinh thi bo qua
         if (Select_zone[i].time < tfData.mStoplossTime || Select_zone[i].time > tfData.mTargetTime) continue;
         // Cap nhat lai internal zone truoc khi thêm vào zone mới.
         if (tfData.mStoploss == Select_zone[i].mStoploss && tfData.mStoplossTime == Select_zone[i].mStoplossTime) {
            tfData.updateCompleteInternalZone(tfData, Select_zone[i]);
         }
         // Kiểm tra nếu zone đã bị phá qua rồi thì bỏ qua
         if (Select_zone[i].mitigated == -1) continue;
         // Neu La Extreme zone
         if (Select_zone[i].iStoploss == tfData.mStoploss && Select_zone[i].iStoplossTime == tfData.mStoplossTime) {
            // Them zone zIntSlow vao zArrPoiZoneBullish voi isTypeZone = 1
            isTypezone = 1;
         } else { // khong phai extreme zone
            // Them zone zIntSlow vao zArrPoiZoneBullish voi isTypeZone = 2
            isTypezone = 2;
         }
         // chuan hoa thong tin
         tfData.updateCompleteInternalZoneFolowMarjorZone(tfData, Select_zone[i], isTypezone);
         // Them zone zIntSlow vao zArrPoiZoneBullish
         tfData.AddToPoiZoneArray(Target_zone, Select_zone[i], poi_limit);
         
      }
   }
   
   // Phương thức chuẩn hoá lại thông tin zone Internal sau khi xác định được IDM
   void updateCompleteInternalZone(TimeFrameData& tfData, PoiZone& zone){
      zone.isMComplete = 2;
      zone.mTarget = tfData.mTarget;
   }
   
   // Phương thức chuẩn hoá lại thông tin zone Internal sau khi xác định được IDM
   void updateCompleteInternalZoneFolowMarjorZone(TimeFrameData& tfData, PoiZone& zone, int typeZone){
      int type = (typeZone == 1 || typeZone == 2) ? typeZone: 0;
      zone.mTrend = tfData.mTrend;
      zone.vMTrend = tfData.vMTrend;
      zone.isMComplete = 1;
      zone.isTypeZone = type;
      zone.mStoploss = tfData.mStoploss;
      zone.mStoplossTime = tfData.mStoplossTime;
      zone.mSnR = tfData.mSnR;
      zone.mTarget = tfData.mTarget;
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
//Todo: Hàm tạo PoiZone từ giá
PoiZone CreatePoiZone(TimeFrameData& tfData, double high, double low, double open, double close, datetime time, 
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
   
   zone.isTypeZone = 0;
      
   zone.mTrend = (tfData.mTrend == 1 || tfData.mTrend == -1)? tfData.mTrend : 0;
   zone.vMTrend = (tfData.vMTrend == 1 || tfData.vMTrend == -1)? tfData.vMTrend : 0;
   zone.isMComplete = -1;  
   zone.mStoploss = 0;
   zone.mStoplossTime = 0;
   zone.mSnR = 0;
   zone.mTarget = 0;
   
   zone.isIComplete = -1;      
   zone.iTrend = (tfData.iTrend == 1 || tfData.iTrend == -1) ? tfData.iTrend : 0;
   zone.vITrend = (tfData.vItrend == 1 || tfData.vItrend == -1) ? tfData.vItrend : 0;
   zone.iStoploss = 0;
   zone.iStoplossTime = 0;
   zone.iSnR = 0;
   zone.iTarget = 0;
   return zone;
}

// Hàm set lại thông số target và stoploss của lowTF theo HighTF
void setGlobalValueLowToHighTF(TimeFrameData& tfData) {
   // Thêm thông số ban đầu Data Default Internal High TF sau khi break
   if (tfData.isHighTF) {
      ss_ITrend = tfData.iTrend;
      ss_vITrend = tfData.vItrend;
      ss_iStoploss = tfData.iStoploss;
      ss_iStoplossTime = tfData.iStoplossTime;
      ss_iSnR = tfData.iSnR;
      ss_iTarget = tfData.iTarget;
      ss_iTargetTime = tfData.iTargetTime;
   }
}

// Hàm bắt đầu truyền thông số vào poizone
void beginSetValueToPoiZone(TimeFrameData& tfData, PoiZone& zone, string type = "") {
   if (type == "InternalZone") {
      // Cap nhat iTarget at current TimeFrame
      if ((tfData.iStoploss == zone.high || tfData.iStoploss == zone.low) && tfData.iStoplossTime == zone.time) {
         zone.mTrend = (tfData.mTrend == 1 || tfData.mTrend == -1)? tfData.mTrend : 0;
         zone.vMTrend = (tfData.vMTrend == 1 || tfData.vMTrend == -1)? tfData.vMTrend : 0;
         zone.mStoploss = (tfData.mStoploss != 0)? tfData.mStoploss : 0;
         zone.mStoplossTime = (tfData.mStoploss != 0)? tfData.mStoplossTime : 0;
         zone.mSnR = (tfData.mSnR != 0)? tfData.mSnR : 0;
         zone.mTarget = (tfData.mTarget != 0)? tfData.mTarget : 0;
         
         zone.isIComplete = 0;       
         zone.iTrend = (tfData.iTrend == 1 || tfData.iTrend == -1) ? tfData.iTrend : 0;
         zone.vITrend = (tfData.vItrend == 1 || tfData.vItrend == -1) ? tfData.vItrend : 0;
         zone.iStoploss = tfData.iStoploss;
         zone.iStoplossTime = tfData.iStoplossTime;
         zone.iSnR = tfData.iSnR;
         zone.iTarget = tfData.iTarget;
         
      }
   }
}

// Hàm cập nhật target Internal zone hiện tại theo Real Time
void updateProcessPoiZone(TimeFrameData& tfData, PoiZone& zone) {
   // Nếu đã cập nhật target trước đó rồi. Return
   if( zone.isIComplete == 1) return;
   // Kiểm tra xem zone hiện tại có phải đang là zone được chỉ định hay không
   if (zone.iStoploss == tfData.iStoploss && zone.iStoplossTime == tfData.iStoplossTime) {
      zone.mTrend = (tfData.mTrend == 1 || tfData.mTrend == -1)? tfData.mTrend : 0;
      zone.vMTrend = (tfData.vMTrend == 1 || tfData.vMTrend == -1)? tfData.vMTrend : 0;
      zone.mStoploss = (tfData.mStoploss != 0)? tfData.mStoploss : 0;
      zone.mStoplossTime = (tfData.mStoploss != 0)? tfData.mStoplossTime : 0;
      zone.mSnR = (tfData.mSnR != 0)? tfData.mSnR : 0;
      zone.mTarget = (tfData.mTarget != 0)? tfData.mTarget : 0;
      
      zone.iTarget = tfData.iTarget;
      zone.iTrend = (tfData.iTrend == 1 || tfData.iTrend == -1) ? tfData.iTrend : 0;
      zone.vITrend = (tfData.vItrend == 1 || tfData.vItrend == -1) ? tfData.vItrend : 0;
      zone.iStoploss = tfData.iStoploss;
      zone.iStoplossTime = tfData.iStoplossTime;
      zone.iSnR = tfData.iSnR;
      zone.isIComplete = 1;
      
      // Hoàn thiện thông số Target Data Default Internal High TF sau khi break
      if (tfData.isHighTF) {
         ss_ITrend = tfData.iTrend;
         ss_vITrend = tfData.vItrend;
         ss_iStoploss = tfData.iStoploss;
         ss_iStoplossTime = tfData.iStoplossTime;
         ss_iSnR = tfData.iSnR;
         ss_iTarget = tfData.iTarget;
         ss_iTargetTime = tfData.iTargetTime;
      }
   }
}

//+-----------------------------------------------------------------------------------+
//|      Tổ hợp các Hàm Scan poizone low timeframe thuộc Internal Break high timeframe|
//+-----------------------------------------------------------------------------------+

// Phương thức duyệt mảng chỉ định làm POI Internal Zone Lowtimeframe từ khoảng giá trị highest và lowest của Internal High Timeframe
void beginScanGlobalZoneInternalSelected(TimeFrameData& tfData, PoiZone& Select_zone[], PoiZone& Target_zone[], int type, MqlRates& bar1){
   string text = "";
   text += "\nBắt đầu scan Global Internal Zone";
   int isTypezone = 0;
   PoiZone tmp_zone;
   string name = "global_Poi";
   string name_plus = "";
   datetime target_time = (ss_iTarget != 0) ? ss_iTargetTime : bar1.time;
   
   // check Zone exits before
   bool next;
   //PoiZone exist_zones[] = Target_zone;
   // Quét toàn bộ zone intSLows
   for(int i=ArraySize(Select_zone) - 1; i >= 0 ; i--) {
      
      // Kiem tra neu zone khong thuoc thoi gian chi dinh thi bo qua
      if (Select_zone[i].time < ss_iStoplossTime || Select_zone[i].time > target_time) {
         text += "\n1. Zone "+ (string) i + " không thuộc thời gian chỉ định. Bỏ qua";
         continue; 
      }
      // Kiểm tra nếu zone đã bị phá qua rồi thì bỏ qua
      if (Select_zone[i].mitigated == -1) {
         text += "\n2. Zone "+ (string) i + " đã bị mitigated. Bỏ qua";
         continue;
      }
      // Kiểm tra đã tồn tại trong target zone hay chưa. Nếu tồn tại rồi thì bỏ qua
      next = false;
      for(int j=0; j<ArraySize(Target_zone); j++) {
         if( Select_zone[i].iStoploss == Target_zone[j].iStoploss) {
            next = true;
            text += "\nx.x Zone "+ (string) i +" - "+(string) j + " đã tồn tại trong Global Zone. Break";
            break;
         } else {
            text += "\nx.x Zone "+ (string) i +" - "+(string) j + " chưa tồn tại trong Global Zone. Tiếp tục kiểm tra.";
         }
      }
      // Đã tồn tại trong Global zone trước đó.
      if( next == true) {
         text += "\n3. Zone "+ (string) i + " đã tồn tại trong Global zone trước đó. Bỏ qua";
         continue;
      }
      
      // Neu La Extreme zone
      if (Select_zone[i].iStoploss == ss_iStoploss) {
         // Them zone zIntSlow vao zArrPoiZoneBullish voi isTypeZone = 1
         isTypezone = 1;
      } else { // khong phai extreme zone
         // Them zone zIntSlow vao zArrPoiZoneBullish voi isTypeZone = 2
         isTypezone = 2;
      }
      tmp_zone = Select_zone[i];
      tmp_zone.isTypeZone = isTypezone;
      tmp_zone.mitigated = 0;
      name_plus = name +DoubleToString(tmp_zone.high) + "_"+ DoubleToString(tmp_zone.low)+  "_" +TimeToString(tmp_zone.time);
      // Them zone tmp_zone vao Target_zone
      tfData.AddToPoiZoneArray(Target_zone, tmp_zone, poi_limit);
      //TODOTODO: Ve zone
      if (type == 1) {
         drawBox("ePOI"+(string)tmp_zone.high, tmp_zone.time, tmp_zone.low, bar1.time, tmp_zone.high,1, color_Global_Internal_Bullish_Zone, 1);
         text += "\n------------------------------------------------------GOAL "+(string)isTypezone+ " "+(string) bar1.high+ " "+(string) bar1.time+"------------------------------------------------------------------";
      } else if (type == -1) {
         drawBox("ePOI"+(string)tmp_zone.low, tmp_zone.time, tmp_zone.high, bar1.time, tmp_zone.low,1, color_Global_Internal_Bearish_Zone, 1);
         text += "\n------------------------------------------------------GOAL "+(string)isTypezone+ " "+(string) bar1.high+ " "+(string) bar1.time+"------------------------------------------------------------------";
      }      
      
   }
   //Print(text);
}

void scanGlobalInternalPoiZone(TimeFrameData& tfData, MqlRates& bar1){
   string text = "";
	if (tfData.isHighTF != true) { // Neu tiep theo cu break out cua Internal High TF la scan thong tin tu Low TF
		if (ss_IntScanActive) {
			if (ss_ITrend != 0) {
				// Scan bullish
				if (ss_ITrend == 1) {
				   if ( ArraySize(tfData.zArrIntBullish) > 0) {
				      beginScanGlobalZoneInternalSelected(tfData, tfData.zArrIntBullish, zArrPoiZoneLTFBullishBelongHighTF, 1, bar1);
				      ss_IntScanActive = false;
				   } else {
				      // Quét toàn bộ các vùng POI Internal low timeframe để Trade theo Order Block, Order Flow mới
				   }
				} else if (ss_ITrend == -1 ) {
				   if ( ArraySize(tfData.zArrIntBearish) > 0) { // Scan Bearish
				      beginScanGlobalZoneInternalSelected(tfData, tfData.zArrIntBearish, zArrPoiZoneLTFBearishBelongHighTF, -1, bar1);
				      ss_IntScanActive = false;
				   } else {
				      // Quét toàn bộ các vùng POI Internal low timeframe để Trade theo Order Block, Order Flow mới
				   }
				}
			} 
			
		} 	else { 
			// Reset thông số ban đầu nếu Stoploss hoặc Take Profit
			if ( (ss_ITrend == 1 && ((bar1.high > ss_iTarget && ss_iTarget != 0) || (bar1.low < ss_iStoploss && ss_iStoploss != 0))) 
			   || (ss_ITrend == -1 && ((bar1.low < ss_iTarget && ss_iTarget != 0 ) || (bar1.high > ss_iStoploss && ss_iStoploss != 0)))
			   ) {
				text += "\n================> Clean Data vi đã take profit hoặc quét stoploss";
				ss_ITrend = 0;
				ss_vITrend = 0;
				ss_iStoploss = 0;
				ss_iStoplossTime = 0;
				ss_iSnR = 0;
				ss_iTarget = 0;
				ss_iTargetTime = 0;
				// xoa du lieu de tranh vao lenh lien tuc sau khi dat target
				tfData.ClearPoiZoneArray(zArrPoiZoneLTFBullishBelongHighTF);
				tfData.ClearPoiZoneArray(zArrPoiZoneLTFBearishBelongHighTF);
			} else {
				if (ss_ITrend == 1) {
				   if ((ss_iTarget != 0 && bar1.high < ss_iTarget) || ( ss_iStoploss != 0 && bar1.low > ss_iStoploss) ) {
				      if (ArraySize(zArrPoiZoneLTFBullishBelongHighTF) == 0 ) {
				         text += "\n================> Thiếu thông số Bullish. Scan lại Global zone ở bước sau";
				         ss_IntScanActive = true;
				      }
				   }
				} else if (ss_ITrend == -1) {
				   if ((bar1.low > ss_iTarget && ss_iTarget != 0 ) || (bar1.high < ss_iStoploss && ss_iStoploss != 0)) {
				      if (ArraySize(zArrPoiZoneLTFBearishBelongHighTF) == 0) {
				         text += "\n================> Thiếu thông số Bearish. Scan lại Global zone ở bước sau";
				         ss_IntScanActive = true;
				      }
				   }
				}
			}     
		} // End ss_IntScanActive == false
	} // End tfData.isHighTF != true
	//text += "\n## ss_ITrend: " + (string) ss_ITrend +" ss_vITrend: "+ (string) ss_vITrend + " ss_iStoploss: " +(string) ss_iStoploss + " ss_iSnR: "+ (string) ss_iSnR + " ss_iTarget: "+ (string) ss_iTarget;
	Print(text);
} // End scanGlobalInternalPoiZone

//+-----------------------------------------------------------------------------------+
//| END: Tổ hợp các Hàm Scan poizone low timeframe thuộc Internal Break high timeframe|
//+-----------------------------------------------------------------------------------+


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
      int count_lookback = 0;
      tfData.timeFrame = timeframe;
      setDefautTimeframe(tfData, timeframe);
      if (tfData.isTimeframe == highPairTF) {
         tfData.isHighTF = true;
         count_lookback = lookback;
      } else {
         tfData.isHighTF = false;
         lookback_LTF = iBarShift(_Symbol, tfData.timeFrame, lookback_time, true);
         count_lookback = (lookback_LTF > 0) ? lookback_LTF : lookback;
      }
      if ( (tfData.isTimeframe == highPairTF && isDrawHighTF == true) || (tfData.isTimeframe == lowPairTF && isDrawLowTF == true)) {
         tfData.isDraw = true;
      }
      
      // Copy toan bo Lookback = 100 Bar tu Bar hien tai vao mang waveRates
      int copied = CopyRates(_Symbol, timeframe, 0, count_lookback, waveRates);
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
      
//      tfData.AddToDoubleArray(tfData.arrDecisionalHigh, firstBarHigh);
//      tfData.AddToDateTimeArray(tfData.arrDecisionalHighTime, firstBarTime);
//      tfData.AddToLongArray(tfData.volArrDecisionalHigh, firstBarVol);
//      
//      tfData.AddToDoubleArray(tfData.arrDecisionalLow, firstBarLow);
//      tfData.AddToDateTimeArray(tfData.arrDecisionalLowTime, firstBarTime);
//      tfData.AddToLongArray(tfData.volArrDecisionalLow, firstBarVol);
      
      // Thêm PoiZone vào mảng
      PoiZone zone1 = CreatePoiZone( tfData,Bar1.high, Bar1.low, Bar1.open, Bar1.close, Bar1.time, 0, -1, -1);
      tfData.AddToPoiZoneArray(tfData.zPoiLow, zone1);
      tfData.AddToPoiZoneArray(tfData.zPoiHigh, zone1);
      //tfData.AddToPoiZoneArray(tfData.zPoiExtremeLow, zone1);
      //tfData.AddToPoiZoneArray(tfData.zPoiExtremeHigh, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrTop, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrBot, zone1);
      tfData.AddToPoiZoneArray(tfData.zHighs, zone1);
      tfData.AddToPoiZoneArray(tfData.zLows, zone1);
      tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone1);
      tfData.AddToPoiZoneArray(tfData.zIntSLows, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrPbHigh, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrPbLow, zone1);
      //tfData.AddToPoiZoneArray(tfData.zPoiDecisionalHigh, zone1);
      //tfData.AddToPoiZoneArray(tfData.zPoiDecisionalLow, zone1);
      //tfData.AddToPoiZoneArray(tfData.zArrDecisionalHigh, zone1);
      //tfData.AddToPoiZoneArray(tfData.zArrDecisionalLow, zone1);
      
      tfData.AddToPoiZoneArray(tfData.zArrIntBullish, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrIntBearish, zone1);
      
      tfData.AddToPoiZoneArray(tfData.zArrPoiZoneBullish, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrPoiZoneBearish, zone1);
      
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
      } else if (typeStructure == INTERNAL_STRUCTURE) {
         iWingding  = (itype == 1)? iWingding_internal_high : iWingding_internal_low;
      } else if (typeStructure == INTERNAL_STRUCTURE_KEY){
         iWingding  = (itype == 1)? iWingding_internal_high : iWingding_internal_low;
      }else if (typeStructure == MAJOR_STRUCTURE) {
         iWingding  = (itype == 1)? 116 : 116;
      }
      
      string text    = (itype == 1)? "Update High" : "Update Low";
      int iDirection = (itype == 1)? -1 : 1;
      
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
   
   // Ham tim look back bar cua low timeframe tu High timeframe
   void lookBackCandle(TimeFrameData& tfData) {
      if (tfData.iTrend == 1) {
         if (ArraySize(tfData.intSLowTime) >= 3) {
            lookback_time = tfData.intSLowTime[2];
         }
      } else if (tfData.iTrend == -1) {
         if (ArraySize(tfData.intSHighTime) >= 3) {
            lookback_time = tfData.intSHighTime[2];
         }
      }
   }
   
   void gannWave(TimeFrameData& tfData){
      MqlRates bar1, bar2, bar3; 
      // danh dau vi tri bat dau
      createObj(waveRates[0].time, waveRates[0].low, 238, -1, tfData.tfColor, "Start");
      string resultStructure = "";
      string resultMarjorStruct = "";
      for (int j = 1; j <= ArraySize(waveRates) - 2; j++){
         
         Print("TF: "+ (string)tfData.isTimeframe+" No:" + (string) j);
         
         bar1 = waveRates[j+1];
         bar2 = waveRates[j];
         bar3 = waveRates[j-1];
         
         Print(inInfoBar(bar1, bar2, bar3));
         Print("First: "+getValueTrend(tfData));
         
         resultStructure = drawStructureInternal(tfData, bar1, bar2, bar3, enabledComment);
         if(StringLen(resultStructure) > 0) {
            Print(resultStructure);
         }
         resultMarjorStruct = updatePointTopBot(tfData, bar1, bar2, bar3, enabledComment);
         if (StringLen(resultMarjorStruct) > 0) {
            Print(resultMarjorStruct);
         }
         drawMarketStruct(tfData, bar1);
         // POI
         scanGlobalInternalPoiZone(tfData, bar1);
         
         // Mitigation
         checkMitigateZone(tfData, bar1);         
         
         Print("\nFinal:"+getValueTrend(tfData));
         Print("------------ End Gann wave---------------\n");
      }
      // danh dau vi tri ket thuc
      createObj(waveRates[ArraySize(waveRates) - 1].time, waveRates[ArraySize(waveRates) - 1].low, 238, -1, tfData.tfColor, "Stop");
      
      
      // Ham tim look back bar cua low timeframe tu High timeframe
      if (tfData.isHighTF) lookBackCandle(tfData);
      
   }
   
   void realGannWave(TimeFrameData& tfData, ENUM_TIMEFRAMES timeframe) {
      string textall = "";
      string text  = "";
      string resultStructure = "";
      string resultMarjorStruct = "";
      textall += "----------------------------------------------------------------------> New "+EnumToString(timeframe)+" bar formed: "+TimeToString(TimeCurrent())+" <-----------------------------------------------------------------------";
      int copied = CopyRates(_Symbol, timeframe, 0, 4, rates);
      
      MqlRates bar1, bar2, bar3;
      bar1 = rates[2];
      bar2 = rates[1];
      bar3 = rates[0];
      
      //text += "--------------Real Gann Wave----------------";
      textall += "\n"+inInfoBar(bar1, bar2, bar3);
      //textall += "\nFirst: "+getValueTrend(tfData);
      //Print(text);
      resultStructure = drawStructureInternal(tfData, bar1, bar2, bar3, enabledComment);
      if (StringLen(resultStructure) > 0) {
         text += resultStructure;
         textall += resultStructure;
      }   
      resultMarjorStruct = updatePointTopBot(tfData, bar1, bar2, bar3, enabledComment);
      if (StringLen(resultMarjorStruct) > 0) {
         text += resultMarjorStruct;
         textall += resultMarjorStruct;
      }
      drawMarketStruct(tfData, bar1);
      // POI
      scanGlobalInternalPoiZone(tfData, bar1);
      
      // Mitigation
      checkMitigateZone(tfData, bar1);
      
      textall += "\n#Final: "+getValueTrend(tfData);
      //text += "\n------------ End Real Gann wave---------------";
      //Print(text); 
      
      textall += "\n----------------------------------------------------------------------> END "+EnumToString(timeframe)+" bar formed: "+ TimeToString(TimeCurrent())+" <-----------------------------------------------------------------------";
      if (StringLen(text) > 0) {
         Print(textall);
      }
      // For develop
      showPoiComment(tfData);
   }
   
   // Todo: Kiểm tra lần lượt zone đã mitigate hay chưa
   void checkMitigateZone(TimeFrameData& tfData, MqlRates& bar1) {
      // Hàm luôn phải chạy không được dừng để check mitigate còn loại POI ra khỏi vùng scan zone.
      if (ArraySize(tfData.zArrIntBearish) > 0) {
         getIsMitigatedZone(bar1, tfData.zArrIntBearish, -1);
      }
      
      if (ArraySize(tfData.zArrIntBullish) > 0) {
         getIsMitigatedZone(bar1, tfData.zArrIntBullish, 1);
      }
      
      // Hàm check mitigate của Marjor Zone theo từng TF
      if (ArraySize(tfData.zArrPoiZoneBearish) > 0) {
         getIsMitigatedZone(bar1, tfData.zArrPoiZoneBearish, -1);
      }
      
      if (ArraySize(tfData.zArrPoiZoneBullish) > 0) {
         getIsMitigatedZone(bar1, tfData.zArrPoiZoneBullish, 1);
      }
      
      // Hàm check mitigate của global zone dành cho Trade Multi TF
      if( ArraySize(zArrPoiZoneLTFBullishBelongHighTF) > 0) {
         getIsMitigatedZone(bar1, zArrPoiZoneLTFBullishBelongHighTF, 1);
      }
      
      if (ArraySize(zArrPoiZoneLTFBearishBelongHighTF) > 0) {
         getIsMitigatedZone(bar1, zArrPoiZoneLTFBearishBelongHighTF, -1);
      }
      
   }
   
   // Hàm kiểm tra từng zone mitigate hay chưa
   void getIsMitigatedZone(MqlRates& bar1, PoiZone& zone[], int type, int skip_key = -1) {
      // kiem tra xem zone co du lieu hay khong
      if (ArraySize(zone) > 0) {
         bool isDraw = false;
         color iColor = clrPapayaWhip;
         // lap du lieu 
         for(int i=0;i < ArraySize(zone);i++) {
            isDraw = false;
            if (i == skip_key) continue;
            // chi kiem tra zone not mitigate va mitigating
            if (zone[i].mitigated == -1) continue;
            
            // neu dang check bullish zone
            if (type == 1) {
               if( bar1.low > zone[i].high) continue; 
               // Neu gia bat dau mitigate zone
               // neu gia van nam trong zone
               if (bar1.low <= zone[i].high && bar1.low >= zone[i].low && zone[i].mitigated != 1) {
                  zone[i].mitigated = 1;
                  //drawBox("ePOI", zone[i].time, zone[i].high, bar1.time, zone[i].low,1, iColor, 1);
               }
               // neu gia vuot ra ngoai zone
               if (bar1.low < zone[i].low && zone[i].mitigated != -1) {
                  zone[i].mitigated = -1;
               }
            } else if (type == -1) { // neu dang check bearish zone
               if (bar1.high < zone[i].low) continue;
               // Neu gia bat dau mitigate zone
               
               // neu gia van nam trong zone
               if (bar1.high >= zone[i].low && bar1.high <= zone[i].high && zone[i].mitigated != 1) {
                  zone[i].mitigated = 1;
                  //drawBox("ePOI", zone[i].time, zone[i].low, bar1.time, zone[i].high,1, iColor, 1);
               }
               
               // neu gia vuot ra ngoai zone
               if (bar1.high > zone[i].high && zone[i].mitigated != -1) {
                  zone[i].mitigated = -1;
               }
            }
         }
      }
   }
   
   //---
   //--- Ham cap nhat ve cau truc song gann, internal struct, major struct
   //---
   string drawStructureInternal(TimeFrameData& tfData, MqlRates& bar1, MqlRates& bar2, MqlRates& bar3, bool isComment = false) {
      string text_all = "";
      
      string str_gann = "\n# Gann";
      string str_internal = "\n# Internal";
      int resultStructure = 0;
      string textGannHigh = "";
      string textGannLow = "";
      
      string textInternalHigh = "";
      string textInternalLow = "";
      
      string str_internal_high = "";
      string str_internal_low = "";
      
      string textTop = "";
      string textBot = "";

      long maxVolume = 0;
      
      // dinh nghia huong ve line target
      bool isDrawTarget = false;
      int line_target = 0;
      double line_dinh = 0;
      double line_day = 0;
      double place_start_line_draw = 0;
      
      
   //    swing high
      if (bar3.high <= bar2.high && bar2.high >= bar1.high) { // tim thay dinh high
         textGannHigh += "\n--->Gann: Find High: "+DoubleToString(bar2.high, digits) +" + Highest: "+ DoubleToString(tfData.highEst, digits) ;
         // set Zone
         PoiZone zone2 = CreatePoiZone( tfData,bar2.high, bar2.low, bar2.open, bar2.close, bar2.time);
         if (typeTickVolume == 1) {
            maxVolume = bar2.tick_volume;
         } else {
            maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
         }         

         // gann finding high
         if (tfData.LastSwingMeter == 1 || tfData.LastSwingMeter == 0) {
            textGannHigh += "; Gann: LastSwingMeter == 1 or 0 => New Highs= "+DoubleToString(bar2.high, digits) +"; LastSwingMeter = -1" ;
            // Add high moi (updatePointStructure), khong xoa Highs 0
            tfData.AddToDoubleArray(tfData.Highs, bar2.high, limit);
            tfData.AddToDateTimeArray(tfData.HighsTime, bar2.time, limit);
            tfData.AddToLongArray(tfData.volHighs, maxVolume, limit);

            drawPointStructure(tfData, 1, bar2.high, bar2.time, GANN_STRUCTURE, false, enabledDraw);
            tfData.LastSwingMeter = -1;
            // cap nhat Zone. Khong xoa (updatePointZone)
            tfData.AddToPoiZoneArray(tfData.zHighs, zone2, limit);
            // cap nhat waiting bos highs ve 0
            tfData.waitingHighs = 0;
         }
         // gann finding low
         if (tfData.LastSwingMeter == -1) {
            //    xoa high cu. viet high moi
            if (bar2.high > tfData.highEst) {
               textGannHigh += "; Gann: LastSwingMeter == -1 => Delete Highs[0] = "+DoubleToString(tfData.Highs[0], digits)+" ,New Highs= "+DoubleToString(bar2.high, digits) +"; LastSwingMeter = -1" ;
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
               // cap nhat waiting bos highs ve 0
               tfData.waitingHighs = 0;
            }
         }
         if(StringLen(textGannHigh) > 0) {
            text_all += str_gann+" (Swing) "+textGannHigh;
         }
         //if (isComment) {
         //   Print(str_gann+textGannHigh);
         //   //ArrayPrint(tfData.Highs);
         //   //ArrayPrint(tfData.volHighs);
         //}
         
         
         // Internal Structure
         str_internal_high += "\n--->Swing High: "+DoubleToString(bar2.high,digits) +".#SS iTrend: " +(string) tfData.iTrend+", LastSwingInternal: "+(string) tfData.LastSwingInternal;
         str_internal_high += "| lastTimeH: "+(string) tfData.lastTimeH+" lastH: "+ DoubleToString(tfData.lastH,digits) +"<->"+" intSHighTime[0] "+(string) tfData.intSHighTime[0]+" intSHighs[0] "+ DoubleToString(tfData.intSHighs[0], digits);
         // finding High
         
         // DONE 1
         // HH
         if ( (tfData.iTrend == 0 || (tfData.iTrend == 1 && tfData.LastSwingInternal == 1)) && bar2.high > tfData.intSHighs[0]){ // iBOS
            textInternalHigh += "\n"+"High 1 iBOS --> Update: "+ "iTrend: 1, LastSwingInternal: -1 , New intSHighs[0]: "+DoubleToString(bar2.high, digits);
            // Add new intSHigh.
            tfData.AddToDoubleArray(tfData.intSHighs, bar2.high);
            tfData.AddToDateTimeArray(tfData.intSHighTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSHighs, maxVolume);

            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            
            tfData.iTrend = 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 1;
            
            if (tfData.iFindTarget == 0 && tfData.intSHighs[0] > tfData.iTarget) {
               tfData.iTarget = tfData.intSHighs[0];
               tfData.iTargetTime = tfData.intSHighTime[0];
               tfData.iFindTarget = 0;
               textInternalHigh += " | Update High 1,2";
            }
            
            if (tfData.iFindTarget == 1) {
               tfData.iTarget = tfData.intSHighs[0];
               tfData.iTargetTime = tfData.intSHighTime[0];
               tfData.iFindTarget = 0;
               textInternalHigh += " | New High 1,1";
            }
            
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone2, poi_limit);
            // cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSHighs = 0;
            // Cap nhat target zone Low
            updateProcessPoiZone(tfData, tfData.zIntSLows[0]);
            // Cap nhat target Internal Zone Bullish
            tfData.UpdatePoiZoneArray(tfData.zArrIntBullish,0,tfData.zIntSLows[0]);
            // Scan poizone low timeframe thuộc Internal Break high timeframe Bullish
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
         
         // HH 2
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.high > tfData.intSHighs[0] && bar2.high > tfData.intSHighs[1]){
            textInternalHigh += "\n"+" High 2 --> Update: "+ "iTrend: 1, LastSwingInternal: -1, Update intSHighs[0]: "
                                 +DoubleToString(bar2.high, digits) + ", Xoa intSHighs[0] old: "+DoubleToString(tfData.intSHighs[0], digits);
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
            
            if (tfData.iFindTarget == 0 && tfData.intSHighs[0] > tfData.iTarget) {
               tfData.iTarget = tfData.intSHighs[0];
               tfData.iTargetTime = tfData.intSHighTime[0];
               tfData.iFindTarget = 0;
               textInternalHigh += " | Update High 2,2";
            }
            
            if (tfData.iFindTarget == 1) {
               tfData.iTarget = tfData.intSHighs[0];
               tfData.iTargetTime = tfData.intSHighTime[0];
               tfData.iFindTarget = 0;
               textInternalHigh += " | New High 2,1";
            }
                        
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSHighs, 0, zone2);
            //// cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSHighs = 0;
            // Cap nhat target zone Low
            updateProcessPoiZone(tfData, tfData.zIntSLows[0]);
            // Cap nhat target Internal Zone Bullish
            tfData.UpdatePoiZoneArray(tfData.zArrIntBullish,0,tfData.zIntSLows[0]);
            
            // Thêm mới thông số Global Target 
            setGlobalValueLowToHighTF(tfData);
            // Scan poizone low timeframe thuộc Internal Break high timeframe bullish
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
                  
         // DONE 4 
         // LH
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.high < tfData.intSHighs[0]) { 
            textInternalHigh += "\n"+ " High 4 --> Update: "+ "iTrend: -1, LastSwingInternal: -1, New intSHighs[0]: "+DoubleToString(bar2.high, digits);
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
            // cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSHighs = 0;
         }
         
         // DONE 5
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == -1 && bar2.high > tfData.intSHighs[0] ) {    // iCHoCH
            textInternalHigh += "\n"+" High 5 iCHoCH --> Update: LastSwingInternal: -1, Update intSHighs[0]: "+DoubleToString(bar2.high, digits)+", Xoa intSHighs[0] old: "+DoubleToString(tfData.intSHighs[0], digits);
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
            textInternalHigh += ", (?) iTrend: "+(string) tfData.iTrend+"\n";
            //// cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSHighs = 0;
         }
         
         // DONE 6
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.high > tfData.intSHighs[0] 
            //&& tfData.waitingIntSHighs == 1
            ) { // iCHoCH
            textInternalHigh += "\n"+" High 6 iCHoCH --> Update: LastSwingInternal: -1, New intSHighs[0]: "+DoubleToString(bar2.high, digits);
            
            // Add new intSHigh
            tfData.AddToDoubleArray(tfData.intSHighs, bar2.high);
            tfData.AddToDateTimeArray(tfData.intSHighTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSHighs, maxVolume);
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            tfData.iTrend = 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 6;
            
            if (tfData.iFindTarget == 1) {
               tfData.iTarget = tfData.intSHighs[0];
               tfData.iTargetTime = tfData.intSHighTime[0];
               tfData.iFindTarget = 0;
               textInternalHigh += " | New High 6";
            }
                                    
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone2, poi_limit);
            // cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSHighs = 0;
            // Cap nhat target zone Low
            updateProcessPoiZone(tfData, tfData.zIntSLows[0]);
            // Cap nhat target Internal Zone Bullish
            tfData.UpdatePoiZoneArray(tfData.zArrIntBullish,0,tfData.zIntSLows[0]);
            // Scan poizone low timeframe thuộc Internal Break high timeframe bullish
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
         
         if(StringLen(textInternalHigh) > 0) {
            text_all += str_internal+" (Swing) "+str_internal_high+textInternalHigh;
         }
         //if( isComment) {
         //   Print(str_internal+textInternalHigh);
         //   //ArrayPrint(tfData.intSHighs);
         //   //ArrayPrint(tfData.volIntSHighs);
         //}
         
      }
   //   
   //   // swing low
      if (bar3.low >= bar2.low && bar2.low <= bar1.low) { // tim thay dinh low
         textGannLow += "\n--->Gann: Find Low: +" +DoubleToString(bar2.low, digits)+ " + Lowest: "+DoubleToString(tfData.lowEst, digits);
         PoiZone zone2 = CreatePoiZone( tfData,bar2.high, bar2.low, bar2.open, bar2.close, bar2.time);
         if (typeTickVolume == 1) {
            maxVolume = bar2.tick_volume;
         } else {
            maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
         }
         // gann finding low
         if (tfData.LastSwingMeter == -1 || tfData.LastSwingMeter == 0) {
            textGannLow += "; Gann: LastSwingMeter == -1 or 0 => New Lows[0] = "+DoubleToString(bar2.low, digits) +"; LastSwingMeter = 1" ;
            // cap nhat low moi, khong xoa Lows 0
            tfData.AddToDoubleArray(tfData.Lows, bar2.low);
            tfData.AddToDateTimeArray(tfData.LowsTime, bar2.time);
            tfData.AddToLongArray(tfData.volLows, maxVolume);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, GANN_STRUCTURE, false, enabledDraw);
            tfData.LastSwingMeter = 1;
            // Them Zone.
            tfData.AddToPoiZoneArray(tfData.zLows, zone2, limit);
            // cap nhat waiting bos lows ve 0
            tfData.waitingLows = 0;
         }
         // gann finding high
         if (tfData.LastSwingMeter == 1) {
            // xoa low cu. viet high moi
            if (bar2.low < tfData.lowEst) {
               textGannLow += "; Gann: LastSwingMeter == 1 => Delete Lows[0] = "+DoubleToString(tfData.Lows[0], digits)+" ,New Lows= "+DoubleToString(bar2.low, digits) +"; LastSwingMeter = 1" ;
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
               // cap nhat waiting bos lows ve 0
               tfData.waitingLows = 0;
            }
         }
         if(StringLen(textGannLow) > 0) {
            text_all += str_gann+" (Swing) "+textGannLow;
         }
         //if (isComment) {
         //   Print(str_gann+textGannLow);
         //   //ArrayPrint(tfData.Lows);
         //   //ArrayPrint(tfData.volLows);
         //}
         
         // Internal Structure 
         str_internal_low += "\n--->Swing Low: "+ DoubleToString(bar2.low, digits) +".#SS iTrend: " +(string) tfData.iTrend+", LastSwingInternal: "+(string) tfData.LastSwingInternal;
         str_internal_low += "| lastTimeL: "+(string) tfData.lastTimeL+" lastL: "+DoubleToString(tfData.lastL,digits) +"<->"+"intSLowTime[0] "+(string) tfData.intSLowTime[0]+" intSLows[0] "+ DoubleToString(tfData.intSLows[0], digits);
         // finding Low
         // DONE 1
         // LL
         if ((tfData.iTrend == 0 || tfData.iTrend == -1) && tfData.LastSwingInternal == -1 && bar2.low < tfData.intSLows[0]){ // iBOS
            textInternalLow += "\n"+("Low 1 iBOS --> Update: "+ "iTrend: -1, LastSwingInternal: 1, New intSLows[0]: "+DoubleToString(bar2.low, digits));
            // Add new intSLows
            tfData.AddToDoubleArray(tfData.intSLows, bar2.low);
            tfData.AddToDateTimeArray(tfData.intSLowTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSLows, maxVolume);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
                     
            tfData.iTrend = -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -1;
            
            if (tfData.iFindTarget == 0 && tfData.intSLows[0] < tfData.iTarget) {
               tfData.iTarget = tfData.intSLows[0];
               tfData.iTargetTime = tfData.intSLowTime[0];
               tfData.iFindTarget = 0;
               textInternalLow += " | Update Low -1,2";
            }
            
            if (tfData.iFindTarget == -1) {
               tfData.iTarget = tfData.intSLows[0];
               tfData.iTargetTime = tfData.intSLowTime[0];
               tfData.iFindTarget = 0;
               textInternalLow += " | New Low -1,1";
            }
            
            // Them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSLows, zone2, poi_limit);
            // cap nhat waiting bos intSLows ve 0
            tfData.waitingIntSLows = 0;
            // Cap nhat target zone High
            updateProcessPoiZone(tfData, tfData.zIntSHighs[0]);
            // Cap nhat target Internal Zone Bearish
            tfData.UpdatePoiZoneArray(tfData.zArrIntBearish,0,tfData.zIntSHighs[0]);
            // Scan poizone low timeframe thuộc Internal Break high timeframe Bearish
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
         
         // LL
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.low < tfData.intSLows[0] && bar2.low < tfData.intSLows[1]){
            textInternalLow += "\n"+" Low 2 --> Update: "+ "iTrend: -1, LastSwingInternal: 1"+
                                 ", Update intSLows[0]: "+DoubleToString(bar2.low, digits) +", Xoa intSLows[0] old: "+DoubleToString(tfData.intSLows[0], digits);
            
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
            
            if (tfData.iFindTarget == 0 && tfData.intSLows[0] < tfData.iTarget) {
               tfData.iTarget = tfData.intSLows[0];
               tfData.iTargetTime = tfData.intSLowTime[0];
               tfData.iFindTarget = 0;
               textInternalLow += " | Update Low -2,2";
            }
            
            if (tfData.iFindTarget == -1) {
               tfData.iTarget = tfData.intSLows[0];
               tfData.iTargetTime = tfData.intSLowTime[0];
               tfData.iFindTarget = 0;
               textInternalLow += " | New Low -2,1";
            }
            
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSLows, 0, zone2);
            //// cap nhat waiting bos intSLows ve 0
            tfData.waitingIntSLows = 0;
            // Cap nhat target zone High
            updateProcessPoiZone(tfData, tfData.zIntSHighs[0]);
            // Cap nhat target Internal Zone Bearish
            tfData.UpdatePoiZoneArray(tfData.zArrIntBearish,0,tfData.zIntSHighs[0]);
                       
            // Thêm mới thông số Global Target 
            setGlobalValueLowToHighTF(tfData);
            // Scan poizone low timeframe thuộc Internal Break high timeframe Bearish
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
         
         // DONE 4
         // Trend Tang. HL
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.low > tfData.intSLows[0]) {
            textInternalLow += "\n"+("Low 4 --> Update: "+ "iTrend: 1, LastSwingInternal: 1, New intSLows[0]: "+DoubleToString(bar2.low, digits));
            
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
            // cap nhat waiting bos intSLows ve 0
            tfData.waitingIntSLows = 0;
         }
         
         // DONE 5
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == 1 && bar2.low < tfData.intSLows[0] ) {  // iCHoCH
            textInternalLow += "\n"+("Low 5 iCHoCH --> Update:  LastSwingInternal: 1, Update intSLows[0]: "+DoubleToString(bar2.low, digits)+", Xoa intSLows[0] old: "+DoubleToString(tfData.intSLows[0], digits));
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
            //// cap nhat waiting bos intSLows ve 0
            tfData.waitingIntSLows = 0;
         }
         
         // DONE 6
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.low < tfData.intSLows[0] 
               //&& tfData.waitingIntSLows == 1
               ) { // iCHoCH
            textInternalLow += "\n"+"Low 6 iCHoCH --> Update: LastSwingInternal: 1, New intSLows[0]: "+DoubleToString(bar2.low, digits);
            
            // Add new intSHigh
            tfData.AddToDoubleArray(tfData.intSLows, bar2.low);
            tfData.AddToDateTimeArray(tfData.intSLowTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSLows, maxVolume);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            tfData.iTrend = -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -6;
            
            if (tfData.iFindTarget == -1) {
               tfData.iTarget = tfData.intSLows[0];
               tfData.iTargetTime = tfData.intSLowTime[0];
               tfData.iFindTarget = 0;
               textInternalLow += " | New Low 6";
            }
            
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSLows, zone2, poi_limit);
            // cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSLows = 0;
            // Cap nhat target zone High
            updateProcessPoiZone(tfData, tfData.zIntSHighs[0]);
            // Cap nhat target Internal Zone Bearish
            tfData.UpdatePoiZoneArray(tfData.zArrIntBearish,0,tfData.zIntSHighs[0]);
            // Scan poizone low timeframe thuộc Internal Break high timeframe Bearish
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
         
         if(StringLen(textInternalLow) > 0) { 
            text_all += str_internal+" (Swing) "+str_internal_low+textInternalLow;
         }
         //if(isComment) {
         //   Print(str_internal+textInternalLow);
         //   //ArrayPrint(tfData.intSLows);
         //   //ArrayPrint(tfData.volIntSLows);
         //}
         
      }
      
      // CHOCH or BOS
      //reset log
      textGannHigh = "";
      textGannLow = "";
      color iColorBull = (tfData.isHighTF) ? color_HTF_Internal_Bullish_Zone : color_LTF_Internal_Bullish_Zone;
      color iColorBear = (tfData.isHighTF) ? color_HTF_Internal_Bearish_Zone : color_LTF_Internal_Bearish_Zone;
      // Gann wave
      // BOS Highs
      if (tfData.waitingHighs == 0 && bar1.high > tfData.Highs[0]) {
         tfData.gTrend = 1;
         tfData.vGTrend = tfData.gTrend;
         tfData.waitingHighs = 1;
         textGannHigh += "\n---> G1 Gann. bar1.high ("+DoubleToString(bar1.high, digits)+") > Highs[0] ("+DoubleToString(tfData.Highs[0], digits)+"). => Cap nhat: gTrend = 1, waitingHighs = 1";
         //if (isComment && StringLen(textGannHigh) > 0) {
         //   Print(str_gann+textGannHigh);
         //}
         if (StringLen(textGannHigh) > 0) {
            text_all += str_gann+" (Break) "+textGannHigh;
         }
         if (isCHoCHBOSVolume) {
            tfData.vGTrend = (checkVolumeBreak(1, bar1, tfData.Highs[0], tfData.volHighs[0])) ? 1: -1;
         }
         
      }
      
      // BOS Low
      if (tfData.waitingLows == 0 && bar1.low < tfData.Lows[0]) {
         tfData.gTrend = -1;
         tfData.vGTrend = tfData.gTrend;
         tfData.waitingLows = 1;
         textGannLow += "\n---> -G1 Gann. bar1.low ("+DoubleToString(bar1.low, digits)+") > Lows[0] ("+DoubleToString(tfData.Lows[0], digits)+"). => Cap nhat: gTrend = -1, waitingHighs = 1";
         //if (isComment && StringLen(textGannLow) > 0) {
         //   Print(str_gann+textGannLow);
         //}
         if (StringLen(textGannLow) > 0) {
            text_all += str_gann+" (Break) "+textGannLow;
         }
         if (isCHoCHBOSVolume) {
            tfData.vGTrend = (checkVolumeBreak(-1, bar1, tfData.Lows[0], tfData.volLows[0])) ? -1: 1;
         }
         
      }
      // END Gann wave
      
      //reset log
      textInternalLow = "";
      textInternalHigh = "";
      // Internal wave
      // High
      if (tfData.waitingIntSHighs == 0) {
         //1 continue bos 
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == 1 && bar1.high > tfData.intSHighs[0]) {
            tfData.iTrend = 1;
            tfData.vItrend = tfData.iTrend;
            tfData.LastSwingInternal = 1;
            tfData.waitingIntSHighs = 1;
                        
            textInternalHigh += "\n---> I1 Bos High => iTrend = 1 && LastSwingInternal = 1 && bar1.high > tfData.intSHighs[0] => iTrend = 1, LastSwingInternal = 1, waitingIntSHighs = 1";
                        
            if (tfData.iFindTarget != 1) {
               tfData.iFindTarget = 1;
               tfData.iStoploss = tfData.intSLows[0];
               tfData.iStoplossTime = tfData.intSLowTime[0];
               tfData.iTarget = 0;
               tfData.iTargetTime = 0;
               tfData.iSnR = tfData.intSHighs[0];
               textInternalHigh += " | Bos I1";
            }
            
            // CHoCH BoS with volume
            line_target = tfData.vItrend;
            line_dinh = tfData.intSLows[0];
            line_day = tfData.intSHighs[0];
            place_start_line_draw = bar1.high;
            if (isCHoCHBOSVolume) {
               if (checkVolumeBreak(1, bar1, tfData.intSHighs[0], tfData.volIntSHighs[0])) { // break out
                  tfData.vItrend = 1;
                  line_dinh = tfData.intSLows[0];
                  line_day = tfData.intSHighs[0];
                  place_start_line_draw = bar1.high;
               } else { // false break out
                  tfData.vItrend = -1;
                  line_dinh = tfData.intSHighs[0];
                  line_day = tfData.intSLows[0];
                  place_start_line_draw = tfData.intSLows[0];
               }
               line_target = tfData.vItrend;
            }
            isDrawTarget = true;
            // Set new value target zone
            beginSetValueToPoiZone(tfData, tfData.zIntSLows[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setGlobalValueLowToHighTF(tfData);
            // Them moi poizone Internal Bullish
            tfData.AddToPoiZoneArray(tfData.zArrIntBullish, tfData.zIntSLows[0], poi_limit);
            // Ve poizone Internal Bullish trên chart
            if(tfData.isDraw) drawBox("ePOI", tfData.zArrIntBullish[0].time, tfData.zArrIntBullish[0].high, bar1.time, tfData.zArrIntBullish[0].low,1, iColorBull, 1);
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
         
         //3 choch high
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar1.high > tfData.intSHighs[0]) {
            tfData.iTrend = 1;
            tfData.vItrend = tfData.iTrend;
            tfData.LastSwingInternal = 1;
            tfData.waitingIntSHighs = 1;
                        
            textInternalHigh += "\n---> I3 CHoCH High => iTrend = -1 && LastSwingInternal = 1 && bar1.high > intSHighs[0] => iTrend = 1, LastSwingInternal = 1, waitingIntSHighs = 1";
                        
            if (tfData.iFindTarget != 1) {
               tfData.iFindTarget = 1;
               tfData.iStoploss = tfData.intSLows[0];
               tfData.iStoplossTime = tfData.intSLowTime[0];
               tfData.iTarget = 0;
               tfData.iTargetTime = 0;
               tfData.iSnR = tfData.intSHighs[0];
               textInternalHigh += " | CHoCH I3";
            }
            
            // CHoCH BoS with volume
            line_target = tfData.vItrend;
            line_dinh = tfData.intSLows[0];
            line_day = tfData.intSHighs[0];
            place_start_line_draw = bar1.high;
            if (isCHoCHBOSVolume) {
               if (checkVolumeBreak(1, bar1, tfData.intSHighs[0], tfData.volIntSHighs[0])) { // break out
                  tfData.vItrend = 1;
                  line_dinh = tfData.intSLows[0];
                  line_day = tfData.intSHighs[0];
                  place_start_line_draw = bar1.high;
               } else { // false break out
                  tfData.vItrend = -1;
                  line_dinh = tfData.intSHighs[0];
                  line_day = tfData.intSLows[0];
                  place_start_line_draw = tfData.intSLows[0];
               }
               line_target = tfData.vItrend;
            }
            isDrawTarget = true;
            // Set new value target zone
            beginSetValueToPoiZone(tfData, tfData.zIntSLows[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setGlobalValueLowToHighTF(tfData);
            // Them moi poizone Internal Bullish
            tfData.AddToPoiZoneArray(tfData.zArrIntBullish, tfData.zIntSLows[0], poi_limit);
            // Ve poizone Internal Bullish trên chart
            if(tfData.isDraw) drawBox("ePOI", tfData.zArrIntBullish[0].time, tfData.zArrIntBullish[0].high, bar1.time, tfData.zArrIntBullish[0].low,1, iColorBull, 1);
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
         
         // 4 choch high
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == -1 && 
                  ArraySize(tfData.intSHighs) > 1 && bar1.high > tfData.intSHighs[0] && bar1.high > tfData.intSHighs[1]) {
            tfData.iTrend = 1;
            tfData.vItrend = tfData.iTrend;
            tfData.LastSwingInternal = 1;
            tfData.waitingIntSHighs = 1;
                        
            textInternalHigh += "\n---> I45 CHoCH High => iTrend = -1 && LastSwingInternal = -1 && bar1.high > intSHighs[0], intSHighs[1]  => iTrend = 1, LastSwingInternal = 1, waitingIntSHighs = 1";
                                    
            if (tfData.intSHighs[0] < tfData.intSHighs[1]) {
               // Clear Draw intSHigh[0]
               deleteObj(tfData.intSHighTime[0], tfData.intSHighs[0], iWingding_internal_high, "");
               // Sort intSHighs
               tfData.SortDoubleArrayAfterDelete(tfData.intSHighs);
               tfData.SortDateTimeArrayAfterDelete(tfData.intSHighTime);
               tfData.SortLongArrayAfterDelete(tfData.volIntSHighs);
               tfData.SortPoiZoneArrayAfterDelete(tfData.zIntSHighs);
            } else if (tfData.intSHighs[0] > tfData.intSHighs[1]) {
               tfData.AddToDoubleArray(tfData.intSLows, bar1.low);
               tfData.AddToDateTimeArray(tfData.intSLowTime, bar1.time);
               tfData.AddToLongArray(tfData.volIntSLows, bar1.tick_volume);
               // set Zone
               PoiZone zone1 = CreatePoiZone( tfData,bar1.high, bar1.low, bar1.open, bar1.close, bar1.time);
               // them Zone
               tfData.AddToPoiZoneArray(tfData.zIntSLows, zone1, poi_limit);
               tfData.waitingIntSLows = 0 ;
               // ve intslow moi
               drawPointStructure(tfData, -1, bar1.low, bar1.time, INTERNAL_STRUCTURE, false, enabledDraw);
            }
            
            if (tfData.iFindTarget != 1) {
               tfData.iFindTarget = 1;
               tfData.iStoploss = tfData.intSLows[0];
               tfData.iStoplossTime = tfData.intSLowTime[0];
               tfData.iTarget = 0;
               tfData.iTargetTime = 0;
               tfData.iSnR = tfData.intSHighs[0];
               textInternalHigh += " | CHoCH I45";
            }
            // CHoCH BoS with volume
            line_target = tfData.vItrend;
            line_dinh = tfData.intSLows[0];
            line_day = tfData.intSHighs[0];
            place_start_line_draw = bar1.high;
            if (isCHoCHBOSVolume) {
               if (checkVolumeBreak(1, bar1, tfData.intSHighs[0], tfData.volIntSHighs[0])) { // break out
                  tfData.vItrend = 1;
                  line_dinh = tfData.intSLows[0];
                  line_day = tfData.intSHighs[0];
                  place_start_line_draw = bar1.high;
               } else { // false break out
                  tfData.vItrend = -1;
                  line_dinh = tfData.intSHighs[0];
                  line_day = tfData.intSLows[0];
                  place_start_line_draw = tfData.intSLows[0];
               }
               line_target = tfData.vItrend;
            }
            isDrawTarget = true;
            // Set new value target zone
            beginSetValueToPoiZone(tfData, tfData.zIntSLows[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setGlobalValueLowToHighTF(tfData);
            // Them moi poizone Internal Bullish
            tfData.AddToPoiZoneArray(tfData.zArrIntBullish, tfData.zIntSLows[0], poi_limit);
            // Ve poizone Internal Bullish trên chart
            if(tfData.isDraw) drawBox("ePOI", tfData.zArrIntBullish[0].time, tfData.zArrIntBullish[0].high, bar1.time, tfData.zArrIntBullish[0].low,1, iColorBull, 1);
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
         // show draw target line
         if ((showTargetHighTF == true && tfData.isTimeframe == highPairTF) || (showTargetLowTF == true && tfData.isTimeframe == lowPairTF)) {
            if (isDrawInteral == true && isDrawTarget == true) {
               isDrawTarget = false;
               // ve line
               DrawDirectionalSegment(line_target, place_start_line_draw, bar1.time, line_dinh, line_day, tfData.tfColor, 1, 4);
            }
         }
         
         //if (isComment && StringLen(textInternalHigh) > 0) {
         //   Print(str_internal+textInternalHigh);
         //}
         if (StringLen(textInternalHigh) > 0) {
            text_all += str_internal+" (Break) "+textInternalHigh;
         }
      }
      
      // Low
      if (tfData.waitingIntSLows == 0) {
         //1 continue bos 
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == -1 && bar1.low < tfData.intSLows[0]) {
            tfData.iTrend = -1;
            tfData.vItrend = tfData.iTrend;
            tfData.LastSwingInternal = -1;
            tfData.waitingIntSLows = 1;
            
            textInternalLow += "\n---> -I1 Bos Low => iTrend = -1 && LastSwingInternal = -1 && bar1.low < intSLows[0]  => iTrend = -1, LastSwingInternal = -1, waitingIntSLows = 1";
                        
            if (tfData.iFindTarget != -1) {
               tfData.iFindTarget = -1;
               tfData.iStoploss = tfData.intSHighs[0];
               tfData.iStoplossTime = tfData.intSHighTime[0];
               tfData.iTarget = 0;
               tfData.iTargetTime = 0;
               tfData.iSnR = tfData.intSLows[0];
               textInternalLow += " | Bos -I1";
            }
                        
            // CHoCH BoS with volume
            line_target = tfData.vItrend;
            line_dinh = tfData.intSHighs[0];
            line_day = tfData.intSLows[0];
            place_start_line_draw = bar1.low;
            if (isCHoCHBOSVolume) {
               if (checkVolumeBreak(-1, bar1, tfData.intSLows[0], tfData.volIntSLows[0])) { // break out
                  tfData.vItrend = -1;
                  line_dinh = tfData.intSHighs[0];
                  line_day = tfData.intSLows[0];
                  place_start_line_draw = bar1.low;
               } else { // false break out
                  tfData.vItrend = 1;
                  line_dinh = tfData.intSLows[0];
                  line_day = tfData.intSHighs[0];
                  place_start_line_draw = tfData.intSHighs[0];
               }
               line_target = tfData.vItrend;
            }
            isDrawTarget = true;
            
            // Set new value target zone
            beginSetValueToPoiZone(tfData, tfData.zIntSHighs[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setGlobalValueLowToHighTF(tfData);
            // Them moi poizone Internal Bearish
            tfData.AddToPoiZoneArray(tfData.zArrIntBearish, tfData.zIntSHighs[0], poi_limit);
            // Ve poizone Internal Bearish trên chart
            if(tfData.isDraw) drawBox("ePOI", tfData.zArrIntBearish[0].time, tfData.zArrIntBearish[0].low, bar1.time, tfData.zArrIntBearish[0].high,1, iColorBear, 1);
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
         
         //3 choch low
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar1.low < tfData.intSLows[0]) {
            tfData.iTrend = -1;
            tfData.vItrend = tfData.iTrend;
            tfData.LastSwingInternal = -1;
            tfData.waitingIntSLows = 1;
                        
            textInternalLow += "\n---> -I3 CHoCH Low => iTrend = 1 && LastSwingInternal = -1 && bar1.low < intSLows[0]  => iTrend = -1, LastSwingInternal = -1, waitingIntSLows = 1";
            
            if (tfData.iFindTarget != -1) {
               tfData.iFindTarget = -1;
               tfData.iStoploss = tfData.intSHighs[0];
               tfData.iStoplossTime = tfData.intSHighTime[0];
               tfData.iTarget = 0;
               tfData.iTargetTime = 0;
               tfData.iSnR = tfData.intSLows[0];
               textInternalLow += " | CHoCH -I3";
            }
            
            // CHoCH BoS with volume
            line_target = tfData.vItrend;
            line_dinh = tfData.intSHighs[0];
            line_day = tfData.intSLows[0];
            place_start_line_draw = bar1.low;
            if (isCHoCHBOSVolume) {
               if (checkVolumeBreak(-1, bar1, tfData.intSLows[0], tfData.volIntSLows[0])) { // break out
                  tfData.vItrend = -1;
                  line_dinh = tfData.intSHighs[0];
                  line_day = tfData.intSLows[0];
                  place_start_line_draw = bar1.low;
               } else { // false break out
                  tfData.vItrend = 1;
                  line_dinh = tfData.intSLows[0];
                  line_day = tfData.intSHighs[0];
                  place_start_line_draw = tfData.intSHighs[0];
               }
               line_target = tfData.vItrend;
            }
            isDrawTarget = true;
            // Set new value target zone
            beginSetValueToPoiZone(tfData, tfData.zIntSHighs[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setGlobalValueLowToHighTF(tfData);
            // Them moi poizone Internal Bearish
            tfData.AddToPoiZoneArray(tfData.zArrIntBearish, tfData.zIntSHighs[0], poi_limit);
            // Ve poizone Internal Bearish trên chart
            if(tfData.isDraw) drawBox("ePOI", tfData.zArrIntBearish[0].time, tfData.zArrIntBearish[0].low, bar1.time, tfData.zArrIntBearish[0].high,1, iColorBear, 1);
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
         
         // 4+5 choch low
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == 1 && 
                ArraySize(tfData.intSLows) > 1 && bar1.low < tfData.intSLows[0] && bar1.low < tfData.intSLows[1]) {
            tfData.iTrend = -1;
            tfData.vItrend = tfData.iTrend;
            tfData.LastSwingInternal = -1;
            tfData.waitingIntSLows = 1;
                        
            textInternalLow += "\n---> -I45 CHoCH Low => iTrend = 1 && LastSwingInternal = 1 && bar1.low < intSLows[0], intSLows[1]  => iTrend = -1, LastSwingInternal = -1, waitingIntSLows = 1";

            if (tfData.intSLows[0] > tfData.intSLows[1]) {
               // Clear Draw intSHigh[0]
               deleteObj(tfData.intSLowTime[0], tfData.intSLows[0], iWingding_internal_low, "");
               // Sort intSHighs
               tfData.SortDoubleArrayAfterDelete(tfData.intSLows);
               tfData.SortDateTimeArrayAfterDelete(tfData.intSLowTime);
               tfData.SortLongArrayAfterDelete(tfData.volIntSLows);
               tfData.SortPoiZoneArrayAfterDelete(tfData.zIntSLows);
            } else if (tfData.intSHighs[0] > tfData.intSHighs[1]) {
               tfData.AddToDoubleArray(tfData.intSHighs, bar1.high);
               tfData.AddToDateTimeArray(tfData.intSHighTime, bar1.time);
               tfData.AddToLongArray(tfData.volIntSHighs, bar1.tick_volume);
               
               // set Zone
               PoiZone zone1 = CreatePoiZone( tfData,bar1.high, bar1.low, bar1.open, bar1.close, bar1.time);
               // them Zone
               tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone1, poi_limit);
               tfData.waitingIntSHighs = 0;
               // ve intslow moi
               drawPointStructure(tfData, 1, bar1.low, bar1.time, INTERNAL_STRUCTURE, false, enabledDraw);
            }
            
            if (tfData.iFindTarget != -1) {
               tfData.iFindTarget = -1;
               tfData.iStoploss = tfData.intSHighs[0];
               tfData.iStoplossTime = tfData.intSHighTime[0];
               tfData.iTarget = 0;
               tfData.iTargetTime = 0;
               tfData.iSnR = tfData.intSLows[0];
               textInternalLow += " | CHoCH -I45";
            }
            
            // CHoCH BoS with volume
            line_target = tfData.vItrend;
            line_dinh = tfData.intSHighs[0];
            line_day = tfData.intSLows[0];
            place_start_line_draw = bar1.low;
            if (isCHoCHBOSVolume) {
               if (checkVolumeBreak(-1, bar1, tfData.intSLows[0], tfData.volIntSLows[0])) { // break out
                  tfData.vItrend = -1;
                  line_dinh = tfData.intSHighs[0];
                  line_day = tfData.intSLows[0];
                  place_start_line_draw = bar1.low;
               } else { // false break out
                  tfData.vItrend = 1;
                  line_dinh = tfData.intSLows[0];
                  line_day = tfData.intSHighs[0];
                  place_start_line_draw = tfData.intSHighs[0];
               }
               line_target = tfData.vItrend;
            }
            isDrawTarget = true;
            // Set new value target zone
            beginSetValueToPoiZone(tfData, tfData.zIntSHighs[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setGlobalValueLowToHighTF(tfData);
            // Them moi poizone Internal Bearish
            tfData.AddToPoiZoneArray(tfData.zArrIntBearish, tfData.zIntSHighs[0], poi_limit);
            // Ve poizone Internal Bearish trên chart
            if(tfData.isDraw) drawBox("ePOI", tfData.zArrIntBearish[0].time, tfData.zArrIntBearish[0].low, bar1.time, tfData.zArrIntBearish[0].high,1, iColorBear, 1);
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) ss_IntScanActive = true;
         }
         // Show draw target line
         if ((showTargetHighTF == true && tfData.isTimeframe == highPairTF) || (showTargetLowTF == true && tfData.isTimeframe == lowPairTF)) {
            if (isDrawInteral == true && isDrawTarget == true) {
               isDrawTarget = false;
               // ve line
               DrawDirectionalSegment(line_target, place_start_line_draw, bar1.time, line_dinh, line_day, tfData.tfColor, 1, 4);
            }
         }
         
         //if (isComment && StringLen(textInternalLow) > 0) {
         //   Print(str_internal+textInternalLow);
         //}
         if (StringLen(textInternalLow) > 0) {
            text_all += str_internal+" (Break) "+textInternalLow;
         }
      }
      return text_all;
   } //--- End Ham cap nhat cau truc song Gann
   
   //---
   //--- Ham cap nhat cau truc thi truong
   //---
   string updatePointTopBot(TimeFrameData& tfData, MqlRates& bar1, MqlRates& bar2, MqlRates& bar3, bool isComment = false){
      // dinh nghia huong ve line target
      bool isDrawTarget = false;
      int line_target = 0;
      double line_dinh = 0;
      double line_day = 0;
      double place_start_line_draw = 0;
      string str_marjor = "\n# Marjor: ";
      //string textall = "----- updatePointTopBot -----";
      string textall = "";
      string text = "";
      //text +=  "First: " + getValueTrend(tfData);
      //text += "\n"+inInfoBar(bar1, bar2, bar3);
      PoiZone zone2 = CreatePoiZone( tfData,bar2.high, bar2.low, bar2.open, bar2.close, bar2.time);
      long maxVolume = 0;
      
      double barHigh = bar1.high;
      double barLow  = bar1.low;
      datetime barTime = bar1.time;
      
      // Lan dau tien
      if(tfData.sTrend == 0 && tfData.mTrend == 0 && tfData.LastSwingMajor == 0) { //ok
         if (barLow < tfData.arrBot[0]){
            text += "\n-0.1. barLow < arrBot[0]"+" => "+DoubleToString( barLow, digits)+" < "+DoubleToString( tfData.arrBot[0], digits);
            text += " => Cap nhat idmLow = Highs[0] = "+DoubleToString( tfData.Highs[0], digits)+"; sTrend = -1; mTrend = -1; LastSwingMajor = 1;";
            
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            //tfData.vol_L_idmLow = tfData.vol_idmLow;
            
            tfData.idmLow = tfData.Highs[0];
            tfData.idmLowTime = tfData.HighsTime[0];
            tfData.vol_idmLow = tfData.volHighs[0];
            
            tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = 1;
            
         } else if (barHigh > tfData.arrTop[0]) { 
            text += "\n0.1. barHigh > arrTop[0]"+" => "+DoubleToString(barHigh,digits)+" > "+DoubleToString(tfData.arrTop[0], digits);
            text += " => Cap nhat idmHigh = Lows[0] = "+DoubleToString(tfData.Lows[0], digits)+"; sTrend = 1; mTrend = 1; LastSwingMajor = -1;";
            
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.vol_idmHigh = tfData.volLows[0];
            tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = -1;
         }
         //if (isComment && StringLen(text) > 0) {
         //   Print(str_marjor+text);
         //}
      }
      // End Lan dau tien
      
      if (bar3.high <= bar2.high && bar2.high >= bar1.high) { // tim thay dinh high
         
         if (tfData.findHigh == 1 && bar2.high > tfData.H) {
            text += "\n0.2. Find Swing High";
            text += " => findhigh == 1 , H new > H old "+DoubleToString(bar2.high, digits)+" > "+DoubleToString( tfData.H, digits)+". Update new High = "+DoubleToString(bar2.high, digits);
            
            tfData.H = bar2.high;
            tfData.HTime = bar2.time;
            tfData.H_bar = bar2;
            tfData.vol_H = bar2.tick_volume;
         }
         if (isComment && StringLen(text) > 0) {
            Print(str_marjor+text);
         }
      }
      if (bar3.low >= bar2.low && bar2.low <= bar1.low) { // tim thay swing low 
         
         if (tfData.findLow == 1 && bar2.low < tfData.L) {
            text += "\n-0.2. Find Swing Low";
            text += " => findlow == 1 , L new < L old "+DoubleToString(bar2.low, digits)+" < "+DoubleToString( tfData.L, digits)+". Update new Low = "+DoubleToString(bar2.low, digits);
            
            tfData.L = bar2.low;
            tfData.LTime = bar2.time;
            tfData.L_bar = bar2;
            tfData.vol_L = bar2.tick_volume;
         }
         //if (isComment && StringLen(text) > 0) {
         //   Print(str_marjor+text);
         //}
      }
      
      if(tfData.sTrend == 1 && tfData.mTrend == 1) {
         // continue BOS 
         if (tfData.LastSwingMajor == -1 && bar1.high > tfData.arrTop[0] && tfData.arrTop[0] != tfData.arrBoHigh[0]) { // Done
            text += "\n1.1. continue BOS, sTrend == 1 && mTrend == 1 && LastSwingMajor == -1 && bar1.high ("+DoubleToString( bar1.high,digits) +") > arrTop[0] ("+DoubleToString(tfData.arrTop[0], digits)+")";
            text += "\n => Cap nhat: findLow = 0, idmHigh = Lows[0] = "+DoubleToString(tfData.Lows[0], digits)+" ; sTrend == 1; mTrend == 1; LastSwingMajor == 1;";
            text += " => New arrBoHigh = arrTop[0] = " + DoubleToString(tfData.arrTop[0],digits) + "; New arrBot = intSLows[0] = " + DoubleToString( tfData.intSLows[0],digits);
            // Add new point swing
            tfData.AddToDoubleArray(tfData.arrBoHigh, tfData.arrTop[0]);
            tfData.AddToDateTimeArray(tfData.arrBoHighTime, tfData.arrTopTime[0]);
            tfData.AddToLongArray(tfData.volArrBoHigh, tfData.volArrTop[0]);
            
            tfData.AddToDoubleArray(tfData.arrBot, tfData.intSLows[0]);
            tfData.AddToDateTimeArray(tfData.arrBotTime, tfData.intSLowTime[0]);
            tfData.AddToLongArray(tfData.volArrBot, tfData.volIntSLows[0]);
            
            // add zone POI Bullish
            tfData.AddToPoiZoneArray(tfData.zArrBot, tfData.zIntSLows[0], limit);
            // Add Zone
            tfData.AddToPoiZoneArray(tfData.zPoiLow, tfData.zIntSLows[0], limit);
            // Todo chuan hoa internal zone
            
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = 1;
            tfData.findLow = 0; 
            tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.vol_idmHigh = tfData.volLows[0];
            //if (isComment && StringLen(text) > 0) {
            //   Print(str_marjor+text);
            //}
            //// BOS High by volume 
            //if (tfData.waitingArrTop == 0) {
            //   tfData.vMTrend = tfData.mTrend;
            //   tfData.waitingArrTop = 1;
            //   if (isCHoCHBOSVolume) tfData.vMTrend = (checkVolumeBreak(1, bar1, tfData.arrTop[0], tfData.volArrTop[0])) ? 1: -1;
            //   tfData.vSTrend = tfData.vMTrend;
            //}
         }
         
         if (bar3.high <= bar2.high && bar2.high >= bar1.high) { // tim thay dinh high 
            if (typeTickVolume == 1) {
               maxVolume = bar2.tick_volume;
            } else {
               maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
            }
            // continue BOS swing high
            if (tfData.LastSwingMajor == 1 && bar2.high > tfData.arrTop[0]) {
               text += "\n1.2. swing high, sTrend == 1 && mTrend == 1 && LastSwingMajor == 1 && bar2.high ("+DoubleToString(bar2.high, digits)+") > arrTop[0] ("+DoubleToString(tfData.arrTop[0], digits)+")";
               text += "\n=> Cap nhat: arrTop[0] = bar2.high = "+DoubleToString(bar2.high, digits)+" ; sTrend == 1; mTrend == 1; LastSwingMajor == -1;";
               // Update Array Top[0]
               if(tfData.arrTop[0] != bar2.high) {
                  // Add new 
                  tfData.AddToDoubleArray( tfData.arrTop, bar2.high);
                  tfData.AddToDateTimeArray( tfData.arrTopTime, bar2.time);
                  tfData.AddToLongArray(tfData.volArrTop, maxVolume);
                  
                  // add new Zone
                  tfData.AddToPoiZoneArray( tfData.zArrTop, zone2, limit);
                  // cap nhat waiting top
                  tfData.waitingArrTop = 0;
               } 
               
               tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = -1;
               //if (isComment && StringLen(text) > 0) {
               //   Print(str_marjor+text);
               //}
            }
            // HH > HH 
            if (tfData.LastSwingMajor == -1 && bar2.high > tfData.arrTop[0]) {
               text += "\n1.3. sTrend == 1 && mTrend == 1 && LastSwingMajor == -1 && bar2.high > arrTop[0]";
               text += "\n=> Xoa label, Cap nhat: arrTop[0] = bar2.high = "+DoubleToString(bar2.high, digits)+" ; sTrend == 1; mTrend == 1; LastSwingMajor == -1;";
               
               // Update Array Top[0] , conditions : L new != L old
               if(tfData.arrTop[0] != bar2.high) {
                  // update point
                  tfData.UpdateDoubleArray(tfData.arrTop, 0, bar2.high);
                  tfData.UpdateDateTimeArray(tfData.arrTopTime, 0, bar2.time);
                  tfData.UpdateLongArray(tfData.volArrTop, 0, maxVolume);
                  // cap nhat Zone
                  tfData.UpdatePoiZoneArray( tfData.zArrTop, 0, zone2);
                  // cap nhat waiting top
                  tfData.waitingArrTop = 0;
               }
               tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = -1;
               //if (isComment && StringLen(text) > 0) {
               //   Print(str_marjor+text);
               //}
            }
         }
         
         //Cross IDM
         if (  
            //tfData.LastSwingMajor == 1 && 
            tfData.findLow == 0 && bar1.low < tfData.idmHigh) {
            text += "\n1.4. Cross IDM Uptrend.  sTrend == 1 && mTrend == 1 && LastSwingMajor == random && bar1.low < idmHigh : " + DoubleToString(bar1.low, digits) + "<" + DoubleToString(tfData.idmHigh, digits);
            // Kiem tra xem bar1.high > arrTop[0] hay khong
            if (bar1.high > tfData.arrTop[0]) {
               // New arrBot
               tfData.AddToDoubleArray(tfData.arrTop, bar1.high);
               tfData.AddToDateTimeArray(tfData.arrTopTime, bar1.time);
               tfData.AddToLongArray(tfData.volArrTop, bar1.tick_volume);
            }
            // cap nhat arPBHighs
            if(tfData.arrTop[0] != tfData.arrPbHigh[0]) {
               // Add new 
               tfData.AddToDoubleArray( tfData.arrPbHigh, tfData.arrTop[0]);
               tfData.AddToDateTimeArray( tfData.arrPbHTime, tfData.arrTopTime[0]);
               tfData.AddToLongArray( tfData.volArrPbHigh, tfData.volArrTop[0]);
               // add new zone
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, tfData.zArrTop[0], limit); 
               // cap nhat waiting pb high
               tfData.waitingArrPbHigh = 0;
            }
            text += "\n Cap nhat: New arrPbHigh = arrTop[0] = "+ DoubleToString(tfData.arrTop[0], digits);
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(IDM_TEXT, tfData.idmHighTime, tfData.idmHigh, bar1.time, tfData.idmHigh, 1, IDM_TEXT, tfData.tfColor, STYLE_DOT);
            text += "\n => Cap nhat findLow = 1; L = bar1.low = "+ DoubleToString(bar1.low, digits);
            
            // active find Low
            tfData.findLow = 1;
            tfData.L = bar1.low; tfData.LTime = bar1.time; tfData.vol_L = bar1.tick_volume;
            tfData.L_bar = bar1; 
            tfData.findHigh = 0; tfData.H = 0; tfData.vol_H = 0;
            
            if (tfData.mFindTarget == 1) {
               tfData.mTarget = tfData.arrPbHigh[0];
               tfData.mTargetTime = tfData.arrPbHTime[0];
               tfData.mFindTarget = 0;
               text += " | Cross IDM Uptrend M1.4";
            }
            
            // Quét toàn bộ các vùng POI để Trade theo Order Block, Order Flow
            tfData.scanPoiZoneLastTime(tfData, 1);
            drawMarjorTradeZone(tfData, bar1);
            //if (isComment && StringLen(text) > 0) {
            //   Print(str_marjor+text);
            //}
         }
         
         // CHoCH Low
         if (
            //tfData.LastSwingMajor == 1 && 
            bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n1.5 sTrend == 1 && mTrend == 1 && LastSwingMajor == random && bar1.low ("+DoubleToString( bar1.low, digits) + ") < arrPbLow[0] ("+ DoubleToString(tfData.arrPbLow[0], digits)+")";
            text += "\n => Cap nhat => Ve line. sTrend = -1; mTrend = -1; LastSwingMajor = -1; findHigh = 0; idmLow = Highs[0]= "+ DoubleToString( tfData.Highs[0], digits);
            text += "\n => Cap nhat => New arrChoLow: = arrPbLow[0] = "+ DoubleToString(tfData.arrPbLow[0], digits);
            
            // draw choch Low
            drawLine(CHOCH_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], barTime, tfData.arrPbLow[0], 1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);

            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            tfData.AddToLongArray( tfData.volArrChoLow, tfData.volArrPbLow[0]);
         
            //text += "\n => Cap nhat => POI Bearish : arrPbHigh[0] "+ DoubleToString(tfData.arrPbHigh[0], digits);
            
            tfData.LastSwingMajor = -1;
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = -1;
            tfData.findHigh = 0; 
            tfData.findLow = 0;
            tfData.idmLow = tfData.Highs[0]; tfData.idmLowTime = tfData.HighsTime[0]; tfData.vol_idmLow = tfData.volHighs[0];
            
            if (tfData.mFindTarget != -1) {
               tfData.mFindTarget = -1;
               tfData.mStoploss = tfData.arrPbHigh[0];
               tfData.mStoplossTime = tfData.arrPbHTime[0];
               tfData.mTarget = 0;
               tfData.mTargetTime = 0;
               tfData.mSnR = tfData.arrPbLow[0];
               text += " | CHoCH Low M1.5";
            }
            
            //if (isComment && StringLen(text) > 0) {
            //   Print(str_marjor+text);
            //}
            
            // CHoCH with Volume
            if (tfData.waitingArrPbLows == 0) {
               tfData.vSTrend = tfData.sTrend;
               tfData.vMTrend = tfData.mTrend;
               tfData.waitingArrPbLows = 1;
               line_target = tfData.sTrend;
               line_dinh = tfData.arrPbHigh[0];
               line_day = tfData.arrPbLow[0];
               place_start_line_draw = bar1.low;
               if (isCHoCHBOSVolume) {
                  // is breakout ?
                  if (checkVolumeBreak(-1, bar1, tfData.arrPbLow[0], tfData.volArrPbLow[0])) {
                     tfData.vSTrend = -1;
                     line_dinh = tfData.arrPbHigh[0];
                     line_day = tfData.arrPbLow[0];
                     place_start_line_draw = bar1.low;
                  } else { // false breakout
                     tfData.vSTrend = 1;
                     line_dinh = tfData.arrPbLow[0];
                     line_day = tfData.arrPbHigh[0];
                     place_start_line_draw = tfData.arrPbHigh[0];
                  }
                  tfData.vMTrend = tfData.vSTrend;
                  line_target = tfData.vSTrend;
               } 
            }
            isDrawTarget = true;
            
         }
         
         // continue Up, Continue BOS up
         if (
            //tfData.LastSwingMajor == -1 && 
            bar1.high > tfData.arrPbHigh[0] && tfData.arrPbHigh[0] != tfData.arrChoHigh[0]) {
            text += "\n1.6 Continue Bos UP. sTrend == 1 && mTrend == 1 && LastSwingMajor == random && bar1.high > arrPbHigh && arrPbHigh: "+
                     DoubleToString(tfData.arrPbHigh[0], digits) + " != arrChoHigh[0]: "+DoubleToString( tfData.arrChoHigh[0], digits);
            text += "---> Update: arrChoHigh[0] = "+ DoubleToString(tfData.arrPbHigh[0], digits);
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoHigh, tfData.arrPbHigh[0]);
            tfData.AddToDateTimeArray( tfData.arrChoHighTime, tfData.arrPbHTime[0]);
            tfData.AddToLongArray( tfData.volArrChoHigh, tfData.volArrPbHigh[0]);
            
            // update Point HL
            if (tfData.L != 0 && (tfData.L != tfData.arrPbLow[0] || (tfData.L == tfData.arrPbLow[0] && tfData.LTime != tfData.arrPbLTime[0]))) {
               text += "\n----> IF: L != 0 && L != arrPbLow[0]("+DoubleToString(tfData.arrPbLow[0], digits)+") => Update: New arrPbLow[0] = "+DoubleToString( tfData.L, digits);
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbLow, tfData.L);
               tfData.AddToDateTimeArray( tfData.arrPbLTime, tfData.LTime);
               tfData.AddToLongArray( tfData.volArrPbLow, tfData.vol_L);
               // Add new zone
               MqlRates bar_tmp = tfData.L_bar;
               PoiZone zone_tmp = CreatePoiZone( tfData,bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, zone_tmp, limit);
               // update waiting arr pblow
               tfData.waitingArrPbLows = 0;
            }
            
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(BOS_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, BOS_TEXT, tfData.tfColor, STYLE_SOLID);
            
            text += "\n--> Cap nhat POI Bullish: L_idmHigh = idmHigh = "+DoubleToString(tfData.idmHigh, digits);
                     
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.findLow = 0; 
            tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.vol_idmHigh = tfData.volLows[0]; 
            tfData.L = 0; tfData.vol_L = 0;
            text += ", findLow = 0, idmHigh = "+DoubleToString(tfData.Lows[0], digits)+", L = 0";
            
            if (tfData.mFindTarget != 1) {
               tfData.mFindTarget = 1;
               tfData.mStoploss = tfData.arrPbLow[0];
               tfData.mStoplossTime = tfData.arrPbLTime[0];
               tfData.mTarget = 0;
               tfData.mTargetTime = 0;
               tfData.mSnR = tfData.arrPbHigh[0];
               text += " | Continue BOS High M1.6";
            }
            
            //if (isComment && StringLen(text) > 0) {
            //   Print(str_marjor+text);
            //}
            // CHoCH High with Volume
            if (tfData.waitingArrPbHigh == 0) {
               tfData.vMTrend = tfData.mTrend;
               tfData.waitingArrPbHigh = 1;
               line_target = tfData.vMTrend;
               line_dinh = tfData.arrPbLow[0];
               line_day = tfData.arrPbHigh[0];
               place_start_line_draw = bar1.high;
               if (isCHoCHBOSVolume) {
                  // is breakout ?
                  if (checkVolumeBreak(1, bar1, tfData.arrPbHigh[0], tfData.volArrPbHigh[0])) {
                     tfData.vMTrend = 1;
                     line_dinh = tfData.arrPbLow[0];
                     line_day = tfData.arrPbHigh[0];
                     place_start_line_draw = bar1.high;
                  } else { // false breakout
                     tfData.vMTrend = -1;
                     line_dinh = tfData.arrPbHigh[0];
                     line_day = tfData.arrPbLow[0];
                     place_start_line_draw = tfData.arrPbLow[0];
                  }
                  tfData.vSTrend = tfData.vMTrend;
                  line_target = tfData.vMTrend;
               } 
            }
            isDrawTarget = true;
            
         }
      }
   
      if(tfData.sTrend == 1 && tfData.mTrend == -1) {
         // continue Up, Continue Choch up
         if (tfData.LastSwingMajor == -1 && bar1.high > tfData.arrPbHigh[0] && tfData.arrPbHigh[0] != tfData.arrChoHigh[0]) {
            text += "\n2.1 CHoCH up. sTrend == 1 && mTrend == -1 && LastSwingMajor == -1 && bar1.high > arrPbHigh[0]";
            
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
               PoiZone zone_tmp = CreatePoiZone( tfData,bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, zone_tmp, limit);
               // update waiting pb low
               tfData.waitingArrPbLows = 0;
            }
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(CHOCH_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);
            text += "\n => Cap nhat => POI Bullish : L = "+ DoubleToString( tfData.L, digits);
            
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.findLow = 0; 
            tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.vol_idmHigh = tfData.volLows[0];
            tfData.L = 0; tfData.vol_L = 0;
            
            if (tfData.mFindTarget != 1) {
               tfData.mFindTarget = 1;
               tfData.mStoploss = tfData.arrPbLow[0];
               tfData.mStoplossTime = tfData.arrPbLTime[0];
               tfData.mTarget = 0;
               tfData.mTargetTime = 0;
               tfData.mSnR = tfData.arrPbHigh[0];
               text += " | CHoCH up M2.1";
            }
            
            //if (isComment && StringLen(text) > 0) {
            //   Print(str_marjor+text);
            //}
            // CHoCH High with Volume
            if (tfData.waitingArrPbHigh == 0) {
               tfData.vSTrend = tfData.sTrend;
               tfData.waitingArrPbHigh = 1;
               if (isCHoCHBOSVolume) {
                  tfData.vSTrend = (checkVolumeBreak(1, bar1, tfData.arrPbHigh[0], tfData.volArrPbHigh[0])) ? 1: -1;
                  tfData.vMTrend = tfData.vSTrend;
               } 
            }
            
         }
           
         // CHoCH DOwn. 
         if (tfData.LastSwingMajor == -1 && bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n2.2 sTrend == 1 && mTrend == -1 && LastSwingMajor == -1 && bar1.low < arrPbLow[0] : " + DoubleToString(bar1.low, digits) + "<" + DoubleToString(tfData.arrPbLow[0], digits);
            text += "\n => Cap nhat => sTrend = -1; mTrend = -1; LastSwingMajor = -1; findHigh = 0; idmLow = Highs[0] = "+DoubleToString(tfData.Highs[0], digits);
            text += "\n => Cap nhat => POI Bearish = arrPbHigh[0] : "+ DoubleToString(tfData.arrPbHigh[0], digits);
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            tfData.AddToLongArray( tfData.volArrChoLow, tfData.volArrPbLow[0]);
            // draw choch low
            drawLine(CHOCH_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], bar1.time, tfData.arrPbLow[0], 1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);
                     
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = -1;
            tfData.findHigh = 0; 
            tfData.idmLow = tfData.Highs[0]; tfData.idmLowTime = tfData.HighsTime[0]; tfData.vol_idmLow = tfData.volHighs[0];
            
            if (tfData.mFindTarget != -1) {
               tfData.mFindTarget = -1;
               tfData.mStoploss = tfData.arrPbHigh[0];
               tfData.mStoplossTime = tfData.arrPbHTime[0];
               tfData.mTarget = 0;
               tfData.mTargetTime = 0;
               tfData.mSnR = tfData.arrPbLow[0];
               text += " | CHoCH Down M2.2";
            }
            
            //if (isComment && StringLen(text) > 0) {
            //   Print(str_marjor+text);
            //}
            // CHoCH Low with Volume
            if (tfData.waitingArrPbHigh == 0) {
               tfData.vSTrend = tfData.sTrend;
               tfData.vMTrend = tfData.mTrend;
               tfData.waitingArrPbHigh = 1;
               if (isCHoCHBOSVolume) {
                  tfData.vSTrend = (checkVolumeBreak(1, bar1, tfData.arrPbHigh[0], tfData.volArrPbHigh[0])) ? -1: 1;
                  tfData.vMTrend = tfData.vSTrend;
               } 
            }
            
         }
      }
      
      if(tfData.sTrend == -1 && tfData.mTrend == -1) {
         // continue BOS 
         if (tfData.LastSwingMajor == 1 && bar1.low < tfData.arrBot[0] && tfData.arrBot[0] != tfData.arrBoLow[0]) { // Done
            text += "\n-3.1. continue BOS, sTrend == -1 && mTrend == -1 && LastSwingMajor == 1 && bar1.low ("+ DoubleToString(bar1.low, digits) +") < arrBot[0] ("+DoubleToString( tfData.arrBot[0], digits)+")";
            text += "\n => Cap nhat: findHigh = 0, idmLow = Highs[0] = "+DoubleToString( tfData.Highs[0], digits)+" ; sTrend == -1; mTrend == -1; LastSwingMajor == -1;";
            text += " => New arrBoLow = arrBot[0] = " + DoubleToString(tfData.arrBot[0],digits) + "; New arrTop = intSHighs[0] = " + DoubleToString(tfData.intSHighs[0],digits);               
            // Add new point
            tfData.AddToDoubleArray( tfData.arrBoLow, tfData.arrBot[0]);
            tfData.AddToDateTimeArray( tfData.arrBoLowTime, tfData.arrBotTime[0]);
            tfData.AddToLongArray( tfData.volArrBoLow, tfData.volArrBot[0]);
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrTop, tfData.intSHighs[0]);
            tfData.AddToDateTimeArray( tfData.arrTopTime, tfData.intSHighTime[0]);
            tfData.AddToLongArray( tfData.volArrTop, tfData.volIntSHighs[0]);
            
            // Add new zone POI Bearish
            tfData.AddToPoiZoneArray( tfData.zArrTop, tfData.zIntSHighs[0], limit); 
            // Add new zone
            tfData.AddToPoiZoneArray( tfData.zPoiHigh, tfData.zIntSHighs[0], limit); 
            // Todo chuan hoa internal zone
                                 
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = -1;
            tfData.findHigh = 0; 
            tfData.idmLow = tfData.Highs[0]; tfData.idmLowTime = tfData.HighsTime[0]; tfData.vol_idmLow = tfData.volHighs[0];
            
            // update waiting arr top
            tfData.waitingArrTop = 0;
//            
//            if (isComment && StringLen(text) > 0) {
//               Print(str_marjor+text);
//            }
            //// Bos Low with Volume
            //if (tfData.waitingArrBot == 0) {
            //   tfData.vSTrend = tfData.sTrend;
            //   tfData.waitingArrBot = 1;
            //   if (isCHoCHBOSVolume) {
            //      tfData.vSTrend = (checkVolumeBreak(-1, bar1, tfData.arrBot[0], tfData.volArrBot[0])) ? -1: 1;
            //   } 
            //   tfData.vMTrend = tfData.vSTrend;
            //}
         }
         
         if (bar3.low >= bar2.low && bar2.low <= bar1.low) { // tim thay swing low 
            if (typeTickVolume == 1) {
               maxVolume = bar2.tick_volume;
            } else {
               maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
            }
            // continue BOS swing low
            if (tfData.LastSwingMajor == -1 && bar2.low < tfData.arrBot[0]) {
               text += "\n-3.2. swing low, sTrend == -1 && mTrend == -1 && LastSwingMajor == -1 && bar2.low ("+DoubleToString(bar2.low, digits)+") < arrBot[0] ("+DoubleToString( tfData.arrBot[0], digits)+")";
               text += "\n=> Cap nhat: arrBot[0] = bar2.low = "+DoubleToString(bar2.low, digits)+" ; sTrend == -1; mTrend == -1; LastSwingMajor == 1;";
               
               // Update ArrayBot[0]
               if(tfData.arrBot[0] != bar2.low) {                                 
                  // Add new point
                  tfData.AddToDoubleArray( tfData.arrBot, bar2.low);
                  tfData.AddToDateTimeArray( tfData.arrBotTime, bar2.time);
                  tfData.AddToLongArray( tfData.volArrBot, maxVolume);
                  // Add new zone
                  tfData.AddToPoiZoneArray( tfData.zArrBot, zone2, limit); 
                  // cap nhat waiting arrBot
                  tfData.waitingArrBot = 0;
               }
               tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = 1;
               //if (isComment && StringLen(text) > 0) {
               //   Print(str_marjor+text);
               //}
            }
   
            // LL < LL
            if (tfData.LastSwingMajor == 1 && bar2.low < tfData.arrBot[0]) {
               text += "\n-3.3. sTrend == -1 && mTrend == -1 && LastSwingMajor == 1 && bar2.low < arrBot[0]";
               text += "\n=> Xoa label, Cap nhat: arrBot[0] = bar2.low = "+DoubleToString(bar2.low, digits)+" ; sTrend == -1; mTrend == -1; LastSwingMajor == 1;";
               
               // Update ArrayBot[0]
               if(tfData.arrBot[0] != bar2.low) {
                  // Update point
                  tfData.UpdateDoubleArray( tfData.arrBot, 0, bar2.low);
                  tfData.UpdateDateTimeArray( tfData.arrBotTime, 0, bar2.time);
                  tfData.UpdateLongArray( tfData.volArrBot, 0, maxVolume);
                  // Update zone
                  tfData.UpdatePoiZoneArray( tfData.zArrBot, 0, zone2);
                  // cap nhat waiting arrBot
                  tfData.waitingArrBot = 0;
               }
               tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = 1;   
               //if (isComment && StringLen(text) > 0) {
               //   Print(str_marjor+text);
               //}
            }
         }
      
         //Cross IDM
         if (
            //tfData.LastSwingMajor == -1 && 
            tfData.findHigh == 0 && bar1.high > tfData.idmLow) {
            text += "\n-3.4. Cross IDM Downtrend, sTrend == -1 && mTrend == -1 && LastSwingMajor == random && bar1.high > idmLow :" + DoubleToString(bar1.high, digits) + ">" + DoubleToString( tfData.idmLow,digits);
            // Kiem tra xem bar1.low < arrBot[0] hay khong
            if (bar1.low < tfData.arrBot[0]) {
               // New arrBot
               tfData.AddToDoubleArray(tfData.arrBot, bar1.low);
               tfData.AddToDateTimeArray(tfData.arrBotTime, bar1.time);
               tfData.AddToLongArray(tfData.volArrBot, bar1.tick_volume);
            }
            // cap nhat arPBLows
            if(tfData.arrBot[0] != tfData.arrPbLow[0]){            
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbLow, tfData.arrBot[0]);
               tfData.AddToDateTimeArray( tfData.arrPbLTime, tfData.arrBotTime[0]);
               tfData.AddToLongArray( tfData.volArrPbLow, tfData.volArrBot[0]);
               // Add new zone
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, tfData.zArrBot[0], limit);
               // update waiting arr pb low
               tfData.waitingArrPbLows = 0;
            } 
            text += "\n Cap nhat: New arrPbLow = arrBot[0] = "+ DoubleToString( tfData.arrBot[0], digits);
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(IDM_TEXT, tfData.idmLowTime, tfData.idmLow, bar1.time, tfData.idmLow, -1, IDM_TEXT, tfData.tfColor, STYLE_DOT);
            text += "\n => Cap nhat findHigh = 1; H = bar1.high = "+ DoubleToString(bar1.high, digits);
            
            // active find High
            tfData.findHigh = 1; 
            tfData.H = bar1.high; tfData.HTime = bar1.time; tfData.vol_H = bar1.tick_volume;
            tfData.H_bar = bar1;
            tfData.findLow = 0; tfData.L = 0; tfData.vol_L = 0;
            
            if (tfData.mFindTarget == -1) {
               tfData.mTarget = tfData.arrPbLow[0];
               tfData.mTargetTime = tfData.arrPbLTime[0];
               tfData.mFindTarget = 0;
               text += " | Cross IDM Uptrend M-3.4";
            }
            
            // Quét toàn bộ các vùng POI để Trade theo Order Block, Order Flow
            tfData.scanPoiZoneLastTime(tfData, -1);
            drawMarjorTradeZone(tfData, bar1);
            //if (isComment && StringLen(text) > 0) {
            //   Print(str_marjor+text);
            //}
         }
         
         // CHoCH High
         if (
            //tfData.LastSwingMajor == -1 && 
            bar1.high > tfData.arrPbHigh[0] && tfData.arrPbHigh[0] != tfData.arrChoHigh[0]) {
            text += "\n-3.5 sTrend == -1 && mTrend == -1 && LastSwingMajor == random && bar1.high ("+ DoubleToString(bar1.high, digits) +") > arrPbHigh[0] ("+ DoubleToString(tfData.arrPbHigh[0], digits)+")";
            text += "\n => Cap nhat => Ve line. sTrend = 1; mTrend = 1; LastSwingMajor = 1; findLow = 0; idmHigh = Lows[0] = "+DoubleToString(tfData.Lows[0], digits);
            text += "\n => Cap nhat => New arrChoHigh: = arrPbHigh[0] = "+ DoubleToString(tfData.arrPbHigh[0], digits);
                        
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
            tfData.findLow = 0;
            tfData.findHigh = 0; 
            tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.vol_idmHigh = tfData.volLows[0];
            
            if (tfData.mFindTarget != 1) {
               tfData.mFindTarget = 1;
               tfData.mStoploss = tfData.arrPbLow[0];
               tfData.mStoplossTime = tfData.arrPbLTime[0];
               tfData.mTarget = 0;
               tfData.mTargetTime = 0;
               tfData.mSnR = tfData.arrPbHigh[0];
               text += " | CHoCH High M-3.5";
            }
            
            //if (isComment && StringLen(text) > 0) {
            //   Print(str_marjor+text);
            //}
            
            // CHoCH High with Volume
            if (tfData.waitingArrPbHigh == 0) {
               tfData.vSTrend = tfData.sTrend;
               tfData.vMTrend = tfData.mTrend;
               tfData.waitingArrPbHigh = 1;
               line_target = tfData.sTrend;
               line_dinh = tfData.arrPbLow[0];
               line_day = tfData.arrPbHigh[0];
               place_start_line_draw = bar1.high;
               if (isCHoCHBOSVolume) {
                  // is breakout ?
                  if (checkVolumeBreak(1, bar1, tfData.arrPbHigh[0], tfData.volArrPbHigh[0])) {
                     tfData.vSTrend = 1;
                     line_dinh = tfData.arrPbLow[0];
                     line_day = tfData.arrPbHigh[0];
                     place_start_line_draw = bar1.high;
                  } else { // false breakout
                     tfData.vSTrend = -1;
                     line_dinh = tfData.arrPbHigh[0];
                     line_day = tfData.arrPbLow[0];
                     place_start_line_draw = tfData.arrPbLow[0];
                  }
                  tfData.vMTrend = tfData.vSTrend;
                  line_target = tfData.vSTrend;
               } 
            }
            isDrawTarget = true;
            
         }
         
         // continue Down, Continue BOS down
         if (
            //tfData.LastSwingMajor == 1 && 
            bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n-3.6 Continue Bos DOWN. sTrend == -1 && mTrend == -1 & LastSwingMajor == random && bar1.low < arrPbLow[0] ("+DoubleToString(tfData.arrPbLow[0], digits)+")"+
                     "&& arrPbLow[0] != arrChoLow[0] ("+DoubleToString(tfData.arrChoLow[0], digits)+")";
            text += "---> Update: arrChoLow[0] = "+ DoubleToString(tfData.arrPbLow[0], digits);
                                    
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            tfData.AddToLongArray( tfData.volArrChoLow, tfData.volArrPbLow[0]);
                        
            // update Point LH         
            if (tfData.H != 0 && (tfData.H != tfData.arrPbHigh[0] || (tfData.H == tfData.arrPbHigh[0] && tfData.HTime != tfData.arrPbHTime[0]))) {
               text += "\n----> IF: H != 0 && H != arrPbHigh[0]("+DoubleToString(tfData.arrPbHigh[0],digits)+") => Update: New arrPbHigh[0] = "+DoubleToString(tfData.H,digits);
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbHigh, tfData.H);
               tfData.AddToDateTimeArray( tfData.arrPbHTime, tfData.HTime);
               tfData.AddToLongArray( tfData.volArrPbHigh, tfData.vol_H);
               // Add new zone
               MqlRates bar_tmp = tfData.H_bar;
               PoiZone zone_tmp = CreatePoiZone( tfData,bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, zone_tmp, limit);
               
               // update waiting arrPbHigh
               tfData.waitingArrPbHigh = 0;
            }
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(BOS_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], bar1.time, tfData.arrPbLow[0], 1, BOS_TEXT, tfData.tfColor, STYLE_SOLID);
            
            text += "\n--> Cap nhat POI Bearish: L_idmLow = idmLow = "+DoubleToString(tfData.idmLow,digits);
                     
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.findHigh = 0; 
            tfData.idmLow = tfData.Highs[0]; tfData.idmLowTime = tfData.HighsTime[0]; tfData.vol_idmLow = tfData.volHighs[0];
            tfData.H = 0; tfData.vol_H = 0; 
            text += ", findHigh = 0, idmLow = "+DoubleToString( tfData.Highs[0], digits)+", H = 0";
            
            if (tfData.mFindTarget != -1) {
               tfData.mFindTarget = -1;
               tfData.mStoploss = tfData.arrPbHigh[0];
               tfData.mStoplossTime = tfData.arrPbHTime[0];
               tfData.mTarget = 0;
               tfData.mTargetTime = 0;
               tfData.mSnR = tfData.arrPbLow[0];
               text += " | Continue BOS Low M-3.6";
            }
            
            //if (isComment && StringLen(text) > 0) {
            //   Print(str_marjor+text);
            //}
            
            // CHoCH with Volume
            if (tfData.waitingArrPbLows == 0) {
               tfData.vMTrend = tfData.mTrend;
               tfData.waitingArrPbLows = 1;
               line_target = tfData.vMTrend;
               line_dinh = tfData.arrPbHigh[0];
               line_day = tfData.arrPbLow[0];
               place_start_line_draw = bar1.low;
               if (isCHoCHBOSVolume) {
                  // is breakout ?
                  if (checkVolumeBreak(-1, bar1, tfData.arrPbLow[0], tfData.volArrPbLow[0])) {
                     tfData.vMTrend = -1;
                     line_dinh = tfData.arrPbHigh[0];
                     line_day = tfData.arrPbLow[0];
                     place_start_line_draw = bar1.low;
                  } else { // false breakout
                     tfData.vMTrend = 1;
                     line_dinh = tfData.arrPbLow[0];
                     line_day = tfData.arrPbHigh[0];
                     place_start_line_draw = tfData.arrPbHigh[0];
                  }
                  tfData.vSTrend = tfData.vMTrend;
                  line_target = tfData.vMTrend;
               } 
            }
            isDrawTarget = true;
            
         }
         
      }
      if (tfData.sTrend == -1 && tfData.mTrend == 1) {
         // continue Down, COntinue Choch down
         if (tfData.LastSwingMajor == 1 && bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n-4.1 CHoCH Down sTrend == -1 && mTrend == 1 && LastSwingMajor == 1 && bar1.low < arPbLow[0]";
                          
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
               PoiZone zone_tmp = CreatePoiZone( tfData,bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, zone_tmp, limit); 
               // update waiting arrPbHigh
               tfData.waitingArrPbHigh = 0;
            }
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(CHOCH_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], bar1.time, tfData.arrPbLow[0], 1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);
            
            text += "\n => Cap nhat => POI bearish H: "+DoubleToString( tfData.H, digits);
            
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.findHigh = 0; 
            tfData.idmLow = tfData.Highs[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.vol_idmLow = tfData.volHighs[0];
            tfData.H = 0; tfData.vol_H = 0;
            
            if (tfData.mFindTarget != -1) {
               tfData.mFindTarget = -1;
               tfData.mStoploss = tfData.arrPbHigh[0];
               tfData.mStoplossTime = tfData.arrPbHTime[0];
               tfData.mTarget = 0;
               tfData.mTargetTime = 0;
               tfData.mSnR = tfData.arrPbLow[0];
               text += " | CHoCH Low M-4.1";
            }
            
            //if (isComment && StringLen(text) > 0) {
            //   Print(str_marjor+text);
            //}
            // CHoCH Low with Volume
            if (tfData.waitingArrPbLows == 0) {
               tfData.vSTrend = tfData.sTrend;
               tfData.vMTrend = tfData.mTrend;
               tfData.waitingArrPbLows = 1;
               if (isCHoCHBOSVolume) {
                  tfData.vSTrend = (checkVolumeBreak(-1, bar1, tfData.arrPbLow[0], tfData.volArrPbLow[0])) ? -1: 1;
                  tfData.vMTrend = tfData.vSTrend;
               } 
            }
            
         }
         // CHoCH Up. 
         if (tfData.LastSwingMajor == 1 && bar1.high > tfData.arrPbHigh[0] && tfData.arrPbHigh[0] != tfData.arrChoHigh[0]) {
               
            text += "\n-4.2 sTrend == -1 && mTrend == 1 && LastSwingMajor == 1 && bar1.high > arrPbHigh[0] : " + DoubleToString(bar1.high, digits) + ">" +DoubleToString(tfData.arrPbHigh[0], digits);
            text += "\n => Cap nhat => sTrend = 1; mTrend = 1; LastSwingMajor = 1; findLow = 0; idmHigh = Lows[0] = "+DoubleToString(tfData.Lows[0], digits);
            text += "\n => Cap nhat => POI Bullish = arrPbLow[0] : "+ DoubleToString(tfData.arrPbLow[0], digits);
            
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoHigh, tfData.arrPbHigh[0]);
            tfData.AddToDateTimeArray( tfData.arrChoHighTime, tfData.arrPbHTime[0]);
            tfData.AddToLongArray( tfData.volArrChoHigh, tfData.volArrPbHigh[0]);
            
            // draw choch low
            drawLine(CHOCH_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);
   
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = 1;
            tfData.findLow = 0; 
            tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.vol_idmHigh = tfData.volLows[0];
            
            if (tfData.mFindTarget != 1) {
               tfData.mFindTarget = 1;
               tfData.mStoploss = tfData.arrPbLow[0];
               tfData.mStoplossTime = tfData.arrPbLTime[0];
               tfData.mTarget = 0;
               tfData.mTargetTime = 0;
               tfData.mSnR = tfData.arrPbHigh[0];
               text += " | CHoCH up M-4.2";
            }
            
            //if (isComment && StringLen(text) > 0) {
            //   Print(str_marjor+text);
            //}
            // CHoCH Low with Volume
            if (tfData.waitingArrPbHigh == 0) {
               tfData.vSTrend = tfData.sTrend;
               tfData.vMTrend = tfData.mTrend;
               tfData.waitingArrPbHigh = 1;
               if (isCHoCHBOSVolume) {
                  tfData.vSTrend = (checkVolumeBreak(1, bar1, tfData.arrPbHigh[0], tfData.volArrPbHigh[0])) ? 1: -1;
                  tfData.vMTrend = tfData.vSTrend;
               } 
            }
            
         }
      }
      // Show draw target line
      if ((showTargetHighTF == true && tfData.isTimeframe == highPairTF) || (showTargetLowTF == true && tfData.isTimeframe == lowPairTF)) {
         // Ve Target Marjog
         if (isDrawMarjor == true && isDrawTarget == true) {
            isDrawTarget = false;
            // ve line
            DrawDirectionalSegment(line_target, place_start_line_draw, bar1.time, line_dinh, line_day, tfData.tfColor, 1, 3);
         }
      }
      
      //if(isComment && StringLen(text) > 0) {
      //   //textall += text;
      //   //text +=  "\n Last: "+getValueTrend(tfData);
      //   //textall += "\n ---------- END updatePointTopBot ------------";
      //   Print(textall);
      //   //showComment(tfData);
      //}
      if (StringLen(text) > 0) {
         textall += str_marjor+text;
      }
      return textall;
   } //--- End Ham cap nhat cau truc thi truong : updatePointTopBot
    
   // Ham tra ve break out hay false break out
   bool checkVolumeBreak(int type_break, MqlRates& barBreak, double value_swing, long vol_swing) {
      bool result = false;
      string text = "";
      text += "==> Info: Bar ("+DoubleToString( ((type_break == 1)? barBreak.high : barBreak.low),digits) +") with volume ("+(string)barBreak.tick_volume+") breaked ("+DoubleToString(value_swing,digits)+") has volume ("+(string) vol_swing+")";
      // Check vol break
      bool result_percent = false;
      int percent = percentCompare;
      if (percentCompare < 80 || percentCompare > 100) percent = 82;
      if (barBreak.tick_volume >= vol_swing*percent/100) {
         text += ": [Success] Bar volume ("+(string)barBreak.tick_volume+") > "+(string)percent+"% Swing volume ("+(string)vol_swing+") is ("+(string) barBreak.tick_volume+" > "+(string) (vol_swing*percent/100)+")";
         result_percent = true;
      } else {
         text += ": [False] Bar volume ("+(string)barBreak.tick_volume+") < "+(string)percent+"% Swing volume ("+(string)vol_swing+") is ("+(string) barBreak.tick_volume+" < "+(string) (vol_swing*percent/100)+")";     
      }
      // End check vol
      
      // Check break with Body or Wick
      double double_bar_break = 0;
      double isDojiBar = 0;
      double highLowBar = 0, bodyBar = 0;
      if (isTypeBreak == 1) { // Phá bằng râu nến
         double_bar_break = (type_break == 1) ? barBreak.high : barBreak.low;
         text += ";"+((result_percent)? "[Success]": "[False]")+" Break with Wick Bar";
         result = result_percent;
      } else { // Phá bằng thân nến
         double_bar_break = barBreak.close;
         // Nếu thân nến phá qua
         if ( (type_break == 1 && double_bar_break > value_swing) || (type_break == -1 && double_bar_break < value_swing) ) {
            text += ";"+((result_percent)? "[Success]": "[False]")+" Break with Body Bar";
            result = result_percent;
         } else { // Nếu râu nến phá qua
            // Kiểm tra xem thân nến có > 50% thanh nến hay không
            highLowBar = barBreak.high - barBreak.low;
            bodyBar = (barBreak.open < barBreak.close) ? (barBreak.close - barBreak.open) : (barBreak.open - barBreak.close);
            isDojiBar = bodyBar - highLowBar*percentIsDojiBar/100;
            text += "; \nbodyBar("+DoubleToString(bodyBar,digits)+") - percent("+(string)percentIsDojiBar+")/100*highLowBar("+DoubleToString(highLowBar,digits)+") ("+(string)(highLowBar*percentIsDojiBar/100)+") = "+ DoubleToString(isDojiBar,digits);
            if (isDojiBar < 0) {
               text += "; [False] Break with Doji Bar";
               result = false;
            } else {
               text += "; "+ ((result_percent)? "[Success]" : "[False]") + " Break with Normal Bar";
               result = result_percent;
            }
         }
      }
      // End Check break with Body or Wick
      //Print(text);
      return result;
   }
   
//   void getZoneValid(TimeFrameData& tfData, bool isComment = false) {
//      isComment = true;
//      showComment(tfData);
//      // Pre arr Decisional
//      //getDecisionalValue(tfData, isComment);
//      
//      //// Extreme Poi
//      //setValueToZone(tfData, 1, tfData.zArrPbHigh, tfData.zPoiExtremeHigh, isComment, "Extreme");
//      //setValueToZone(tfData, -1, tfData.zArrPbLow, tfData.zPoiExtremeLow, isComment, "Extreme");
//      ////// Decisional Poi
//      //setValueToZone(tfData, 1, tfData.zArrDecisionalHigh, tfData.zPoiDecisionalHigh, isComment, "Decisional");
//      //setValueToZone(tfData, -1, tfData.zArrDecisionalLow, tfData.zPoiDecisionalLow, isComment, "Decisional");
//   }      
   
//   // Todo1: dang setup chua xong, can verify Decisinal POI moi khi chay. Luu gia tri High, Low vao 1 gia tri cố định để so sánh
//   // 
//   void getDecisionalValue(TimeFrameData& tfData, bool isComment = false) {
//      string str_zone = "==> Function getDecisionalValue: ";
//      string text = "";
//      // High
//      if (ArraySize(tfData.intSHighs) > 1 && tfData.arrDecisionalHigh[0] != tfData.intSHighs[1]) {
//         text += "\n Checking intSHighs[1]: "+ DoubleToString( tfData.intSHighs[1],digits);
//         // intSHigh[1] not include Extrempoi
//         int isExist = -1;
//         if (ArraySize(tfData.arrPbHigh) > 0) {
//            isExist = checkExist(tfData.intSHighs[1], tfData.arrPbHigh);
//            text += ": Tim thay vi tri "+(string) isExist+" trong arrPbHigh.";
//         }
//         // Neu khong phai la extreme POI. update if isExist == -1
//         if (isExist == -1) {
//            // add new point
//            tfData.AddToDoubleArray(tfData.arrDecisionalHigh, tfData.intSHighs[1]);
//            tfData.AddToDateTimeArray(tfData.arrDecisionalHighTime, tfData.intSHighTime[1]);
//            // Get Bar Index
//            MqlRates iBar;
//            int indexH = iBarShift(_Symbol, tfData.timeFrame, tfData.intSHighTime[1], true);
//            if (indexH != -1) {
//               getValueBar(iBar, tfData.timeFrame,indexH);               
//               // Add new zone
//               MqlRates bar_tmp = iBar;
//               PoiZone zone_tmp = CreatePoiZone( tfData,bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
//               tfData.AddToPoiZoneArray( tfData.zArrDecisionalHigh, zone_tmp, limit);
//            }
//         } else {
//            text += "\n Da ton tai o vi tri : "+(string) isExist+" trong arrPbHigh. Bo qua.";
//         }
//      }
//      
//      // Low
//      if (ArraySize(tfData.intSLows) > 1 && tfData.arrDecisionalLow[0] != tfData.intSLows[1]) {
//         text += "\n Checking intSLows[1]: "+ DoubleToString( tfData.intSLows[1],digits);
//         // intSLow[1] not include Extrempoi
//         int isExist = -1;
//         if (ArraySize(tfData.arrPbLow) > 0) {
//            isExist = checkExist(tfData.intSLows[1], tfData.arrPbLow);
//            text += ": Tim thay vi tri "+(string) isExist+" trong arrPbLow.";
//         }
//         // Neu khong phai la extreme POI. update if isExist == -1
//         if (isExist == -1) {
//            // add new point
//            tfData.AddToDoubleArray(tfData.arrDecisionalLow, tfData.intSLows[1]);
//            tfData.AddToDateTimeArray(tfData.arrDecisionalLowTime, tfData.intSLowTime[1]);
//            // Get Bar Index
//            MqlRates iBar;
//            int indexL = iBarShift(_Symbol, tfData.timeFrame, tfData.intSLowTime[1], true);
//            if (indexL != -1) {
//               getValueBar(iBar, tfData.timeFrame, indexL);               
//               // Add new zone
//               MqlRates bar_tmp = iBar;
//               PoiZone zone_tmp = CreatePoiZone( tfData,bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time);
//               tfData.AddToPoiZoneArray( tfData.zArrDecisionalLow, zone_tmp, limit);
//            }
//         } else {
//            text += "\n Da ton tai o vi tri : "+(string) isExist+" trong arrPbLow. Bo qua.";
//         }
//      }
//      if (isComment) Print(str_zone+text);
//   }
   
   //int checkExist(double value, double& array[]){
   //   int checkExist = -1;
   //   if (ArraySize(array) > 0) {
   //      for(int i=0;i<ArraySize(array);i++) {
   //         if (array[i] == value) {
   //            checkExist = i;
   //            break;
   //         }
   //      }
   //   }
   //   return checkExist;
   //}
   
//   void setValueToZone(TimeFrameData& tfData, int _type,PoiZone& zoneDefault[], PoiZone& zoneTarget[], bool isComment = false, string str_poi = ""){
//      string text = "";
//      // type = 1 is High, -1 is Low
//      double priceKey = (_type == 1) ? zoneDefault[0].high : zoneDefault[0].low; // Price key => Lấy giá theo loại (1 or -1) để so sánh với zone[0] xem đã tồn tại hay chưa
//      datetime timeKey = zoneDefault[0].time;
//      // check default has new value?? => Kiểm tra xem phần tử đầu tiên có phải là phần tử cần thêm vào hay không
//      if (ArraySize(zoneDefault) > 1 && priceKey != zoneTarget[0].priceKey && timeKey != zoneTarget[0].timeKey && priceKey != 0) {   
//         text += ( "--> "+ str_poi +" "+ (( _type == 1)? "High" : "Low") +". Xuat hien value: "+DoubleToString(priceKey,5)+" co time: "+(string)timeKey+" moi. them vao "+str_poi+" "+ (( _type == 1)? "Bearish" : "Bullish") +" Zone");
//
//         int indexH; 
//         MqlRates barH;
//         
//         int result = -1;
//         indexH = iBarShift(_Symbol, tfData.timeFrame, timeKey, true);
//         if (indexH != -1) {
//            // result = -1 => is nothing; result = 0 => is Default; result = index => update
//            result = isFVG(tfData, indexH, _type); // High is type = 1 or Low is type = -1
//            // set Value to barH
//            if (result != -1) {
//               getValueBar(barH, tfData.timeFrame, (result != 0) ? result : indexH);
//               
//               // Add new zone
//               MqlRates bar_tmp = barH;
//               PoiZone zone_tmp = CreatePoiZone( tfData,bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time, 0, priceKey, timeKey);
//               tfData.AddToPoiZoneArray( zoneTarget, zone_tmp, limit);
//            }
//         } else {
//            text += ("Khong lam gi");
//         }
//         if(isComment) {
//            Print(text);
//         }
//      }
//   }
      
   ////--- Return position bar on chart
   //int isFVG(TimeFrameData& tfData, int index, int type){ // type = 1 is High (Bearish) or type = -1 is Low (Bullish) 
   //   string text = "-------------- Check FVG";
   //   int indexOrigin = index;
   //   int result = -1;
   //   bool stop = false;
   //   ENUM_TIMEFRAMES timeframe = tfData.timeFrame;
   //   MqlRates bar1, bar2, bar3;
   //   int i = 0;
   //   while(stop == false && index >=0) {
   //      text += "\n Number " + (string)i;
   //      // gia tri lay tu xa ve gan 
   //      getValueBar(bar1, timeframe, index); // Bar current
   //      getValueBar(bar2, timeframe, index-1);
   //      getValueBar(bar3, timeframe, index-2); 
   //      text += "\n bar 1: "+ " High: "+ DoubleToString(bar1.high, digits) + " Low: "+ DoubleToString(bar1.low, digits);
   //      text += "\n bar 2: "+ " High: "+ DoubleToString(bar2.high, digits) + " Low: "+ DoubleToString(bar2.low, digits);
   //      text += "\n bar 3: "+ " High: "+ DoubleToString(bar3.high, digits) + " Low: "+ DoubleToString(bar3.low, digits);
   //      if (( type == -1 && bar1.high > tfData.arrTop[0]) || (type == 1 && bar1.low < tfData.arrBot[0])) { // gia vuot qua dinh gan nhat. Bo qua
   //         text += "\n gia vuot qua dinh, day gan nhat. Bo qua";
   //         result = 0;
   //         stop = true;
   //         break;
   //      }
   //      if (type == -1) { // Bull FVG
   //         if (  bar1.low > bar3.high && // has space
   //               bar2.close > bar3.high && bar1.close > bar1.open && bar3.close > bar3.open // is Green Bar
   //            ) {
   //            result = index;
   //            stop = true;
   //            text += "\n Bull FVG: Tim thay nen co FVG. High= "+ DoubleToString(bar1.high, digits) +" Low= "+DoubleToString( bar1.low, digits);
   //            break;
   //         }
   //      } else if (type == 1) { // Bear FVG 
   //         if (
   //            bar1.high < bar3.low && // has space
   //            bar2.close < bar3.low && bar1.close < bar1.open && bar3.close < bar3.open // is Red Bar
   //         ) {
   //            result = index;
   //            stop = true;
   //            text += "\n Bear FVG: Tim thay nen co FVG. High= "+ DoubleToString(bar1.high, digits) +" Low= "+ DoubleToString(bar1.low, digits);
   //            break;
   //         }
   //      }
   //      if (stop == false) {
   //         i++;
   //         index--;
   //      }
   //   }
   //   //Print(text);
   //   return result;
   //}
   
   ////--- Set all value Index to Bar Default
   //void getValueBar(MqlRates& bar, ENUM_TIMEFRAMES Timeframe,int index) {
   //   bar.high = iHigh(_Symbol, Timeframe, index);
   //   bar.low = iLow(_Symbol, Timeframe, index);
   //   bar.open = iOpen(_Symbol, Timeframe, index);
   //   bar.close = iClose(_Symbol, Timeframe, index);
   //   bar.time = iTime(_Symbol, Timeframe, index);
   //   //Print("- Bar -"+index + " - "+ " High: "+ bar.high+" Low: "+bar.low + " Time: "+ bar.time);
   //}

   // Ham ve Trade zone Marjor Struct
   void drawMarjorTradeZone(TimeFrameData& tfData, MqlRates& bar1) {
      if (tfData.isDraw) {
         color iColor;
         color mExtremeBear, mExtremeBull, mDecisionalBear, mDecisionalBull;
         
         if(tfData.isHighTF) {
            mExtremeBear = color_HTF_Extreme_Bearish_Zone;
            mExtremeBull = color_HTF_Extreme_Bullish_Zone;
            mDecisionalBear = color_HTF_Decisional_Bearish_Zone;
            mDecisionalBull = color_HTF_Decisional_Bullish_Zone;
         } else {
            mExtremeBear = color_LTF_Extreme_Bearish_Zone;
            mExtremeBull = color_LTF_Extreme_Bullish_Zone;
            mDecisionalBear = color_LTF_Decisional_Bearish_Zone;
            mDecisionalBull = color_LTF_Decisional_Bullish_Zone;
         }
         // Bearish Zone.
         if (ArraySize(tfData.zArrPoiZoneBearish) > 0) { 
            for(int i=0;i<=ArraySize(tfData.zArrPoiZoneBearish) - 1;i++) {
               iColor = (tfData.zArrPoiZoneBearish[i].isTypeZone == 1) ? mExtremeBear : mDecisionalBear;
               drawBox("ePOI", tfData.zArrPoiZoneBearish[i].time, tfData.zArrPoiZoneBearish[i].low, bar1.time, tfData.zArrPoiZoneBearish[i].high,1, iColor, 1);
            }
         }
         
         // Bullish Zone.
         if (ArraySize(tfData.zArrPoiZoneBullish) > 0) { 
            for(int i=0;i<=ArraySize(tfData.zArrPoiZoneBullish) - 1;i++) {
               iColor = (tfData.zArrPoiZoneBullish[i].isTypeZone == 1) ? mExtremeBull : mDecisionalBull;
               drawBox("ePOI", tfData.zArrPoiZoneBullish[i].time, tfData.zArrPoiZoneBullish[i].high, bar1.time, tfData.zArrPoiZoneBullish[i].low,1, iColor, 1);
            }
         }  
      }
   }
   
   // ham ve trade line
   void drawMarketStruct(TimeFrameData& tfData, MqlRates& bar1) {
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
   text += "Timeframe: "+ EnumToString(timeframe);
   text += " | Struct is : " + ((tfData.sTrend == 0) ? "Not defined" : ((tfData.sTrend == 1) ? "S UpTrend" : "S DownTrend")) + "( "+ (string) tfData.sTrend + " . "+ (string) tfData.vSTrend+ ")";
   text += " | Marjor Struct is : " + ((tfData.mTrend == 0) ? "Not defined" : ((tfData.mTrend == 1) ? "m UpTrend" : "m DownTrend")) + "( "+ (string) tfData.mTrend + " . "+ (string) tfData.vMTrend+ ")";
   text += " | Internal is : " + ((tfData.iTrend == 0) ? "Not defined" : ((tfData.iTrend == 1) ? "i UpTrend" : "i DownTrend"))+ "( "+ (string) tfData.iTrend + " . "+ (string) tfData.vItrend+ ")";
   //text += " iFindtarget : " + (string) tfData.iFindTarget + " - iStoploss: "+ DoubleToString(tfData.iStoploss,digits)+ " - iTarget: "+ DoubleToString(tfData.iTarget,digits);
   text += " | Gann wave is : " + ((tfData.gTrend == 0) ? "Not defined" : ((tfData.gTrend == 1) ? "g UpTrend" : " DownTrend"))+ "( "+ (string) tfData.gTrend + " . "+ (string) tfData.vGTrend+ ")";
   
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
   string text = "Bar1 (R) high: "+ DoubleToString(bar1.high,digits) +" - low: "+ DoubleToString(bar1.low,digits) + " - vol: "+ (string)  bar1.tick_volume +
                  " --- "+" Bar2 high: "+ DoubleToString(bar2.high,digits) +" - low: "+ DoubleToString(bar2.low,digits)+ " - vol: "+ (string) bar2.tick_volume +
                  " --- "+" Bar3 (L) high: "+ DoubleToString(bar3.high,digits) +" - low: "+ DoubleToString(bar3.low,digits)+" - vol: "+ (string) bar3.tick_volume;
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
//| Hàm: Vẽ Đoạn Giá Có Mũi Tên Hướng                                |
//| * Tên đối tượng được tạo dựa trên Thời gian (duy nhất cho mỗi nến) |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Hàm: Vẽ Đoạn Giá Có Mũi Tên Hướng (Đã sửa lỗi)                   |
//+------------------------------------------------------------------+
bool DrawDirectionalSegment(
    const int direction, // 1: Lên, -1: Xuống
    double price_start_draw, // vị trí đặt nét vẽ
    datetime time_coord,
    double price_dinh, // đỉnh tam giác 
    double price_day, // đáy tam giác
    color color_val, 
    int width_val = 1,
    int style = 1 // style cua duong ke
    )
{
    
    // Định nghĩa BASE_NAME
    const string BASE_NAME = "DirSeg_";
    
    // TẠO TÊN DUY NHẤT: Kết hợp Tên Cơ Sở và Thời gian của nến
    string unique_time_str = TimeToString(time_coord, TIME_DATE|TIME_SECONDS);
    StringReplace(unique_time_str, ":", "_"); // Thay thế dấu : để tránh lỗi tên
    string seg_name = BASE_NAME + "Seg_" + unique_time_str;
    string arr_name = BASE_NAME + "Arr_" + unique_time_str;
    
    double start_price = price_start_draw; 
    double high_of_line = (price_dinh > price_day) ? price_dinh - price_day : price_day - price_dinh;
    double end_price;   
    int arrow_code;     
    //Print("=> Target Line: Hướng "+((direction > 0)? "Tăng" : "Giảm")+". Từ (Đỉnh)="+ DoubleToString(price_dinh,digits) + " đến (Đáy)="+ DoubleToString(price_day,digits));
    // 1. XÁC ĐỊNH HƯỚNG VÀ VỊ TRÍ MŨI TÊN
    if (direction == 1) // MŨI TÊN HƯỚNG LÊN 
    {
        arrow_code = 233; // SỬA: SYMBOL_ARROW_UP → SYMBOL_ARROWUP
        end_price   = price_start_draw + high_of_line; // SỬA: fmax → MathMax
    }
    else if (direction == -1) // MŨI TÊN HƯỚNG XUỐNG
    {
        arrow_code = 234; // SỬA: SYMBOL_ARROW_DOWN → SYMBOL_ARROWDOWN
        end_price   = price_start_draw - high_of_line; // SỬA: fmin → MathMin
    }
    else
    {
        Print("Lỗi: Tham số 'direction' không hợp lệ. Chỉ chấp nhận 1 (Lên) hoặc -1 (Xuống).");
        return false;
    }
      //arrow_code = 32;
    // 2. KIỂM TRA GIÁ TRỊ HỢP LỆ (SỬA LẠI HOÀN TOÀN)
    if (price_dinh <= 0.0 || price_day <= 0.0 || 
        !MathIsValidNumber(price_dinh) || !MathIsValidNumber(price_day) ||
        time_coord <= 0)
    {
        Print("Lỗi: Giá trị đầu vào không hợp lệ. Price đỉnh: ", price_dinh, ", Price đáy: ", price_day, ", Time: ", time_coord);
        return false;
    }

    // 3. XÓA ĐỐI TƯỢNG CŨ (NẾU TỒN TẠI)
    ObjectDelete(0, seg_name);
    ObjectDelete(0, arr_name);

    // 4. VẼ ĐOẠN THẲNG (OBJ_TREND) - SỬA: OBJ_FIBOSEG → OBJ_TREND
    if (!ObjectCreate(0, seg_name, OBJ_TREND, 0, time_coord, start_price, time_coord, end_price))
    {
        Print("Lỗi tạo đoạn thẳng: ", GetLastError());
        return false;
    }
    
    
    // Thiết lập thuộc tính cho đoạn thẳng
    ObjectSetInteger(0, seg_name, OBJPROP_COLOR, color_val);
    ObjectSetInteger(0, seg_name, OBJPROP_WIDTH, width_val);
    ObjectSetInteger(0, seg_name, OBJPROP_RAY, false);
    ObjectSetInteger(0, seg_name, OBJPROP_SELECTABLE, false);
    // thiet lap kieu ve style cua doan thang
    switch(style)
      {
       case  2: // Dot
         ObjectSetInteger(0, seg_name, OBJPROP_STYLE, STYLE_DOT);
         break;
       case  3: // Dash
         ObjectSetInteger(0, seg_name, OBJPROP_STYLE, STYLE_DASH);
         break;
       case  4: // Dash + dot
         ObjectSetInteger(0, seg_name, OBJPROP_STYLE, STYLE_DASHDOT);
         break;
       default:
         ObjectSetInteger(0, seg_name, OBJPROP_STYLE, STYLE_SOLID);
         break;
      }

//    // 5. VẼ MŨI TÊN (OBJ_ARROW_CHECK) - SỬA: OBJ_ARROW → OBJ_ARROW_CHECK
//    if (!ObjectCreate(0, arr_name, OBJ_ARROW_CHECK, 0, time_coord, end_price))
//    {
//        Print("Lỗi tạo mũi tên: ", GetLastError());
//        // Xóa đoạn thẳng đã tạo nếu mũi tên thất bại
//        ObjectDelete(0, seg_name);
//        return false;
//    }
//    
//    // Thiết lập thuộc tính cho mũi tên
//    ObjectSetInteger(0, arr_name, OBJPROP_COLOR, color_val);
//    ObjectSetInteger(0, arr_name, OBJPROP_ARROWCODE, arrow_code);
//    ObjectSetInteger(0, arr_name, OBJPROP_WIDTH, width_val + 2); 
//    ObjectSetInteger(0, arr_name, OBJPROP_SELECTABLE, false);

    // 6. VẼ LẠI BIỂU ĐỒ
    ChartRedraw();
    return true;
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
////   PoiZone zone1 = CreatePoiZone( tfData,ask + 0.0020, ask - 0.0020, ask, bid, TimeCurrent());
////   h1Data.AddToPoiZoneArray(h1Data.zHighs, zone1);
////   
////   PoiZone zone2 = CreatePoiZone( tfData,ask + 0.0015, ask - 0.0015, ask, bid, TimeCurrent());
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
////   PoiZone zone3 = CreatePoiZone( tfData,ask + 0.0010, ask - 0.0010, ask, bid, TimeCurrent());
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

// Todo: 
void showPoiComment(TimeFrameData& tfData) {
   bool show = false;
   string text = "Timeframe: "+ (string) tfData.isTimeframe;
   //text += "\nss_IntScanActive: " + (string) ss_IntScanActive + " ss_ITrend: " + (string) ss_ITrend + " ss_vITrend: " + (string) ss_vITrend +
   //      "_ ss_iStoploss: " + DoubleToString(ss_iStoploss, digits) + " ss_iStoplossTime: " + (string) ss_iStoplossTime +" ss_iSnR: " + DoubleToString( ss_iSnR, digits) +
   //      "_ ss_iTarget: " + DoubleToString(ss_iTarget, digits) +" ss_iTargetTime: " + (string) ss_iTargetTime;
   
   if (tfData.sTrend == 1 
      //|| tfData.sTrend == -1
      ) {
      //show = true;
      //Print("zLows: "); ArrayPrint(tfData.zLows);
      //Print("zIntSLows: "); ArrayPrint(tfData.zIntSLows);
      
      //Print("zArrPbLow"); ArrayPrint(tfData.zArrPbLow);
      //Print("zArrIntBullish: "); ArrayPrint(tfData.zArrIntBullish);
      //Print("zArrPoiZoneBullish: "); ArrayPrint(tfData.zArrPoiZoneBullish);
   }
   if (tfData.sTrend == -1 
      //|| tfData.sTrend == 1
      ) {
      //show = true;
      //Print("zHighs: "); ArrayPrint(tfData.zHighs);
      //Print("zIntSHighs: "); ArrayPrint(tfData.zIntSHighs);
      
      //Print("zArrPbHigh"); ArrayPrint(tfData.zArrPbHigh); 
      //Print("zArrIntBearish: "); ArrayPrint(tfData.zArrIntBearish);
      //Print("zArrPoiZoneBearish: "); ArrayPrint(tfData.zArrPoiZoneBearish);
   }
   
   if (ss_ITrend == 1) {
      show = true;
      //Print("zArrIntBullish: "); ArrayPrint(tfData.zArrIntBullish);
      Print("zArrPoiZoneLTFBullishBelongHighTF: "); ArrayPrint(zArrPoiZoneLTFBullishBelongHighTF);
   }
   
   if (ss_ITrend == -1) {
      show = true;
      //Print("zArrIntBearish: "); ArrayPrint(tfData.zArrIntBearish);
      Print("zArrPoiZoneLTFBearishBelongHighTF: "); ArrayPrint(zArrPoiZoneLTFBearishBelongHighTF);
   }
   
   //text += "\nEND Timeframe: "+ EnumToString(tfData.timeFrame);
   if (show) Print(text);
}

void showComment(TimeFrameData& tfData) {
   //Print("Timeframe: "+ (string) tfData.isTimeframe);
   
      //Print("Highs: "); ArrayPrint(tfData.Highs);
      //Print("Vol Highs: "); ArrayPrint(tfData.volHighs);
      //Print("Lows: "); ArrayPrint(tfData.Lows); 
      //Print("Vol Lows: "); ArrayPrint(tfData.volLows); 
      //Print("zHighs: "); ArrayPrint(tfData.zHighs);
      //Print("zLows: "); ArrayPrint(tfData.zLows);
      
      //Print("intSHighs: "); ArrayPrint(tfData.intSHighs);
      //Print("Vol intSHighs: "); ArrayPrint(tfData.volIntSHighs);
      //Print("intSLows: "); ArrayPrint(tfData.intSLows); 
      //Print("Vol intSLows: "); ArrayPrint(tfData.volIntSLows); 
      //Print("zIntSHighs: "); ArrayPrint(tfData.zIntSHighs);
      //Print("zIntSLows: "); ArrayPrint(tfData.zIntSLows);
      
      
      //Print("arrTop: "); ArrayPrint(tfData.arrTop); 
      //Print("Vol arrTop: "); ArrayPrint(tfData.volArrTop);
      //Print("arrBot: "); ArrayPrint(tfData.arrBot); 
      //Print("Vol arrBot: "); ArrayPrint(tfData.volArrBot);
      ////////////////Print("zArrTop: "); ArrayPrint(tfData.zArrTop);
      ////////////////Print("zArrBot: "); ArrayPrint(tfData.zArrBot);
      
      
      //Print("arrPbHigh: "); ArrayPrint(tfData.arrPbHigh); 
      //Print("Vol arrPbHigh: "); ArrayPrint(tfData.volArrPbHigh);
      //Print("arrPbLow: "); ArrayPrint(tfData.arrPbLow); 
      //Print("Vol arrPbLow: "); ArrayPrint(tfData.volArrPbLow);
      //Print("zArrPbHigh"); ArrayPrint(tfData.zArrPbHigh); 
      //Print("zArrPbLow"); ArrayPrint(tfData.zArrPbLow);
      
      
      //Print("arrDecisionalHigh: "); ArrayPrint(tfData.arrDecisionalHigh);
      //Print("Vol arrDecisionalHigh: "); ArrayPrint(tfData.volArrDecisionalHigh);
      //Print("arrDecisionalLow: "); ArrayPrint(tfData.arrDecisionalLow);
      //Print("Vol arrDecisionalLow: "); ArrayPrint(tfData.volArrDecisionalLow);
      //Print("zPoiDecisionalLow: "); ArrayPrint(tfData.zPoiDecisionalLow);
      //Print("zPoiDecisionalHigh: "); ArrayPrint(tfData.zPoiDecisionalHigh);
      
      
      //Print("arrBoHigh: "+(string) tfData.arrBoHigh[0] + " "+ (string) tfData.arrBoHighTime[0]);
//         Print("Vol arrBoHigh: "); ArrayPrint(tfData.volArrBoHigh);
      //Print("arrBoLow: "+(string) tfData.arrBoLow[0] + " "+ (string) tfData.arrBoLowTime[0]);
//         Print("Vol arrBoLow: "); ArrayPrint(tfData.volArrBoLow);

      
      //Print("arrChoHigh: "+DoubleToString( tfData.arrChoHigh[0], digits) + " "+ (string) tfData.arrChoHighTime[0]);
//         Print("Vol arrChoHigh: "); ArrayPrint(tfData.volArrChoHigh);
      //Print("arrChoLow: "+(string) tfData.arrChoLow[0]  + " "+ (string) tfData.arrChoLowTime[0]);
//         Print("Vol arrChoLow: "); ArrayPrint(tfData.volArrChoLow);
      
      //Print("zPoiExtremeHigh: "); ArrayPrint(tfData.zPoiExtremeHigh);
      //Print("zPoiExtremeLow: "); ArrayPrint(tfData.zPoiExtremeLow);
      
      //Print("zArrPoiZoneBullish: "); ArrayPrint(tfData.zArrPoiZoneBullish);
      //Print("zArrPoiZoneBearish: "); ArrayPrint(tfData.zArrPoiZoneBearish);
      
      //Print("zArrPoiZoneLTFBullishBelongHighTF: "); ArrayPrint(zArrPoiZoneLTFBullishBelongHighTF);
      //Print("zArrPoiZoneLTFBearishBelongHighTF: "); ArrayPrint(zArrPoiZoneLTFBearishBelongHighTF);
      
} 

string getValueTrend(TimeFrameData& tfData) {
   string text =  "\n($) Struct Trend = STrend: "+ (string) tfData.sTrend + " vSTrend: "+(string) tfData.vSTrend + ". waitingStrend: pbHigh "+(string) tfData.waitingArrPbHigh + " pbLow " + (string) tfData.waitingArrPbLows +
                     " _ Marjor Trend = mTrend: "+(string) tfData.mTrend+ " vMTrend: "+(string) tfData.vMTrend+  ". waitingMtrend: waitingArrTop "+(string) tfData.waitingArrTop + " waitingArrBot " + (string) tfData.waitingArrBot + " - LastSwingMajor: "+(string) tfData.LastSwingMajor+ 
               "\n    findHigh: "+(string) tfData.findHigh+" - idmHigh: "+DoubleToString(tfData.idmHigh, digits)+ " - vol idmHigh: "+(string) tfData.vol_idmHigh+
               " findLow: "+(string) tfData.findLow+" - idmLow: "+DoubleToString( tfData.idmLow,digits)+ " - vol idmLow: "+(string) tfData.vol_idmLow+
               " _ mFindtarget: "+(string) tfData.mFindTarget + " mStoploss: " + DoubleToString(tfData.mStoploss,digits) + " mSnR: " + DoubleToString(tfData.mSnR,digits) + " mTarget: "+ DoubleToString(tfData.mTarget,digits) + " mFullTarget: "+ DoubleToString(tfData.mFullTarget,digits) +
               "\n($) Internal Trend: iTrend: "+(string) tfData.iTrend+ " vItrend: "+(string) tfData.vItrend+ " waitingItrend: IntSHighs "+(string) tfData.waitingIntSHighs + " IntSLows " + (string) tfData.waitingIntSLows +" - LastSwingInternal: "+(string) tfData.LastSwingInternal+
               " _ iFindtarget: "+(string) tfData.iFindTarget + " iStoploss: " + DoubleToString(tfData.iStoploss,digits) + " iSnR: " + DoubleToString(tfData.iSnR,digits) + " iTarget: "+ DoubleToString(tfData.iTarget,digits) + " iFullTarget: "+ DoubleToString(tfData.iFullTarget,digits) +
               "\n($) Gann Trend: gTrend: "+(string) tfData.gTrend+ " vGTrend: "+(string) tfData.vGTrend+ " - LastSwingMeter: "+(string) tfData.LastSwingMeter+ " | | H: "+ DoubleToString( tfData.H, digits) +" - L: "+DoubleToString( tfData.L, digits);  
   text += "\n($) Global Trend: ss_ITrend: " + (string) ss_ITrend +"; ss_vITrend: "+ (string) ss_vITrend + "; ss_iStoploss: " +DoubleToString(ss_iStoploss,digits) + "; ss_iSnR: "+ DoubleToString (ss_iSnR, digits) + "; ss_iTarget: "+ DoubleToString( ss_iTarget, digits);               
   return text;
}