//+------------------------------------------------------------------+
//|                                                      GlobalVars.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Trade\Trade.mqh>

//#region variable declaration
bool enabledComment = true;
bool disableComment = false;
bool g_needRedraw = false; // Cờ kiểm soát việc vẽ lại biểu đồ

bool enabledNotification = false;

bool enabledDraw = true;
bool disableDraw = false;

string webhook = "";

int GANN_STRUCTURE = 1;
int INTERNAL_STRUCTURE = 2;
int INTERNAL_STRUCTURE_KEY = 3;
int MAJOR_STRUCTURE = 4;

int INTERNAL_PULLBACK_MAIN = 1;
int INTERNAL_PULLBACK_SUB = 2;

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
string BULL_TEXT = "bull";
string BEAR_TEXT = "bear";
string GANN_TEXT = "gann";
string INTERNAL_TEXT = "internal";
string MARJOR_TEXT = "marjor";
string INTERNAL_TEXT_GLOBAL_LTF = "G-LTF-Internal";
string INTERNAL_TEXT_GLOBAL = "G-Internal";
string MARJOR_TEXT_GLOBAL = "G-Marjor";
string TAB_STRING = "     ";

int iWingding_gann_high = 159;
int iWingding_gann_low = 159;
int iWingding_internal_high = 225;
int iWingding_internal_low = 226;
int iWingding_internal_key_high = 225;
int iWingding_internal_key_low = 226;

input group "=== Market Struct Inputs ==="   
input int _PointSpace = 1000; // Khoảng cách để vẽ swing, line so với high và low 
input int poi_limit = 30; // Số lượng mảng POI tối đa để lưu vào hệ thống
int limit = 30; // Khối lượng tối đa để lưu trữ mảng của Swing High, Low
int lookback = 100; // Số lượng thanh Bar được đếm ngược lại so với thời điểm chạy bot
datetime lookback_time = 0; 
int lookback_LTF = 0;
// định nghĩa riêng cặp khung thời gian trade
enum pairTF {m3_m1 = 1, m5_m1 = 2, m10_m1 = 3, m15_m1 = 4, h1_m5 = 5, h4_m15 = 6, d1_h1 = 7};
input pairTF pairTimeFrameInput = m15_m1; // Cặp khung thời gian trade: high TimeFrame _ low TimeFrame 
int lowPairTF;
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
input bool isCheckPullBackBySwept = false; // Định nghĩa pullback swing có cần swept nến trước hay không 
enum isTickVolume {isBar = 1, isMax3Bar = 2};
input isTickVolume typeTickVolume = 1; // 1: is Bar; 2 : largest of 3 adjacent candles
input int percentCompare = 100; // Số % Volume quyết định Breakout 1 swing.(70%-100%)
input group "=== Draw target ==="
input bool showTargetHighTF = true; // Hien thi target line o High Timeframe
input bool showTargetLowTF = true; // Hien thi target line o Low Timeframe
input bool isDrawMarjor = true; // Draw target with Marjor Swing
input bool isDrawInternal = true; // Draw target with Internal Swing

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

input group "=== PoiZone Global POI Trade Zone colors ==="
input color color_Global_Internal_Bullish_Zone_LTF = clrOliveDrab; // Low Internal bullish
input color color_Global_Internal_Bearish_Zone_LTF = clrFireBrick; // Low Internal bearish

input color color_Global_Internal_Bullish_Zone_HTF = clrLightSkyBlue; // High Internal bullish
input color color_Global_Internal_Bearish_Zone_HTF = clrPlum; // High Internal bearish

input color color_Mitigated_Zone = clrSilver; // Mitigated color

input group "=== Chart Partent ==="
// Tham số cấu hình
input double WickRatio = 2.0; // Râu nến phải dài gấp ít nhất 2 lần thân nến

double Ask;
double Bid;
double Spread;
int volume_style; // 1: Real Volume, 2: Tick Volume
// End #region variale declaration

//+------------------------------------------------------------------+
//| Status Trade by SMC                                              |
//+------------------------------------------------------------------+
// Khai báo biến tín hiệu Internal HTF toàn cục
struct SignalInternal{
   // Value HighTimeFrame to Global setup
   int sg_sTrend;
   int sg_vSTrend;
   
   int sg_mTrend;
   int sg_vMTrend;
   int sg_wvMTrend;
   bool sg_wvIsBuyMarjor;
   bool sg_wvIsSellMarjor;
   
   int sg_iTrend;
   int sg_vITrend;
   int sg_wvITrend;
   
   int sg_wvIsBuyInternal;
   int sg_wvIsSellInternal;

   bool sg_getIdmBuy;
   bool sg_getIdmSell;
};
   
// --- 1. ĐỊNH NGHĨA CÁI LÕI DỮ LIỆU SWING ---
struct InternalSwingData {
   bool isActive;
   double         vins_SwingNew; // 
   datetime       vins_SwingTimeNew;
   MqlRates       vins_barSwing;
   MqlRates       vins_barOrderBlock;
   
   // Các biến xác nhận tín hiệu gốc của bạn
   int            vins_isSignalConfirm_Patten;  // -1: Khong hinh thanh EG hoac swept. 0: waiting. 1. Hinh thanh EG
   int            vins_isSignalConfirm_Patten_Again; // 0: waiting. 1: breakout. -1. Scan ready
   int            vins_isSignalConfirm_OB_Patten; // -1: Khong hinh thanh EG. 0: waiting. 1. Hinh thanh EG
   int            vins_isSignalConfirm_LTF; // Mặc định = 2 (Chờ LTF soi)
   
   bool           vins_isOrderFlowMitigated;
   bool           vins_isPoiZoneSwept;
   bool           vins_isPoiZoneMitigated;
   
   int            vins_isSignalConfirm_LTF_byWave; // 0: default. 1: gann wave. 2: internal wave; 
   int            vins_LTF_mTrend;
   int            vins_LTF_wvmTrend;
   int            vins_LTF_iTrend;
   int            vins_LTF_wviTrend;
   
   // LTF price to Trade
   double         vins_Entry_Stop; // Giá đặt lệnh stop
   double vins_Entry_Limit; // Giá đặt lệnh Limit
   //double vins_Stoploss_loose; // Dừng lỗ lỏng
   //double vins_Stoploss_tight; // Dừng lỗ chặt
   //double vins_TakeProfit_Internal; // Chốt lời 1 phần xu hướng nhỏ
   //double vins_TakeProfit_Marjor; // Chốt lời toàn bộ xu hướng lớn
   
   // Hàm Reset làm sạch dữ liệu (Cần thiết khi đổi xu hướng)
   void Reset() {
      vins_SwingNew = 0;
      vins_SwingTimeNew = 0;
      vins_Entry_Stop = 0;
      vins_isSignalConfirm_Patten = -1;
      vins_isSignalConfirm_Patten_Again = 1;
      vins_isSignalConfirm_OB_Patten = -1;
      vins_isSignalConfirm_LTF = 2;
      vins_isSignalConfirm_LTF_byWave = 0;
      vins_isOrderFlowMitigated = false;
      vins_isPoiZoneSwept = false;
      vins_isPoiZoneMitigated = false;
      vins_LTF_mTrend = 0;
      vins_LTF_wvmTrend = 0;
      vins_LTF_iTrend = 0;
      vins_LTF_wviTrend = 0;
      ZeroMemory(vins_barSwing);
      ZeroMemory(vins_barOrderBlock);
   }
   
};

// --- 2. ĐỊNH NGHĨA QUẢN LÝ LỒNG NHAU (MAIN-SUB) ---
struct StructureManager {
   InternalSwingData main; // Swing gốc HTF
   InternalSwingData sub;  // Swing phụ/tiếp diễn (Điểm tựa vào lệnh)
   
   void ResetAll() {
      main.Reset();
      sub.Reset();
   }
};

// Khai báo thông số của Internal wave sau khi breakout và tạo swing high low continue
struct ValueInternal{
   // Thông số cơ bản
   int vi_mTrend;
   long vi_wvmTrend;
   int vi_ITrend;
   long vi_wvITrend;
   
   bool vi_wvIsBuyInternal;
   bool vi_wvIsSellInternal;
   bool vi_isSwept;
   
   double vi_intSHigh;
   datetime vi_intSHighTime;
   bool vi_intSHigh_isMitigatedPoiZone;
   double vi_intSLow;
   datetime vi_intSLowTime;
   bool vi_intSLow_isMitigatedPoiZone;
   
   double vi_intSnR;
   double vi_isMitigatedPoiZone;
   double vi_isSweptPoiZone;
   double vi_isMitigatedOrderFlow;
   
   // ĐÃ ĐỔI TÊN ĐỂ TRÁNH TRÙNG LẶP
   StructureManager vi_TempSwing_High; // Quản lý phía SELL
   StructureManager vi_TempSwing_Low;  // Quản lý phía BUY

   // Vùng đệm để soi kính hiển vi
   InternalSwingData candidate_High;
   InternalSwingData candidate_Low;
   
   // Hàm Reset làm sạch dữ liệu (Cần thiết khi đổi xu hướng)
   void Reset(string text = "") {
      //Print("============= RESET THONG SO [ ValueInternal ] THANH CONG==============");
      string message = "Reset valueInternal. Xoa pending order.";
      sendNoti(text+message);
      
      vi_mTrend = 0;
      vi_wvmTrend = 0;
      vi_ITrend = 0;
      vi_wvITrend = 0;
      vi_wvIsBuyInternal = false;
      vi_wvIsSellInternal = false;
      vi_isSwept = false;
      vi_intSHigh = 0;
      vi_intSHighTime = 0;
      vi_intSHigh_isMitigatedPoiZone = false;
      vi_intSLow = 0;
      vi_intSLowTime = 0;
      vi_intSLow_isMitigatedPoiZone = false;
      
      vi_intSnR = 0;
      vi_isMitigatedPoiZone = false;
      vi_isSweptPoiZone = false;
      vi_isMitigatedOrderFlow = false;
      
      vi_TempSwing_High.ResetAll();
      vi_TempSwing_Low.ResetAll();
      candidate_High.Reset();
      candidate_Low.Reset();
   }
};


// Khai báo biến trạng thái HTF to LTF. Khi breakout từ Internal HTF sang LTF
struct StatusInternalHighToLow{
   bool sHL_IntScanActive;
   int sHL_ITrend;
   int sHL_vITrend;
   int sHL_mitigate_iOrderFlow; // Mặc định = -1 kể cả khi breakout, Khi sHL_iTarget được xác định = 0, khi mitigate = 1.
   double sHL_iStoploss; //
   double sHL_iOrderBlock;
   int sHL_mitigate_iOrderBlock; // Mặc định = -1, Khi breakout =0, Khi mitigate thì biến này chuyển thành 1. 
   double sHL_iTarget;
   double sHL_iSnR;
   datetime sHL_iStoplossTime;
   datetime sHL_iTargetTime;

   void Reset(){
      sHL_IntScanActive = false;
      sHL_ITrend = 0;
      sHL_vITrend = 0;
      sHL_mitigate_iOrderFlow = -1;
      sHL_iStoploss = 0;
      sHL_iOrderBlock = 0;
      sHL_mitigate_iOrderBlock = -1;
      sHL_iTarget = 0;
      sHL_iSnR = 0;
      sHL_iStoplossTime = 0;
      sHL_iTargetTime = 0;
   }
};

// Settings status default for Trade Basic
struct infoMarketStructStatus{
   // Swing Internal HTF tạm thời. (RealTime)
   double iMSS_intSHighHTFRealTime;
   double iMSS_intSLowHTFRealTime;

   // Swing Internal LTF tạm thời sau khi break Internal ở HTF. AF After Break
   double iMSS_H_AF_LTFRealTime;
   int iMSS_H_pattern_signal;
   double iMSS_L_AF_LTFRealTime;
   int iMSS_L_pattern_signal;
   int iMSS_findH;
   int iMSS_findL;
   double iMSS_H_arrPBHigh_LTF;
   double iMSS_L_arrPBLow_LTF;

   void Reset(){
      iMSS_intSHighHTFRealTime = 0;
      iMSS_intSLowHTFRealTime = 0;
      iMSS_H_AF_LTFRealTime = -1;
      iMSS_H_pattern_signal = -1;
      iMSS_L_AF_LTFRealTime = -1;
      iMSS_L_pattern_signal = -1;
      iMSS_findH = -1;
      iMSS_findL = -1;
      iMSS_H_arrPBHigh_LTF = 0;
      iMSS_L_arrPBLow_LTF = 0;
   }

   void ResetHL() {
      iMSS_H_pattern_signal = -1;
      iMSS_L_pattern_signal = -1;
      iMSS_findH = -1;
      iMSS_findL = -1;
      iMSS_H_AF_LTFRealTime = -1;
      iMSS_L_AF_LTFRealTime = -1;
   }
};

// Khai báo struct toàn cục cho toàn bộ thông tin trade
struct TradeBasicStatus{
   SignalInternal signalInternal;  // Settings biến tín hiệu Internal HTF toàn cục
   ValueInternal valueInternal; // Settings thông số thông tin thị trường hiện tại của HTF.
   StatusInternalHighToLow statusInternalHTL; // Settings biến trạng thái HTF to LTF sau khi breakout HTF. Biến phụ có thể sử dụng hoặc không.
   infoMarketStructStatus marketStructStatus; // Status thông tin thị trường RealTime 
   
};
TradeBasicStatus myEAs;
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
   
   int mitigated; // -1 reject order block, 0 not mitigate, 1 mitigating Order Block
   bool isSwept;
   color zoneColor; // THÊM DÒNG NÀY: Lưu màu sắc riêng của từng Zone
   
//   int isFvG; // 0 not defind, -1 not Fvg, 1 has FvG
// 
   int isTypeZone; // 1 is Extreme, 2 is Decisional 
   string name; // Tên của zone để vẽ và sau để dùng xoá zone
   //double priceKey;
   //datetime timeKey;
};

// PoiZone global thuộc marjor structure
PoiZone zGTradeZoneBullishHTF[];
PoiZone zGTradeZoneBearishHTF[];
PoiZone zGTradeZoneInternalBullishHTF[];
PoiZone zGTradeZoneInternalBearishHTF[];

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
   long wvolHighs[];
   datetime wvolHighTime[];
   long wvolLows[];
   datetime wvolLowTime[];
   
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
   long wvolIntSHighs[];
   datetime wvolIntSHighTime[];
   long wvolIntSLows[];
   datetime wvolIntSLowTime[];
   
   // Internal. Lưu thông số bar break, nơi đặt line, chiều dài line
   int isDrawTarget_internal; // Hướng check volume. 1 Hướng buy ; -1 Hướng sell
   MqlRates barBreak_internal;
   MqlRates barBreak_internal_old;
   int line_direction_internal;
   double line_high_internal;
   double line_low_internal;
   double place_start_line_draw_internal;
   
   int iFindTarget;
   double iStoploss; datetime iStoplossTime;
   double iOrderBlock;
   double iTarget; datetime iTargetTime;
   double iFullTarget;
   double iSnR;
   
   int LastSwingInternal;
   int iTrend;
   int vItrend;
   int wvItrend;
   bool wvIsBuyInternal; // Trả về trạng thái logic phù hợp Buy. true => Buy, false = Không làm gì
   bool wvIsSellInternal; // Trả về trạng thái logic phù hợp Sell. true => Sell, false = Không làm gì
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
   int wvMtrend;
   bool wvIsBuyMarjor; // Trả về trạng thái logic phù hợp Buy. true => Buy, false = Không làm gì
   bool wvIsSellMarjor; // Trả về trạng thái logic phù hợp Sell. true => Sell, false = Không làm gì
   datetime arrPbHTime[];
   double arrPbHigh[];
   datetime arrPbLTime[];
   double arrPbLow[];
   long volArrPbHigh[];
   long volArrPbLow[];
   int waitingArrPbHigh; // Chờ nến phá vỡ đỉnh Pullback marjor swing highs. default = 0
   int waitingArrPbLows;  // Chờ nến phá vỡ đỉnh Publlback marjor swing lows.  default = 0
   long wvolArrPbHigh[];
   datetime wvolArrPbHighTime[];
   long wvolArrPbLow[];
   datetime wvolArrPbLowTime[];
   
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
   //long wvolArrChoHigh[];
   //long wvolArrChoLow[];
   
   double arrBoHigh[];
   double arrBoLow[];
   datetime arrBoHighTime[];
   datetime arrBoLowTime[];
   long volArrBoHigh[];
   long volArrBoLow[];
   //long wvolArrBoHigh[];
   //long wvolArrBoLow[];

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
   PoiZone zPoiLow[];
   PoiZone zPoiHigh[];
   
   PoiZone zArrIntBullish[];
   PoiZone zArrIntBearish[];
 

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
      iTrend = 0; vItrend = 0; wvItrend = 0; wvIsBuyInternal = false; wvIsSellInternal = false;
      mTrend = 0; vMTrend = 0; wvMtrend = 0; wvIsBuyMarjor = false; wvIsSellMarjor = false;
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
      waitingArrTop = 0;
      waitingArrBot = 0;
      waitingArrPbHigh = 0;
      waitingArrPbLows = 0;
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
      iOrderBlock = 0;
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
      ArrayInitialize(wvolHighs, 0.0);
      ArrayInitialize(wvolHighTime, 0.0);
      ArrayInitialize(wvolLows, 0.0);
      ArrayInitialize(wvolLowTime, 0.0);
      
      ArrayInitialize(intSHighs, 0.0);
      ArrayInitialize(intSLows, 0.0);
      ArrayInitialize(intSHighTime, 0);
      ArrayInitialize(intSLowTime, 0);
      
      ArrayInitialize(volIntSHighs, 0.0);
      ArrayInitialize(volIntSLows, 0.0);
      ArrayInitialize(wvolIntSHighs, 0.0);
      ArrayInitialize(wvolIntSHighTime, 0.0);
      ArrayInitialize(wvolIntSLows, 0.0);
      ArrayInitialize(wvolIntSLowTime, 0.0);
      
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
      
      ArrayInitialize(wvolArrPbHigh, 0);
      ArrayInitialize(wvolArrPbLow, 0);
      ArrayInitialize(wvolArrPbHighTime, 0);
      ArrayInitialize(wvolArrPbLowTime, 0);
      
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
      
      ZeroMemory(L_bar);
      ZeroMemory(H_bar);
      
      // reset line draw
      isDrawTarget_internal = 0;
      ZeroMemory(barBreak_internal);
      ZeroMemory(barBreak_internal_old);
      line_direction_internal = 0;
      line_high_internal = 0;
      line_low_internal = 0;
   }
   
   // Helper Methods for Array Management
   
   void resetDrawBarSettings(TimeFrameData& tfData, int typeDraw = 0) {
      if (typeDraw == INTERNAL_STRUCTURE) {
         barBreak_internal_old = barBreak_internal;
         isDrawTarget_internal = 0;
         ZeroMemory(barBreak_internal);
         line_direction_internal = 0;
         line_high_internal = 0;
         line_low_internal = 0;
      } else if (typeDraw == MAJOR_STRUCTURE) {
      
      }
   }
   
   // Phương thức thêm phần tử vào mảng long
   int AddToLongArray(long &array[], long value, int ilimit = 30)
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
   int AddToDoubleArray(double &array[], double value, int ilimit = 30)
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
   int AddToDateTimeArray(datetime &array[], datetime value, int ilimit = 30)
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
   int AddToPoiZoneArray(PoiZone &array[], PoiZone &value, int ilimit = 30, string name = "")
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
      array[0].name = name;
      
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
   bool UpdatePoiZoneArray(PoiZone &array[], int index, PoiZone &value, string name="")
   {
      int size = ArraySize(array);
      if(index < 0 || index >= size) return false;
      
      array[index] = value;
      array[index].name = name;
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
   
   // Hàm trả về true hoặc false trạng thái check logic volume wave Buy or Sell của 1 con sóng
   bool getStatusLegalByVolumeOfBreakStruct(TimeFrameData& tfData, string typeStruct = "", int typeDirection = 0) {
      bool result = false;
      long waveBreak_new1 = 0;
      long wavePullBack_prev2 = 0;
      long waveBreak_prev3 = 0;
      
         if (typeStruct == "Internal" && (ArraySize(tfData.wvolIntSHighs) > 2 || ArraySize(tfData.wvolIntSLows) > 2)) {
            
            //Print("wvolIntSHighs");ArrayPrint(tfData.intSHighs); ArrayPrint(tfData.wvolIntSHighs);
            //Print("wvolIntSLows");ArrayPrint(tfData.intSLows); ArrayPrint(tfData.wvolIntSLows);
            
            // Check logic Buy by wave volume kieu Internal
            if (typeDirection == 1) {
               waveBreak_new1 = tfData.wvolIntSHighs[0];
               wavePullBack_prev2 = tfData.wvolIntSLows[0];
               waveBreak_prev3 = tfData.wvolIntSHighs[1];
               
            // Check logic Sell by wave volume kieu Internal
            } else if (typeDirection == -1) {
               waveBreak_new1 = tfData.wvolIntSLows[0];
               wavePullBack_prev2 = tfData.wvolIntSHighs[0];
               waveBreak_prev3 = tfData.wvolIntSLows[1];
            }
         } else if (typeStruct == "Marjor" && (ArraySize(tfData.wvolArrPbHigh) > 2 || ArraySize(tfData.wvolArrPbLow) > 2)) {
            // Check logic Buy by wave volume kieu Marjor
            if (typeDirection == 1) {
               waveBreak_new1 = tfData.wvolArrPbHigh[0];
               wavePullBack_prev2 = tfData.wvolArrPbLow[0];
               waveBreak_prev3 = tfData.wvolArrPbHigh[1];
               
            // Check logic Sell by wave volume kieu Marjor
            } else if (typeDirection == -1) {
               waveBreak_new1 = tfData.wvolArrPbLow[0];
               wavePullBack_prev2 = tfData.wvolArrPbHigh[0];
               waveBreak_prev3 = tfData.wvolArrPbLow[1];
            }
         }
      
      // Check logic: con song break: đồng thời > song cung chieu phia truoc đó && > song nguoc chieu vua break xong.
      if (waveBreak_new1 > wavePullBack_prev2 && waveBreak_new1 > waveBreak_prev3) {
         result = true;
      }
      return result;
   }
   
   // Hàm để nhận và lưu trữ dữ liệu - Đã sửa lỗi "structures containing objects"
   void copyZoneToZone(const PoiZone &sourceArray[], PoiZone &targetArray[]) {
      int size = ArraySize(sourceArray);
      
      // 1. Cấp phát lại bộ nhớ cho mảng đích
      if(ArrayResize(targetArray, size) == -1) {
         Print("Lỗi cấp phát bộ nhớ mảng đích!");
         return;
      }
      
      // 2. Sao chép thủ công từng phần tử
      // MQL5 cho phép gán trực tiếp structure: target = source
      // Việc gán này sẽ tự động xử lý các biến string bên trong một cách an toàn.
      for(int i = 0; i < size; i++) {
         targetArray[i] = sourceArray[i];
      }
      
      // Print("Đã copy thành công ", size, " vùng POI.");
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
      Clear();
   }

   // Giải phóng toàn bộ bộ nhớ dynamic an toàn
   void Clear()
   {
      for(int i = 0; i < m_total; i++)
      {
         if(CheckPointer(m_timeframeData[i]) == POINTER_DYNAMIC)
         {
            delete m_timeframeData[i];
            m_timeframeData[i] = NULL;
         }
      }
      m_total = 0;
      ArrayResize(m_timeframeData, 0);
      ArrayResize(m_timeframes, 0);
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

      // Create news timeframe data
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

//+------------------------------------------------------------------+
//| Hàm tạo PoiZone tối ưu - Kiểm tra nến hiện tại trước             |
//+------------------------------------------------------------------+
PoiZone createpoizone_optimized(ENUM_TIMEFRAMES tf, int indexAnchor, int type)
{
   PoiZone zone;
   ZeroMemory(zone);
   string symbol = _Symbol;

   // Lấy thông số nến hiện tại (nến neo)
   double openAnchor  = iOpen(symbol, tf, indexAnchor);
   double closeAnchor = iClose(symbol, tf, indexAnchor);
   double highAnchor  = iHigh(symbol, tf, indexAnchor);
   double lowAnchor   = iLow(symbol, tf, indexAnchor);

   if(type == 1) // --- CHIẾN LƯỢC BULLISH ---
   {
      zone.low = lowAnchor; // Low luôn lấy từ nến neo
      
      // Nếu nến hiện tại là nến GIẢM, lấy luôn High của nó
      if(closeAnchor < openAnchor) 
      {
         zone.high = highAnchor;
      }
      else // Nếu không, mới bắt đầu tìm ngược về quá khứ
      {
         zone.high = highAnchor; // Giá trị dự phòng
         for(int i = indexAnchor + 1; i < indexAnchor + 50; i++)
         {
            if(iClose(symbol, tf, i) < iOpen(symbol, tf, i)) // Tìm nến giảm
            {
               zone.high = iHigh(symbol, tf, i);
               break;
            }
         }
      }
   }
   else if(type == -1) // --- CHIẾN LƯỢC BEARISH ---
   {
      zone.high = highAnchor; // High luôn lấy từ nến neo
      
      // Nếu nến hiện tại là nến TĂNG, lấy luôn Low của nó
      if(closeAnchor > openAnchor)
      {
         zone.low = lowAnchor;
      }
      else // Nếu không, mới bắt đầu tìm ngược về quá khứ
      {
         zone.low = lowAnchor; // Giá trị dự phòng
         for(int i = indexAnchor + 1; i < indexAnchor + 50; i++)
         {
            if(iClose(symbol, tf, i) > iOpen(symbol, tf, i)) // Tìm nến tăng
            {
               zone.low = iLow(symbol, tf, i);
               break;
            }
         }
      }
   }

   // Các thông số khác của Zone
   zone.time  = iTime(symbol, tf, indexAnchor);
   zone.open  = openAnchor;
   zone.close = closeAnchor;
   zone.mitigated = 0;

   return zone;
}

//Todo: Hàm tạo PoiZone từ giá
PoiZone CreatePoiZone(TimeFrameData& tfData, double high, double low, double open, double close, datetime time, 
                      int mitigated = 0, double priceKey = -1, datetime timeKey = -1, color zone_color = clrWhite, string name = "")
{
   PoiZone zone;
   ZeroMemory(zone);
   
   zone.high = high;
   zone.low = low;
   zone.open = open;
   zone.close = close;
   zone.time = time;
   zone.mitigated = mitigated;
   zone.isSwept = false;
   
   //zone.priceKey = (priceKey != -1) ? priceKey : -1;
   //zone.timeKey = (timeKey != -1) ? timeKey : 0;
   zone.zoneColor = zone_color;
   zone.isTypeZone = 0;
      
   return zone;
}

void ProcessSwingLogic(InternalSwingData &main, 
                      InternalSwingData &sub, 
                      InternalSwingData &candidate, 
                      MqlRates &bar, 
                      int dir, 
                      double snr_gann) {
   
   bool isOrderFlowMitigated = false;
   bool isPoiZoneMitigated = false; // Hiện tại đang mặc định false theo code của bạn

   // --- BƯỚC 1: KIỂM TRA TÍNH HỢP LỆ (VALIDITY) ---
   // Đỉnh phải thấp hơn đỉnh Main hoặc đáy phải cao hơn đáy main
   if (dir == 1) { // Direction BUY (xử lý Low Swing)
      if (bar.low < main.vins_SwingNew) return;
   } else { // Direction SELL (xử lý High Swing)
      if (bar.high > main.vins_SwingNew) return;
   }

   // --- BƯỚC 2: KIỂM TRA MITIGATED ORDER FLOW (GANN PULLBACK) ---
   if (snr_gann != 0) {
      isOrderFlowMitigated = (dir == 1) ? (bar.low <= snr_gann) : (bar.high >= snr_gann);
   }

   // --- BƯỚC 3: KIỂM TRA MITIGATED ORDER BLOCK (MAIN & SUB) ---
   // Kiểm tra Main trước
   if (main.vins_SwingNew != 0) {
      if (dir == 1)
         isPoiZoneMitigated = (bar.low >= main.vins_SwingNew && bar.low <= main.vins_barOrderBlock.high);
      else
         isPoiZoneMitigated = (bar.high <= main.vins_SwingNew && bar.high >= main.vins_barOrderBlock.low);
   }
   
   // Nếu Main chưa mitigated, kiểm tra tiếp Sub
   if (!isPoiZoneMitigated && sub.vins_SwingNew != 0) {
      if (dir == 1)
         isPoiZoneMitigated = (bar.low >= sub.vins_SwingNew && bar.low <= sub.vins_barOrderBlock.high);
      else
         isPoiZoneMitigated = (bar.high <= sub.vins_SwingNew && bar.high >= sub.vins_barOrderBlock.low);
   }

   // --- BƯỚC 4: KẾT LUẬN VÀ GÁN DỮ LIỆU ---
   if (isPoiZoneMitigated || isOrderFlowMitigated) {
      candidate.vins_SwingNew     = (dir == 1) ? bar.low : bar.high;
      candidate.vins_SwingTimeNew = bar.time;
      candidate.vins_barSwing     = bar;

      candidate.vins_isOrderFlowMitigated = isOrderFlowMitigated;
      candidate.vins_isPoiZoneMitigated   = isPoiZoneMitigated;
      string text = "============= SET THONG SO SWING GANN PULLBACK THANH CONG ==============";
      text += StringFormat("Direction: %d | Time: %s | Swing %s Price: %s", dir, TimeToString(bar.time), (dir==1)?"Low": "High",DoubleToString(candidate.vins_SwingNew, _Digits));
      ///Print(text);
      
      string message = StringFormat("[HTF] PB Gann Swing %s Price: %s - Time: %s | IsOfMitigated: %s | IsObMitigated: %s", 
                                    (dir==1)?"Low": "High", DoubleToString(candidate.vins_SwingNew,_Digits), TimeToString(bar.time), 
                                    (candidate.vins_isOrderFlowMitigated)? "Yes": "No", (candidate.vins_isPoiZoneMitigated)? "Yes": "No"
                                    );
      sendNoti(message);
   }
}

void setValueToCandidateSwingHTF(TimeFrameData& tfData, MqlRates& barSwing, int direction = 0) {
   // Bảo vệ: Nếu direction = 0 hoặc dữ liệu không hợp lệ thì thoát
   if (direction == 0) return;

   if (direction == 1) {
      // Chuẩn bị SnR Gann cho hướng BUY
      double snr = (ArraySize(tfData.Highs) > 1) ? tfData.Highs[1] : 0;
      
      // Gọi hàm xử lý, truyền vào các biến LOW
      ProcessSwingLogic(myEAs.valueInternal.vi_TempSwing_Low.main, 
                        myEAs.valueInternal.vi_TempSwing_Low.sub, 
                        myEAs.valueInternal.candidate_Low, 
                        barSwing, 1, snr);
   } 
   else if (direction == -1) {
      // Chuẩn bị SnR Gann cho hướng SELL
      double snr = (ArraySize(tfData.Lows) > 1) ? tfData.Lows[1] : 0;
      
      // Gọi hàm xử lý, truyền vào các biến HIGH
      ProcessSwingLogic(myEAs.valueInternal.vi_TempSwing_High.main, 
                        myEAs.valueInternal.vi_TempSwing_High.sub, 
                        myEAs.valueInternal.candidate_High, 
                        barSwing, -1, snr);
   }
}

// Set thông số để có hướng trade theo Internal HTF. (valueInternal). Hàm được đặt sau khi tìm thấy new swing HTF            
void setValueToInternalSwingHTF(TimeFrameData& tfData, MqlRates& barBreak, MqlRates& barSwing, int direction = 0){
   string text = "";
   myEAs.valueInternal.vi_mTrend = tfData.mTrend;
   myEAs.valueInternal.vi_wvmTrend = tfData.wvMtrend;
   myEAs.valueInternal.vi_ITrend = tfData.iTrend;
   myEAs.valueInternal.vi_wvITrend = tfData.wvItrend;
   myEAs.valueInternal.vi_wvIsBuyInternal = tfData.wvIsBuyInternal;
   myEAs.valueInternal.vi_wvIsSellInternal = tfData.wvIsSellInternal;
   
   myEAs.valueInternal.vi_intSHigh = tfData.intSHighs[0];
   myEAs.valueInternal.vi_intSHighTime = tfData.intSHighTime[0];
   myEAs.valueInternal.vi_intSLow = tfData.intSLows[0];
   myEAs.valueInternal.vi_intSLowTime = tfData.intSLowTime[0];
   
   text += "============= .1. SET THONG SO INTERNAL NGUOC TREND HTF " + (string)(tfData.timeFrame) + " =============\n";
   // Check Swing High
   if(direction == -1) {
      text += StringFormat("============= Kiểm tra Poizone Intenal High: Có Swing High %s tại thời điểm %s\n", DoubleToString(barSwing.high,_Digits), TimeToString(barSwing.time));
               
      // Set thong so mitigated Poizone Internal High
      if(ArraySize(zGTradeZoneBearishHTF) > 0) {
         
         for(int i=0;i<ArraySize(zGTradeZoneBearishHTF);i++){
            if(zGTradeZoneBearishHTF[i].mitigated == -1) continue; // Poizone da bi pha qua truoc do. bo qua
            if(zGTradeZoneBearishHTF[i].time >= myEAs.valueInternal.vi_intSHighTime) continue; // Bo qua poizone co thoi gian khong hop le
            if(myEAs.valueInternal.vi_intSHigh < zGTradeZoneBearishHTF[i].low) continue; // Gia chua cham vao poizone. bo qua
            if(myEAs.valueInternal.vi_intSHigh >= zGTradeZoneBearishHTF[i].low && myEAs.valueInternal.vi_intSHigh <= zGTradeZoneBearishHTF[i].high) {
               myEAs.valueInternal.vi_intSHigh_isMitigatedPoiZone = true;
               break;
            }
         }
      }
      
      
      
   } else if (direction == 1){ // Check swing low
      // Set thong so mitigated Poizone Intenal Low
      if(ArraySize(zGTradeZoneBullishHTF) > 0) {
         text += StringFormat("============= Kiểm tra Poizone Intenal Low: Có Swing Low %s tại thời điểm %s\n", DoubleToString(barSwing.low, _Digits), TimeToString(barSwing.time));
         
         for(int i=0;i<ArraySize(zGTradeZoneBullishHTF);i++) {
            if(zGTradeZoneBullishHTF[i].mitigated == -1) continue; // Poizone da bi pha qua truoc do. bo qua
            if(zGTradeZoneBullishHTF[i].time >= myEAs.valueInternal.vi_intSLowTime) continue; // Bo qua poizone co thoi gian khong hop le
            if(myEAs.valueInternal.vi_intSLow > zGTradeZoneBullishHTF[i].high) continue; // Gia chua cham vao poizone. bo qua
            if(myEAs.valueInternal.vi_intSLow <= zGTradeZoneBullishHTF[i].high && myEAs.valueInternal.vi_intSLow >= zGTradeZoneBullishHTF[i].low) {
               myEAs.valueInternal.vi_intSLow_isMitigatedPoiZone = true;
               break;
            }
         }
      }
      
      
      
   }
   
   
   // Kiểm tra xem Swing break có phải là swept đỉnh hoặc đáy trước đó hay không?
   if (ArraySize(tfData.intSHighs) > 1 && ArraySize(tfData.intSLows) > 1) {
      myEAs.valueInternal.vi_intSnR = (tfData.iTrend == 1)? tfData.intSHighs[1] : tfData.intSLows[1];
      if (tfData.iTrend == 1) {
         if (barBreak.high < tfData.intSHighs[1]) {
            // phai sweept intsHigh[1] bang swing high [0]
            myEAs.valueInternal.vi_isSwept = (barSwing.high > tfData.intSHighs[1] && barSwing.close < tfData.intSHighs[1]) ? true : false;
         } else {
            // gia close cua break va swing deu thap hon swing high[1]
            myEAs.valueInternal.vi_isSwept = ((barBreak.close < tfData.intSHighs[1] && barSwing.close < tfData.intSHighs[1]) || barSwing.close < tfData.intSHighs[1]) ? true : false;
         }
      } else if (tfData.iTrend == -1) {
         if (barBreak.low > tfData.intSLows[1]) {
            // phai sweept intsHigh[1] bang swing high [0]
            myEAs.valueInternal.vi_isSwept = (barSwing.low < tfData.intSLows[1] && barSwing.close > tfData.intSLows[1]) ? true : false;
         } else {
            // gia close cua break va swing deu thap hon swing high[1]
            myEAs.valueInternal.vi_isSwept = ((barBreak.close > tfData.intSLows[1] && barSwing.close > tfData.intSLows[1] )|| barSwing.close > tfData.intSLows[1]) ? true : false;
         }
      }
   } else {
      myEAs.valueInternal.vi_intSnR = (tfData.iTrend == 1)? tfData.intSHighs[0] : tfData.intSLows[0];
      myEAs.valueInternal.vi_isSwept = false;
   }
   
   // Kiểm tra Swing có mitigated POI hay không.
   if(myEAs.valueInternal.vi_isMitigatedPoiZone == false || myEAs.valueInternal.vi_isSweptPoiZone == false) {
      // Nếu Trend là trend tăng
      if(tfData.mTrend == 1 && tfData.iTrend == -1 && ArraySize(zGTradeZoneBullishHTF) > 0 && direction == 1) {
         // kiểm tra toàn bộ các PoiZone bullish
         for(int i=0;i<ArraySize(zGTradeZoneBullishHTF);i++) {
            if(zGTradeZoneBullishHTF[i].mitigated == -1) continue; // Poizone da bi pha qua truoc do. bo qua
            if(barSwing.low > zGTradeZoneBullishHTF[i].high) continue; // Gia chua cham vao poizone. bo qua
            
            if(barSwing.low < zGTradeZoneBullishHTF[i].low && barSwing.close > zGTradeZoneBullishHTF[i].low) {
               myEAs.valueInternal.vi_isSweptPoiZone = true;
            }
            if(barSwing.low <= zGTradeZoneBullishHTF[i].high && barSwing.low >= zGTradeZoneBullishHTF[i].low) {
               myEAs.valueInternal.vi_isMitigatedPoiZone = true;
               break;
            }
         }
      } else if(tfData.mTrend == -1 && tfData.iTrend == 1 && ArraySize(zGTradeZoneBearishHTF) > 0 && direction == -1){
         // kiểm tra toàn bộ các PoiZone bearish
         for(int i=0;i<ArraySize(zGTradeZoneBearishHTF);i++) {
            if(zGTradeZoneBearishHTF[i].mitigated == -1) continue; // Poizone da bi pha qua truoc do. bo qua
            if(barSwing.high < zGTradeZoneBearishHTF[i].low) continue; // Gia chua cham vao poizone. bo qua
            
            if(barSwing.high > zGTradeZoneBearishHTF[i].high && barSwing.close < zGTradeZoneBearishHTF[i].high) {
               myEAs.valueInternal.vi_isSweptPoiZone = true;
            }
            if(barSwing.high >= zGTradeZoneBearishHTF[i].low && barSwing.high <= zGTradeZoneBearishHTF[i].high) {
               myEAs.valueInternal.vi_isMitigatedPoiZone = true;
               break;
            }
         }
      }
       
   } // End Kiem tra
   
   // Kiểm tra bar swing đã mitigated Order Flow hay chưa
   if (tfData.iTrend == 1 && direction == 1) {
      myEAs.valueInternal.vi_isMitigatedOrderFlow = (barSwing.low <= myEAs.valueInternal.vi_intSnR)? true : false;
   } else if (tfData.iTrend == -1 && direction == -1) {
      myEAs.valueInternal.vi_isMitigatedOrderFlow = (barSwing.high >= myEAs.valueInternal.vi_intSnR)? true : false;
   }
   
   if(StringLen(text) > 0) {
      
      text += "============= SET THONG SO SWING : ";
      text += ((direction == 1) ? ("LOW = "+DoubleToString(barSwing.low, _Digits)) : ("HIGH = "+ DoubleToString(barSwing.high, _Digits)) )+ " TAI THOI DIEM "+TimeToString(barSwing.time);
      text += "(KIỂM TRA THÊM CẢ TRƯƠNG HỢP BREAK SWING NÀY CÓ SWEPT HOAC MITIGATED POIZONE HAY KHÔNG)==============";
      //Print(text);
      
   }
   string message = StringFormat("[HTF] Found TP Swing %s: %s - %s", 
         (direction == 1)? "LOW" : "HIGH", (direction == 1)? DoubleToString(barSwing.low, _Digits) : DoubleToString(barSwing.high, _Digits), TimeToString(barSwing.time));
   sendNoti(message);
}


//+--------------------------------------------------------------------------------------+
//| Hàm check trạng thái High Timeframe Internal Buy or Sell dựa trên volume wave        |
//+--------------------------------------------------------------------------------------+
int getStatusInternalBuySell(TimeFrameData& tfData, int typeBuyOrSell) {
   int result = 0;
   // return Buy
   if (typeBuyOrSell == 1) {
      // Phai Break success
      if(tfData.iTrend == 1) {
         // Break voi volume thap
         if(tfData.wvItrend != tfData.iTrend) {
            // Neu swept voi volume thap.
            if (myEAs.valueInternal.vi_isSwept) {
               //Print("Swept đỉnh với volume thấp. Trả về false Breakout => Sell");
               return -1;
            }
         }
      } 
      // Phai swept hoặc mitigated Poizone hoặc swept poizone
      else if (tfData.iTrend == -1) {
         if (myEAs.valueInternal.vi_ITrend != 0 && tfData.wvItrend != tfData.iTrend) {
            // Neu swept voi volume thap.
            if (myEAs.valueInternal.vi_isSwept) {
               //Print("Swept đáy với volume thấp. Trả về false Breakout => Buy");
               return 1;
            }
            
            // Neu break voi volume thap + Mitigated PoiZone Marjor
            if (tfData.mTrend != tfData.iTrend && myEAs.valueInternal.vi_isMitigatedPoiZone) {
               //Print("Break đáy với volume thấp. Mitigated Poizone Marjor => Buy");
               return 1;
            }
            
            // Neu break voi volume thap + Mitigated PoiZone Marjor
            if (tfData.mTrend != tfData.iTrend && myEAs.valueInternal.vi_isSweptPoiZone) {
               //Print("Break đáy với volume thấp. Swept Poizone Marjor => Buy");
               return 1;
            }
         }
         
      }
      //Print("Khong vao truong hop ngoai le nao. Tra ve trang thai wave volume binh thuong");
      result = (tfData.wvIsBuyInternal)? 1 : -1;
   } 
   // return Sell
   else if (typeBuyOrSell == -1) {
      // Phai Break success
      if(tfData.iTrend == -1) {
         // Break voi volume thap
         if(tfData.wvItrend != tfData.iTrend) {
            // Neu swept voi volume thap.
            if (myEAs.valueInternal.vi_isSwept && tfData.wvItrend != tfData.iTrend) {
               //Print("Swept đáy với volume thấp. Trả về false Breakout => Buy");
               return 1;
            }
         }
         
      } 
      // Phai swept
      else if (tfData.iTrend == 1) {
         if (myEAs.valueInternal.vi_ITrend != 0 && tfData.wvItrend != tfData.iTrend) {
            // Neu swept voi volume thap.
            if (myEAs.valueInternal.vi_isSwept && tfData.wvItrend != tfData.iTrend) {
               //Print("Swept đỉnh với volume thấp. Trả về false Breakout => Sell");
               return -1;
            }
            // Neu break voi volume thap + Mitigated PoiZone Marjor
            if (tfData.mTrend != tfData.iTrend && myEAs.valueInternal.vi_isMitigatedPoiZone) {
               //Print("Break đỉnh với volume thấp. Mitigated Poizone Marjor => Sell");
               return -1;
            }
            
            // Neu break voi volume thap + Mitigated PoiZone Marjor
            if (tfData.mTrend != tfData.iTrend && myEAs.valueInternal.vi_isSweptPoiZone) {
               //Print("Break đỉnh với volume thấp. Swept Poizone Marjor => Sell");
               return -1;
            }
          }  
      }
      //Print("Khong vao truong hop ngoai le nao. Tra ve trang thai wave volume binh thuong");
      result = (tfData.wvIsSellInternal)? -1 : 1;
   }
   return result;
}

//+------------------------------------------------------------------+
//| Hàm tìm kiếm nến sử dụng MqlRates                                |
//| type: 1 (Up), -1 (Down)                                          |
//| current_bar: Cấu trúc MqlRates của nến chỉ định (nến hiện tại)   |
//| limit_time: Thời gian giới hạn lùi về quá khứ                    |
//| result_bar: Cấu trúc nến tìm được sẽ lưu vào đây                 |
//| Trả về: true nếu tìm thấy, false nếu không                       |
//+------------------------------------------------------------------+
bool FindCandleByRates(int type, ENUM_TIMEFRAMES timeframe, MqlRates &current_bar, datetime limit_time, MqlRates &result_bar)
{
   bool print_log = disableComment;
   // 1. Kiểm tra chính cây nến truyền vào
   bool is_up = current_bar.close > current_bar.open;
   bool is_down = current_bar.close < current_bar.open;

   if((type == 1 && is_up) || (type == -1 && is_down))
   {
      if(print_log) Print(TAB_STRING+"--- Tự nến swing là nến OB");
      result_bar = current_bar; // Gán toàn bộ thông tin nến hiện tại vào kết quả
      return true;              // Trả về true ngay lập tức
   }

   // 2. Nếu không phải, bắt đầu tìm kiếm ngược về quá khứ
   MqlRates rates[];
   ArraySetAsSeries(rates, true); // Đảo ngược mảng để index 0 là nến mới nhất
   
   // Lấy dữ liệu nến từ biểu đồ (lấy đủ nhiều để đảm bảo tới được limit_time)
   // Sử dụng thời gian nhỏ hơn làm start_time và thời gian lớn hơn làm stop_time để đảm bảo CopyRates thành công
   datetime t_start = (current_bar.time < limit_time) ? current_bar.time : limit_time;
   datetime t_stop  = (current_bar.time > limit_time) ? current_bar.time : limit_time;
   int copied = CopyRates(_Symbol, timeframe, t_start, t_stop, rates);
   
   if(copied <= 1) return false; // Không có dữ liệu nến nào khác để tìm

   // Bắt đầu từ index 1 (vì index 0 chính là current_bar chúng ta đã kiểm tra ở trên)
   for(int i = 1; i < copied; i++)
   {
      // Kiểm tra loại nến
      bool found = false;
      if(type == 1 && rates[i].close > rates[i].open) found = true;
      if(type == -1 && rates[i].close < rates[i].open) found = true;

      if(found)
      {
         if(print_log) Print(TAB_STRING+"--- Sau nến swing "+(string)i+" nến là nến OB");
         result_bar = rates[i]; // Lưu nến tìm được
         return true;
      }
   }

   return false; // Không tìm thấy nến nào thỏa mãn
}

//+----------------------------------------------------------------------------+
//| Hàm quan trọng. Check sóng PullBack                                        |
//| Setup thông số swing High, Low tạm thời có thích hợp để trade hay không.   |     
//| Mọi logic trade về lấy thông số sẽ được viết tại hàm này.                  |
//+----------------------------------------------------------------------------+
void checkValueWithInternalSwingHTF(TimeFrameData& tfData, MqlRates& barPrev, MqlRates& barSwing, MqlRates& barNext, int direction = 0, int type = 0) {
   if(myEAs.valueInternal.vi_ITrend == 0 || (direction != 1 && direction != -1)) return;
   if (type == INTERNAL_PULLBACK_MAIN) {
      myEAs.valueInternal.vi_ITrend = tfData.iTrend;
      myEAs.valueInternal.vi_wvITrend = tfData.wvItrend;
      myEAs.valueInternal.vi_mTrend = tfData.mTrend;
      myEAs.valueInternal.vi_wvmTrend = tfData.wvMtrend;
   }
   int pattent = -1, pattent_again = -1, check_lowtf = -1;
   bool isMitigated = false, isSwept = false;
   // BULLISH
   if (direction == 1) { 
      
      #define sData myEAs.valueInternal.candidate_Low
      if (type == INTERNAL_PULLBACK_MAIN) {
         sData.Reset();
         sData.vins_SwingNew = barSwing.low;
         sData.vins_SwingTimeNew = barSwing.time;
         sData.vins_barSwing = barSwing;
      }
      if (type == INTERNAL_PULLBACK_MAIN) {
         FindCandleByRates(-1, tfData.timeFrame, barSwing, myEAs.valueInternal.vi_intSHighTime, sData.vins_barOrderBlock);
      } else {
         FindCandleByRates(-1, tfData.timeFrame, barSwing, tfData.HighsTime[0], sData.vins_barOrderBlock);
      }
      
      
      // 1. Kiểm tra Swept (nếu có cài đặt)
      if (isCheckPullBackBySwept && !CheckTheCandleCluster(barPrev, barSwing, barNext, direction, true)) {
         //#undef sData
         return;
      }
      // 2. Kiểm tra Cấu trúc Cluster (Phân tầng tối ưu)
      bool isCluster = CheckTheCandleCluster(barPrev, barSwing, barNext, direction);
      
      if(isCluster) {
         // Nếu Cluster thỏa mãn, bước vào check Engulfing nới lỏng so với nến OrderBlock
         if(CheckTheCandleEngulfing(sData.vins_barOrderBlock, barNext, 1)) {
            sData.vins_isSignalConfirm_Patten = 1;
            sData.vins_isSignalConfirm_LTF = 0;
            sData.vins_isSignalConfirm_Patten_Again = -1;
         } else {
            // Cluster thỏa mãn nhưng chưa Engulfing -> Chế độ chờ
            sData.vins_isSignalConfirm_Patten = -1;
            sData.vins_isSignalConfirm_LTF = 2;
            sData.vins_isSignalConfirm_Patten_Again = 1;
         }
      } else {
         // Cluster không thỏa mãn -> Reset
         sData.vins_isSignalConfirm_Patten = -1;
         sData.vins_isSignalConfirm_LTF = 2;
         sData.vins_isSignalConfirm_Patten_Again = 1;
      }
      
      
      if (type == INTERNAL_PULLBACK_MAIN) {
         // Order Flow & POI (Giữ nguyên)
         if(ArraySize(tfData.intSHighs) > 1 && ArraySize(tfData.intSLows) > 1) {
            if(barSwing.low <= tfData.intSHighs[1] && barSwing.low >= tfData.intSLows[1]) sData.vins_isOrderFlowMitigated = true;
         }
         for(int i=0; i<ArraySize(zGTradeZoneInternalBullishHTF); i++){
            if(zGTradeZoneInternalBullishHTF[i].mitigated == -1) continue;
            if(barSwing.low > zGTradeZoneInternalBullishHTF[i].high) continue;
            if(barSwing.low < zGTradeZoneInternalBullishHTF[i].low && barSwing.close > zGTradeZoneInternalBullishHTF[i].low) sData.vins_isPoiZoneSwept = true;
            if(barSwing.low <= zGTradeZoneInternalBullishHTF[i].high && barSwing.low >= zGTradeZoneInternalBullishHTF[i].low) {
               sData.vins_isPoiZoneMitigated = true; break;
            }
         }
      }
      pattent = sData.vins_isSignalConfirm_Patten;
      pattent_again = sData.vins_isSignalConfirm_Patten_Again;
      check_lowtf = sData.vins_isSignalConfirm_LTF;
      isMitigated = sData.vins_isOrderFlowMitigated;
      isSwept = sData.vins_isPoiZoneSwept;
      
      // Khi Main hình thành lần đầu, candidate sẽ được copy du lieu dau tien vao main
      if (type == INTERNAL_PULLBACK_MAIN) {
         myEAs.valueInternal.vi_TempSwing_Low.main = sData;
      }
      #undef sData
   } 
   else { 
      
      #define sData myEAs.valueInternal.candidate_High
      if (type == INTERNAL_PULLBACK_MAIN) {
         sData.Reset();
         sData.vins_SwingNew = barSwing.high;
         sData.vins_SwingTimeNew = barSwing.time;
         sData.vins_barSwing = barSwing;
      }   
      
      if (type == INTERNAL_PULLBACK_MAIN) {
         FindCandleByRates(1, tfData.timeFrame, barSwing, myEAs.valueInternal.vi_intSLowTime, sData.vins_barOrderBlock);
      } else {
         FindCandleByRates(1, tfData.timeFrame, barSwing, tfData.LowsTime[0], sData.vins_barOrderBlock);
      }
      
      if (isCheckPullBackBySwept && !CheckTheCandleCluster(barPrev, barSwing, barNext, direction, true)) {
         //#undef sData
         return;
      }
      
      // Kiểm tra Cấu trúc Cluster
      bool isCluster = CheckTheCandleCluster(barPrev, barSwing, barNext, direction);
      
      if(isCluster) {
         // Nếu Cluster thỏa mãn, check Engulfing giảm so với nến OB
         if(CheckTheCandleEngulfing(sData.vins_barOrderBlock, barNext, -1)) {
            sData.vins_isSignalConfirm_Patten = 1;
            sData.vins_isSignalConfirm_LTF = 0;
            sData.vins_isSignalConfirm_Patten_Again = -1;
         } else {
            sData.vins_isSignalConfirm_Patten = -1;
            sData.vins_isSignalConfirm_LTF = 2;
            sData.vins_isSignalConfirm_Patten_Again = 1;
         }
      } else {
         sData.vins_isSignalConfirm_Patten = -1;
         sData.vins_isSignalConfirm_LTF = 2;
         sData.vins_isSignalConfirm_Patten_Again = 1;
      }
      if (type == INTERNAL_PULLBACK_MAIN) {
         if(ArraySize(tfData.intSLows) > 1 && ArraySize(tfData.intSHighs) > 1) {
            if(barSwing.high >= tfData.intSLows[1] && barSwing.high <= tfData.intSHighs[1]) sData.vins_isOrderFlowMitigated = true;
         }
         for(int i=0; i<ArraySize(zGTradeZoneInternalBearishHTF); i++){
            if(zGTradeZoneInternalBearishHTF[i].mitigated == -1) continue;
            if(barSwing.high < zGTradeZoneInternalBearishHTF[i].low) continue;
            if(barSwing.high > zGTradeZoneInternalBearishHTF[i].high && barSwing.close < zGTradeZoneInternalBearishHTF[i].high) sData.vins_isPoiZoneSwept = true;
            if(barSwing.high >= zGTradeZoneInternalBearishHTF[i].low && barSwing.high <= zGTradeZoneInternalBearishHTF[i].high) {
               sData.vins_isPoiZoneMitigated = true; break;
            }
         }
      } else if (type == INTERNAL_PULLBACK_SUB) {
      
      }
      
      pattent = sData.vins_isSignalConfirm_Patten;
      pattent_again = sData.vins_isSignalConfirm_Patten_Again;
      check_lowtf = sData.vins_isSignalConfirm_LTF;
      isMitigated = sData.vins_isOrderFlowMitigated;
      isSwept = sData.vins_isPoiZoneSwept;
      
      // Khi Main hình thành lần đầu, candidate sẽ được copy du lieu dau tien vao main
      if (type == INTERNAL_PULLBACK_MAIN) {
         myEAs.valueInternal.vi_TempSwing_High.main = sData;
      }
      #undef sData
   }
   //DeleteAllPendingOrders(_Symbol, InpMagic);
   string message = "";
   string str_completed = (check_lowtf == 1)? "Completed" : "Not Completed";
   message = StringFormat("[HTF] PB %s Swing %s at %s is [%s] => Pattent: %s, Scan Again: %s, Check LowTF: %s, IsMitigatedPoizone: %s, IsSweptPoiZone: %s",
                          (direction == 1)? "LOW" : "HIGH", (direction == 1)? DoubleToString(barSwing.low, _Digits) : DoubleToString(barSwing.high, _Digits) , TimeToString(barSwing.time), str_completed, (pattent == 1)? "yes" : "no", 
                          (pattent_again == 1)? "yes" : "no", (check_lowtf == 1)? "yes" : "no", (isMitigated)? "yes" : "no", (isSwept)? "yes" : "no");
   
   string text = "========[CHECK "+((direction == 1)? "LOW":"HIGH")+"] Kiểm tra thông số tín hiệu PullBack (EG hoặc Swept) Swing HTF "+((type == INTERNAL_PULLBACK_MAIN)? "MAIN": "SUB")+" hoàn tất ========";
   //Print(text);
   sendNoti(message);
}
         

// Hàm set lại thông số target và stoploss của lowTF theo HighTF
void setValueRealtimeByHighTF(TimeFrameData& tfData) {
   // Thêm thông số ban đầu Data Default Internal High TF sau khi break
   myEAs.statusInternalHTL.sHL_ITrend = tfData.iTrend;
   myEAs.statusInternalHTL.sHL_vITrend = tfData.vItrend;
   myEAs.statusInternalHTL.sHL_iStoploss = tfData.iStoploss;
   myEAs.statusInternalHTL.sHL_iStoplossTime = tfData.iStoplossTime;
   myEAs.statusInternalHTL.sHL_iOrderBlock = tfData.iOrderBlock;
   myEAs.statusInternalHTL.sHL_iSnR = tfData.iSnR;
   myEAs.statusInternalHTL.sHL_iTarget = tfData.iTarget;
   myEAs.statusInternalHTL.sHL_iTargetTime = tfData.iTargetTime;
   myEAs.statusInternalHTL.sHL_mitigate_iOrderBlock = 0;
   if (myEAs.statusInternalHTL.sHL_iTarget != 0) {
      myEAs.statusInternalHTL.sHL_mitigate_iOrderFlow = 0;
      myEAs.statusInternalHTL.sHL_mitigate_iOrderBlock = 0;
   }
}


//+------------------------------------------------------------------+
//| Hàm kiểm tra Setup Sweep + Engulfing                             |
//+------------------------------------------------------------------+
int CheckCandleByTime(datetime checkTime, ENUM_TIMEFRAMES tf, int mode)
{  
   // 0. Chuyển đổi thời gian sang chỉ số shift
   int shift = iBarShift(_Symbol, tf, checkTime, false);
   
   if(shift < 1) 
   {
      PrintFormat(">>> [%s] Dữ liệu chưa sẵn sàng (Nến kế tiếp chưa đóng).", TimeToString(checkTime));
      return 0; 
   }
   
   // 1. Khai báo mảng kiểu MqlRates để chứa dữ liệu
   MqlRates bars[];
   
   // 2. Chuyển mảng về dạng chuỗi thời gian (để chỉ số 0 là nến hiện tại)
   ArraySetAsSeries(bars, true);
   
   // 3. Sao chép dữ liệu của thanh nến tại vị trí shift - 1
   int count = 3;     // Số lượng nến cần lấy
   // Tham số: Symbol, Timeframe, vị trí bắt đầu, số lượng nến cần lấy, mảng đích
   int copied = CopyRates(_Symbol, tf, shift - 1, count, bars);
   if(copied < count)
   {
      PrintFormat(">>> Lỗi sao chép dữ liệu nến cho CheckCandleByTime: chỉ copy được %d/%d nến.", copied, count);
      return 0;
   }
   MqlRates barNext = bars[0];
   MqlRates barCenter = bars[1];
   MqlRates barPrev = bars[2];
   
   int result = 0;
   result = CheckTheCandleCluster(barPrev, barCenter, barNext, mode) ? 1 : 0;
   return result;
}

// Hàm trả về trạng thái của cụm 3 nến là EG hoặc swept hay không?
bool CheckTheCandleCluster(MqlRates& barPrev, MqlRates& barCenter, MqlRates& barNext, int mode = 0, bool checkIsSweep = false) {
   // LẤY DỮ LIỆU GIÁ
   double oNext = barNext.open;
   double cNext = barNext.close;
   
   double o0 = barCenter.open;
   double c0 = barCenter.close;
   double h0 = barCenter.high;
   double l0 = barCenter.low;
   
   double o1 = barPrev.open;
   double c1 = barPrev.close;
   double h1 = barPrev.high;
   double l1 = barPrev.low;

   string side = (mode == 1) ? "BUY" : "SELL";

   // --- LOGIC CHO LỆNH BUY (1) ---
   if(mode == 1)
   {
      // Bước 1: Kiểm tra Sweep râu dưới
      bool isSweep = (l0 < l1) && (c0 > l1);
      if(!isSweep) 
      {
         //PrintFormat("[%s] Tín hiệu kém: Nến không quét râu dưới nến trước (L0:%s >= L1:%s)", side, DoubleToString(l0, _Digits), DoubleToString(l1, _Digits));
         return false;
      } else {
         //PrintFormat("[%s] XÁC NHẬN: Nến swing swept nến trước thành công!", side);
         if(checkIsSweep) {
            return true;
         }
         //
      }

      // Bước 2: Kiểm tra nến mục tiêu TỰ Engulfing nến trước
      bool selfEngulfing = (c0 > o0) && (c0 >= c1) && (c0 > o1);
      if(selfEngulfing) 
      {
         //PrintFormat("[%s] XÁC NHẬN: Nến mục tiêu tự Engulfing mạnh!", side);
         return true;
      }

      // Bước 3: Kiểm tra nến kế tiếp Engulfing nến mục tiêu
      bool nextEngulfing = (cNext > oNext) && (cNext >= c0) && (cNext > o0);
      if(nextEngulfing)
      {
         //PrintFormat("[%s] XÁC NHẬN: Nến kế tiếp Engulfing thành công!", side);
         return true;
      }
      
      //PrintFormat("[%s] Tín hiệu kém: Đã sweep nhưng không có nến Engulfing xác nhận.", side);
   }

   // --- LOGIC CHO LỆNH SELL (-1) ---
   if(mode == -1)
   {
      
      // Bước 1: Kiểm tra Sweep râu trên
      bool isSweep = (h0 > h1) && (c0 < h1);
      if(!isSweep) 
      {
         //PrintFormat("[%s] Tín hiệu kém: Nến không quét râu trên nến trước (H0:%s <= H1:%s)", side, DoubleToString(h0, _Digits), DoubleToString(h1, _Digits));
         return false;
      } else {
         //PrintFormat("[%s] XÁC NHẬN: Nến swing swept nến trước thành công!", side);
         if(checkIsSweep) {
            return true;
         }
      }
      
      // Bước 2: Kiểm tra nến mục tiêu TỰ Engulfing nến trước
      bool selfEngulfing = (c0 < o0) && (c0 <= c1) && (c0 < o1);
      if(selfEngulfing)
      {
         //PrintFormat("[%s] XÁC NHẬN: Nến mục tiêu tự Engulfing mạnh!", side);
         return true;
      }

      // Bước 3: Kiểm tra nến kế tiếp Engulfing nến mục tiêu
      bool nextEngulfing = (cNext < oNext) && (cNext <= c0) && (cNext < o0);
      if(nextEngulfing)
      {
         //PrintFormat("[%s] XÁC NHẬN: Nến kế tiếp Engulfing thành công!", side);
         return true;
      }
      
      
      //PrintFormat("[%s] Tín hiệu kém: Đã sweep nhưng không có nến Engulfing xác nhận.", side);
   }

   return false;
}

// +------------------------------------------------------------------+
// | Hàm kiểm tra nến nhấn chìm (Engulfing) - Điều kiện thân nến        |
// | type = 1: Bullish EG (Close > Body nến trước)                     |
// | type = -1: Bearish EG (Close < Body nến trước)                    |
// +------------------------------------------------------------------+
bool CheckTheCandleEngulfing(MqlRates &candlePrev, MqlRates &candleCurrent, int type) {
   
   if (type == 1) { // BULLISH ENGULFING
      // 1. Nến hiện tại phải là nến tăng
      if (candleCurrent.close <= candleCurrent.open) return false;
      
      // 2. Xác định phần cao nhất của thân nến trước (Body High)
      double bodyHighPrev = MathMax(candlePrev.open, candlePrev.close);
      
      // 3. Chỉ cần giá đóng cửa vượt qua thân nến cao nhất trước đó
      if (candleCurrent.close > bodyHighPrev) return true;
   } 
   else if (type == -1) { // BEARISH ENGULFING
      // 1. Nến hiện tại phải là nến giảm
      if (candleCurrent.close >= candleCurrent.open) return false;
      
      // 2. Xác định phần thấp nhất của thân nến trước (Body Low)
      double bodyLowPrev = MathMin(candlePrev.open, candlePrev.close);
      
      // 3. Chỉ cần giá đóng cửa thấp hơn thân nến thấp nhất trước đó
      if (candleCurrent.close < bodyLowPrev) return true;
   }
   
   return false;
}

//+-----------------------------------------------------------------------------------+
//|      Tổ hợp các Hàm Scan poizone low timeframe thuộc Internal Break high timeframe|
//+-----------------------------------------------------------------------------------+
// Phương thức scan mảng từ Gann thành Poizone to Trade theo marjor struct
void scanMarjorTradeZoneHighTF(TimeFrameData& tfData, MqlRates& bar1) {
   bool isFound = false;
   PoiZone zone_tmp;
   // Nếu đang là xu hướng tăng
   if (tfData.mTrend == 1) {
      // Kiểm tra xem đã get IDM hay chưa.
      if (tfData.arrPbHTime[0] > tfData.arrPbLTime[0]) { return;}
      // Bắt đầu scan marjor zone bullish
      for(int i=ArraySize(tfData.zLows) - 1; i >= 0 ; i--) {
         // Kiem tra neu zone khong thuoc thoi gian chi dinh thi bo qua
         if (tfData.zLows[i].time < tfData.arrPbLTime[0]) continue;
         
         // Kiểm tra nếu zone đã bị phá qua rồi thì bỏ qua
         if (tfData.zLows[i].mitigated == -1) continue;
         isFound = false;
         // Kiểm tra nếu đã tồn tại zone rồi thì bỏ qua
         for (int j=0; j< ArraySize(zGTradeZoneBullishHTF); j++) {
            if (tfData.zLows[i].time == zGTradeZoneBullishHTF[j].time 
               && MathAbs(tfData.zLows[i].high - zGTradeZoneBullishHTF[j].high) < 0.00001 
               && MathAbs(tfData.zLows[i].low - zGTradeZoneBullishHTF[j].low) < 0.00001) {
               //if (tfData.zLows[i].mitigated != zGTradeZoneBullishHTF[j].mitigated) {
               //   // Cập nhật trạng thái mitigated mới
               //   zGTradeZoneBullishHTF[j].mitigated = tfData.zLows[i].mitigated;
               //}
               isFound = true;
               // Đã tồn tại zone
               break;
            }
         }
         if (isFound) continue;  // ← Bỏ qua nếu đã tìm thấy trong Trade Zone
         zone_tmp = tfData.zLows[i];
         zone_tmp.mitigated = 0;
         zone_tmp.isSwept = false;
         // Kiểm tra Extreme zone
         if (tfData.zLows[i].low == tfData.arrPbLow[0] && tfData.zLows[i].time == tfData.arrPbLTime[0]) {
            zone_tmp.zoneColor = color_HTF_Extreme_Bullish_Zone;
            zone_tmp.isTypeZone = 1;
         } else {
            zone_tmp.zoneColor = color_HTF_Decisional_Bullish_Zone;
            zone_tmp.isTypeZone = 2;
         }
         zone_tmp.name = MARJOR_TEXT_GLOBAL+"_"+BULL_TEXT+"_"+TimeToString(zone_tmp.time);
         // Them zone zLows vao zGTradeZoneBullishHTF
         tfData.AddToPoiZoneArray(zGTradeZoneBullishHTF, zone_tmp, poi_limit, zone_tmp.name);
         // Ve POI
         DrawBox(0, zone_tmp.name, 0, zone_tmp.time, zone_tmp.low, bar1.time, zone_tmp.high, zone_tmp.zoneColor, STYLE_SOLID,1, true, false, false, true, 0);
      }
   } else if(tfData.mTrend == -1) { // Nếu đang là xu hướng giảm
      // Kiểm tra xem đã get IDM hay chưa.
      if (tfData.arrPbLTime[0] > tfData.arrPbHTime[0]) { return;}
      // Bắt đầu scan marjor zone bearish
      for(int i=ArraySize(tfData.zHighs) - 1; i >= 0 ; i--) {
         // Kiem tra neu zone khong thuoc thoi gian chi dinh thi bo qua
         if (tfData.zHighs[i].time < tfData.arrPbHTime[0]) continue;
         
         // Kiểm tra nếu zone đã bị phá qua rồi thì bỏ qua
         if (tfData.zHighs[i].mitigated == -1) continue;
         isFound = false;
         // Kiểm tra nếu đã tồn tại zone rồi thì bỏ qua
         for (int j=0; j< ArraySize(zGTradeZoneBearishHTF); j++) {
            if (tfData.zHighs[i].time == zGTradeZoneBearishHTF[j].time 
               && MathAbs(tfData.zHighs[i].high - zGTradeZoneBearishHTF[j].high) < 0.00001 
               && MathAbs(tfData.zHighs[i].low - zGTradeZoneBearishHTF[j].low) < 0.00001) {
               //if( tfData.zHighs[i].mitigated != zGTradeZoneBearishHTF[j].mitigated) {
               //   // Cập nhật trạng thái mitigated mới
               //   zGTradeZoneBearishHTF[j].mitigated = tfData.zHighs[i].mitigated;
               //}
               // Đã tồn tại zone
               isFound = true;
               break;
            }
         }
         if (isFound) continue;  // ← Bỏ qua nếu đã tìm thấy trong Trade Zone
         zone_tmp = tfData.zHighs[i];
         zone_tmp.mitigated = 0;
         zone_tmp.isSwept = false;
         // Kiểm tra Extreme zone
         if (tfData.zHighs[i].high == tfData.arrPbHigh[0] && tfData.zHighs[i].time == tfData.arrPbHTime[0]) {
            zone_tmp.zoneColor = color_HTF_Extreme_Bearish_Zone;
            zone_tmp.isTypeZone = 1;
         } else {
            zone_tmp.zoneColor = color_HTF_Decisional_Bearish_Zone;
            zone_tmp.isTypeZone = 2;
         }
         zone_tmp.name = MARJOR_TEXT_GLOBAL+"_"+BEAR_TEXT+"_"+TimeToString(zone_tmp.time);
         // Them zone zLows vao zGTradeZoneBullishHTF
         tfData.AddToPoiZoneArray(zGTradeZoneBearishHTF, zone_tmp, poi_limit, zone_tmp.name);
         // Ve POI
         DrawBox(0, zone_tmp.name, 0, zone_tmp.time, zone_tmp.high, bar1.time, zone_tmp.low, zone_tmp.zoneColor, STYLE_SOLID,1, true, false, false, true, 0);
      }
   }
}

// Phương thức reset mảng Global Marjor Poizone
void resetTradeZoneHTF(TimeFrameData& tfData, PoiZone& zone[]) {
   string objName = "";
   if (ArraySize(zone) > 0) {
      for(int i=0;i<ArraySize(zone);i++) {
         objName = zone[i].name;
         if (ObjectFind(0, objName) >= 0) {
            ObjectDelete(0, objName);
         }
      }
   }
   tfData.ClearPoiZoneArray(zone);
}

// Phương thức scan mảng từ Gann thành Poizone to Trade theo Internal structs
void scanInternalTradeZoneHighTF(TimeFrameData& tfData, MqlRates& bar1) {
   // string text = "";
   bool isFound = false;
   string poi_name = "";
   PoiZone zone_tmp;
   // Nếu HTF Internal đang là xu hướng tăng
   if (tfData.iTrend == 1) {
      // ArrayPrint(tfData.zLows);
      // ArrayPrint(zGTradeZoneInternalBullishHTF);
      for(int i=ArraySize(tfData.zLows) -1; i >= 0 ; i--) {
         
         // Kiem tra neu zone khong thuoc thoi gian chi dinh thi bo qua
         if (tfData.zLows[i].time < tfData.intSLowTime[0]) continue;
         
         // Kiểm tra nếu zone đã bị phá qua rồi thì bỏ qua
         if (tfData.zLows[i].mitigated == -1) continue;
         isFound = false;
         poi_name = "";
         // Kiểm tra nếu đã tồn tại zone rồi thì bỏ qua
         for (int j=0; j< ArraySize(zGTradeZoneInternalBullishHTF); j++) {
            if (tfData.zLows[i].time == zGTradeZoneInternalBullishHTF[j].time 
               && MathAbs(tfData.zLows[i].high - zGTradeZoneInternalBullishHTF[j].high) < 0.00001 
               && MathAbs(tfData.zLows[i].low - zGTradeZoneInternalBullishHTF[j].low) < 0.00001) {
               //if (tfData.zLows[i].mitigated != zGTradeZoneInternalBullishHTF[j].mitigated) {
               //   // Cập nhật trạng thái mitigated mới
               //   zGTradeZoneInternalBullishHTF[j].mitigated = tfData.zLows[i].mitigated;
               //}
               isFound = true;
               // Đã tồn tại zone
               break;
            }
         }
         if (isFound) continue;  // ← Bỏ qua nếu đã tìm thấy trong Trade Zone
         zone_tmp = tfData.zLows[i];
         zone_tmp.mitigated = 0;
         zone_tmp.isSwept = false;
         // Kiểm tra Extreme zone
         zone_tmp.isTypeZone = (tfData.zLows[i].low == tfData.intSLows[0] && tfData.zLows[i].time == tfData.intSLowTime[0]) ? 1 : 2;
         zone_tmp.zoneColor = color_Global_Internal_Bullish_Zone_HTF;
         poi_name = INTERNAL_TEXT_GLOBAL+"_"+BULL_TEXT+"_"+TimeToString(zone_tmp.time);
         // Them zone zLows vao zGTradeZoneInternalBullishHTF
         tfData.AddToPoiZoneArray(zGTradeZoneInternalBullishHTF, zone_tmp, poi_limit, poi_name);
         DrawBox(0, poi_name, 0, zone_tmp.time, zone_tmp.low, bar1.time, zone_tmp.high, zone_tmp.zoneColor, STYLE_SOLID,1, true, false, false, true, 0);
         // text += "\nThêm zone Internal Bullish HTF: Time - " + TimeToString(tfData.zLows[i].time) + " High - " + DoubleToString(tfData.zLows[i].high, _Digits) + " Low - " + DoubleToString(tfData.zLows[i].low, _Digits);
      }
   } else if(tfData.iTrend == -1) { // Nếu HTF Internal đang là xu hướng giảm
      // ArrayPrint(tfData.zHighs);
      // ArrayPrint(zGTradeZoneInternalBearishHTF);
      for(int i=ArraySize(tfData.zHighs) -1; i >= 0 ; i--) {
         // Kiem tra neu zone khong thuoc thoi gian chi dinh thi bo qua
         if (tfData.zHighs[i].time < tfData.intSHighTime[0]) continue;
         
         // Kiểm tra nếu zone đã bị phá qua rồi thì bỏ qua
         if (tfData.zHighs[i].mitigated == -1) continue;
         isFound = false;
         poi_name = "";
         // Kiểm tra nếu đã tồn tại zone rồi thì bỏ qua
         for (int j=0; j< ArraySize(zGTradeZoneInternalBearishHTF); j++) {
            if (tfData.zHighs[i].time == zGTradeZoneInternalBearishHTF[j].time 
               && MathAbs(tfData.zHighs[i].high - zGTradeZoneInternalBearishHTF[j].high) < 0.00001 
               && MathAbs(tfData.zHighs[i].low - zGTradeZoneInternalBearishHTF[j].low) < 0.00001) {
               //if( tfData.zHighs[i].mitigated != zGTradeZoneInternalBearishHTF[j].mitigated) {
               //   // Cập nhật trạng thái mitigated mới
               //   zGTradeZoneInternalBearishHTF[j].mitigated = tfData.zHighs[i].mitigated;
               //}
               // Đã tồn tại zone
               isFound = true;
               break;
            }
         }
         if (isFound) continue;  // ← Bỏ qua nếu đã tìm thấy trong Trade Zone
         zone_tmp = tfData.zHighs[i];
         zone_tmp.mitigated = 0;
         zone_tmp.isSwept = false;
         // Kiểm tra Extreme zone
         zone_tmp.isTypeZone = (tfData.zHighs[i].high == tfData.intSHighs[0] && tfData.zHighs[i].time == tfData.intSHighTime[0])? 1 : 2;
         zone_tmp.zoneColor = color_Global_Internal_Bearish_Zone_HTF;
         poi_name = INTERNAL_TEXT_GLOBAL+"_"+BEAR_TEXT+"_"+TimeToString(zone_tmp.time);
         // Them zone zHighs vao zGTradeZoneInternalBearishHTF
         tfData.AddToPoiZoneArray(zGTradeZoneInternalBearishHTF, zone_tmp, poi_limit, poi_name);
         DrawBox(0, poi_name, 0, zone_tmp.time, zone_tmp.high, bar1.time, zone_tmp.low, zone_tmp.zoneColor, STYLE_SOLID,1, true, false, false, true, 0);
         // text += "\nThêm zone Internal Bearish HTF: Time - " + TimeToString(tfData.zHighs[i].time) + " High - " + DoubleToString(tfData.zHighs[i].high, _Digits) + " Low - " + DoubleToString(tfData.zHighs[i].low, _Digits);
      }
   }
   // if (StringLen(text) > 0) {
   //    Print(text);
   //    Print("-------------------------------------------------------");
   // }
}

// Phương thức duyệt mảng chỉ định làm POI Internal Zone Lowtimeframe từ khoảng giá trị highest và lowest của Internal High Timeframe
void beginScanGlobalZoneInternalSelected(TimeFrameData& tfData, PoiZone& zGlobalInternalZone[], PoiZone& Select_zone[], PoiZone& Target_zone[], int type, MqlRates& bar1){
   string text = "";
   string str_info_row = "";
   string str_tf = (tfData.isHighTF)? "High_TF": "Low_TF";
   text += "\nBắt đầu scan Global Internal Zone thuộc "+ str_tf;
   string name_poi = "";
   int isTypezone = 0;
   PoiZone tmp_zone;
   datetime target_time = (myEAs.statusInternalHTL.sHL_iTarget != 0) ? myEAs.statusInternalHTL.sHL_iTargetTime : bar1.time;
   color gl_color;
   PoiZone zFilterdZone[];
    //Print("zGlobalInternalZone size: "+ (string) ArraySize(zGlobalInternalZone)); ArrayPrint(zGlobalInternalZone);
    //Print("Select_zone size: "+ (string) ArraySize(Select_zone)); ArrayPrint(Select_zone);
   
   // Lọc zone từ Select_zone là tập con của zGlobalInternalZone
   for(int i=ArraySize(zGlobalInternalZone) - 1; i >= 0 ; i--) {
      for(int j=0; j< ArraySize(Select_zone); j++) {
         // Nếu thời gian của Internal Zone LTF không thuộc khoảng thời gian của Global Internal Zone HTF thì bỏ qua
         if ( zGlobalInternalZone[i].time > Select_zone[j].time) continue;
         if (type == 1 && zGlobalInternalZone[i].low <= Select_zone[j].low && zGlobalInternalZone[i].high >= Select_zone[j].low) {
            // Thêm zone vào mảng tạm zFilterdZone
            tfData.AddToPoiZoneArray( zFilterdZone, Select_zone[j]);
         } else if (type == -1 && zGlobalInternalZone[i].high >= Select_zone[j].high && zGlobalInternalZone[i].low <= Select_zone[j].high) {
            // Thêm zone vào mảng tạm zFilterdZone
            tfData.AddToPoiZoneArray( zFilterdZone, Select_zone[j]);
         }
      }
   }
   //Print("zFilterdZone size: "+ (string) ArraySize(zFilterdZone)); ArrayPrint(zFilterdZone);
   // check Zone exits before
   bool next;
   //PoiZone exist_zones[] = Target_zone;
   // Quét toàn bộ zone intSLows
   for(int i=ArraySize(zFilterdZone) - 1; i >= 0 ; i--) {
      name_poi = "";
      str_info_row = " ( Time: "+ (string)zFilterdZone[i].time + " - High: "+ DoubleToString(zFilterdZone[i].high, _Digits) + " - Low: "+ DoubleToString(zFilterdZone[i].low, _Digits)+")";
      // Kiem tra neu zone khong thuoc thoi gian chi dinh thi bo qua
      if (zFilterdZone[i].time < myEAs.statusInternalHTL.sHL_iStoplossTime || zFilterdZone[i].time > target_time) {
         text += "\n1. Zone "+ (string) i + " không thuộc thời gian chỉ định. Bỏ qua."+str_info_row;
         continue; 
      }
      // Kiểm tra nếu zone đã bị phá qua rồi thì bỏ qua
      if (zFilterdZone[i].mitigated == -1) {
         text += "\n2. Zone "+ (string) i + " đã bị mitigated. Bỏ qua."+str_info_row;
         continue;
      }
      // Kiểm tra đã tồn tại trong target zone hay chưa. Nếu tồn tại rồi thì bỏ qua
      next = false;
      for(int j=0; j<ArraySize(Target_zone); j++) {
         if( zFilterdZone[i].high == Target_zone[j].high && zFilterdZone[i].low == Target_zone[j].low && zFilterdZone[i].time == Target_zone[j].time) {
            next = true;
            text += "\nx.x Zone "+ (string) i +" - "+(string) j + " đã tồn tại trong Global Zone. Break."+str_info_row;
            break;
         } else {
            text += "\nx.x Zone "+ (string) i +" - "+(string) j + " chưa tồn tại trong Global Zone. Tiếp tục kiểm tra."+str_info_row;
         }
      }
      // Đã tồn tại trong Global zone trước đó.
      if( next == true) {
         text += "\n3. Zone "+ (string) i + " đã tồn tại trong Global zone trước đó. Bỏ qua."+str_info_row;
         continue;
      }
      
      // Neu La Extreme zone
      if ((type == 1 && zFilterdZone[i].low == myEAs.statusInternalHTL.sHL_iStoploss) || (type == -1 && zFilterdZone[i].high == myEAs.statusInternalHTL.sHL_iStoploss)) {
         // Them zone zIntSlow vao PoiZoneBullish voi isTypeZone = 1
         isTypezone = 1;
         if(tfData.isHighTF) {
            gl_color = (type == 1) ? color_HTF_Extreme_Bullish_Zone : color_HTF_Extreme_Bearish_Zone;
         } else {
            gl_color = (type == 1) ? color_LTF_Extreme_Bullish_Zone : color_LTF_Extreme_Bearish_Zone;
         }
      } else { // khong phai extreme zone
         // Them zone zIntSlow vao PoiZoneBullish voi isTypeZone = 2
         isTypezone = 2;
         if(tfData.isHighTF) {
            gl_color = (type == 1) ? color_HTF_Decisional_Bullish_Zone : color_HTF_Decisional_Bearish_Zone;
         } else {
            gl_color = (type == 1) ? color_LTF_Decisional_Bullish_Zone : color_LTF_Decisional_Bearish_Zone;
         }
      }
      tmp_zone = zFilterdZone[i];
      tmp_zone.isTypeZone = isTypezone;
      tmp_zone.mitigated = 0;
      tmp_zone.zoneColor = gl_color;
      name_poi = INTERNAL_TEXT_GLOBAL_LTF+"_"+((type == 1)? BULL_TEXT: BEAR_TEXT)+"_"+TimeToString(tmp_zone.time);
      // Them zone tmp_zone vao Target_zone
      tfData.AddToPoiZoneArray(Target_zone, tmp_zone, poi_limit, name_poi);
      //TODOTODO: Ve zone
      if (type == 1) {
         //drawBox("ePOI", tmp_zone.time, tmp_zone.low, bar1.time, tmp_zone.high,1, gl_color, 1);
         DrawBox(0, name_poi, 0, tmp_zone.time, tmp_zone.low, bar1.time, tmp_zone.high, tmp_zone.zoneColor, STYLE_SOLID,1, true, false, false, true, 0);
         text += "\n------------------------------------------------------GOAL "+(string)isTypezone+ " "+(string) bar1.high+ " "+(string) bar1.time+"------------------------------------------------------------------";
      } else if (type == -1) {
         //drawBox("ePOI", tmp_zone.time, tmp_zone.high, bar1.time, tmp_zone.low,1, gl_color, 1);
         DrawBox(0, name_poi, 0, tmp_zone.time, tmp_zone.high, bar1.time, tmp_zone.low, tmp_zone.zoneColor, STYLE_SOLID,1, true, false, false, true, 0);
         text += "\n------------------------------------------------------GOAL "+(string)isTypezone+ " "+(string) bar1.high+ " "+(string) bar1.time+"------------------------------------------------------------------";
      }      
      
   }
    //Print(text);
    //ArrayPrint(Target_zone);
    //Print("\n-------------------------------------------------------");
}

//+------------------------------------------------------------------+
//|    Internal Settings                                             |
//+------------------------------------------------------------------+
// Kiểm tra trạng thái thời gian thực của Internal Swing đã target hoặc stoploss hay chưa
void checkStatusRealTimeInternalStructHTF(ValueInternal& iVData, MqlRates& bar1) {
   string text = "";
   //ValueInternal& iVData = myEAs.valueInternal;
   // Nếu giá vượt qua dữ liệu tổng của ValueInternal. Reset toàn bộ
   // Reset thông số ban đầu nếu Stoploss hoặc Take Profit
   if (bar1.high > iVData.vi_intSHigh || bar1.low < iVData.vi_intSLow) {
      if (bar1.high > iVData.vi_intSHigh) {
         if((iVData.vi_ITrend == 1 && iVData.vi_wvITrend == 1) || (iVData.vi_ITrend == -1 && iVData.vi_wvITrend == 1)) {
            text += "[Success]Take profit "+ ((iVData.vi_ITrend == 1)? "Internal Uptrend." : "Swept Internal DownTrend.");
         } else if ((iVData.vi_ITrend == -1 && iVData.vi_wvITrend == -1) || (iVData.vi_ITrend == 1 && iVData.vi_wvITrend == -1)) {
            text += "[Error]Stoploss "+ ((iVData.vi_ITrend == -1)? "Internal DownTrend." : "Swept Internal Uptrend.");
         }
         text += " Giá "+DoubleToString(bar1.high, _Digits)+" vượt lên Internal High: "+ DoubleToString(iVData.vi_intSHigh,_Digits)+". ";
      }else if (bar1.low < iVData.vi_intSLow) {
         if((iVData.vi_ITrend == -1 && iVData.vi_wvITrend == -1) || (iVData.vi_ITrend == 1 && iVData.vi_wvITrend == -1)) {
            text += "[Success]Take profit " + ((iVData.vi_ITrend == -1)? "Internal DownTrend." : "Swept Internal Uptrend.");
         } else if ((iVData.vi_ITrend == 1 && iVData.vi_wvITrend == 1) || (iVData.vi_ITrend == -1 && iVData.vi_wvITrend == 1)) {
            text += "[Error]Stoploss "+ ((iVData.vi_ITrend == 1)? "Internal Uptrend." : "Swept Internal DownTrend.");
         }
         text += " Giá "+DoubleToString(bar1.low, _Digits)+" giảm qua Internal Low: "+ DoubleToString(iVData.vi_intSLow,_Digits)+". ";
      }
      // Reset Value Internal
		myEAs.valueInternal.Reset(text);
		//DeleteAllPendingOrders(_Symbol, InpMagic);
		
		return;
   }
   
   // Nếu giá vượt qua dữ liệu pullback. Xoá thông tin của pullback đó.
   // Main High
   if(iVData.vi_TempSwing_High.main.vins_SwingNew != 0 && bar1.high > iVData.vi_TempSwing_High.main.vins_SwingNew) {
      text += "Deleted MAIN Pullback Swing High "+DoubleToString(iVData.vi_TempSwing_High.main.vins_SwingNew, _Digits);
      iVData.vi_TempSwing_High.ResetAll();
      iVData.candidate_High.Reset();
      //DeleteAllPendingOrders(_Symbol, InpMagic);
   }
   // Main Low
   if(iVData.vi_TempSwing_Low.main.vins_SwingNew != 0 && bar1.low < iVData.vi_TempSwing_Low.main.vins_SwingNew) {
      text += "Deleted MAIN Pullback Swing Low "+DoubleToString(iVData.vi_TempSwing_Low.main.vins_SwingNew, _Digits);
      iVData.vi_TempSwing_Low.ResetAll();
      iVData.candidate_Low.Reset();
      //DeleteAllPendingOrders(_Symbol, InpMagic);
   }
   
   // Sub High
   if(iVData.vi_TempSwing_High.sub.vins_SwingNew != 0 && bar1.high > iVData.vi_TempSwing_High.sub.vins_SwingNew) {
      text += "Deleted SUB Pullback Swing High "+DoubleToString(iVData.vi_TempSwing_High.sub.vins_SwingNew, _Digits)+". ";
      iVData.vi_TempSwing_High.sub.Reset();
      //DeleteAllPendingOrders(_Symbol, InpMagic);
   }
   // Sub Low
   if(iVData.vi_TempSwing_Low.sub.vins_SwingNew != 0 && bar1.low < iVData.vi_TempSwing_Low.sub.vins_SwingNew) {
      text += "Deleted SUB Pullback Swing Low "+DoubleToString(iVData.vi_TempSwing_Low.sub.vins_SwingNew, _Digits)+". ";
      iVData.vi_TempSwing_Low.sub.Reset();
      //DeleteAllPendingOrders(_Symbol, InpMagic);
   }
   
   // Candidate High
   if(iVData.candidate_High.vins_SwingNew != 0 && bar1.high > iVData.candidate_High.vins_SwingNew) {
      text += "Deleted Candidate Pullback Swing High "+DoubleToString(iVData.candidate_High.vins_SwingNew, _Digits);
      iVData.candidate_High.Reset();
      //DeleteAllPendingOrders(_Symbol, InpMagic);
   }
   
   // Candidate Low
   if(iVData.candidate_Low.vins_SwingNew != 0 && bar1.low < iVData.candidate_Low.vins_SwingNew) {
      text += "Deleted Candidate Pullback Swing Low "+DoubleToString(iVData.candidate_Low.vins_SwingNew, _Digits);
      iVData.candidate_Low.Reset();
      //DeleteAllPendingOrders(_Symbol, InpMagic);
   }
   
   if(StringLen(text) > 0) {
      sendNoti(text);
   }   
}
//+------------------------------------------------------------------+
//|     End Internal Settings                                        |
//+------------------------------------------------------------------+
		
		
// Hàm đặt trong real wave
void checkStatusSettingPoiZone(TimeFrameData& tfData, MqlRates& bar1){
   string text = "";
	if (tfData.isHighTF != true) { // Neu tiep theo cu break out cua Internal High TF la scan thong tin tu Low TF
		
		// Kiểm tra trạng thái thời gian thực của Internal Swing đã target hoặc stoploss hay chưa
		if (myEAs.valueInternal.vi_ITrend != 0) {
		   checkStatusRealTimeInternalStructHTF(myEAs.valueInternal, bar1);
		}
		
		// Kiểm tra các vùng Trade Poi Internal Lowtimeframe sau khi đã hình thành signal từ HTF( Phần xác nhận ở Low Time Frame))
		getStatusConfirmByLowTimeframe(tfData);
		
		
		if (myEAs.statusInternalHTL.sHL_IntScanActive) {
			if (myEAs.statusInternalHTL.sHL_ITrend != 0) {
				// Scan bullish
				if (myEAs.statusInternalHTL.sHL_ITrend == 1) {
				   if ( ArraySize(tfData.zArrIntBullish) > 0) {
				      beginScanGlobalZoneInternalSelected(tfData, zGTradeZoneInternalBullishHTF,tfData.zArrIntBullish, zArrPoiZoneLTFBullishBelongHighTF, 1, bar1);
				      myEAs.statusInternalHTL.sHL_IntScanActive = false;
				   } else {
				      // Quét toàn bộ các vùng POI Internal low timeframe để Trade theo Order Block, Order Flow mới
				   }
				} else if (myEAs.statusInternalHTL.sHL_ITrend == -1 ) {
				   if ( ArraySize(tfData.zArrIntBearish) > 0) { // Scan Bearish
				      beginScanGlobalZoneInternalSelected(tfData, zGTradeZoneInternalBearishHTF,tfData.zArrIntBearish, zArrPoiZoneLTFBearishBelongHighTF, -1, bar1);
				      myEAs.statusInternalHTL.sHL_IntScanActive = false;
				   } else {
				      // Quét toàn bộ các vùng POI Internal low timeframe để Trade theo Order Block, Order Flow mới
				   }
				}
			} 
			
		} 	else { 
			// Reset thông số ban đầu nếu Stoploss hoặc Take Profit
			if ( (myEAs.statusInternalHTL.sHL_ITrend == 1 && ((bar1.high > myEAs.statusInternalHTL.sHL_iTarget && myEAs.statusInternalHTL.sHL_iTarget != 0) || (bar1.low < myEAs.statusInternalHTL.sHL_iStoploss && myEAs.statusInternalHTL.sHL_iStoploss != 0))) 
			   || (myEAs.statusInternalHTL.sHL_ITrend == -1 && ((bar1.low < myEAs.statusInternalHTL.sHL_iTarget && myEAs.statusInternalHTL.sHL_iTarget != 0 ) || (bar1.high > myEAs.statusInternalHTL.sHL_iStoploss && myEAs.statusInternalHTL.sHL_iStoploss != 0)))
			   ) {
				text += "\n================> Clean Data vi đã take profit hoặc quét stoploss";
				myEAs.statusInternalHTL.Reset();
				
				// Reset gl_find H or L
				myEAs.marketStructStatus.ResetHL();
				// xoa du lieu de tranh vao lenh lien tuc sau khi dat target  
				resetTradeZoneHTF(tfData, zArrPoiZoneLTFBearishBelongHighTF);
				resetTradeZoneHTF(tfData, zArrPoiZoneLTFBullishBelongHighTF);
				//// Reset Value Internal
				//myEAs.valueInternal.Reset();
				
				//DeleteAllPendingOrders(_Symbol, InpMagic);
			} else {
				if (myEAs.statusInternalHTL.sHL_ITrend == 1) {
				   if ((myEAs.statusInternalHTL.sHL_iTarget != 0 && bar1.high < myEAs.statusInternalHTL.sHL_iTarget) || ( myEAs.statusInternalHTL.sHL_iStoploss != 0 && bar1.low > myEAs.statusInternalHTL.sHL_iStoploss) ) {
				      if (ArraySize(zArrPoiZoneLTFBullishBelongHighTF) == 0 ) {
				         text += "\n================> LTF: Thiếu thông số Bullish. Scan lại Global zone ở bước sau";
				         myEAs.statusInternalHTL.sHL_IntScanActive = true;
				      }
				   }
				} else if (myEAs.statusInternalHTL.sHL_ITrend == -1) {
				   if ((bar1.low > myEAs.statusInternalHTL.sHL_iTarget && myEAs.statusInternalHTL.sHL_iTarget != 0 ) || (bar1.high < myEAs.statusInternalHTL.sHL_iStoploss && myEAs.statusInternalHTL.sHL_iStoploss != 0)) {
				      if (ArraySize(zArrPoiZoneLTFBearishBelongHighTF) == 0) {
				         text += "\n================> LTF: Thiếu thông số Bearish. Scan lại Global zone ở bước sau";
				         myEAs.statusInternalHTL.sHL_IntScanActive = true;
				      }
				   }
				}
			}     
		} // End myEAs.statusInternalHTL.sHL_IntScanActive == false
		
		
      
	} // End tfData.isHighTF != true
	else { // Begin tfData.isHighTF == true. Setup cac thong so khi dang o HTF
	   
	   // --- Check HTF bar break Body of ORDER BLOCK sau mỗi nến HTF ---
      checkStatusBarBreakoutBodyToOrderBlock(bar1);
	   
	   if (myEAs.marketStructStatus.iMSS_findH == 1 || myEAs.marketStructStatus.iMSS_findL == 1) {
	      //Print("myEAs.marketStructStatus.iMSS_findH = " + (string) myEAs.marketStructStatus.iMSS_findH); 
   	   //Print("myEAs.marketStructStatus.iMSS_intSHighHTFRealTime(Old) = "+DoubleToString(myEAs.marketStructStatus.iMSS_intSHighHTFRealTime, _Digits)); 
   	   //Print("tfData.intSHighs[0]");Print(tfData.intSHighs[0]);
   	   if (myEAs.marketStructStatus.iMSS_findH == 1 && myEAs.marketStructStatus.iMSS_intSHighHTFRealTime != tfData.intSHighs[0]) {
   	      //Print("Settings thông số HTF = Internal High:");
   	      myEAs.marketStructStatus.iMSS_H_pattern_signal = CheckCandleByTime(tfData.intSHighTime[0], tfData.timeFrame, -1);
   	      myEAs.marketStructStatus.iMSS_intSHighHTFRealTime = tfData.intSHighs[0];
   	      //if (myEAs.marketStructStatus.iMSS_H_pattern_signal == 1) Print("waiting");
   	   }
//   	   Print("myEAs.marketStructStatus.iMSS_intSHighHTFRealTime(New) = "+DoubleToString(myEAs.marketStructStatus.iMSS_intSHighHTFRealTime, _Digits));
//   	   
//   	   Print("myEAs.marketStructStatus.iMSS_findL = " + (string) myEAs.marketStructStatus.iMSS_findL);
//   	   Print("myEAs.marketStructStatus.iMSS_intSLowHTFRealTime(Old) = "+DoubleToString(myEAs.marketStructStatus.iMSS_intSLowHTFRealTime, _Digits));
//   	   Print("tfData.intSLows[0]"); Print(tfData.intSLows[0]);
   	   if (myEAs.marketStructStatus.iMSS_findL == 1 && myEAs.marketStructStatus.iMSS_intSLowHTFRealTime != tfData.intSLows[0]) {
   	      //Print("Settings thông số HTF = Internal Low:");
   	      myEAs.marketStructStatus.iMSS_L_pattern_signal = CheckCandleByTime(tfData.intSLowTime[0], tfData.timeFrame, 1);
   	      myEAs.marketStructStatus.iMSS_intSLowHTFRealTime = tfData.intSLows[0];
   	      //if (myEAs.marketStructStatus.iMSS_L_pattern_signal == 1) Print("waiting");
   	   }
   	   //Print("myEAs.marketStructStatus.iMSS_intSLowHTFRealTime(New) = "+DoubleToString(myEAs.marketStructStatus.iMSS_intSLowHTFRealTime, _Digits));
   	   //Print("----");
	   }
   }   
} // End checkStatusSettingPoiZone

// --- Check HTF bar break Body of ORDER BLOCK sau mỗi nến HTF ---
void checkStatusBarBreakoutBodyToOrderBlock(MqlRates& bar1) {
   string text = "";
   bool result = false;
   #define subHData myEAs.valueInternal.candidate_High
   // 1. XỬ LÝ CHO SWING HIGH (BEARISH - CHỜ PHÁ VỠ XUỐNG)
   if (subHData.vins_SwingNew != 0 && subHData.vins_barOrderBlock.open != 0 && subHData.vins_isSignalConfirm_Patten == -1 && subHData.vins_isSignalConfirm_Patten_Again == 1) 
   {
       // Lấy tham chiếu đến nến OB đã tìm được trước đó
       MqlRates obBar = subHData.vins_barOrderBlock;
       // ĐIỀU KIỆN NỚI LỎNG: Lấy giá thấp nhất của thân nến OB (Body Low)
       double price_need_compare = MathMin(obBar.high, obBar.low);
       
       // Nếu nến hiện tại (bar1) đóng cửa dưới thân nến OB
       if (bar1.close < price_need_compare && (bar1.low <= obBar.low || bar1.high >= obBar.high)) {
           subHData.vins_isSignalConfirm_Patten_Again = 2;
           result = true;
           text += StringFormat("[HTF] Active Break Again giảm | Swing High %s at %s", DoubleToString(subHData.vins_barSwing.high, _Digits), TimeToString(subHData.vins_barSwing.time));
           text += "\n"+StringFormat("Xác nhận Break OB Sell: bar1.close (%s) < OB Bar Low (%s)", DoubleToString(bar1.close, _Digits), DoubleToString(price_need_compare, _Digits));
           text += StringFormat("[Swing High OB bar info] Time: %s | Open: %s | High: %s | Low: %s | Close: %s | Vol: %lld", 
                TimeToString(obBar.time), DoubleToString(obBar.open, _Digits), DoubleToString(obBar.high, _Digits), DoubleToString(obBar.low, _Digits), DoubleToString(obBar.close, _Digits), obBar.tick_volume);
       }
   }
   #undef subHData
   
   #define subLData myEAs.valueInternal.candidate_Low
   // 2. XỬ LÝ CHO SWING LOW (BULLISH - CHỜ PHÁ VỠ LÊN)
   if (subLData.vins_SwingNew != 0 && subLData.vins_barOrderBlock.open != 0 && subLData.vins_isSignalConfirm_Patten == -1 && subLData.vins_isSignalConfirm_Patten_Again == 1) 
   {
       // Lấy tham chiếu đến nến OB đã tìm được trước đó
       MqlRates obBar = subLData.vins_barOrderBlock;
       
       // ĐIỀU KIỆN NỚI LỎNG: Lấy giá cao nhất của thân nến OB (Body High)
       double price_need_compare = MathMax(obBar.high, obBar.low);
       
       // Nếu nến hiện tại (bar1) đóng cửa trên thân nến OB
       if (bar1.close > price_need_compare && (bar1.low <= obBar.low || bar1.high >= obBar.high)) {
           subLData.vins_isSignalConfirm_Patten_Again = 2;
           result = true;
           text += StringFormat("[HTF] Active Break Again tăng | Swing Low %s at %s: ", DoubleToString(subLData.vins_barSwing.low, _Digits), TimeToString(subLData.vins_barSwing.time));
           text += "\n"+StringFormat("Xác nhận Break OB Buy: bar1.close (%s) > OB Bar High (%s)", DoubleToString(bar1.close, _Digits), DoubleToString(price_need_compare, _Digits));
           text += StringFormat("[Swing Low OB bar info] Time: %s | Open: %s | High: %s | Low: %s | Close: %s | Vol: %lld", 
                TimeToString(obBar.time), DoubleToString(obBar.open, _Digits), DoubleToString(obBar.high, _Digits), DoubleToString(obBar.low, _Digits), DoubleToString(obBar.close, _Digits), obBar.tick_volume);
       }
   }
   #undef subLData
   if (result && StringLen(text) > 0) {
      sendNoti(text);
      //Print(text);
   }
}

// --- Hàm phụ trợ: Thực hiện kiểm tra logic Gann với các mảng cụ thể ---
bool PerformGannCheck(TimeFrameData& tfData, InternalSwingData& subData, int type, 
                     const double& prices[], const datetime& times[], const long& vols[],
                     const double& oppPrices[], const datetime& oppTimes[], const long& oppVols[]) {
   int keyGann = -1, keyNext = -1;
   long volSwingPre = 0, volSwing = 0, volSwingNext = 0;
   int iTrend_LTF = 0; 
   int wvITrend_LTF = 0;

   double i_swingGann = subData.vins_SwingNew, i_swingGann_Pre = 0, i_swingGann_Next = 0;
   datetime i_swingGannTime = 0, i_swingGann_Pre_Time = 0, i_swingGann_Next_Time = 0;
   double price_Stop = 0;
   string text = "";
   bool result = false;

   // Prices là tfData.Highs (nếu type = -1) hoặc tfData.Lows (nếu type = 1)
   int size = ArraySize(prices);
   if(size <= 0) return false;

   for(int j = 0; j < size; j++) {
      if(times[j] < subData.vins_SwingTimeNew) continue;
      if(prices[j] == i_swingGann) {
         keyGann = j; volSwing = vols[j]; i_swingGannTime = times[j];
         text += "Tìm thấy Gann Swing " + (string)((type == 1) ? "Lows" : "Highs") + " ở vị trí: [" + (string)j + "] có giá " + DoubleToString(i_swingGann, _Digits) + " tại thời gian " + TimeToString(i_swingGannTime);
         break;
      }
   }

   // oppPrices là swing ngược với đỉnh or đáy swing. Tức là sử dụng oppPrices là tfData.Lows (nếu type = -1) hoặc tfData.Highs (nếu type = 1)
   if(keyGann < 0 || i_swingGannTime == 0) {
      Print("Khong tim thay swing thich hop. Bo qua.");
      Print(TAB_STRING);
      return false;  
   }
   if(ArraySize(oppPrices) < (keyGann + 1)) return false;

   for(int k = keyGann + 1; k >= 0; k--) {
      if(oppTimes[k] > i_swingGannTime) break;
      if(oppTimes[k] < i_swingGannTime && ((type == 1 && oppPrices[k] > i_swingGann) || (type == -1 && oppPrices[k] < i_swingGann))) {
         volSwingPre = (ArraySize(oppVols) >= k) ? oppVols[k] : 0;
         i_swingGann_Pre = oppPrices[k];
         i_swingGann_Pre_Time = oppTimes[k];
      }
   }

   int oppSize = ArraySize(oppPrices);
   for(int k = 0; k < oppSize; k++) {
      if(oppTimes[k] < i_swingGannTime) continue;
      if((type == 1 && oppPrices[k] > i_swingGann_Pre) || (type == -1 && oppPrices[k] < i_swingGann_Pre)) keyNext = k;
      if((type == 1 && oppPrices[k] < i_swingGann_Pre) || (type == -1 && oppPrices[k] > i_swingGann_Pre)) break;
   }

   if(keyNext >= 0 && ArraySize(oppVols) >= keyNext) {
      if(
         (
            (type == 1 && oppPrices[keyNext] > i_swingGann_Pre && oppPrices[keyNext] > i_swingGann) || 
            (type == -1 && oppPrices[keyNext] < i_swingGann_Pre && oppPrices[keyNext] < i_swingGann)
         ) 
         && oppTimes[keyNext] > i_swingGannTime
      ) {
         i_swingGann_Next = oppPrices[keyNext];
         i_swingGann_Next_Time = oppTimes[keyNext];
      }
   }

   if(i_swingGann_Next_Time > i_swingGannTime) volSwingNext = GetTickVolumeSum(_Symbol, tfData.timeFrame, i_swingGannTime, i_swingGann_Next_Time);

   text += "\nGann: Swing Pre: " + DoubleToString(i_swingGann_Pre, _Digits) + " vol: " + (string)volSwingPre;
   text += " | Swing: " + DoubleToString(i_swingGann, _Digits) + " vol: " + (string)volSwing;
   text += " | Swing Next: " + DoubleToString(i_swingGann_Next, _Digits) + " vol: " + (string)volSwingNext;

   if(volSwingNext != 0) {
      subData.vins_isSignalConfirm_LTF = (volSwingNext > volSwing && volSwingNext > volSwingPre) ? 1 : -1;
      if(subData.vins_isSignalConfirm_LTF == 1) {
         subData.vins_isSignalConfirm_LTF_byWave = 1; // Danh dau Gann = 1
         text += "\n => Chấp nhận Signal LowTF = 1";
         price_Stop = oppPrices[0];
         for(int k = 0; k < oppSize; k++) {
            if((type == 1 && oppPrices[k] > price_Stop) || (type == -1 && oppPrices[k] < price_Stop)) price_Stop = oppPrices[k];
            if(oppTimes[k] < i_swingGannTime) break;
         }
         iTrend_LTF = (type == 1) ? 1 : -1; 
         wvITrend_LTF = iTrend_LTF;
         subData.vins_Entry_Stop = price_Stop;
         subData.isActive = true; 
         result = true;
      } else text += "=> Từ chối Signal LowTF = -1";

      subData.vins_LTF_iTrend = iTrend_LTF;
      subData.vins_LTF_wviTrend = wvITrend_LTF;
      subData.vins_LTF_mTrend = tfData.mTrend;
      subData.vins_LTF_wvmTrend = tfData.wvMtrend;
   } else text += (type == 1) ? "\nChưa tìm thấy Bullish Gann Break LTF" : "\nChưa tìm thấy Bearish Gann Break LTF";

   //Print(text);
   return result;
}

// --- Hàm phụ trợ: Kiểm tra tín hiệu sóng Gann ---
bool CheckGannWaveSignal(TimeFrameData& tfData, InternalSwingData& subData, int type) {
   if(type == 1) {
      return PerformGannCheck(tfData, subData, type, tfData.Lows, tfData.LowsTime, tfData.wvolLows, tfData.Highs, tfData.HighsTime, tfData.wvolHighs);
   } else {
      return PerformGannCheck(tfData, subData, type, tfData.Highs, tfData.HighsTime, tfData.wvolHighs, tfData.Lows, tfData.LowsTime, tfData.wvolLows);
   }
}

// --- Hàm phụ trợ: Kiểm tra tín hiệu sóng Internal ---
bool CheckInternalWaveSignal(TimeFrameData& tfData, InternalSwingData& subData, int key, int type) {
   string text = "Kiểm tra sóng Internal " +((type == 1) ? "tăng" : "giảm");
   long volSwingPre = 0, volSwing = 0, volSwingNext = 0;
   double iSwingPrevPrice = 0, iSwingPrice = 0, iSwingNextPrice = 0;
   datetime iSwingTime = 0, iSwingNextTime = 0;
   double price_Stop = 0;
   
   int i_iTrend = 0, i_wvIrend = 0;
   bool result = false;

   if(type == 1) { // Buy
      if(ArraySize(tfData.wvolIntSHighs) < (key + 1)) return false;
      // Dò đỉnh
      if(tfData.intSHighTime[key] > tfData.intSLowTime[key] && tfData.intSHighs[key] > tfData.intSHighs[key + 1]) {
         // Pre swing High
         volSwingPre = tfData.wvolIntSHighs[key + 1]; iSwingPrevPrice = tfData.intSHighs[key+   1];
         // Swing Low
         volSwing = tfData.wvolIntSLows[key]; iSwingPrice = tfData.intSLows[key]; iSwingTime = tfData.intSLowTime[key];
         // Next swing High
         iSwingNextTime = tfData.wvolIntSHighTime[key]; iSwingNextPrice = tfData.intSHighs[key];
         volSwingNext = GetTickVolumeSum(_Symbol, tfData.timeFrame, iSwingTime, iSwingNextTime);
         // Trend of swing
         i_iTrend = (tfData.intSHighs[key] > tfData.intSHighs[key + 1]) ? 1 : -1;
         text += "\n1 Swing High Pre: " + DoubleToString(iSwingPrevPrice, _Digits) + " vol: " + (string)volSwingPre;
      } else if(key > 0 && tfData.intSHighTime[key - 1] > tfData.intSLowTime[key] && tfData.intSHighs[key - 1] > tfData.intSHighs[key]) {
         // Pre swing High
         volSwingPre = tfData.wvolIntSHighs[key]; iSwingPrevPrice = tfData.intSHighs[key];
         // Swing Low
         volSwing = tfData.wvolIntSLows[key]; iSwingPrice = tfData.intSLows[key]; iSwingTime = tfData.intSLowTime[key];
         // Next swing High
         iSwingNextTime = tfData.wvolIntSHighTime[key - 1]; iSwingNextPrice = tfData.intSHighs[key - 1];
         volSwingNext = GetTickVolumeSum(_Symbol, tfData.timeFrame, iSwingTime, iSwingNextTime);
         price_Stop = tfData.intSHighs[key - 1];
         // Trend of swing
         i_iTrend = (tfData.intSHighs[key - 1] > tfData.intSHighs[key]) ? 1 : -1;
         text += "\n2 Swing High Pre: " + DoubleToString(iSwingPrevPrice, _Digits) + " vol: " + (string)volSwingPre;
      }
   } else { // Sell
      if(ArraySize(tfData.wvolIntSLows) < (key + 1)) return false;
      // Dò đáy
      if(tfData.intSLowTime[key] > tfData.intSHighTime[key] && tfData.intSLows[key] < tfData.intSLows[key + 1]) {
         // Pre swing Low
         volSwingPre = tfData.wvolIntSLows[key + 1]; iSwingPrevPrice = tfData.intSLows[key + 1];
         // Swing High
         volSwing = tfData.wvolIntSHighs[key]; iSwingPrice = tfData.intSHighs[key]; iSwingTime = tfData.intSHighTime[key];
         // Next swing Low
         iSwingNextPrice = tfData.intSLows[key]; iSwingNextTime = tfData.wvolIntSLowTime[key];
         // Volume of swing
         volSwingNext = GetTickVolumeSum(_Symbol, tfData.timeFrame, iSwingTime, iSwingNextTime);
         // Trend of swing
         i_iTrend = (tfData.intSLows[key] < tfData.intSLows[key + 1]) ? -1 : 1;
         text += "\n-1 Swing Low Pre: " + DoubleToString(iSwingPrevPrice, _Digits) + " vol: " + (string)volSwingPre;
      } else if(key > 0 && tfData.intSLowTime[key - 1] > tfData.intSHighTime[key] && tfData.intSLows[key - 1] < tfData.intSLows[key]) {
         // Pre swing Low
         volSwingPre = tfData.wvolIntSLows[key]; iSwingPrevPrice = tfData.intSLows[key];
         // Swing High
         volSwing = tfData.wvolIntSHighs[key]; iSwingPrice = tfData.intSHighs[key]; iSwingTime = tfData.intSHighTime[key];
         // Next swing Low
         iSwingNextPrice = tfData.intSLows[key - 1]; iSwingNextTime = tfData.wvolIntSLowTime[key - 1];
         volSwingNext = GetTickVolumeSum(_Symbol, tfData.timeFrame, iSwingTime, iSwingNextTime);
         // Trend of swing
         i_iTrend = (tfData.intSLows[key - 1] < tfData.intSLows[key]) ? -1 : 1;
         text += "\n-2 Swing Low Pre: " + DoubleToString(iSwingPrevPrice, _Digits) + " vol: " + (string)volSwingPre;
      }
   }

   if(volSwingNext != 0) {
      i_wvIrend = (volSwingNext > volSwing) ? i_iTrend : (0 - i_iTrend);
      text += " | Swing " + ((type == 1) ? "Low: " : "High: ") + DoubleToString(iSwingPrice, _Digits) + " vol: " + (string)volSwing;
      text += " | Swing " + ((type == 1) ? "High Next: " : "Low Next: ") + DoubleToString(iSwingNextPrice, _Digits) + " vol: " + (string)volSwingNext;

      subData.vins_isSignalConfirm_LTF = (i_iTrend == type && volSwingNext > volSwing && volSwingNext > volSwingPre) ? 1 : -1;
      if(subData.vins_isSignalConfirm_LTF == 1) {
         subData.vins_isSignalConfirm_LTF_byWave = 2; // Danh dau internal = 2
         text += "\n => Chấp nhận Signal từ LTF = 1";
         price_Stop = (type == 1) ? tfData.intSHighs[0] : tfData.intSLows[0];
         subData.vins_Entry_Stop = price_Stop;
         text += "; Cập nhật entry_stop: " + DoubleToString(price_Stop, _Digits);
         subData.isActive = true;
         result = true;
      } else text += "\n=> Từ chối Signal từ LTF = -1";

      subData.vins_LTF_iTrend = i_iTrend;
      subData.vins_LTF_wviTrend = i_wvIrend;
      subData.vins_LTF_mTrend = tfData.mTrend;
      subData.vins_LTF_wvmTrend = tfData.wvMtrend;
   } else text += (type == 1) ? "\nChưa tìm thấy Bullish Internal Break LTF" : "\nChưa tìm thấy Bearish Internal Break LTF";

   //Print(text);
   //Print(TAB_STRING);
   return result;
}

// --- Hàm phụ trợ: Tìm kiếm chỉ số của điểm swing dựa trên giá và thời gian ---
int FindSwingIndex(const double& prices[], const datetime& times[], double targetPrice, datetime targetTime) {
   int size = ArraySize(prices);
   for(int i = 0; i < size - 1; i++) {
      if(times[i] < targetTime) continue;
      if(MathAbs(prices[i] - targetPrice) < _Point / 10.0) return i;
   }
   return -1;
}

// --- Hàm phụ trợ: Xử lý tín hiệu Low Timeframe cho cả Mua và Bán ---
void ProcessLowTFSignal(TimeFrameData& tfData, InternalSwingData& candidate, StructureManager& manager, int type) {
   // Nếu không có tín hiệu swing new thì return
   if(candidate.vins_SwingNew == 0) return;
   bool print_log = disableComment;
   string text = "";
   if(!((candidate.vins_isSignalConfirm_Patten == 1 && candidate.vins_isSignalConfirm_LTF == 0) || 
        (candidate.vins_isSignalConfirm_Patten_Again == 2 && candidate.vins_isSignalConfirm_LTF == 2))) return;

   text += ("Tín hiệu khung thời gian HTF New Swing: " + DoubleToString(candidate.vins_SwingNew, _Digits) + " tại thời điểm : " + (string)candidate.vins_SwingTimeNew);
   text += ("Bắt đầu soi kính hiển vi khung thời gian LTF - Swing " + (string)((type == 1) ? "Low" : "High"));
   
   int key = -1;
   if(type == 1) {
      if(ArraySize(tfData.intSLows) > 0)
         key = FindSwingIndex(tfData.intSLows, tfData.intSLowTime, candidate.vins_SwingNew, candidate.vins_SwingTimeNew);
   } else {
      if(ArraySize(tfData.intSHighs) > 0)
         key = FindSwingIndex(tfData.intSHighs, tfData.intSHighTime, candidate.vins_SwingNew, candidate.vins_SwingTimeNew);
   }
   
   bool result = false;
   if(key >= 0) {
      if(key > 0) result = CheckInternalWaveSignal(tfData, candidate, key, type);
      else result = CheckGannWaveSignal(tfData, candidate, type);
   } else {
      // Truong Hop Dac biet. Neu dang tim sub swing thì kiểm tra sóng gann thêm 1 lần nữa.
      if(candidate.vins_SwingNew != manager.main.vins_SwingNew && manager.main.vins_SwingNew != 0) {
         text += ("Truong Hop Dac biet. Neu dang tim sub swing thì kiểm tra sóng gann thêm 1 lần nữa.");
         result = CheckGannWaveSignal(tfData, candidate, type);
      } else {
         candidate.vins_isSignalConfirm_LTF = -1;
         text += ("Khong tim thay swing thich hop. Bo qua.");
      }
   }

   if(result) {
      manager.sub = candidate;
      if(manager.main.vins_SwingNew == candidate.vins_SwingNew && manager.main.vins_SwingTimeNew == candidate.vins_SwingTimeNew)
         manager.main = candidate;
   }
   text += ("Da tung kiem tra " + ((type == 1) ? "Low LTF" : "High LTF"));
   string message = StringFormat("[LTF] Checked %s: %s swing: %s at %s \nIsMitigatedPoizone: %s | IsSweptPoizone: %s | IsPattent: %s", 
                               (type == 1) ? "Low" : "High", 
                               ((candidate.vins_isSignalConfirm_LTF == 1) ? "Confirm" : "Unconfirm") + ((type == 1)? "->BUY" : "->SELL"), 
                               (type == 1) ? DoubleToString(candidate.vins_barSwing.low, _Digits) : DoubleToString(candidate.vins_barSwing.high, _Digits), 
                               TimeToString(candidate.vins_barSwing.time),
                               (candidate.vins_isPoiZoneMitigated)? "Yes" : "No" , (candidate.vins_isPoiZoneSwept)? "Yes" : "No" , (candidate.vins_isSignalConfirm_Patten)? "Yes" : "No"
                               );
   if(candidate.vins_isSignalConfirm_LTF == 1) sendNoti(message);
   //if (print_log && StringLen(text) > 0) Print(text);
}

void getStatusConfirmByLowTimeframe(TimeFrameData& tfData) {
   // Xử lý tín hiệu Mua (Low)
   ProcessLowTFSignal(tfData, myEAs.valueInternal.candidate_Low, myEAs.valueInternal.vi_TempSwing_Low, 1);
   
   // Xử lý tín hiệu Bán (High)
   ProcessLowTFSignal(tfData, myEAs.valueInternal.candidate_High, myEAs.valueInternal.vi_TempSwing_High, -1);
}

//+------------------------------------------------------------------+
//| Hàm tính tổng Tick Volume với Timeframe tùy chọn                 |
//+------------------------------------------------------------------+
long GetTickVolumeSum(string symbol, ENUM_TIMEFRAMES timeframe, datetime startTime, datetime endTime) {
//--- 1. Kiểm tra tính hợp lệ của thời gian
   if(startTime >= endTime) {
      //PrintFormat("Lỗi: Thời gian bắt đầu (%s) phải nhỏ hơn kết thúc (%s)", TimeToString(startTime), TimeToString(endTime));
      return(0);
   }

//--- 2. Khai báo mảng để lưu trữ dữ liệu Tick Volume
   long tickVolumeArray[];
   
//--- 3. Đảm bảo dữ liệu được sắp xếp theo thứ tự thời gian (tùy chọn nhưng nên làm)
   ArraySetAsSeries(tickVolumeArray, false);

//--- 4. Sử dụng CopyTickVolume để lấy dữ liệu. Hàm này sẽ lấy dữ liệu của 'symbol' trên khung 'timeframe' trong khoảng từ 'startTime' đến 'endTime'
   int copied = CopyTickVolume(symbol, timeframe, startTime, endTime, tickVolumeArray);

//--- 5. Kiểm tra nếu việc lấy dữ liệu thất bại hoặc không có dữ liệu
   if(copied <= 0){
      //PrintFormat("Không có dữ liệu cho %s trên khung %s trong khoảng thời gian này.", symbol, EnumToString(timeframe));
      return(0);
   }

//--- 6. Tính tổng các phần tử trong mảng bằng vòng lặp
   long totalVolume = 0;
   for(int i = 0; i < copied; i++) {
      totalVolume += tickVolumeArray[i];
   }

   return(totalVolume);
}

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
      definedFunction(*tfData, timeframe);
      gannWave(*tfData);
   }
   
   // Ham goi boi OnTick
   void realTimeDefinition(ENUM_TIMEFRAMES timeframe) {
      
      // Lấy dữ liệu cho khung timeframe
      TimeFrameData* tfData = GlobalVars.GetData(timeframe);
      realGannWave(*tfData, timeframe);
      
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
         //case  PERIOD_M3:
         //  tfData.tfColor = clrSkyBlue;
         //  tfData.isTimeframe = 3;
         //  break;
         case  PERIOD_M5:
           tfData.tfColor = clrSkyBlue;
           tfData.isTimeframe = 5;
           break;
         //case  PERIOD_M10:
         //  tfData.tfColor = clrBlue;
         //  tfData.isTimeframe = 10;
         //  break;
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
      // Thử lấy Real Volume trước
      long rVol = iRealVolume(_Symbol, tfData.timeFrame, 1);
      volume_style = (rVol > 0)? 1 : 2;
      
      // Copy toan bo Lookback = 100 Bar tu Bar hien tai vao mang waveRates
      int copied = CopyRates(_Symbol, timeframe, 0, count_lookback, waveRates);
      if(copied <= 0)
      {
         PrintFormat(">>> Lỗi: Không thể sao chép dữ liệu lịch sử nến cho definedFunction (Copied = %d)", copied);
         return;
      }
      
      //int firstBar = ArraySize(waveRates) - 1;
      int firstBar = 0;
      MqlRates Bar1 = waveRates[firstBar];
      double firstBarHigh     = waveRates[firstBar].high;
      double firstBarLow      = waveRates[firstBar].low;
      datetime firstBarTime   = waveRates[firstBar].time;
      long firstBarVol        = (volume_style == 2)? waveRates[firstBar].tick_volume : waveRates[firstBar].real_volume;
      
      tfData.highEst = firstBarHigh;
      tfData.lowEst = firstBarLow;
      tfData.hightime = firstBarTime;
      tfData.lowtime = firstBarTime;
      
      // Gann structure
      tfData.AddToDoubleArray(tfData.Highs, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.HighsTime, firstBarTime);
      tfData.AddToLongArray(tfData.volHighs, firstBarVol);
      tfData.AddToLongArray(tfData.wvolHighs, firstBarVol);
      tfData.AddToDateTimeArray(tfData.wvolHighTime, firstBarTime);
      
      tfData.AddToDoubleArray(tfData.Lows, firstBarLow);
      tfData.AddToDateTimeArray(tfData.LowsTime, firstBarTime);
      tfData.AddToLongArray(tfData.volLows, firstBarVol);
      tfData.AddToLongArray(tfData.wvolLows, firstBarVol);
      tfData.AddToDateTimeArray(tfData.wvolLowTime, firstBarTime);
      
      // internal structure
      tfData.AddToDoubleArray(tfData.intSHighs, firstBarHigh);
      tfData.AddToDateTimeArray(tfData.intSHighTime, firstBarTime);
      tfData.AddToLongArray(tfData.volIntSHighs, firstBarVol);
      tfData.AddToLongArray(tfData.wvolIntSHighs, firstBarVol);
      tfData.AddToDateTimeArray(tfData.wvolIntSHighTime, firstBarTime);
      
      tfData.AddToDoubleArray(tfData.intSLows, firstBarLow);
      tfData.AddToDateTimeArray(tfData.intSLowTime, firstBarTime);
      tfData.AddToLongArray(tfData.volIntSLows, firstBarVol);
      tfData.AddToLongArray(tfData.wvolIntSLows, firstBarVol);
      tfData.AddToDateTimeArray(tfData.wvolIntSLowTime, firstBarTime);
      
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
      tfData.AddToLongArray(tfData.wvolArrPbHigh, firstBarVol);
      tfData.AddToDateTimeArray(tfData.wvolArrPbHighTime, firstBarTime);
      
      tfData.AddToDoubleArray(tfData.arrPbLow, firstBarLow);
      tfData.AddToDateTimeArray(tfData.arrPbLTime, firstBarTime);
      tfData.AddToLongArray(tfData.volArrPbLow, firstBarVol);
      tfData.AddToLongArray(tfData.wvolArrPbLow, firstBarVol);
      tfData.AddToDateTimeArray(tfData.wvolArrPbLowTime, firstBarTime);
      
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
      
      // Thêm PoiZone vào mảng
      PoiZone zone1 = CreatePoiZone( tfData,Bar1.high, Bar1.low, Bar1.open, Bar1.close, Bar1.time, 0, -1, -1);
      tfData.AddToPoiZoneArray(tfData.zPoiLow, zone1);
      tfData.AddToPoiZoneArray(tfData.zPoiHigh, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrTop, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrBot, zone1);
      tfData.AddToPoiZoneArray(tfData.zHighs, zone1);
      tfData.AddToPoiZoneArray(tfData.zLows, zone1);
      tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone1);
      tfData.AddToPoiZoneArray(tfData.zIntSLows, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrPbHigh, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrPbLow, zone1);
      
      tfData.AddToPoiZoneArray(tfData.zArrIntBullish, zone1);
      tfData.AddToPoiZoneArray(tfData.zArrIntBearish, zone1);
      
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
         if (ArraySize(tfData.intSLowTime) >= 5) {
            lookback_time = tfData.intSLowTime[4];
         }
      } else if (tfData.iTrend == -1) {
         if (ArraySize(tfData.intSHighTime) >= 5) {
            lookback_time = tfData.intSHighTime[4];
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
         checkStatusSettingPoiZone(tfData, bar1);
         
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
      bool print_log = false;
      string textall = "";
      string text  = "";
      string resultStructure = "";
      string resultMarjorStruct = "";
      textall += "----------------------------------------------------------------------> START "+EnumToString(timeframe)+" bar formed: "+ TimeToString(TimeCurrent())+" <-----------------------------------------------------------------------";
      int copied = CopyRates(_Symbol, timeframe, 0, 4, rates);
      if(copied < 3) return;
      
      MqlRates bar1, bar2, bar3;
      bar1 = rates[2];
      bar2 = rates[1];
      bar3 = rates[0];
      
      //text += "--------------Real Gann Wave----------------";
      textall += "\n"+inInfoBar(bar1, bar2, bar3);
      //textall += "\nFirst: "+getValueTrend(tfData);
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
      checkStatusSettingPoiZone(tfData, bar1);
      
      // Mitigation
      checkMitigateZone(tfData, bar1);
           
      // Gọi hàm vào lệnh
      if (tfData.isHighTF == false) {
         //afterCheckMarketForTrade(tfData);
         CheckMarketForTradeByWaveVolume(tfData);
      }
      
      // For develop
      //showPoiComment(tfData);
      
      // Hàm để cuối cùng.
      textall += "\n#Final: "+getValueTrend(tfData);
      //text += "\n------------ End Real Gann wave---------------";
      //Print(text); 
      textall += "\n----------------------------------------------------------------------> END "+EnumToString(timeframe)+" bar formed: "+ TimeToString(TimeCurrent())+" <-----------------------------------------------------------------------";
      if (print_log && StringLen(text) > 0) {
         Print(textall);
      }
   }
   
   // Hàm vào lệnh theo điều kiện của EA bởi volume Wave
   void CheckMarketForTradeByWaveVolume(TimeFrameData& tfData){
      string text = "";
      bool print_log = false;
      if (print_log) Print("$ Ham CheckMarketForTradeByWaveVolume is running.");
      
      // 1. Kiểm tra xem đã có lệnh nào của cặp tiền này và Magic này chưa
       //if(IsTradeExists(_Symbol, InpMagic))
       //{
       //    // Nếu đã có lệnh, chúng ta thoát hàm luôn, không chạy các logic phía dưới
       //    if (print_log) Print(TAB_STRING+ "1. Đang có lệnh chạy, bỏ qua không kiểm tra nữa.");
       //    return; 
       //} else {
       //    if (print_log) Print(TAB_STRING+ "1. Chưa có lệnh nào đang chạy. Tiếp tục.");
       //}
      // 2. Kiểm tra tồn tại các đỉnh đáy Internal HTF
      if (myEAs.valueInternal.vi_intSHigh == 0 || myEAs.valueInternal.vi_intSLow == 0) {
         text = TAB_STRING+"2. Kiểm tra tồn tại các đỉnh đáy Internal HTF: Chưa tồn tại do valueInternal istoploss == 0 OR valueInternal iTarget == 0. Bo qua";
         if (print_log) Print(text);
         return;
      } else {
         if (print_log) Print(TAB_STRING+ "2. Kiểm tra tồn tại các đỉnh đáy Internal HTF. Đã có trong hệ thống. Tiếp tục.");
      }
      // Kiểm tra tồn tại OB hoặc OF hay không
      text = TAB_STRING+ "3. Kiểm tra tồn tại Poizone: ";
      if ((ArraySize(zGTradeZoneBullishHTF) == 0 && ArraySize(zGTradeZoneBearishHTF) == 0) || (ArraySize(zGTradeZoneInternalBullishHTF) == 0 && ArraySize(zGTradeZoneInternalBearishHTF) == 0)) { 
         if ((ArraySize(zGTradeZoneBullishHTF) == 0 && ArraySize(zGTradeZoneBearishHTF) == 0)) {
            text = "\n"+TAB_STRING+"3.1. Dieu kien 1 Poizone Marjor khong ton tai. ( zGTradeZoneBullishHTF == 0 && zGTradeZoneBearishHTF == 0 ) Bo qua";
         } else {
            text = "\n"+TAB_STRING+"3.2. Dieu kien 2 Poizone Internal khong ton tai. ( zGTradeZoneInternalBullishHTF == 0 && zGTradeZoneInternalBearishHTF == 0 ).Bo qua.";
         }  
         if (print_log) Print(text);
         return;
      } else {
         text += " - Tồn tại các Poizone trong hệ thống. Tiếp tục.";
         if (print_log) Print(text);
      }
      
      // Kiem tra tồn tại swing template Pullback hoặc swept High Low Internal hay không
      text = TAB_STRING+"4. Kiểm tra tồn tại swing template Pullback hoặc swept High Low Internal: ";
      if(myEAs.valueInternal.vi_TempSwing_High.main.vins_SwingNew == 0 && myEAs.valueInternal.vi_TempSwing_Low.main.vins_SwingNew == 0) {
         text += "\n"+TAB_STRING+ " - Chưa xuất hiện Swing PullBack khi Breakout thành công hoặc Không tìm thấy swing swept Internal struct trước đó. Bỏ qua";
         if (print_log) Print(text);
         return;
      } else {
         text += " - Tồn tại các Swing Pullback hoặc swing swept Internal trong hệ thống. Tiếp tục.";
         if (print_log) Print(text);
      }
      
      // 5. Bắt đầu kiểm tra điều kiện vào lệnh
      if(myEAs.valueInternal.vi_TempSwing_High.sub.vins_isSignalConfirm_LTF == 1 || myEAs.valueInternal.vi_TempSwing_Low.sub.vins_isSignalConfirm_LTF == 1) {
         goTradeBySMC(tfData);
      }
   }
   
   
   // Hàm vào lệnh theo đièu kiện SMC
   void goTradeBySMC(TimeFrameData& tfData) {
      bool print_log = false;
      string text = "";
      // Kiểm tra điều kiện vào lệnh theo volume wave
      int result = 0;
      int type_trade = 0; // 1: buy, -1: sell
      int option_trade = 0;
      bool conditions_typeA = false;
      bool callFunctionTrade = false;
      text = TAB_STRING+ "5. Bắt đầu kiểm tra điều kiện vào lệnh\n";
      
      int f_iTrend = 0;
      int f_wvITrend = 0;
      int f_mTrend = 0;
      int f_wvmTrend = 0;
            
      type_trade = (myEAs.valueInternal.vi_isSwept && myEAs.valueInternal.vi_ITrend != myEAs.valueInternal.vi_wvITrend) ? (0 - myEAs.valueInternal.vi_ITrend) : myEAs.valueInternal.vi_ITrend;
      
      if (type_trade == 1) {
         if (myEAs.valueInternal.vi_TempSwing_Low.sub.vins_isSignalConfirm_LTF != 1) return;
         f_iTrend = 1;
         f_wvITrend = 1;
         f_mTrend = myEAs.valueInternal.vi_TempSwing_Low.sub.vins_LTF_mTrend;
         f_wvmTrend = myEAs.valueInternal.vi_TempSwing_Low.sub.vins_LTF_wvmTrend;
      } else if(type_trade == -1) {
         if (myEAs.valueInternal.vi_TempSwing_High.sub.vins_isSignalConfirm_LTF != 1) return;
         f_iTrend = -1;
         f_wvITrend = -1;
         f_mTrend = myEAs.valueInternal.vi_TempSwing_High.sub.vins_LTF_mTrend;
         f_wvmTrend = myEAs.valueInternal.vi_TempSwing_High.sub.vins_LTF_wvmTrend;
      }      
      if ( f_iTrend != 0 && f_wvITrend != 0 && f_mTrend != 0 && f_wvmTrend != 0 && f_iTrend == f_wvITrend ) {
         // 5.1 kiểm tra xem đã get IDM High TF hay chưa
         if (myEAs.signalInternal.sg_getIdmBuy == false && myEAs.signalInternal.sg_getIdmSell == false) {
            conditions_typeA = false;
            text += TAB_STRING + "Vào lệnh theo kiểu chưa get IDM - ";
         } else {
            conditions_typeA = false;
            text += TAB_STRING + "Vào lệnh theo kiểu đã get IDM rồi - ";
         }
         // Tầng 0: HTF thuan trend. marjor == internal. Option: I II III IV và XIII XIV XV XVI
         if (myEAs.signalInternal.sg_mTrend == myEAs.signalInternal.sg_iTrend ) { 
            // Tầng 1: Phần I II + XV XVI : HTF marjor == HTF internal && HTF Internal trend = wave volume HTF Internal Trend
            if (myEAs.signalInternal.sg_iTrend == myEAs.signalInternal.sg_wvITrend) { 
               // Tầng 2: I.1-4 + và XVI.61-64
               if (myEAs.signalInternal.sg_wvITrend == f_iTrend) { 
                  // Tầng 3: I.1 - I.4 và XVI.64 - XVI.61
                  if (f_mTrend == f_wvmTrend) {
                     // I.1 - XVI.64 : sg_mTrend; = sg_iTrend; = sg_wvItrend; = iTrend; = mTrend; = wvMTrend;
                     if (f_iTrend == f_mTrend) {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == 1)? 1 : 64;
                        text += "Option Trade: " + (string) option_trade + " - I.1 - XVI.64 : sg_mTrend; = sg_iTrend; = sg_wvItrend; = iTrend; = mTrend; = wvMTrend;";
                     // I.4 - XVI.61 : myEAs.signalInternal.sg_mTrend; = sg_iTrend; = sg_wvItrend; != iTrend; != mTrend; != wvMTrend;
                     } else {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == 1)? 4 : 61;
                        text += "Option Trade: " + (string) option_trade + " - I.4 - XVI.61 : myEAs.signalInternal.sg_mTrend; = sg_iTrend; = sg_wvItrend; != iTrend; != mTrend; != wvMTrend;";
                     }
                  // Tầng 3: I.2 - I.3 và XVI.62 - XVI.63
                  } else {
                     // I.2 - XVI.63 : sg_mTrend; = sg_iTrend; = sg_wvItrend; = iTrend; = mTrend; != wvMTrend;
                     if (f_iTrend == f_mTrend) {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == 1)? 2 : 63;
                        text += "Option Trade: " + (string) option_trade + " - I.2 - XVI.63 : sg_mTrend; = sg_iTrend; = sg_wvItrend; = iTrend; = mTrend; != wvMTrend;";
                     // I.3 - XVI.62: sg_mTrend; = sg_iTrend; = sg_wvItrend; = iTrend; != mTrend; = wvMTrend;
                     } else {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == 1)? 3 : 62;
                        text += "Option Trade: " + (string) option_trade + " - I.3 - XVI.62: sg_mTrend; = sg_iTrend; = sg_wvItrend; = iTrend; != mTrend; = wvMTrend;";
                     }
                     
                  }
               // Phần II.5-8 + XV.57-60
               } else { 
                  // Khong lam gi ca
                  text += "Option Trade: Phần II.5-8 + XV.57-60 : gMarjor = gInternal; gInternal = waveVol gInternal; gInternal != tfData.iTrend; ";
               }
            //Tầng 1: Phần III IV + XIII XIV : HTF marjor == HTF internal && HTF Internal trend != wave volume HTF Internal Trend
            } else { 
               // Tầng 2: Phần IV.13-16 + XIII.49-52
               if (myEAs.signalInternal.sg_wvITrend == f_iTrend) { 
                  // Tầng 3: IV.13 - IV.16 và XIII.49 - XIII.52
                  if (f_mTrend == f_wvmTrend) {
                     // IV.16 - XIII.49 : sg_mTrend; = sg_iTrend; != sg_wvItrend; != iTrend; != mTrend; != wvMTrend;
                     if (f_iTrend == f_mTrend) {
                        callFunctionTrade = true;
                        option_trade = (tfData.iTrend == -1)? 16 : 49;
                        text += "Option Trade: " + (string) option_trade + " - IV.16 - XIII.49 : sg_mTrend; = sg_iTrend; != sg_wvItrend; != iTrend; != mTrend; != wvMTrend;";
                     // IV.13 - XIII.52: sg_mTrend; = sg_iTrend; != sg_wvItrend; != iTrend; = mTrend; != wvMTrend;
                     } else {
                        // Không làm gì
                        text += "Option Trade: Phần IV.13 - XIII.52: sg_mTrend; = sg_iTrend; != sg_wvItrend; != iTrend; = mTrend; != wvMTrend;";
                     }
                  // Tầng 3: IV.14 - IV.15 và XIII.50 - XIII.51
                  } else {
                     // IV.15 - XIII.50: sg_mTrend; = sg_iTrend; != sg_wvItrend; != iTrend; != mTrend; = wvMTrend;
                     if (f_iTrend == f_mTrend) {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == -1)? 15 : 50;
                        text += "Option Trade: " + (string) option_trade + " - sg_mTrend; = sg_iTrend; != sg_wvItrend; != iTrend; != mTrend; = wvMTrend;";
                     // IV.14 - XIII.51: sg_mTrend; = sg_iTrend; != sg_wvItrend; != iTrend; = mTrend; != wvMTrend;
                     } else {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == -1)? 14 : 51;
                        text += "Option Trade: " + (string) option_trade + " - sg_mTrend; = sg_iTrend; != sg_wvItrend; != iTrend; = mTrend; != wvMTrend;";
                     }
                  }
               // Phần III.9-12 + XIV.53-56   
               } else { 
                  // Khong lam gi ca
                  text += "Option Trade: Phần III.9-12 + XIV.53-56 - gMarjor = gInternal; gInternal != wave vol gInternal; wave vol gInternal != tfData.iTrend";
                  
               }
            }
         // Tầng 0: HTF nghich trend. marjor != internal. Option: V VI VII VIII và IX X XI XII
         } else { 
            // Tầng 1: Phần V + VI + XI +XII : HTF wave Volume Internal trend != HTF Internal Trend
            if (myEAs.signalInternal.sg_iTrend != myEAs.signalInternal.sg_wvITrend) { 
               // Tầng 2: Phần V + XII
               if (myEAs.signalInternal.sg_wvITrend == f_iTrend) {
                  // Tầng 3: V.17 - V.20 và XII.45 - XII.48
                  if (f_mTrend == f_wvmTrend) {
                     // V.17 - XII.48: sg_mTrend; != sg_iTrend; = sg_wvItrend; = iTrend; = mTrend; = wvMTrend;
                     if (f_iTrend == f_mTrend) {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == 1)? 17 : 48;
                        text += "Option Trade: " + (string) option_trade + " - sg_mTrend; != sg_iTrend; = sg_wvItrend; = iTrend; = mTrend; = wvMTrend;";
                     // V.20 - XII.45: sg_mTrend; != sg_iTrend; = sg_wvItrend; = iTrend; = mTrend; != wvMTrend;
                     } else {
                        // Không làm gì
                        text += "Option Trade:  V.20 - XII.45: sg_mTrend; != sg_iTrend; = sg_wvItrend; = iTrend; = mTrend; != wvMTrend;";
                        
                     }
                  // Tầng 3: V.18 - V.19 và XII.46 - XII.47
                  } else {
                     // V.18 - XII.47: sg_mTrend; != sg_iTrend; = sg_wvItrend; = iTrend; = mTrend; != wvMTrend;
                     if (f_iTrend == f_mTrend) {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == 1)? 18 : 47;
                        text += "Option Trade: " + (string) option_trade + " - sg_mTrend; != sg_iTrend; = sg_wvItrend; = iTrend; = mTrend; != wvMTrend;";
                     // V.19 - XII.46: sg_mTrend; != sg_iTrend; = sg_wvItrend; = iTrend; != mTrend; = wvMTrend;
                     } else {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == 1)? 19 : 46;
                        text += "Option Trade: " + (string) option_trade + " - sg_mTrend; != sg_iTrend; = sg_wvItrend; = iTrend; != mTrend; = wvMTrend;";
                     }
                  }
               // Tầng 2: Phần VI + XI
               } else {
                  // Không làm gì cả
                  text += "Option Trade: Phần VI + XI - gMarjor != gInternal; gInternal != wave vol gInternal; gMarjor != tfData.iTrend; gInternal != tfData.iTrend";
               }
            // Tầng 1: Phần VII + VIII + IX + X : HTF wave Volume Internal trend = HTF Internal Trend
            } else {
               // Tầng 2: Phần VII + X: : HTF wave Volume Internal trend != LTF Internal Trend
               if (myEAs.signalInternal.sg_wvITrend != f_iTrend) { 
                  // Không làm gì cả
                  text += "Option Trade: Phần VII + X - gMarjor != gInternal; gInternal == wave vol gInternal; tfData.iTrend != gInternal";
               // Tầng 2: Phần VIII + IX : HTF wave Volume Internal trend == LTF Internal Trend
               } else { 
                  // Tầng 3: VIII.30 + VIII.31 - IX.34 + IX.35
                  if (f_mTrend != f_wvmTrend) {
                     // VIII.31 - IX.34: sg_mTrend; != sg_iTrend; != sg_wvItrend; != iTrend; != mTrend; = wvMTrend;
                     if (f_iTrend == f_mTrend) {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == -1)? 31 : 34;
                        text += "Option Trade: " + (string) option_trade + " - sg_mTrend; != sg_iTrend; != sg_wvItrend; != iTrend; != mTrend; = wvMTrend;";
                     // VIII.30 - IX.35: sg_mTrend; != sg_iTrend; != sg_wvItrend; != iTrend; = mTrend; != wvMTrend;
                     } else {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == -1)? 30 : 35;
                        text += "Option Trade: " + (string) option_trade + " - sg_mTrend; != sg_iTrend; != sg_wvItrend; != iTrend; = mTrend; != wvMTrend;";
                     }
                  // Tầng 3: VIII.29 + VIII.32 - IX.33 + IX.36
                  } else {
                     // VIII.32 - IX.33: sg_mTrend; != sg_iTrend; != sg_wvItrend; != iTrend; != mTrend; != wvMTrend;
                     if (f_iTrend == f_mTrend) {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == -1)? 32 : 33;
                        text += "Option Trade: " + (string) option_trade + " - sg_mTrend; != sg_iTrend; != sg_wvItrend; != iTrend; != mTrend; != wvMTrend;";
                     // VIII.29 - IX.36: sg_mTrend; != sg_iTrend; != sg_wvItrend; != iTrend; = mTrend; = wvMTrend;
                     } else {
                        callFunctionTrade = true;
                        option_trade = (f_iTrend == -1)? 29 : 36;
                        text += "Option Trade: " + (string) option_trade + " - sg_mTrend; != sg_iTrend; != sg_wvItrend; != iTrend; = mTrend; = wvMTrend;";
                     }
                  }
               }
            }
         }
         // Nếu đạt điều kiện vào lệnh. Gọi hàm kiểm tra vào lệnh
         
         text += "\n"+TAB_STRING+ "Kết luận hàm : ";
         if (callFunctionTrade) {
            text += "\n ===> Đạt điều kiện để trade. Tiếp tục gọi hàm: CheckMarketForTradeByPredefinedOptions để tìm kiếm điểm vào lệnh";
            //CheckMarketForTradeByPredefinedOptions(tfData, f_iTrend, option_trade, conditions_typeA);
            result = 1;
         } else {
            text += "\n ===> Không đạt điều kiện nên không thể call Function Trade.";
         }
         
      }   // End ifs (tfData.iTrend == tfData.wvItrend) 
      else {
         text += "\n ===> iTrend = "+(string)f_iTrend+"; wvItrend = "+(string)f_wvITrend+"; mTrend = "+(string)f_mTrend+"; wvmTrend = "+(string)f_wvmTrend+"; iTrend("+(string)f_iTrend+") != wvTTrend("+(string)f_wvITrend+") => điều kiện ban đầu không đạt. Bỏ qua.";
      }
      if(print_log) Print(text);
      if(result == 1) {
         if(print_log) Print(TAB_STRING);
      }
   }
   
   // Hàm lọc dữ liệu đầu vào để quyết định vào lệnh theo kiểu nào được định sẵn
   void CheckMarketForTradeByPredefinedOptions(TimeFrameData& tfData, int direction_trade, int option_trade, bool getIDM = false){
       string text = "";
       bool print_log = enabledComment;
       if(print_log) Print("Timeframe: "+EnumToString(tfData.timeFrame)+"- Kiem tra dieu kien vao lenh theo huong : " + (string) direction_trade +" voi option: " + (string) option_trade +" - " + ((getIDM)? "Da ": "Chua") + " Get IDM");
       if (direction_trade == 1) {
         if (option_trade == 1 || option_trade == 2 || option_trade ==3 || option_trade ==4) {
            if (getIDM) {
               // -HTF: 
               // Phai trung xu huong trade
               if(myEAs.valueInternal.vi_ITrend != 1) {
                  if(print_log) Print("[Bo qua] Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }  
               // - Internal High: ○ Không được sweep Internal High[1] 
               if(myEAs.valueInternal.vi_isSwept) {
                  if(print_log) Print("[Bo qua] Internal High[0] đã swept Internal High[1]"+(string) myEAs.valueInternal.vi_isSwept);
                  return; 
               }
               // - Internal Low: - Wave volume:  ○ wvIntHIgh[0] > wvIntHigh[1] && ○ wvIntHigh[0] > wvIntLow[1]
               if(myEAs.valueInternal.vi_TempSwing_Low.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "Buy 1 2 3 4 - GetIDM roi";
               //    - SL & TP:
               //       ○ SL: Internal Low[0]
               //       ○ TP: Internal High[0]
               //    - Nếu Internal Low[1] chạm vào POI Marjor:
               //       ○ -SL: có thể đặt tại arrPBLow[0] LTF
               //          TP: Internal High[0] và arrPBHigh[0] HTF
            } else {
               // Phai trung xu huong trade
               if(myEAs.valueInternal.vi_ITrend != 1) {
                  if(print_log) Print("[Bo qua] Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }  
               // - Internal High: ○ Không được sweep Internal High[1] 
               if(myEAs.valueInternal.vi_isSwept) {
                  if(print_log) Print("[Bo qua] Internal High[0] đã swept Internal High[1]"+(string) myEAs.valueInternal.vi_isSwept);
                  return; 
               }
               // - Internal Low: - Wave volume:  ○ wvIntHIgh[0] > wvIntHigh[1] && ○ wvIntHigh[0] > wvIntLow[1]
               if(myEAs.valueInternal.vi_TempSwing_Low.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "Buy 1 2 3 4 - Chua GetIDM";
               // -HTF:
               //    - Internal High[0]:
               //       ○ Không được sweep Internal High[1] 
               //    - Internal Low:
               //    - Wave volume:
               //       ○ wvIntHIgh[0] > wvIntHigh[1]
               //       ○ wvIntHigh[0] > wvIntLow[1]
               //    - SL & TP:
               //       ○ SL: 
               //          § Internal Low[0]
               //          § SL phải là Internal Swing Low HTF( Nếu xa quá, chờ sweep Internal Swing Low LTF)
               //       ○ TP: Internal High[0]
  
            }
         }

         else if (option_trade == 17 || option_trade == 18 || option_trade == 19) {
            if (getIDM) {
               // Phai ngược xu huong trade
               if(myEAs.valueInternal.vi_ITrend != -1) {
                  if(print_log) Print("[Bo qua] Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }
               // HTF:
               // - Internal High:
               // - Internal Low[0]:
               //    • Option 1: Bắt buộc internal Low[0] phải sweept :
               //       ○ Internal Low[1]
               //       ○ Hoặc  POI Marjor
               if(myEAs.valueInternal.vi_isSwept == false && myEAs.valueInternal.vi_isSweptPoiZone == false) {
                  if(print_log) Print("[Bo qua] Internal Low[0] đã không swept Internal Low[1]"+(string) myEAs.valueInternal.vi_isSwept +" hoac khong swept Poizone Bullish");
                  return; 
               }
               
               //    • Option 2: Bắt buộc Internal Low[0] phải nằm trong POI Marjor
               if(myEAs.valueInternal.vi_isMitigatedPoiZone == false) {
                  if(print_log) Print("[Bo qua] Internal Low[0] đã không mitigated Poizone Bullish");
               }
               // - Wave volume:
               //    • wvInternalLow[0] < wvInternalHigh[1]
               //    • wvInternanlLow[0] < wvInternalLow[1]
               // - Internal Low: - Wave volume:  ○ wvIntHIgh[0] > wvIntHigh[1] && ○ wvIntHigh[0] > wvIntLow[1]
               if(myEAs.valueInternal.vi_TempSwing_Low.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "Buy confirm dieu kien [Swept] options 17 18 19";
               // - SL & TP:
               //    • SL: InternalLow[0] HTF hoặc arrPbLow[0] LTF
               //    • TP:
               //       ○ Options 1: InternalHigh[1]
               //       ○ Options 2: arrPBHigh[0]

            } else {
               // Khong lam gi
            }
         }

         else if (option_trade == 33 || option_trade ==34 || option_trade ==35) {
            if (getIDM) {
               // Phai trùng xu huong trade HTF
               if(myEAs.valueInternal.vi_ITrend == -1) {
                  if(print_log) Print("[Bo qua] Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }
               // -HTF:
               //    - Internal High[0]:
               //       ○ không được mitigated POI marjor
               if(myEAs.valueInternal.vi_isMitigatedPoiZone) {
                  if(print_log) Print("[Bo qua] HTF Internal high[0] da mitigated PoiZone Bearish");
                  return;
               }
               //       ○ không được sweep Internal High[1]
               if(myEAs.valueInternal.vi_isSwept) {
                  if(print_log) Print("[Bo qua] HTF Internal high[0] da swept Internal High[1]");
                  return;
               }
               //       ○ không được hình thành bộ nến sweep hoặc nến EG ????????????? Todo: tuananh
               
               //    - Wave volume:
               //       ○ wvIntHigh[0] > wvIntHigh[1]
               //       ○ wvIntHigh[0] > wvIntLow[1]
               if(myEAs.valueInternal.vi_TempSwing_Low.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "Buy confirm 33 34 35";
               //    - SL & TP:
               //       ○ SL: Đặt ở LTF arrPBLow[0]
               // TP: Đặt ở HTF intHigh[0]
            } else {
               // Khong lam gi ca
            }
         }

         else if (option_trade == 49 || option_trade ==50 || option_trade ==51) {
            if (getIDM) {
               // HTF:
               if(myEAs.valueInternal.vi_ITrend == 1) {
                  if(print_log) Print("[Bo qua] HTF: Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }
               //    - Internal High[1]:
               //       ○ Bắt buộc không được nằm trong POI marjor. Todo: tuananh
               //    - Internal Low[0]:
               //       ○ Bắt buộc phải tạo cặp EG hoặc bộ nến swept
               
               //       ○ Bắt buộc phải sweep:
               //          § Internal Low[1] Hoặc
               //          § POI marjor Low: Todo:tuananh SAI TU DUY. Song giam lay dau ra POI zone
               if(myEAs.valueInternal.vi_isSwept == false) {
                  if(print_log) Print("[Bo qua] HTF: Internal Low[0] khong swept Internal Low[1]");
                  return;
               }
               //       ○ Hoặc bắt buộc phải chạm POI Marjor
               //    - Wave vol:
               //       ○ InternalLow[0] < InternalHigh[1]
               //       ○ InternalLow[0] < InternalLow[1]
               if(myEAs.valueInternal.vi_TempSwing_Low.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "Buy Swept 49 50 51 - Da get IDM";
               //    - SL & TP:
               //       ○ SL: Internal Low[0]
               // TP: Internal High[0] ; Nếu chạm POI marjor hoặc sweep POI marjor thì đặt arrPBHigh[0]
            } else {
               // HTF:
               if(myEAs.valueInternal.vi_ITrend == 1) {
                  if(print_log) Print("[Bo qua] HTF: Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }
               //    - Internal High[0]:
               //       ○ Bắt buộc không nằm trong Marjor POI
               //    - Internal Low[0]
               //       ○ Bắt  buộc phải sweep Internal Low[1] 
               //       ○ Bắt buộc phải tạo cặp EG hoặc bộ nến sweep
               if(myEAs.valueInternal.vi_isSwept == false) {
                  if(print_log) Print("[Bo qua] HTF: Internal Low[0] khong swept Internal Low[1]");
                  return;
               }
               //    - Wave vol:
               //       ○ wvInternalLow[0] < wvInternnalHigh[1]
               //       ○ wvInternalLow[0] < wvinternalLow[1]
               if(myEAs.valueInternal.vi_TempSwing_Low.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "Buy Swept 49 50 51 - Chua get IDM";
               //    - SL & TP:
               //       ○ SL: Internal Low[0]
               // TP: Internal High[0] 
            }
         }

      } else if (direction_trade == -1) {
         if (option_trade == 61 || option_trade ==62 || option_trade ==63 || option_trade ==64) {
            if (getIDM) {
               // -HTF:
               if(myEAs.valueInternal.vi_ITrend == 1) {
                  if(print_log) Print("[Bo qua] HTF: Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }
               
               //    - Internal Low[0]:
               //       ○ bắt buộc không là bộ nến EG hoặc sweep
               //       ○ Bắt buộc không được sweept Internal Low[1]
               if(myEAs.valueInternal.vi_isSwept) {
                  if(print_log) Print("[Bo qua] HTF: Do Internal Low[0] da swept Internal Low[1]");
                  return;
               }
               //    - Internal High[0]:
               //       ○ Bắt buộc phải là bộ nến EG hoặc sweep
               //    - Wave vol: 
               //       ○ Internal Low[0] > Internal High[1]
               //       ○ Internal Low[0] > Internal Low[1]
               if(myEAs.valueInternal.vi_TempSwing_High.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "Sell 61 62 63 64 - Da get IDM";
               //    - SL & TP:
               //       ○ SL : Internal High[1] && có thể sử dụng arrPbHigh[0] của LTF nếu Internal High[1] chạm POI của marjor 
               //         TP : Internal Low[0] && Nếu Internal High[1] chạm POI của marjor thì arrPBLow[0]
            } else {
               //HTF:
               if(myEAs.valueInternal.vi_ITrend == 1) {
                  if(print_log) Print("[Bo qua] HTF: Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }
               
               //	- Internal Low[0]:
               //		○ bắt buộc không là bộ nến EG hoặc sweep
               //		○ Bắt buộc không được sweept Internal Low[1]
               if(myEAs.valueInternal.vi_isSwept) {
                  if(print_log) Print("[Bo qua] HTF: Do Internal Low[0] da swept Internal Low[1]");
                  return;
               }
               //	- Internal High[0]:
               //		○ Bắt buộc phải là bộ nến EG hoặc sweep
               //	- Wave vol: 
               //		○ Internal Low[0] > Internal High[1]
               //		○ Internal Low[0] > Internal Low[1]
               if(myEAs.valueInternal.vi_TempSwing_High.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "Sell 61 62 63 64 - Chua get IDM";
               //	- SL & TP:
               //		○ SL : Internal High[1]
               //      TP : Internal Low[0]
            }
         }
         
         else if (option_trade == 46 || option_trade == 47 || option_trade == 48) {
            if (getIDM) {
               // - HTF:
               if(myEAs.valueInternal.vi_ITrend != 1) {
                  if(print_log) Print("[Bo qua] HTF: Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }
               //    Options 1: b1:
               //       - Internal High[0]:
               //          ○ Phải sweept Internal High[1]
               //          ○ Phải hình thành bộ nến sweept hoặc EG
               //          ○ Mitigated POI Marjor hoặc không
               if(myEAs.valueInternal.vi_isSwept == false && myEAs.valueInternal.vi_isMitigatedPoiZone == false) {
                  if(print_log) Print("[Bo qua] HTF: Internal high[0] khong swept internal high[1] hoac inernal high[0] khong mitigated Bear Poizone");
                  return;
               }
               //       - Wave volume:
               //          ○ wvIntHigh[0] < wvIntLow[1]
               //          ○ wvIntHIgh[0] < wvIntHigh[1]
               if(myEAs.valueInternal.vi_TempSwing_High.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "SELL swept 46 47 48";
               //       - SL & TP:
               //          ○ SL : Đặt tại intHIgh[0]
               //          ○ TP:
               //             § Chưa mitigated POI Marjor: Đặt tại intLow[0]
               //             § Mitigated POI Marjor: Đặt tại intLow[0] && arrPBLow[0]
               //    Options 2: b2:
               //       - Internal High[0]:
               //          ○ Phải hình thành bộ nến sweep hoặc EG
               //          ○ Phải mitigated POI của Marjor
               //       - Wave volume:
               //          ○ wvIntHIgh[0] < wvIntLow[0]
               //          ○ wvIntHigh[0] < wvIntHigh[1]
               //       - SL & TP:
               //          ○ SL: Đặt tại intHigh[0] or POI Marjor High
               //    TP: IntLow[1] HTF && arrPBLow[0] HTF
            } else {
               // Khong lam gi ca
            }
         }

         else if (option_trade == 30 || option_trade ==31 || option_trade ==32) {
            if (getIDM) {
               // HTF:
               if(myEAs.valueInternal.vi_ITrend != -1) {
                  if(print_log) Print("[Bo qua] HTF: Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }
               //    - Internal High[0]:
               //    - Internal Low[0]:
               //       • Không được nằm trong POI Marjor
               //       • Không được sweep:
               if(myEAs.valueInternal.vi_isSwept || myEAs.valueInternal.vi_isMitigatedPoiZone) {
                  if(print_log) Print("[Bo qua] HTF: Internal low[0] da swept internal low[1] hoac internal low[0] da mitigated Bull Poizone");
                  return;
               }
               //          ○ InternalLow[1]
               //          ○ POI Marjor
               //    - Wave volume:
               //       • wvInternalLow[0] > wvInternalLow[1]
               //       • wvInternalLow[0] > wvInternalHigh[1]
               if(myEAs.valueInternal.vi_TempSwing_High.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "SELL 30 31 32";
               //    - SL & TP:
               //       • SL: Internal High[0] or arrPBHigh[0] LTF
               //       • TP: Internnal Low[0]

            } else {
                  // Khong lam gi ca
            }
         }

         else if (option_trade == 14 || option_trade == 15 || option_trade == 16) {
            if (getIDM) {
               // HTF:
               if(myEAs.valueInternal.vi_ITrend != 1) {
                  if(print_log) Print("[Bo qua] HTF: Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }
               // - Internal High[0]: 
               //    • phải sweept High[1]
               //    • Phải tạo thành cặp nến EG hoặc bộ nến sweep
               //    •  Internal High[0] === LTF arrPBHigh[0]
               if(myEAs.valueInternal.vi_isSwept == false) {
                  if(print_log) Print("[Bo qua] HTF: Internal high[0] khong swept internal high[1]");
                  return;
               }
               // - Internal Low[1]:
               //    • Phải không được chạm POI marjor or sweep Poi Marjor. Todo:tuananh
               
               // - Wave volume:
               //    • wvInternal High[0] < wvInternal High[1]
               //    • wvInternalHigh[0] < wvInternalLow[0]
               if(myEAs.valueInternal.vi_TempSwing_High.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "SELL swept 14 15 16 - da get IDM";
               // - SL & TP:
               //    • SL: InternalHIgh[0]
               //    • TP: Internal Low[0]

               // - 
               // - Giá phải mitigated POI HTF BB Bearsih hoặc sweept High[1] HTF???

            } else {
               // HTF:
               if(myEAs.valueInternal.vi_ITrend != 1) {
                  if(print_log) Print("[Bo qua] HTF: Khac xu hướng: "+(string) myEAs.valueInternal.vi_ITrend +"!="+(string) direction_trade);
                  return;
               }
               //    - Internal High[0]: 
               //       • phải sweept High[1]
               //       • Phải tạo thành cặp nến EG hoặc bộ nến sweep
               //       •  Internal High[0] === LTF arrPBHigh[0]
               if(myEAs.valueInternal.vi_isSwept == false) {
                  if(print_log) Print("[Bo qua] HTF: Internal high[0] khong swept internal high[1]");
                  return;
               }
               //    - Internal Low[1]:
               //       • Phải không được chạm POI marjor or sweep Poi Marjor. Todo: tuananh
               
               //    - Wave volume:
               //       • wvInternal High[0] < wvInternal High[1]
               //       • wvInternalHigh[0] < wvInternalLow[0]
               if(myEAs.valueInternal.vi_TempSwing_High.main.vins_isSignalConfirm_LTF != 1) {
                  if(print_log) Print("[Bo qua] LowTimeframe volume không có mô hình nến xác nhận");
                  return; 
               }
               text += "SELL swept 14 15 16 - Chua get IDM";
               //    - SL & TP:
               //       • SL: InternalHIgh[0]
               //    TP: Internal Low[0]
            }
            
         } 
      }
      if(StringLen(text) > 0) {
         if(print_log) Print(text);
         if(print_log) Print("Ham goi lenh trade");
         if(print_log) Print(TAB_STRING);
      }
   }
   
   // Todo: Kiểm tra lần lượt zone đã mitigate hay chưa
   void checkMitigateZone(TimeFrameData& tfData, MqlRates& bar1) {
      // Hàm luôn phải chạy không được dừng để check mitigate còn loại POI ra khỏi vùng scan zone.
      // Gann Structure Highs và Lows
      if (ArraySize(tfData.zHighs) > 0) {
         getIsMitigatedZone(tfData, bar1, tfData.zHighs, -1, "zHighs");
      }
      
      if (ArraySize(tfData.zLows) > 0) {
         getIsMitigatedZone(tfData, bar1, tfData.zLows, 1, "zLows");
      }
      
      // Internal Structure Highs và Lows . Có vẽ
      if (ArraySize(tfData.zArrIntBearish) > 0) {
         getIsMitigatedZone(tfData, bar1, tfData.zArrIntBearish, -1, "zArrIntBearish", true);
      }
      
      if (ArraySize(tfData.zArrIntBullish) > 0) {
         getIsMitigatedZone(tfData, bar1, tfData.zArrIntBullish, 1, "zArrIntBullish", true);
      }
      
      // Hàm check mitigate của Global Target
      if (myEAs.statusInternalHTL.sHL_ITrend != 0) {
         getIsMitigateGlobal(bar1);
      }
      
      // Hàm check mitigate của Internal global zone LowTF dành cho Trade Multi TF. Có vẽ
      if( ArraySize(zArrPoiZoneLTFBullishBelongHighTF) > 0) {
         getIsMitigatedZone(tfData, bar1, zArrPoiZoneLTFBullishBelongHighTF, 1, "zArrPoiZoneLTFBullishBelongHighTF");
      }
      
      if (ArraySize(zArrPoiZoneLTFBearishBelongHighTF) > 0) {
         getIsMitigatedZone(tfData, bar1, zArrPoiZoneLTFBearishBelongHighTF, -1, "zArrPoiZoneLTFBearishBelongHighTF");
      }
            
      // ----------------------------------------------------------- //
      if (tfData.isHighTF) {
         // Hàm check mitigate của Trade Zone thuộc Internal Structure HighTF. Có vẽ
         if( ArraySize(zGTradeZoneInternalBullishHTF) > 0) {
            getIsMitigatedTradeZone(tfData, bar1, zGTradeZoneInternalBullishHTF, 1, "zGTradeZoneInternalBullishHTF");
         }
   
         if (ArraySize(zGTradeZoneInternalBearishHTF) > 0) {
            getIsMitigatedTradeZone(tfData, bar1, zGTradeZoneInternalBearishHTF, -1, "zGTradeZoneInternalBearishHTF");
         }
   
         // Hàm check mitigate của Trade Zone thuộc Marjor Structure HighTF
         if( ArraySize(zGTradeZoneBearishHTF) > 0) {
            getIsMitigatedTradeZone(tfData, bar1, zGTradeZoneBearishHTF, -1, "zGTradeZoneBearishHTF");
         }
         
         if (ArraySize(zGTradeZoneBullishHTF) > 0) {
            getIsMitigatedTradeZone(tfData, bar1, zGTradeZoneBullishHTF, 1, "zGTradeZoneBullishHTF");
         }
      }
      
   }
   
   // Hàm chỉ kiểm tra ss Global đã mitigate order flow hoặc order block hay chưa
   void getIsMitigateGlobal(MqlRates& bar1) {
      if (myEAs.statusInternalHTL.sHL_iTarget == 0) return;
      if (myEAs.statusInternalHTL.sHL_ITrend == 1) {
         // Kiểm tra order flow
         if (myEAs.statusInternalHTL.sHL_mitigate_iOrderFlow == 0 && bar1.low < myEAs.statusInternalHTL.sHL_iSnR && bar1.low > myEAs.statusInternalHTL.sHL_iStoploss) {
            myEAs.statusInternalHTL.sHL_mitigate_iOrderFlow = 1;
         } 
         
         // Kiểm tra order block
         if (myEAs.statusInternalHTL.sHL_mitigate_iOrderBlock == 0 && bar1.low < myEAs.statusInternalHTL.sHL_mitigate_iOrderBlock && bar1.low > myEAs.statusInternalHTL.sHL_iStoploss) {
            myEAs.statusInternalHTL.sHL_mitigate_iOrderBlock = 1;
         }
         
         // Nếu giá hit stoploss
         if (bar1.close < myEAs.statusInternalHTL.sHL_iStoploss) {
            myEAs.statusInternalHTL.sHL_mitigate_iOrderFlow = -1;
            myEAs.statusInternalHTL.sHL_mitigate_iOrderBlock = -1;
         }
      } else if (myEAs.statusInternalHTL.sHL_ITrend == -1) {
         // Kiểm tra order flow
         if (myEAs.statusInternalHTL.sHL_mitigate_iOrderFlow == 0 && bar1.high > myEAs.statusInternalHTL.sHL_iSnR && bar1.high < myEAs.statusInternalHTL.sHL_iStoploss) {
            myEAs.statusInternalHTL.sHL_mitigate_iOrderFlow = 1;
         } 
         
         // Kiểm tra order block
         if (myEAs.statusInternalHTL.sHL_iOrderBlock == 0 && bar1.high > myEAs.statusInternalHTL.sHL_iOrderBlock && bar1.high < myEAs.statusInternalHTL.sHL_iStoploss) {
            myEAs.statusInternalHTL.sHL_iOrderBlock = 1;
         }
         
         // Nếu giá hit stoploss
         if (bar1.close > myEAs.statusInternalHTL.sHL_iStoploss) {
            myEAs.statusInternalHTL.sHL_mitigate_iOrderFlow = -1;
            myEAs.statusInternalHTL.sHL_mitigate_iOrderBlock = -1;
         }
      }
   }
   
  
  //+------------------------------------------------------------------+
   //| Hàm kiểm tra và vẽ lại các zone khi bị mitigated - MQL5 version  |
   //+------------------------------------------------------------------+
   void getIsMitigatedZone(TimeFrameData &tfData, MqlRates& bar1, PoiZone& zone[], int type,  string zoneString = "", bool isReDraw = false, int skip_key = -1) 
{
   int totalZones = ArraySize(zone);
   if (totalZones <= 0) return;
   
   for(int i = 0; i < totalZones; i++) 
   {
      if (i == skip_key) continue;
      
      // Chỉ kiểm tra các zone chưa bị phá vỡ hoàn toàn (-1)
      if (zone[i].mitigated == -1) continue;
      
      // Tạo tên đối tượng duy nhất cho zone
      string objName = (StringLen(zone[i].name) > 0)? zone[i].name : "";
      
      bool isMitigated = false;
      bool isBreak = false;
      bool isSwept = false;
      
      // --- TRƯỜNG HỢP BULLISH ZONE (Vùng để BUY) ---
      if (type == 1)
      {
         // Kiểm tra sweep: Low thấp hơn đáy zone nhưng Close trên đáy zone
         if (bar1.low < zone[i].low && bar1.close >= zone[i].low) 
         {
            zone[i].isSwept = true;
            isSwept = true;
         }
         
         // Kiểm tra mitigate: Giá chạm vào zone
         if (bar1.low <= zone[i].high && bar1.low >= zone[i].low) 
         {
            if (zone[i].mitigated != 1) 
            {
               zone[i].mitigated = 1;
               isMitigated = true;
            }
         }
         
         // Kiểm tra break hoàn toàn: Close dưới đáy zone
         if (bar1.close < zone[i].low) 
         {
            zone[i].mitigated = -1;
            zone[i].zoneColor = color_Mitigated_Zone;
            zone[i].isSwept = false;
            isBreak = true;
         }
      } 
      else if (type == -1) // BEARISH ZONE
      {
         // Kiểm tra sweep: High cao hơn đỉnh zone nhưng Close dưới đỉnh zone
         if (bar1.high > zone[i].high && bar1.close <= zone[i].high) 
         {
            zone[i].isSwept = true;
            isSwept = true;
         }
         
         // Kiểm tra mitigate: Giá chạm vào zone
         if (bar1.high >= zone[i].low && bar1.high <= zone[i].high) 
         {
            if (zone[i].mitigated != 1) 
            {
               zone[i].mitigated = 1;
               zone[i].zoneColor = color_Mitigated_Zone;
               isMitigated = true;
            }
         }
         
         // Kiểm tra break hoàn toàn: Close trên đỉnh zone
         if (bar1.close > zone[i].high) 
         {
            zone[i].mitigated = -1;
            zone[i].isSwept = false;
            isBreak = true;
         }
      }
      
      if (tfData.isDraw) 
      {
         // --- XỬ LÝ XÓA KHI BREAK ---
         if (isBreak && isReDraw) 
         {
            
            if (ObjectFind(0, objName) >= 0) {
               ObjectDelete(0, objName);
            }
            
            //// Xóa nhãn cũ (nếu có từ phiên bản trước)
            //string labelName = objName + "_Label";
            //if (ObjectFind(0, labelName) >= 0) ObjectDelete(0, labelName);
            
            continue;
         }
         
         // --- XỬ LÝ VẼ VÀ KÉO DÀI BOX ---
         // Vẽ khi: Mới chạm (isMitigated), đã chạm từ trước (mitigated==1), hoặc bị quét râu (isSwept)
         if (isMitigated || ((zone[i].mitigated == 1 || isSwept) && isReDraw) )
         {
            color zoneColor = zone[i].zoneColor;
            
            // Tùy chọn: Bạn có thể đổi màu tại đây nếu muốn phân biệt vùng Mitigated và Active
            // Ví dụ: if(zone[i].mitigated == 1) zoneColor = clrGray;

            if (type == 1) // Bullish zone
            {
               DrawBox(0, objName, 0, zone[i].time, zone[i].low, bar1.time, zone[i].high, zoneColor, STYLE_SOLID, 1, true, false, false, true, 0);
            }
            else if (type == -1) // Bearish zone
            {
               DrawBox(0, objName, 0, zone[i].time, zone[i].high, bar1.time, zone[i].low, zoneColor, STYLE_SOLID, 1, true, false, false, true, 0);
            }
         }
      }
   }
}
   
   //+-------------------------------------------------------------------------------+
   //| Hàm kiểm tra và vẽ lại các Trade Global zone khi bị mitigated - MQL5 version  |
   //+-------------------------------------------------------------------------------+
   void getIsMitigatedTradeZone(TimeFrameData &tfData, MqlRates& bar1, PoiZone& zone[], int type, string zoneString = "", int skip_key = -1) 
   {
      // Kiểm tra mảng zone có dữ liệu hay không
      int totalZones = ArraySize(zone);
      if (totalZones <= 0) return;
      
      // Duyệt qua tất cả các zone
      for(int i = 0; i < totalZones; i++) 
      {
         if (i == skip_key) continue;
         
         // Chỉ kiểm tra các zone chưa bị phá vỡ hoàn toàn (-1)
         if (zone[i].mitigated == -1) continue;
         
         // Tạo tên đối tượng duy nhất cho zone
         string objName = zone[i].name;
         
         // --- LOGIC KIỂM TRA TRẠNG THÁI ---
         bool isMitigated = false;
         bool isBreak = false;
         bool isSwept = false;
         
         // --- TRƯỜNG HỢP BULLISH ZONE (Vùng để BUY) ---
         if (type == 1)
         {
            // Kiểm tra sweep: Low thấp hơn đáy zone nhưng Close trên đáy zone
            if (bar1.low < zone[i].low && bar1.close >= zone[i].low) 
            {
               zone[i].isSwept = true;
               isSwept = true;
            }
            
            // Kiểm tra mitigate: Giá chạm vào zone
            if (bar1.low <= zone[i].high && bar1.low >= zone[i].low) 
            {
               if (zone[i].mitigated != 1) 
               {
                  zone[i].mitigated = 1;
                  zone[i].zoneColor = color_Mitigated_Zone;
                  isMitigated = true;
               }
            }
            
            // Kiểm tra break hoàn toàn: Close dưới đáy zone
            if (bar1.close < zone[i].low) 
            {
               zone[i].mitigated = -1;
               zone[i].isSwept = false;
               isBreak = true;
            }
         } 
         else if (type == -1) // BEARISH ZONE
         {
            // Kiểm tra sweep: High cao hơn đỉnh zone nhưng Close dưới đỉnh zone
            if (bar1.high > zone[i].high && bar1.close <= zone[i].high) 
            {
               zone[i].isSwept = true;
               isSwept = true;
            }
            
            // Kiểm tra mitigate: Giá chạm vào zone
            if (bar1.high >= zone[i].low && bar1.high <= zone[i].high) 
            {
               if (zone[i].mitigated != 1) 
               {
                  zone[i].mitigated = 1;
                  zone[i].zoneColor = color_Mitigated_Zone;
                  isMitigated = true;
               }
            }
            
            // Kiểm tra break hoàn toàn: Close trên đỉnh zone
            if (bar1.close > zone[i].high) 
            {
               zone[i].mitigated = -1;
               zone[i].isSwept = false;
               isBreak = true;
            }
         }
         
         
         // --- XỬ LÝ XÓA KHI BREAK ---
         if (isBreak) 
         {
            
            if (ObjectFind(0, objName) >= 0) {
               ObjectDelete(0, objName);
            }
            
            //// Xóa nhãn cũ (nếu có từ phiên bản trước)
            //string labelName = objName + "_Label";
            //if (ObjectFind(0, labelName) >= 0) ObjectDelete(0, labelName);
            
            continue;
         }
         
         // --- XỬ LÝ VẼ VÀ KÉO DÀI BOX ---
         // Vẽ khi: Mới chạm (isMitigated), đã chạm từ trước (mitigated==1), hoặc bị quét râu (isSwept)
         if (isMitigated || zone[i].mitigated == 1 || isSwept) 
         {
            
            // Tùy chọn: Bạn có thể đổi màu tại đây nếu muốn phân biệt vùng Mitigated và Active
            // Ví dụ: if(zone[i].mitigated == 1) zoneColor = clrGray;

            if (type == 1) // Bullish zone
            {
               DrawBox(0, objName, 0, zone[i].time, zone[i].low, bar1.time, zone[i].high, zone[i].zoneColor, STYLE_SOLID, 1, true, false, false, true, 0);
            }
            else if (type == -1) // Bearish zone
            {
               DrawBox(0, objName, 0, zone[i].time, zone[i].high, bar1.time, zone[i].low, zone[i].zoneColor, STYLE_SOLID, 1, true, false, false, true, 0);
            }
         }
         
         
      }
   }
   
   //+------------------------------------------------------------------+
   //| Hàm tính tổng Volume giữa 2 khoảng thời gian                     |
   //+------------------------------------------------------------------+
   long GetCumulativeVolume(datetime startTime, datetime endTime, ENUM_TIMEFRAMES tf, string str_options = "")
   {
      string text = "#################### ["+str_options+"]: ";
      text += "Bắt đầu tính tổng volume từ "+(string) startTime + " đến " + (string) endTime;
      // 1. Chuyển đổi thời gian sang chỉ số nến (index)
      int startBar = iBarShift(_Symbol, tf, startTime);
      int endBar   = iBarShift(_Symbol, tf, endTime);
      
      long totalVolume = 0;
      long i_Volume;
      // 2. Xác định nến nào cũ hơn, nến nào mới hơn để chạy vòng lặp
      // Trong MQL5, nến càng cũ thì index càng lớn
      int highIndex = (startBar > endBar) ? startBar : endBar;
      int lowIndex  = (startBar > endBar) ? endBar : startBar;
      
      text += "; được tính tổng từ "+(string) ((volume_style == 1)? iVolume(_Symbol, tf, lowIndex) : iTickVolume(_Symbol, tf, lowIndex))+ 
               " đến "+ (string) ((volume_style == 1)? iVolume(_Symbol, tf, highIndex) : iTickVolume(_Symbol, tf, highIndex));
      // 3. Vòng lặp cộng dồn
      for(int i = lowIndex; i <= highIndex; i++)
      {
         i_Volume = (volume_style == 1)? iVolume(_Symbol, tf, i) : iTickVolume(_Symbol, tf, i);
         totalVolume += i_Volume;
      }
      text += " có tổng volume bằng: "+(string) totalVolume;
      //if(print_log) Print(text);
      return totalVolume;
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
      
      long wVol = 0;
      
      // dinh nghia lai mau sac cua zone
      color clr_internal_bullish;
      color clr_internal_bearish;
      if (tfData.isHighTF) {
         clr_internal_bullish = color_HTF_Internal_Bullish_Zone;
         clr_internal_bearish = color_HTF_Internal_Bearish_Zone;
      } else {
         clr_internal_bullish = color_LTF_Internal_Bullish_Zone;
         clr_internal_bearish = color_LTF_Internal_Bearish_Zone;
      }
      
      // dinh nghia lai ten internal swing
      string internal_name = "";
      // swing high
      if (bar3.high <= bar2.high && bar2.high >= bar1.high) { // tim thay dinh high
         bool resulCheckPullbackGannHigh = false;
         textGannHigh += "\n--->Gann: Find High: "+DoubleToString(bar2.high, _Digits) +" + Highest: "+ DoubleToString(tfData.highEst, _Digits) ;
         // set Zone bearish
         // Gọi hàm với nến số 2 làm điểm neo
         int indexAnchor = iBarShift(_Symbol, tfData.timeFrame, bar2.time);
         PoiZone mZone = createpoizone_optimized(tfData.timeFrame, indexAnchor, -1);
         PoiZone zone_bearish = CreatePoiZone( tfData, mZone.high, mZone.low, bar2.open, bar2.close, bar2.time, clr_internal_bearish);
         if (typeTickVolume == 1) {
            maxVolume = bar2.tick_volume;
         } else {
            maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
         }         
         
         // gann finding high
         if (tfData.LastSwingMeter == 1 || tfData.LastSwingMeter == 0) {
            textGannHigh += "; Gann: LastSwingMeter == 1 or 0 => New Highs= "+DoubleToString(bar2.high, _Digits) +"; LastSwingMeter = -1" ;
            // Add high moi (updatePointStructure), khong xoa Highs 0
            tfData.AddToDoubleArray(tfData.Highs, bar2.high, limit);
            tfData.AddToDateTimeArray(tfData.HighsTime, bar2.time, limit);
            tfData.AddToLongArray(tfData.volHighs, maxVolume, limit);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.LowsTime[0], tfData.timeFrame, "Gann New High");
            tfData.AddToLongArray(tfData.wvolHighs, wVol, limit);
            tfData.AddToDateTimeArray(tfData.wvolHighTime, bar2.time, limit);
                        
            drawPointStructure(tfData, 1, bar2.high, bar2.time, GANN_STRUCTURE, false, enabledDraw);
            tfData.LastSwingMeter = -1;
            // cap nhat Zone. Khong xoa (updatePointZone)
            tfData.AddToPoiZoneArray(tfData.zHighs, zone_bearish, limit);
            // cap nhat waiting bos highs ve 0
            tfData.waitingHighs = 0;
            resulCheckPullbackGannHigh = true;
         }
         // gann finding low
         if (tfData.LastSwingMeter == -1) {
            //    xoa high cu. viet high moi
            if (bar2.high > tfData.highEst) {
               textGannHigh += "; Gann: LastSwingMeter == -1 => Delete Highs[0] = "+DoubleToString(tfData.Highs[0], _Digits)+" ,New Highs= "+DoubleToString(bar2.high, _Digits) +"; LastSwingMeter = -1" ;
               // xoa high cu
               if (ArraySize(tfData.Highs) > 1) deleteObj(tfData.HighsTime[0], tfData.Highs[0], iWingding_gann_high, "");
               //       cap nhat high moi
               tfData.UpdateDoubleArray(tfData.Highs, 0, bar2.high);
               tfData.UpdateDateTimeArray(tfData.HighsTime, 0, bar2.time);
               tfData.UpdateLongArray(tfData.volHighs, 0, maxVolume);
               
               wVol = GetCumulativeVolume(bar2.time, tfData.LowsTime[0], tfData.timeFrame, "Gann Update High");
               tfData.UpdateLongArray(tfData.wvolHighs, 0, wVol);
               tfData.UpdateDateTimeArray(tfData.wvolHighTime, 0, bar2.time);
               
               drawPointStructure(tfData, 1, bar2.high, bar2.time, GANN_STRUCTURE, true, enabledDraw);
               tfData.LastSwingMeter = -1;
               // cap nhat Zone. Xoa 0 (updatePointZone)
               tfData.UpdatePoiZoneArray(tfData.zHighs, 0, zone_bearish);
               // cap nhat waiting bos highs ve 0
               tfData.waitingHighs = 0;
               resulCheckPullbackGannHigh = true;
            }
         }
         // Kiem tra xem co phai swing pullback hay khong
         if (tfData.isHighTF && resulCheckPullbackGannHigh && myEAs.valueInternal.vi_TempSwing_High.main.vins_SwingNew != 0){
            setValueToCandidateSwingHTF(tfData, bar2, -1);
            if(myEAs.valueInternal.candidate_High.vins_SwingNew != 0) {
               //Print("Gann High 1");
               checkValueWithInternalSwingHTF(tfData,  bar3, bar2, bar1, -1, INTERNAL_PULLBACK_SUB);
            }
         }
         
         //+------------------------------------------------------------------+
         //| Phần dành cho scalping Robot                                     |
         //+------------------------------------------------------------------+
         if (myEAs.valueInternal.vi_TempSwing_Low.main.vins_isSignalConfirm_LTF_byWave == 1 && bar2.high > myEAs.valueInternal.vi_TempSwing_Low.main.vins_Entry_Stop) {
            myEAs.valueInternal.vi_TempSwing_Low.main.vins_Entry_Stop = bar2.high;
            myEAs.valueInternal.vi_TempSwing_Low.main.isActive = true;
            textGannHigh += "\n ScalpingRobot: Gann => Finding New High for buy Stop. Update New Entry stop && isActive = true";
         }
         //+------------------------------------------------------------------+
         //| Kết thúc Phần dành cho scalping Robot                            |
         //+------------------------------------------------------------------+
          
         if(StringLen(textGannHigh) > 0) {
            text_all += str_gann+" (Swing) "+textGannHigh;
         }
         
                  
         // Internal Structure
         str_internal_high += "\n--->Swing High: "+DoubleToString(bar2.high,_Digits) +".#SS iTrend: " +(string) tfData.iTrend+", LastSwingInternal: "+(string) tfData.LastSwingInternal;
         str_internal_high += "| lastTimeH: "+(string) tfData.lastTimeH+" lastH: "+ DoubleToString(tfData.lastH,_Digits) +"<->"+" intSHighTime[0] "+(string) tfData.intSHighTime[0]+" intSHighs[0] "+ DoubleToString(tfData.intSHighs[0], _Digits);
         wVol = 0;
         
         // finding High
         
         // DONE 1
         // HH
         if ( (tfData.iTrend == 0 || (tfData.iTrend == 1 && tfData.LastSwingInternal == 1)) && bar2.high > tfData.intSHighs[0]){ // iBOS
            textInternalHigh += "\n"+"High 1 iBOS --> Update: "+ "iTrend: 1, LastSwingInternal: -1 , New intSHighs[0]: "+DoubleToString(bar2.high, _Digits);
            // Add new intSHigh.
            tfData.AddToDoubleArray(tfData.intSHighs, bar2.high);
            tfData.AddToDateTimeArray(tfData.intSHighTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSHighs, maxVolume);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.intSLowTime[0], tfData.timeFrame, "Internal Break High");
            tfData.AddToLongArray(tfData.wvolIntSHighs, wVol, limit);
            tfData.AddToDateTimeArray(tfData.wvolIntSHighTime, bar2.time);
            
            // Setup wave volume
            if (tfData.wvItrend == 0 && tfData.wvolIntSHighTime[0] > tfData.wvolIntSLowTime[0]) {
               tfData.wvItrend = (tfData.wvolIntSHighs[0] > tfData.wvolIntSLows[0]) ? 1 : -1;
               // Trả về trạng thái chấp nhận Buy or Sell của Internal sau cú Break khi xác nhận được swing đầu tiên
               tfData.wvIsBuyInternal = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Internal", 1);
               tfData.wvIsSellInternal = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Internal", -1);
               // Set thông số hướng để vẽ line break
               tfData.line_direction_internal = (tfData.isDrawTarget_internal == tfData.iTrend)? tfData.wvItrend : 0;
               // Set thông số để có hướng trade theo Internal HTF. (valueInternal)
               if (tfData.isHighTF) {
                  //Print("1 Set thông số swing High trước. Sau đó sẽ check xem là swept hay không?");
                  setValueToInternalSwingHTF(tfData, bar3, bar2, -1);
                  // Kiem tra dinh swept false breakout
                  if (myEAs.valueInternal.vi_ITrend != myEAs.valueInternal.vi_wvITrend && 
                     (myEAs.valueInternal.vi_isSwept || myEAs.valueInternal.vi_isMitigatedPoiZone || myEAs.valueInternal.vi_isSweptPoiZone)) {
                     //Print("Swept High hoac Mitigated poizone Marjor. Tiếp tục check Low timeframe để tìm tín hiệu sớm.");
                     //Print("High 1 iBOS");
                     checkValueWithInternalSwingHTF(tfData,  bar3, bar2, bar1, -1, INTERNAL_PULLBACK_MAIN);
                     
                     //Print("Swept High hoac Mitigated poizone Marjor. ");
                  }
                  
               }
            }
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            
            tfData.iTrend = 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 1;
            
            if (tfData.iFindTarget == 0 && tfData.intSHighs[0] > tfData.iTarget) {
               tfData.iTarget = tfData.intSHighs[0];
               tfData.iTargetTime = tfData.intSHighTime[0];
               tfData.iFindTarget = 0;
               textInternalHigh += " | Update High 1,2";
               // Phan cap nhat find L cua LTF thi xac dinh duoc HighTF iTarget
               if(tfData.isHighTF) {
                  myEAs.marketStructStatus.iMSS_findL = 1;
                  myEAs.marketStructStatus.iMSS_findH = 0;
               } 
            }
            
            if (tfData.iFindTarget == 1) {
               tfData.iTarget = tfData.intSHighs[0];
               tfData.iTargetTime = tfData.intSHighTime[0];
               tfData.iFindTarget = 0;
               textInternalHigh += " | New High 1,1";
               // Phan cap nhat find L cua LTF thi xac dinh duoc HighTF iTarget
               if(tfData.isHighTF) {
                  myEAs.marketStructStatus.iMSS_findL = 1;
                  myEAs.marketStructStatus.iMSS_findH = 0;
               } 
            }
            
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone_bearish, poi_limit);
            // cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSHighs = 0;
            // Cap nhat target zone Low
            // updateProcessPoiZone(tfData, tfData.zIntSLows[0]);
            // Cap nhat target Internal Zone Bullish
            internal_name = INTERNAL_TEXT+"_"+BULL_TEXT+"_"+TimeToString(tfData.zIntSLows[0].time);
            tfData.UpdatePoiZoneArray(tfData.zArrIntBullish,0,tfData.zIntSLows[0], internal_name);
            
            if(tfData.isHighTF) {
               // Scan poizone low timeframe thuộc Internal Break high timeframe Bullish
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
               // Kiểm định lại cú break thuộc breakout hay false breakout để xác nhận New Swing
               
            } 
         }
         
         // HH 2
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.high > tfData.intSHighs[0] && bar2.high > tfData.intSHighs[1]){
            textInternalHigh += "\n"+" High 2 --> Update: "+ "iTrend: 1, LastSwingInternal: -1, Update intSHighs[0]: "
                                 +DoubleToString(bar2.high, _Digits) + ", Xoa intSHighs[0] old: "+DoubleToString(tfData.intSHighs[0], _Digits);
            // Delete Label
            if (ArraySize(tfData.intSHighs) > 1) deleteObj(tfData.intSHighTime[0], tfData.intSHighs[0], iWingding_internal_high, "");
            // Update new intSHigh.
            tfData.UpdateDoubleArray(tfData.intSHighs, 0, bar2.high);
            tfData.UpdateDateTimeArray(tfData.intSHighTime, 0, bar2.time);
            tfData.UpdateLongArray(tfData.volIntSHighs, 0, maxVolume);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.intSLowTime[0], tfData.timeFrame, "Internal Update High");
            tfData.UpdateLongArray(tfData.wvolIntSHighs, 0,wVol);
            tfData.UpdateDateTimeArray(tfData.wvolIntSHighTime, 0, bar2.time);
            
            // Setup wave volume
            if (tfData.wvItrend != 0 && tfData.wvolIntSHighTime[0] > tfData.wvolIntSLowTime[0]) {
               tfData.wvItrend = (tfData.wvolIntSHighs[0] > tfData.wvolIntSLows[0]) ? 1 : -1;
               // Trả về trạng thái chấp nhận Buy or Sell của Internal sau cú Break khi xác nhận được swing đầu tiên
               tfData.wvIsBuyInternal = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Internal", 1);
               tfData.wvIsSellInternal = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Internal", -1);
               // Set thông số hướng để vẽ line break
               tfData.line_direction_internal = (tfData.isDrawTarget_internal == tfData.iTrend)? tfData.wvItrend : 0;
               // Set thông số để có hướng trade theo Internal HTF. (valueInternal)
               if (tfData.isHighTF) {
                  //Print("2 Set thông số swing High trước. Sau đó sẽ check xem là swept hay không?");
                  setValueToInternalSwingHTF(tfData, bar3, bar2, -1);
                  // Kiem tra dinh swept false breakout
                  if (myEAs.valueInternal.vi_ITrend != myEAs.valueInternal.vi_wvITrend && 
                     (myEAs.valueInternal.vi_isSwept || myEAs.valueInternal.vi_isMitigatedPoiZone || myEAs.valueInternal.vi_isSweptPoiZone)) {
                     //Print("Swept High hoac Mitigated poizone Marjor. Tiếp tục check Low timeframe để tìm tín hiệu sớm.");
                     //Print("High 2");
                     checkValueWithInternalSwingHTF(tfData,  bar3, bar2, bar1, -1, INTERNAL_PULLBACK_MAIN);
                     //Print("Swept High hoac Mitigated poizone Marjor. ");
                  }
               }
            }
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
            
            tfData.iTrend = 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 2;
            
            if (tfData.iFindTarget == 0 && tfData.intSHighs[0] > tfData.iTarget) {
               tfData.iTarget = tfData.intSHighs[0];
               tfData.iTargetTime = tfData.intSHighTime[0];
               tfData.iFindTarget = 0;
               textInternalHigh += " | Update High 2,2";
               // Phan cap nhat find L cua LTF thi xac dinh duoc HighTF iTarget
               if(tfData.isHighTF) {
                  myEAs.marketStructStatus.iMSS_findL = 1;
                  myEAs.marketStructStatus.iMSS_findH = 0;
               } 
            }
            
            if (tfData.iFindTarget == 1) {
               tfData.iTarget = tfData.intSHighs[0];
               tfData.iTargetTime = tfData.intSHighTime[0];
               tfData.iFindTarget = 0;
               textInternalHigh += " | New High 2,1";
               // Phan cap nhat find L cua LTF thi xac dinh duoc HighTF iTarget
               if(tfData.isHighTF) {
                  myEAs.marketStructStatus.iMSS_findL = 1;
                  myEAs.marketStructStatus.iMSS_findH = 0;
               } 
            }
                        
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSHighs, 0, zone_bearish);
            //// cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSHighs = 0;
            // Cap nhat target zone Low
            // updateProcessPoiZone(tfData, tfData.zIntSLows[0]);
            // Cap nhat target Internal Zone Bullish
            internal_name = INTERNAL_TEXT+"_"+BULL_TEXT+"_"+TimeToString(tfData.zIntSLows[0].time);
            tfData.UpdatePoiZoneArray(tfData.zArrIntBullish,0,tfData.zIntSLows[0], internal_name);
            
            if(tfData.isHighTF) {
               // Thêm mới thông số Global Target 
               setValueRealtimeByHighTF(tfData);
               
               // Scan poizone low timeframe thuộc Internal Break high timeframe bullish
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
            }
         }
                  
         // DONE 4 
         // LH
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.high < tfData.intSHighs[0]) { 
            textInternalHigh += "\n"+ " High 4 --> Update: "+ "iTrend: -1, LastSwingInternal: -1, New intSHighs[0]: "+DoubleToString(bar2.high, _Digits);
            // Add new intSHigh
            tfData.AddToDoubleArray(tfData.intSHighs, bar2.high);
            tfData.AddToDateTimeArray(tfData.intSHighTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSHighs, maxVolume);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.intSLowTime[0], tfData.timeFrame, "Internal New High");
            tfData.AddToLongArray(tfData.wvolIntSHighs, wVol, limit);
            tfData.AddToDateTimeArray(tfData.wvolIntSHighTime, bar2.time);
                        
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            tfData.iTrend = -1;
            tfData.LastSwingInternal = -1;
            resultStructure = 4;
            
            // Set thông số swing high có đủ điều kiện để trade hay không. (valueInternal)
            if (tfData.isHighTF) {
               if (myEAs.valueInternal.vi_TempSwing_High.main.vins_SwingNew == 0) {
                  //Print("High 4");
                  checkValueWithInternalSwingHTF(tfData,  bar3, bar2, bar1, tfData.iTrend, INTERNAL_PULLBACK_MAIN);
               }
                  
            }
            
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone_bearish, poi_limit);
            // cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSHighs = 0;
         }
         
         // DONE 5
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == -1 && bar2.high > tfData.intSHighs[0] ) {    // iCHoCH
            textInternalHigh += "\n"+" High 5 iCHoCH --> Update: LastSwingInternal: -1, Update intSHighs[0]: "+DoubleToString(bar2.high, _Digits)+", Xoa intSHighs[0] old: "+DoubleToString(tfData.intSHighs[0], _Digits);
            // Delete prev label
            if (ArraySize(tfData.intSHighs) > 1) deleteObj(tfData.intSHighTime[0], tfData.intSHighs[0], iWingding_internal_high, "");
            // Update new intSHigh.
            tfData.UpdateDoubleArray(tfData.intSHighs, 0, bar2.high);
            tfData.UpdateDateTimeArray(tfData.intSHighTime, 0, bar2.time);
            tfData.UpdateLongArray(tfData.volIntSHighs, 0, maxVolume);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.intSLowTime[0], tfData.timeFrame, "Internal Update High");
            tfData.UpdateLongArray(tfData.wvolIntSHighs, 0, wVol);
            tfData.UpdateDateTimeArray(tfData.wvolIntSHighTime, 0, bar2.time);
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
                     
            tfData.iTrend = (bar2.high <= tfData.intSHighs[1])? -1 : 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 5;
            
            if (bar2.high <= tfData.intSHighs[1]) {
               // Set thông số swing high có đủ điều kiện để trade hay không. (valueInternal)
               if (tfData.isHighTF) {
                  if (myEAs.valueInternal.vi_TempSwing_High.main.vins_SwingNew == 0) {
                     //Print("High 5");
                     checkValueWithInternalSwingHTF(tfData,  bar3, bar2, bar1, tfData.iTrend, INTERNAL_PULLBACK_MAIN);
                  }
                     
               }
            }
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSHighs, 0, zone_bearish);
            textInternalHigh += ", (?) iTrend: "+(string) tfData.iTrend+"\n";
            //// cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSHighs = 0;
         }
         
         // DONE 6
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.high > tfData.intSHighs[0] 
            //&& tfData.waitingIntSHighs == 1
            ) { // iCHoCH
            textInternalHigh += "\n"+" High 6 iCHoCH --> Update: LastSwingInternal: -1, New intSHighs[0]: "+DoubleToString(bar2.high, _Digits);
            
            // Add new intSHigh
            tfData.AddToDoubleArray(tfData.intSHighs, bar2.high);
            tfData.AddToDateTimeArray(tfData.intSHighTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSHighs, maxVolume);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.intSLowTime[0], tfData.timeFrame, "Internal Break High");
            tfData.AddToLongArray(tfData.wvolIntSHighs, wVol, limit);
            tfData.AddToDateTimeArray(tfData.wvolIntSHighTime, bar2.time);
            
            drawPointStructure(tfData, 1, bar2.high, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            tfData.iTrend = 1;
            tfData.LastSwingInternal = -1;
            resultStructure = 6;
            
            if (tfData.iFindTarget == 1) {
               tfData.iTarget = tfData.intSHighs[0];
               tfData.iTargetTime = tfData.intSHighTime[0];
               tfData.iFindTarget = 0;
               textInternalHigh += " | New High 6";
               // Phan cap nhat find L cua LTF thi xac dinh duoc HighTF iTarget
               if(tfData.isHighTF) {
                  myEAs.marketStructStatus.iMSS_findL = 1;
                  myEAs.marketStructStatus.iMSS_findH = 0;
               } 
            }
            
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSHighs, zone_bearish, poi_limit);
            // cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSHighs = 0;
            // Cap nhat target zone Low
            // updateProcessPoiZone(tfData, tfData.zIntSLows[0]);
            // Cap nhat target Internal Zone Bullish
            internal_name = INTERNAL_TEXT+"_"+BULL_TEXT+"_"+TimeToString(tfData.zIntSLows[0].time);
            tfData.UpdatePoiZoneArray(tfData.zArrIntBullish,0,tfData.zIntSLows[0], internal_name);
            
            if(tfData.isHighTF) {
               // Scan poizone low timeframe thuộc Internal Break high timeframe bullish
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
            }
         }
         //+------------------------------------------------------------------+
         //| Phần dành cho scalping Robot                                     |
         //+------------------------------------------------------------------+
         if (myEAs.valueInternal.vi_TempSwing_Low.main.vins_isSignalConfirm_LTF_byWave == 2 && bar2.high > myEAs.valueInternal.vi_TempSwing_Low.main.vins_Entry_Stop) {
            myEAs.valueInternal.vi_TempSwing_Low.main.vins_Entry_Stop = bar2.high;
            myEAs.valueInternal.vi_TempSwing_Low.main.isActive = true;
            textInternalHigh += "\n ScalpingRobot: Gann => Finding New High for buy Stop. Update New Entry stop && isActive = true";
         }
         //+------------------------------------------------------------------+
         //| Kết thúc Phần dành cho scalping Robot                            |
         //+------------------------------------------------------------------+         
         if(StringLen(textInternalHigh) > 0) {
            text_all += str_internal+" (Swing) "+str_internal_high+textInternalHigh;
         }
      }
   //   
         wVol = 0;
   //   // swing low
      if (bar3.low >= bar2.low && bar2.low <= bar1.low) { // tim thay dinh low
         bool resulCheckPullbackGannLow = false;
         textGannLow += "\n--->Gann: Find Low: +" +DoubleToString(bar2.low, _Digits)+ " + Lowest: "+DoubleToString(tfData.lowEst, _Digits);
         // set Zone bullish
         int indexAnchor = iBarShift(_Symbol, tfData.timeFrame, bar2.time);
         PoiZone mZone = createpoizone_optimized(tfData.timeFrame, indexAnchor, 1);
         PoiZone zone_bullish = CreatePoiZone( tfData, mZone.high, mZone.low, bar2.open, bar2.close, bar2.time, clr_internal_bullish);
         if (typeTickVolume == 1) {
            maxVolume = bar2.tick_volume;
         } else {
            maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
         }
         // gann finding low
         if (tfData.LastSwingMeter == -1 || tfData.LastSwingMeter == 0) {
            textGannLow += "; Gann: LastSwingMeter == -1 or 0 => New Lows[0] = "+DoubleToString(bar2.low, _Digits) +"; LastSwingMeter = 1" ;
            // cap nhat low moi, khong xoa Lows 0
            tfData.AddToDoubleArray(tfData.Lows, bar2.low);
            tfData.AddToDateTimeArray(tfData.LowsTime, bar2.time);
            tfData.AddToLongArray(tfData.volLows, maxVolume);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.HighsTime[0], tfData.timeFrame, "Gann New Low");
            tfData.AddToLongArray(tfData.wvolLows, wVol, limit);
            tfData.AddToDateTimeArray(tfData.wvolLowTime, bar2.time);
                        
            drawPointStructure(tfData, -1, bar2.low, bar2.time, GANN_STRUCTURE, false, enabledDraw);
            tfData.LastSwingMeter = 1;
            // Them Zone.
            tfData.AddToPoiZoneArray(tfData.zLows, zone_bullish, limit);
            // cap nhat waiting bos lows ve 0
            tfData.waitingLows = 0;
            resulCheckPullbackGannLow = true;
         }
         // gann finding high
         if (tfData.LastSwingMeter == 1) {
            // xoa low cu. viet high moi
            if (bar2.low < tfData.lowEst) {
               textGannLow += "; Gann: LastSwingMeter == 1 => Delete Lows[0] = "+DoubleToString(tfData.Lows[0], _Digits)+" ,New Lows= "+DoubleToString(bar2.low, _Digits) +"; LastSwingMeter = 1" ;
               // xoa low cu
               if (ArraySize(tfData.Lows) > 1) deleteObj(tfData.LowsTime[0], tfData.Lows[0], iWingding_gann_low, "");
               // cap nhat low moi.
               tfData.UpdateDoubleArray(tfData.Lows, 0, bar2.low);
               tfData.UpdateDateTimeArray(tfData.LowsTime, 0, bar2.time);
               tfData.UpdateLongArray(tfData.volLows, 0, maxVolume);
               
               wVol = GetCumulativeVolume(bar2.time, tfData.HighsTime[0], tfData.timeFrame, "Gann Update Low");
               tfData.UpdateLongArray(tfData.wvolLows, 0, wVol);
               tfData.UpdateDateTimeArray(tfData.wvolLowTime, 0, bar2.time);
               
               drawPointStructure(tfData, -1, bar2.low, bar2.time, GANN_STRUCTURE, true, enabledDraw);
               tfData.LastSwingMeter = 1;
               // cap nhat Zone
               tfData.UpdatePoiZoneArray(tfData.zLows, 0, zone_bullish);
               // cap nhat waiting bos lows ve 0
               tfData.waitingLows = 0;
               resulCheckPullbackGannLow = true;
            }
         }
         
         // Kiem tra xem co phai swing pullback hay khong
         if (tfData.isHighTF && resulCheckPullbackGannLow && myEAs.valueInternal.vi_TempSwing_Low.main.vins_SwingNew != 0){
            setValueToCandidateSwingHTF(tfData, bar2, 1);
            if(myEAs.valueInternal.candidate_Low.vins_SwingNew != 0) {
               //Print("Gann Low -1");
               checkValueWithInternalSwingHTF(tfData,  bar3, bar2, bar1, 1, INTERNAL_PULLBACK_SUB);
            }
         }
         
         //+------------------------------------------------------------------+
         //| Phần dành cho scalping Robot                                     |
         //+------------------------------------------------------------------+
         if (myEAs.valueInternal.vi_TempSwing_High.main.vins_isSignalConfirm_LTF_byWave == 1 && bar2.low < myEAs.valueInternal.vi_TempSwing_High.main.vins_Entry_Stop) {
            myEAs.valueInternal.vi_TempSwing_High.main.vins_Entry_Stop = bar2.low;
            myEAs.valueInternal.vi_TempSwing_High.main.isActive = true;
            textGannLow += "\n ScalpingRobot: Gann => Finding New Low for Sell Stop. Update New Entry stop && isActive = true";
         }
         //+------------------------------------------------------------------+
         //| Kết thúc Phần dành cho scalping Robot                            |
         //+------------------------------------------------------------------+   
         if(StringLen(textGannLow) > 0) {
            text_all += str_gann+" (Swing) "+textGannLow;
         }
         
         // Internal Structure 
         str_internal_low += "\n--->Swing Low: "+ DoubleToString(bar2.low, _Digits) +".#SS iTrend: " +(string) tfData.iTrend+", LastSwingInternal: "+(string) tfData.LastSwingInternal;
         str_internal_low += "| lastTimeL: "+(string) tfData.lastTimeL+" lastL: "+DoubleToString(tfData.lastL,_Digits) +"<->"+"intSLowTime[0] "+(string) tfData.intSLowTime[0]+" intSLows[0] "+ DoubleToString(tfData.intSLows[0], _Digits);
         // finding Low
         // DONE 1
         // LL
         if ((tfData.iTrend == 0 || tfData.iTrend == -1) && tfData.LastSwingInternal == -1 && bar2.low < tfData.intSLows[0]){ // iBOS
            textInternalLow += "\n"+("Low 1 iBOS --> Update: "+ "iTrend: -1, LastSwingInternal: 1, New intSLows[0]: "+DoubleToString(bar2.low, _Digits));
            // Add new intSLows
            tfData.AddToDoubleArray(tfData.intSLows, bar2.low);
            tfData.AddToDateTimeArray(tfData.intSLowTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSLows, maxVolume);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.intSHighTime[0], tfData.timeFrame, "Internal New Low");
            tfData.AddToLongArray(tfData.wvolIntSLows, wVol, limit);
            tfData.AddToDateTimeArray(tfData.wvolIntSLowTime, bar2.time);
            
            // Setup wave volume
            if (tfData.wvItrend == 0 && tfData.wvolIntSLowTime[0] > tfData.wvolIntSHighTime[0]) {
               tfData.wvItrend = (tfData.wvolIntSLows[0] > tfData.wvolIntSHighs[0]) ? -1 : 1;
               // Trả về trạng thái chấp nhận Buy or Sell của Internal sau cú Break khi xác nhận được swing đầu tiên
               tfData.wvIsBuyInternal = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Internal", 1);
               tfData.wvIsSellInternal = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Internal", -1);
               // Set thông số hướng để vẽ line break
               tfData.line_direction_internal = (tfData.isDrawTarget_internal == tfData.iTrend)? tfData.wvItrend : 0;
               // Set thông số để có hướng trade theo Internal HTF. (valueInternal)
               if (tfData.isHighTF) {
                  //Print("1 Set thông số swing Low trước. Sau đó sẽ check xem là swept hay không?");
                  setValueToInternalSwingHTF(tfData, bar3, bar2, 1);
                  // Kiem tra dinh swept false breakout
                  if (myEAs.valueInternal.vi_ITrend != myEAs.valueInternal.vi_wvITrend && 
                     (myEAs.valueInternal.vi_isSwept || myEAs.valueInternal.vi_isMitigatedPoiZone || myEAs.valueInternal.vi_isSweptPoiZone)) {
                     //Print("Swept High hoac Mitigated poizone Marjor. Tiếp tục check Low timeframe để tìm tín hiệu sớm.");
                     //Print("Low 1");
                     checkValueWithInternalSwingHTF(tfData,  bar3, bar2, bar1, 1, INTERNAL_PULLBACK_MAIN);
                     //Print("Swept Low hoac Mitigated poizone Marjor. ");
                  }
               }
            }
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
                     
            tfData.iTrend = -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -1;
            
            if (tfData.iFindTarget == 0 && tfData.intSLows[0] < tfData.iTarget) {
               tfData.iTarget = tfData.intSLows[0];
               tfData.iTargetTime = tfData.intSLowTime[0];
               tfData.iFindTarget = 0;
               textInternalLow += " | Update Low -1,2";
               // Phan cap nhat find H cua LTF thi xac dinh duoc HighTF iTarget
               if(tfData.isHighTF) {
                  myEAs.marketStructStatus.iMSS_findL = 0;
                  myEAs.marketStructStatus.iMSS_findH = 1;
               } 
            }
            
            if (tfData.iFindTarget == -1) {
               tfData.iTarget = tfData.intSLows[0];
               tfData.iTargetTime = tfData.intSLowTime[0];
               tfData.iFindTarget = 0;
               textInternalLow += " | New Low -1,1";
               // Phan cap nhat find H cua LTF thi xac dinh duoc HighTF iTarget
               if(tfData.isHighTF) {
                  myEAs.marketStructStatus.iMSS_findL = 0;
                  myEAs.marketStructStatus.iMSS_findH = 1;
               } 
            }
            
            // Them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSLows, zone_bullish, poi_limit);
            // cap nhat waiting bos intSLows ve 0
            tfData.waitingIntSLows = 0;
            // Cap nhat target zone High
            // updateProcessPoiZone(tfData, tfData.zIntSHighs[0]);
            // Cap nhat target Internal Zone Bearish
            internal_name = INTERNAL_TEXT+"_"+BEAR_TEXT+"_"+TimeToString(tfData.zIntSHighs[0].time);
            tfData.UpdatePoiZoneArray(tfData.zArrIntBearish,0,tfData.zIntSHighs[0], internal_name);
            
            if(tfData.isHighTF) {
               // Scan poizone low timeframe thuộc Internal Break high timeframe Bearish
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
            }
         }
         
         // LL
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar2.low < tfData.intSLows[0] && bar2.low < tfData.intSLows[1]){
            textInternalLow += "\n"+" Low 2 --> Update: "+ "iTrend: -1, LastSwingInternal: 1"+
                                 ", Update intSLows[0]: "+DoubleToString(bar2.low, _Digits) +", Xoa intSLows[0] old: "+DoubleToString(tfData.intSLows[0], _Digits);
            
            // Delete Label
            if (ArraySize(tfData.intSLows) > 1) deleteObj(tfData.intSLowTime[0], tfData.intSLows[0], iWingding_internal_low, "");
            // Update new intSLows
            tfData.UpdateDoubleArray(tfData.intSLows, 0, bar2.low);
            tfData.UpdateDateTimeArray(tfData.intSLowTime, 0, bar2.time);
            tfData.UpdateLongArray(tfData.volIntSLows, 0, maxVolume);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.intSHighTime[0], tfData.timeFrame, "Internal Update Low");
            tfData.UpdateLongArray(tfData.wvolIntSLows, 0, wVol);
            tfData.UpdateDateTimeArray(tfData.wvolIntSLowTime, 0, bar2.time);
            
            // Setup wave volume
            if (tfData.wvItrend != 0 && tfData.wvolIntSLowTime[0] > tfData.wvolIntSHighTime[0]) {
               tfData.wvItrend = (tfData.wvolIntSLows[0] > tfData.wvolIntSHighs[0]) ? -1 : 1;
               // Trả về trạng thái chấp nhận Buy or Sell của Internal sau cú Break khi xác nhận được swing đầu tiên
               tfData.wvIsBuyInternal = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Internal", 1);
               tfData.wvIsSellInternal = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Internal", -1);
               // Set thông số hướng để vẽ line break
               tfData.line_direction_internal = (tfData.isDrawTarget_internal == tfData.iTrend)? tfData.wvItrend : 0;
               // Set thông số để có hướng trade theo Internal HTF. (valueInternal)
               if (tfData.isHighTF) {
                  //Print("2 Set thông số swing Low trước. Sau đó sẽ check xem là swept hay không?");
                  setValueToInternalSwingHTF(tfData, bar3, bar2, 1);
                  // Kiem tra dinh swept false breakout
                  if (myEAs.valueInternal.vi_ITrend != myEAs.valueInternal.vi_wvITrend && 
                     (myEAs.valueInternal.vi_isSwept || myEAs.valueInternal.vi_isMitigatedPoiZone || myEAs.valueInternal.vi_isSweptPoiZone)) {        
                     //Print("Swept High hoac Mitigated poizone Marjor. Tiếp tục check Low timeframe để tìm tín hiệu sớm.");
                     Print("Low 2");
                     checkValueWithInternalSwingHTF(tfData,  bar3, bar2, bar1, 1, INTERNAL_PULLBACK_MAIN);
                     //Print("Swept Low hoac Mitigated poizone Marjor. ");
                  }
               }
            }
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
                     
            tfData.iTrend = -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -2;
            
            if (tfData.iFindTarget == 0 && tfData.intSLows[0] < tfData.iTarget) {
               tfData.iTarget = tfData.intSLows[0];
               tfData.iTargetTime = tfData.intSLowTime[0];
               tfData.iFindTarget = 0;
               textInternalLow += " | Update Low -2,2";
               // Phan cap nhat find H cua LTF thi xac dinh duoc HighTF iTarget
               if(tfData.isHighTF) {
                  myEAs.marketStructStatus.iMSS_findL = 0;
                  myEAs.marketStructStatus.iMSS_findH = 1;
               } 
            }
            
            if (tfData.iFindTarget == -1) {
               tfData.iTarget = tfData.intSLows[0];
               tfData.iTargetTime = tfData.intSLowTime[0];
               tfData.iFindTarget = 0;
               textInternalLow += " | New Low -2,1";
               // Phan cap nhat find H cua LTF thi xac dinh duoc HighTF iTarget
               if(tfData.isHighTF) {
                  myEAs.marketStructStatus.iMSS_findL = 0;
                  myEAs.marketStructStatus.iMSS_findH = 1;
               } 
            }
            
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSLows, 0, zone_bullish);
            //// cap nhat waiting bos intSLows ve 0
            tfData.waitingIntSLows = 0;
            // Cap nhat target zone High
            // updateProcessPoiZone(tfData, tfData.zIntSHighs[0]);
            // Cap nhat target Internal Zone Bearish
            internal_name = INTERNAL_TEXT+"_"+BEAR_TEXT+"_"+TimeToString(tfData.zIntSHighs[0].time);
            tfData.UpdatePoiZoneArray(tfData.zArrIntBearish,0,tfData.zIntSHighs[0], internal_name);
            
            if(tfData.isHighTF) {
               // Thêm mới thông số Global Target 
               setValueRealtimeByHighTF(tfData);
               // Scan poizone low timeframe thuộc Internal Break high timeframe Bearish
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
            }
            
            isDrawTarget = true;
            tfData.isDrawTarget_internal = tfData.iTrend;
            tfData.line_high_internal = tfData.intSHighs[0];
            tfData.line_low_internal = tfData.intSLows[0];
            tfData.barBreak_internal = bar1;
         }
         
         // DONE 4
         // Trend Tang. HL
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.low > tfData.intSLows[0]) {
            textInternalLow += "\n"+("Low 4 --> Update: "+ "iTrend: 1, LastSwingInternal: 1, New intSLows[0]: "+DoubleToString(bar2.low, _Digits));
            
            // Add new intSLows
            tfData.AddToDoubleArray(tfData.intSLows, bar2.low);
            tfData.AddToDateTimeArray(tfData.intSLowTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSLows, maxVolume);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.intSHighTime[0], tfData.timeFrame, "Internal New Low");
            tfData.AddToLongArray(tfData.wvolIntSLows, wVol, limit);
            tfData.AddToDateTimeArray(tfData.wvolIntSLowTime, bar2.time);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            tfData.iTrend = 1;
            tfData.LastSwingInternal = 1;
            resultStructure = -4;
            
            // Set thông số swing high có đủ điều kiện để trade hay không. (valueInternal)
            if (tfData.isHighTF) {
               if (myEAs.valueInternal.vi_TempSwing_Low.main.vins_SwingNew == 0) {
                  //Print("Low 4");
                  checkValueWithInternalSwingHTF(tfData,  bar3, bar2, bar1, tfData.iTrend, INTERNAL_PULLBACK_MAIN);
               }
                  
            }
            
            // Them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSLows, zone_bullish, poi_limit);
            // cap nhat waiting bos intSLows ve 0
            tfData.waitingIntSLows = 0;
         }
         
         // DONE 5
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == 1 && bar2.low < tfData.intSLows[0] ) {  // iCHoCH
            textInternalLow += "\n"+("Low 5 iCHoCH --> Update:  LastSwingInternal: 1, Update intSLows[0]: "+DoubleToString(bar2.low, _Digits)+", Xoa intSLows[0] old: "+DoubleToString(tfData.intSLows[0], _Digits));
            // Delete Label
            if (ArraySize(tfData.intSLows) > 1) deleteObj(tfData.intSLowTime[0], tfData.intSLows[0], iWingding_internal_low, "");
            // Update new intSLows
            tfData.UpdateDoubleArray(tfData.intSLows, 0, bar2.low);
            tfData.UpdateDateTimeArray(tfData.intSLowTime, 0, bar2.time);
            tfData.UpdateLongArray(tfData.volIntSLows, 0, maxVolume);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.intSHighTime[0], tfData.timeFrame, "Internal Update Low");
            tfData.UpdateLongArray(tfData.wvolIntSLows, 0, wVol);
            tfData.UpdateDateTimeArray(tfData.wvolIntSLowTime, 0, bar2.time);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, true, enabledDraw);
                     
            tfData.iTrend = (bar2.low >= tfData.intSLows[1]) ? 1 : -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -5;
            
            if (bar2.low >= tfData.intSLows[1]) {
               // Set thông số swing high có đủ điều kiện để trade hay không. (valueInternal)
               if (tfData.isHighTF) {
                  if (myEAs.valueInternal.vi_TempSwing_Low.main.vins_SwingNew == 0) {
                     //Print("Low 5");
                     checkValueWithInternalSwingHTF(tfData,  bar3, bar2, bar1, tfData.iTrend, INTERNAL_PULLBACK_MAIN);
                  }
                     
               }
            }
            
            // cap nhat Zone
            tfData.UpdatePoiZoneArray(tfData.zIntSLows, 0, zone_bullish);
            textInternalLow += ", (?) iTrend: "+(string) tfData.iTrend;
            //// cap nhat waiting bos intSLows ve 0
            tfData.waitingIntSLows = 0;
         }
         
         // DONE 6
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar2.low < tfData.intSLows[0] 
               //&& tfData.waitingIntSLows == 1
               ) { // iCHoCH
            textInternalLow += "\n"+"Low 6 iCHoCH --> Update: LastSwingInternal: 1, New intSLows[0]: "+DoubleToString(bar2.low, _Digits);
            
            // Add new intSHigh
            tfData.AddToDoubleArray(tfData.intSLows, bar2.low);
            tfData.AddToDateTimeArray(tfData.intSLowTime, bar2.time);
            tfData.AddToLongArray(tfData.volIntSLows, maxVolume);
            
            wVol = GetCumulativeVolume(bar2.time, tfData.intSHighTime[0], tfData.timeFrame, "Internal New Low");
            tfData.AddToLongArray(tfData.wvolIntSLows, wVol, limit);
            tfData.AddToDateTimeArray(tfData.wvolIntSLowTime, bar2.time);
            
            drawPointStructure(tfData, -1, bar2.low, bar2.time, INTERNAL_STRUCTURE, false, enabledDraw);
            tfData.iTrend = -1;
            tfData.LastSwingInternal = 1;
            resultStructure = -6;
            
            if (tfData.iFindTarget == -1) {
               tfData.iTarget = tfData.intSLows[0];
               tfData.iTargetTime = tfData.intSLowTime[0];
               tfData.iFindTarget = 0;
               textInternalLow += " | New Low 6";
               // Phan cap nhat find H cua LTF thi xac dinh duoc HighTF iTarget
               if(tfData.isHighTF) {
                  myEAs.marketStructStatus.iMSS_findL = 0;
                  myEAs.marketStructStatus.iMSS_findH = 1;
               } 
            }
            
            // them Zone
            tfData.AddToPoiZoneArray(tfData.zIntSLows, zone_bullish, poi_limit);
            // cap nhat waiting bos intSHighs ve 0
            tfData.waitingIntSLows = 0;
            // Cap nhat target zone High
            // updateProcessPoiZone(tfData, tfData.zIntSHighs[0]);
            // Cap nhat target Internal Zone Bearish
            internal_name = INTERNAL_TEXT+"_"+BEAR_TEXT+"_"+TimeToString(tfData.zIntSHighs[0].time);
            tfData.UpdatePoiZoneArray(tfData.zArrIntBearish,0,tfData.zIntSHighs[0], internal_name);
            
            if(tfData.isHighTF) {
               // Scan poizone low timeframe thuộc Internal Break high timeframe Bearish
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
            }
         }
         //+------------------------------------------------------------------+
         //| Phần dành cho scalping Robot                                     |
         //+------------------------------------------------------------------+
         if (myEAs.valueInternal.vi_TempSwing_High.main.vins_isSignalConfirm_LTF_byWave == 2 && bar2.low < myEAs.valueInternal.vi_TempSwing_High.main.vins_Entry_Stop) {
            myEAs.valueInternal.vi_TempSwing_High.main.vins_Entry_Stop = bar2.low;
            myEAs.valueInternal.vi_TempSwing_High.main.isActive = true;
            textInternalLow += "\n ScalpingRobot: Gann => Finding New Low for Sell Stop. Update New Entry stop && isActive = true";
         }
         //+------------------------------------------------------------------+
         //| Kết thúc Phần dành cho scalping Robot                            |
         //+------------------------------------------------------------------+ 
         if(StringLen(textInternalLow) > 0) { 
            text_all += str_internal+" (Swing) "+str_internal_low+textInternalLow;
         }         
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
         textGannHigh += "\n---> G1 Gann. bar1.high ("+DoubleToString(bar1.high, _Digits)+") > Highs[0] ("+DoubleToString(tfData.Highs[0], _Digits)+"). => Cap nhat: gTrend = 1, waitingHighs = 1";
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
         textGannLow += "\n---> -G1 Gann. bar1.low ("+DoubleToString(bar1.low, _Digits)+") > Lows[0] ("+DoubleToString(tfData.Lows[0], _Digits)+"). => Cap nhat: gTrend = -1, waitingHighs = 1";
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
            tfData.wvItrend = 0;
            tfData.wvIsBuyInternal = false;
            tfData.wvIsSellInternal = false;
            tfData.LastSwingInternal = 1;
            tfData.waitingIntSHighs = 1;
                        
            textInternalHigh += "\n---> I1 Bos High => iTrend = 1 && LastSwingInternal = 1 && bar1.high > tfData.intSHighs[0] => iTrend = 1, LastSwingInternal = 1, waitingIntSHighs = 1";
                        
            if (tfData.iFindTarget != 1) {
               tfData.iFindTarget = 1;
               tfData.iStoploss = tfData.intSLows[0];
               tfData.iStoplossTime = tfData.intSLowTime[0];
               tfData.iOrderBlock = tfData.zIntSLows[0].high;
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
            tfData.isDrawTarget_internal = tfData.iTrend;
            tfData.line_high_internal = tfData.intSHighs[0];
            tfData.line_low_internal = tfData.intSLows[0];
            tfData.barBreak_internal = bar1;
            // Set news value target zone
            //beginSetValueToPoiZone(tfData, tfData.zIntSLows[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setValueRealtimeByHighTF(tfData);
            // Them moi poizone Internal Bullish
            internal_name = INTERNAL_TEXT+"_"+BULL_TEXT+"_"+TimeToString(tfData.zIntSLows[0].time);
            tfData.AddToPoiZoneArray(tfData.zArrIntBullish, tfData.zIntSLows[0], poi_limit);
            // Ve poizone Internal Bullish trên chart
            if(tfData.isDraw) {
               DrawBox(0, internal_name, 0, tfData.zArrIntBullish[0].time, tfData.zArrIntBullish[0].high, bar1.time, tfData.zArrIntBullish[0].low, iColorBull, STYLE_SOLID,1, true, false, false, true, 0);
            } 
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) {
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               
               // Reset PoiZone Trade Zone belong to Internal structure
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBullishHTF);
               
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
            }
         }
         
         //3 choch high
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == 1 && bar1.high > tfData.intSHighs[0]) {
            tfData.iTrend = 1;
            tfData.vItrend = tfData.iTrend;
            tfData.wvItrend = 0;
            tfData.wvIsBuyInternal = false;
            tfData.wvIsSellInternal = false;
            tfData.LastSwingInternal = 1;
            tfData.waitingIntSHighs = 1;
                        
            textInternalHigh += "\n---> I3 CHoCH High => iTrend = -1 && LastSwingInternal = 1 && bar1.high > intSHighs[0] => iTrend = 1, LastSwingInternal = 1, waitingIntSHighs = 1";
                        
            if (tfData.iFindTarget != 1) {
               tfData.iFindTarget = 1;
               tfData.iStoploss = tfData.intSLows[0];
               tfData.iStoplossTime = tfData.intSLowTime[0];
               tfData.iOrderBlock = tfData.zIntSLows[0].high;
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
            tfData.isDrawTarget_internal = tfData.iTrend;
            tfData.line_high_internal = tfData.intSHighs[0];
            tfData.line_low_internal = tfData.intSLows[0];
            tfData.barBreak_internal = bar1;
            // Set news value target zone
            //beginSetValueToPoiZone(tfData, tfData.zIntSLows[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setValueRealtimeByHighTF(tfData);
            // Them moi poizone Internal Bullish
            internal_name = INTERNAL_TEXT+"_"+BULL_TEXT+"_"+TimeToString(tfData.zIntSLows[0].time);
            tfData.AddToPoiZoneArray(tfData.zArrIntBullish, tfData.zIntSLows[0], poi_limit);
            // Ve poizone Internal Bullish trên chart
            if(tfData.isDraw) {
               DrawBox(0, internal_name, 0, tfData.zArrIntBullish[0].time, tfData.zArrIntBullish[0].high, bar1.time, tfData.zArrIntBullish[0].low, iColorBull, STYLE_SOLID,1, true, false, false, true, 0);
            } 
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) {
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               
               // Reset PoiZone Trade Zone belong to Internal structure
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBullishHTF);
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
            }
         }
         
         // 4 choch high
         if (tfData.iTrend == -1 && tfData.LastSwingInternal == -1 && 
                  ArraySize(tfData.intSHighs) > 1 && bar1.high > tfData.intSHighs[0] && bar1.high > tfData.intSHighs[1]) {
            tfData.iTrend = 1;
            tfData.vItrend = tfData.iTrend;
            tfData.wvItrend = 0;
            tfData.wvIsBuyInternal = false;
            tfData.wvIsSellInternal = false;
            tfData.LastSwingInternal = 1;
            tfData.waitingIntSHighs = 1;
                        
            textInternalHigh += "\n---> I45 CHoCH High => iTrend = -1 && LastSwingInternal = -1 && bar1.high > intSHighs[0], intSHighs[1]  => iTrend = 1, LastSwingInternal = 1, waitingIntSHighs = 1";
                                    
            if (tfData.intSHighs[0] < tfData.intSHighs[1]) {
               // Clear Draw intSHigh[0]
               deleteObj(tfData.intSHighTime[0], tfData.intSHighs[0], iWingding_internal_high, "");
               // Sort intSHighs. 
               tfData.SortDoubleArrayAfterDelete(tfData.intSHighs);
               tfData.SortDateTimeArrayAfterDelete(tfData.intSHighTime);
               tfData.SortLongArrayAfterDelete(tfData.volIntSHighs);
               tfData.SortLongArrayAfterDelete(tfData.wvolIntSHighs);
               tfData.SortDateTimeArrayAfterDelete(tfData.wvolIntSHighTime);
               tfData.SortPoiZoneArrayAfterDelete(tfData.zIntSHighs);
            } else if (tfData.intSHighs[0] > tfData.intSHighs[1]) {
               tfData.AddToDoubleArray(tfData.intSLows, bar1.low);
               tfData.AddToDateTimeArray(tfData.intSLowTime, bar1.time);
               tfData.AddToLongArray(tfData.volIntSLows, bar1.tick_volume);
                              
               wVol = GetCumulativeVolume(bar1.time, tfData.intSHighTime[0], tfData.timeFrame, "I45 CHoCH High");
               tfData.AddToLongArray(tfData.wvolIntSLows, wVol, limit);
               tfData.AddToDateTimeArray(tfData.wvolIntSLowTime, bar1.time);
               // set Zone bullish từ bar1
               int indexAnchor = iBarShift(_Symbol, tfData.timeFrame, bar1.time);
               PoiZone mZone = createpoizone_optimized(tfData.timeFrame, indexAnchor, 1);
               PoiZone zone1 = CreatePoiZone( tfData, mZone.high, mZone.low, bar2.open, bar2.close, bar2.time, clr_internal_bullish);
               // PoiZone zone1 = CreatePoiZone( tfData, bar1.high, bar1.low, bar1.open, bar1.close, bar1.time);
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
               tfData.iOrderBlock = tfData.zIntSLows[0].high;
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
            tfData.isDrawTarget_internal = tfData.iTrend;
            tfData.line_high_internal = tfData.intSHighs[0];
            tfData.line_low_internal = tfData.intSLows[0];
            tfData.barBreak_internal = bar1;
            // Set news value target zone
            //beginSetValueToPoiZone(tfData, tfData.zIntSLows[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setValueRealtimeByHighTF(tfData);
            // Them moi poizone Internal Bullish
            internal_name = INTERNAL_TEXT+"_"+BULL_TEXT+"_"+TimeToString(tfData.zIntSLows[0].time);
            tfData.AddToPoiZoneArray(tfData.zArrIntBullish, tfData.zIntSLows[0], poi_limit);
            // Ve poizone Internal Bullish trên chart
            if(tfData.isDraw) {
               DrawBox(0, internal_name, 0, tfData.zArrIntBullish[0].time, tfData.zArrIntBullish[0].high, bar1.time, tfData.zArrIntBullish[0].low, iColorBull, STYLE_SOLID,1, true, false, false, true, 0);
            } 
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) {
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               // Reset PoiZone Trade Zone belong to Internal structure
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBullishHTF);
               
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
            }
         }
         // show draw target line
         if ((showTargetHighTF == true && tfData.isTimeframe == highPairTF) || (showTargetLowTF == true && tfData.isTimeframe == lowPairTF)) {
            if (isDrawInternal == true && isDrawTarget == true) {
               isDrawTarget = false;
               //// ve line
               //DrawDirectionalSegment(line_target, place_start_line_draw, bar1.time, line_dinh, line_day, tfData.tfColor, 1, 4);
            }
         }
         
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
            tfData.wvItrend = 0;
            tfData.wvIsBuyInternal = false;
            tfData.wvIsSellInternal = false;
            tfData.LastSwingInternal = -1;
            tfData.waitingIntSLows = 1;
            
            textInternalLow += "\n---> -I1 Bos Low => iTrend = -1 && LastSwingInternal = -1 && bar1.low < intSLows[0]  => iTrend = -1, LastSwingInternal = -1, waitingIntSLows = 1";
                        
            if (tfData.iFindTarget != -1) {
               tfData.iFindTarget = -1;
               tfData.iStoploss = tfData.intSHighs[0];
               tfData.iStoplossTime = tfData.intSHighTime[0];
               tfData.iOrderBlock = tfData.zIntSHighs[0].low;
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
            tfData.isDrawTarget_internal = tfData.iTrend;
            tfData.line_high_internal = tfData.intSHighs[0];
            tfData.line_low_internal = tfData.intSLows[0];
            tfData.barBreak_internal = bar1;
            // Set news value target zone
            //beginSetValueToPoiZone(tfData, tfData.zIntSHighs[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setValueRealtimeByHighTF(tfData);
            // Them moi poizone Internal Bearish
            internal_name = INTERNAL_TEXT+"_"+BEAR_TEXT+"_"+TimeToString(tfData.zIntSHighs[0].time);
            tfData.AddToPoiZoneArray(tfData.zArrIntBearish, tfData.zIntSHighs[0], poi_limit);
            // Ve poizone Internal Bearish trên chart
            if(tfData.isDraw) {
               DrawBox(0, internal_name, 0, tfData.zArrIntBearish[0].time, tfData.zArrIntBearish[0].low, bar1.time, tfData.zArrIntBearish[0].high, iColorBull, STYLE_SOLID,1, true, false, false, true, 0);
            }
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) {
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               // Reset PoiZone Trade Zone belong to Internal structure
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBullishHTF);
               
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
            }
         }
         
         //3 choch low
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == -1 && bar1.low < tfData.intSLows[0]) {
            tfData.iTrend = -1;
            tfData.vItrend = tfData.iTrend;
            tfData.wvItrend = 0;
            tfData.wvIsBuyInternal = false;
            tfData.wvIsSellInternal = false;
            tfData.LastSwingInternal = -1;
            tfData.waitingIntSLows = 1;
                        
            textInternalLow += "\n---> -I3 CHoCH Low => iTrend = 1 && LastSwingInternal = -1 && bar1.low < intSLows[0]  => iTrend = -1, LastSwingInternal = -1, waitingIntSLows = 1";
            
            if (tfData.iFindTarget != -1) {
               tfData.iFindTarget = -1;
               tfData.iStoploss = tfData.intSHighs[0];
               tfData.iStoplossTime = tfData.intSHighTime[0];
               tfData.iOrderBlock = tfData.zIntSHighs[0].low;
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
            tfData.isDrawTarget_internal = tfData.iTrend;
            tfData.line_high_internal = tfData.intSHighs[0];
            tfData.line_low_internal = tfData.intSLows[0];
            tfData.barBreak_internal = bar1;
            // Set news value target zone
            //beginSetValueToPoiZone(tfData, tfData.zIntSHighs[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setValueRealtimeByHighTF(tfData);
            // Them moi poizone Internal Bearish
            internal_name = INTERNAL_TEXT+"_"+BEAR_TEXT+"_"+TimeToString(tfData.zIntSHighs[0].time);
            tfData.AddToPoiZoneArray(tfData.zArrIntBearish, tfData.zIntSHighs[0], poi_limit);
            // Ve poizone Internal Bearish trên chart
            if(tfData.isDraw) {
               DrawBox(0, internal_name, 0, tfData.zArrIntBearish[0].time, tfData.zArrIntBearish[0].low, bar1.time, tfData.zArrIntBearish[0].high, iColorBull, STYLE_SOLID,1, true, false, false, true, 0);
            }
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) {
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               
               // Reset PoiZone Trade Zone belong to Internal structure
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBullishHTF);
               
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
            }
         }
         
         // 4+5 choch low
         if (tfData.iTrend == 1 && tfData.LastSwingInternal == 1 && 
                ArraySize(tfData.intSLows) > 1 && bar1.low < tfData.intSLows[0] && bar1.low < tfData.intSLows[1]) {
            tfData.iTrend = -1;
            tfData.vItrend = tfData.iTrend;
            tfData.wvItrend = 0;
            tfData.wvIsBuyInternal = false;
            tfData.wvIsSellInternal = false;
            tfData.LastSwingInternal = -1;
            tfData.waitingIntSLows = 1;
                        
            textInternalLow += "\n---> -I45 CHoCH Low => iTrend = 1 && LastSwingInternal = 1 && bar1.low < intSLows[0], intSLows[1]  => iTrend = -1, LastSwingInternal = -1, waitingIntSLows = 1";

            if (tfData.intSLows[0] > tfData.intSLows[1]) {
               // Clear Draw intSHigh[0]
               deleteObj(tfData.intSLowTime[0], tfData.intSLows[0], iWingding_internal_low, "");
               // Sort intSLows
               tfData.SortDoubleArrayAfterDelete(tfData.intSLows);
               tfData.SortDateTimeArrayAfterDelete(tfData.intSLowTime);
               tfData.SortLongArrayAfterDelete(tfData.volIntSLows);
               tfData.SortLongArrayAfterDelete(tfData.wvolIntSLows);
               tfData.SortDateTimeArrayAfterDelete(tfData.wvolIntSLowTime);
               tfData.SortPoiZoneArrayAfterDelete(tfData.zIntSLows);
            } else if (tfData.intSHighs[0] > tfData.intSHighs[1]) {
               tfData.AddToDoubleArray(tfData.intSHighs, bar1.high);
               tfData.AddToDateTimeArray(tfData.intSHighTime, bar1.time);
               tfData.AddToLongArray(tfData.volIntSHighs, bar1.tick_volume);
               
               wVol = GetCumulativeVolume(bar1.time, tfData.intSLowTime[0], tfData.timeFrame, "I45 CHoCH Low");
               tfData.AddToLongArray(tfData.wvolIntSHighs, wVol, limit);
               tfData.AddToDateTimeArray(tfData.wvolIntSHighTime, bar1.time);
               // set Zone bearish từ bar1
               PoiZone mZone = createpoizone_optimized(_Period, 1, -1);
               PoiZone zone1 = CreatePoiZone( tfData, mZone.high, mZone.low, bar2.open, bar2.close, bar2.time, clr_internal_bearish);
               // // set Zone
               // PoiZone zone1 = CreatePoiZone( tfData,bar1.high, bar1.low, bar1.open, bar1.close, bar1.time);
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
               tfData.iOrderBlock = tfData.zIntSHighs[0].low;
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
            tfData.isDrawTarget_internal = tfData.iTrend;
            tfData.line_high_internal = tfData.intSHighs[0];
            tfData.line_low_internal = tfData.intSLows[0];
            tfData.barBreak_internal = bar1;
            // Set news value target zone
            //beginSetValueToPoiZone(tfData, tfData.zIntSHighs[0], "InternalZone");
            // Thêm mới thông số Global Target 
            setValueRealtimeByHighTF(tfData);
            // Them moi poizone Internal Bearish
            internal_name = INTERNAL_TEXT+"_"+BEAR_TEXT+"_"+TimeToString(tfData.zIntSHighs[0].time);
            tfData.AddToPoiZoneArray(tfData.zArrIntBearish, tfData.zIntSHighs[0], poi_limit);
            // Ve poizone Internal Bearish trên chart
            if(tfData.isDraw) {
               DrawBox(0, internal_name, 0, tfData.zArrIntBearish[0].time, tfData.zArrIntBearish[0].low, bar1.time, tfData.zArrIntBearish[0].high, iColorBull, STYLE_SOLID,1, true, false, false, true, 0);
            }
            // Kích hoạt scan Global Poi zone
            if(tfData.isHighTF) {
               myEAs.statusInternalHTL.sHL_IntScanActive = true;
               // Reset PoiZone Trade Zone belong to Internal structure
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneInternalBullishHTF);
               
               // Scan lại các zone Internal Trade Zone HighTF
               scanInternalTradeZoneHighTF(tfData, bar1);
            }
         }
         // Show draw target line
         if ((showTargetHighTF == true && tfData.isTimeframe == highPairTF) || (showTargetLowTF == true && tfData.isTimeframe == lowPairTF)) {
            if (isDrawInternal == true && isDrawTarget == true) {
               isDrawTarget = false;
               //// ve line
               //DrawDirectionalSegment(line_target, place_start_line_draw, bar1.time, line_dinh, line_day, tfData.tfColor, 1, 4);
            }
         }
         
         if (StringLen(textInternalLow) > 0) {
            text_all += str_internal+" (Break) "+textInternalLow;
         }
      }
      
      // Show draw target line by wave volume
      if ((showTargetHighTF == true && tfData.isTimeframe == highPairTF) || (showTargetLowTF == true && tfData.isTimeframe == lowPairTF)) {
         if (isDrawInternal == true && tfData.line_direction_internal != 0) {
            double line_start = 0;
            double line_end = 0;
            // ve line
            if (tfData.iTrend == 1) {
               // breakout success
               if (tfData.line_direction_internal == tfData.iTrend) {
                  tfData.place_start_line_draw_internal = tfData.barBreak_internal.high;
                  line_start = tfData.line_low_internal;
                  line_end = tfData.line_high_internal;
               // false breakout
               } else {
                  tfData.place_start_line_draw_internal = tfData.line_low_internal;
                  line_start = tfData.line_high_internal;
                  line_end = tfData.line_low_internal;
               }
               
            } else {
               // breakout success
               if (tfData.line_direction_internal == tfData.iTrend) {
                  tfData.place_start_line_draw_internal = tfData.barBreak_internal.low;
                  line_start = tfData.line_high_internal;
                  line_end = tfData.line_low_internal;
                  
               // false breakout
               } else {
                  tfData.place_start_line_draw_internal = tfData.line_high_internal;
                  line_start = tfData.line_low_internal;
                  line_end = tfData.line_high_internal;
                  
               }
            }
            // ve line
            DrawDirectionalSegment(tfData.line_direction_internal, tfData.place_start_line_draw_internal, tfData.barBreak_internal.time, line_start, line_end, tfData.tfColor, 1, 4);
            tfData.resetDrawBarSettings(tfData, INTERNAL_STRUCTURE);
         }
      }
      
      // Set Global Value of High Timeframe
      if (tfData.isHighTF) {
         myEAs.signalInternal.sg_iTrend = tfData.iTrend;
         myEAs.signalInternal.sg_vITrend = tfData.vItrend;
         myEAs.signalInternal.sg_wvITrend = tfData.wvItrend;
         // Tra ve trang thai cua status global Internal breakout
         myEAs.signalInternal.sg_wvIsBuyInternal = getStatusInternalBuySell(tfData, 1); 
         myEAs.signalInternal.sg_wvIsSellInternal = getStatusInternalBuySell(tfData, -1);
         //Print("== SET thong so Status Global Signal Thanh cong==");
      } else { // Set thong so co ban cho Low Timeframe
         if (myEAs.marketStructStatus.iMSS_findH == 1) {
            if (myEAs.marketStructStatus.iMSS_H_AF_LTFRealTime <= 0 || (myEAs.marketStructStatus.iMSS_H_AF_LTFRealTime > 0 && myEAs.marketStructStatus.iMSS_H_AF_LTFRealTime < tfData.intSHighs[0])) {
               myEAs.marketStructStatus.iMSS_H_AF_LTFRealTime = tfData.intSHighs[0];
            }
         } else if (myEAs.marketStructStatus.iMSS_findL == 1) {
            if (myEAs.marketStructStatus.iMSS_L_AF_LTFRealTime <= 0 || (myEAs.marketStructStatus.iMSS_L_AF_LTFRealTime > 0 && myEAs.marketStructStatus.iMSS_L_AF_LTFRealTime > tfData.intSLows[0])) {
               myEAs.marketStructStatus.iMSS_L_AF_LTFRealTime = tfData.intSLows[0];
            }
         }
      }
      
      if(StringLen(text_all) > 0) {
         // For Deverlop
         showComment(tfData);
      }
      
      if (isComment == false) {
         text_all = "";
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
      PoiZone zone_tmp;
      // dinh nghia lai mau cua poi zone
      color clr_marjor_bullish;
      color clr_marjor_bearish;
      if (tfData.isHighTF) {
         clr_marjor_bearish = color_HTF_Decisional_Bearish_Zone;
         clr_marjor_bullish = color_HTF_Decisional_Bullish_Zone;
      } else {
         clr_marjor_bearish = color_LTF_Decisional_Bearish_Zone;
         clr_marjor_bullish = color_LTF_Decisional_Bullish_Zone;
      }
      // Gọi hàm với nến số 2 làm điểm neo
      int indexAnchor = iBarShift(_Symbol, tfData.timeFrame, bar2.time);
      PoiZone mZone_bearish = createpoizone_optimized(tfData.timeFrame, indexAnchor, -1);
      PoiZone zone_bearish = CreatePoiZone( tfData, mZone_bearish.high, mZone_bearish.low, bar2.open, bar2.close, bar2.time, clr_marjor_bearish);

      PoiZone mZone_bullish = createpoizone_optimized(tfData.timeFrame, indexAnchor, 1);
      PoiZone zone_bullish = CreatePoiZone( tfData, mZone_bullish.high, mZone_bullish.low, bar2.open, bar2.close, bar2.time, clr_marjor_bullish);

      long maxVolume = 0;
      
      double barHigh = bar1.high;
      double barLow  = bar1.low;
      datetime barTime = bar1.time;
      
      long wVol = 0;
      // dinh nghia lai ten cua marjor swing
      string marjor_name = "";
      // Lan dau tien
      if(tfData.sTrend == 0 && tfData.mTrend == 0 && tfData.LastSwingMajor == 0) { //ok
         if (barLow < tfData.arrBot[0]){
            text += "\n-0.1. barLow < arrBot[0]"+" => "+DoubleToString( barLow, _Digits)+" < "+DoubleToString( tfData.arrBot[0], _Digits);
            text += " => Cap nhat idmLow = Highs[0] = "+DoubleToString( tfData.Highs[0], _Digits)+"; sTrend = -1; mTrend = -1; LastSwingMajor = 1;";
            
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            //tfData.vol_L_idmLow = tfData.vol_idmLow;
            
            tfData.idmLow = tfData.Highs[0];
            tfData.idmLowTime = tfData.HighsTime[0];
            tfData.vol_idmLow = tfData.volHighs[0];
            
            tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = 1;
                        
         } else if (barHigh > tfData.arrTop[0]) { 
            text += "\n0.1. barHigh > arrTop[0]"+" => "+DoubleToString(barHigh,_Digits)+" > "+DoubleToString(tfData.arrTop[0], _Digits);
            text += " => Cap nhat idmHigh = Lows[0] = "+DoubleToString(tfData.Lows[0], _Digits)+"; sTrend = 1; mTrend = 1; LastSwingMajor = -1;";
            
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.vol_idmHigh = tfData.volLows[0];
            tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = -1;
         }
         
         if (tfData.isHighTF) {
            myEAs.signalInternal.sg_getIdmSell = false;
            myEAs.signalInternal.sg_getIdmBuy = false;
            // // Reset PoiZone Trade Zone belong to Marjor structure
            resetTradeZoneHTF(tfData, zGTradeZoneBearishHTF);
            resetTradeZoneHTF(tfData, zGTradeZoneBullishHTF);
            // Scan lại zone mới để thêm vào Trade Zone
            scanMarjorTradeZoneHighTF(tfData, bar1);
            
         }
      }
      // End Lan dau tien
      
      if (bar3.high <= bar2.high && bar2.high >= bar1.high) { // tim thay dinh high
         
         if (tfData.findHigh == 1 && bar2.high > tfData.H) {
            text += "\n0.2. Find Swing High";
            text += " => findhigh == 1 , H new > H old "+DoubleToString(bar2.high, _Digits)+" > "+DoubleToString( tfData.H, _Digits)+". Update new High = "+DoubleToString(bar2.high, _Digits);
            
            tfData.H = bar2.high;
            tfData.HTime = bar2.time;
            tfData.H_bar = bar2;
            tfData.vol_H = bar2.tick_volume;
         }
      }
      if (bar3.low >= bar2.low && bar2.low <= bar1.low) { // tim thay swing low 
         
         if (tfData.findLow == 1 && bar2.low < tfData.L) {
            text += "\n-0.2. Find Swing Low";
            text += " => findlow == 1 , L new < L old "+DoubleToString(bar2.low, _Digits)+" < "+DoubleToString( tfData.L, _Digits)+". Update new Low = "+DoubleToString(bar2.low, _Digits);
            
            tfData.L = bar2.low;
            tfData.LTime = bar2.time;
            tfData.L_bar = bar2;
            tfData.vol_L = bar2.tick_volume;
         }
      }
      
      if(tfData.sTrend == 1 && tfData.mTrend == 1) {
         // continue BOS 
         if (tfData.LastSwingMajor == -1 && bar1.high > tfData.arrTop[0] && tfData.arrTop[0] != tfData.arrBoHigh[0]) { // Done
            text += "\n1.1. continue BOS, sTrend == 1 && mTrend == 1 && LastSwingMajor == -1 && bar1.high ("+DoubleToString( bar1.high,_Digits) +") > arrTop[0] ("+DoubleToString(tfData.arrTop[0], _Digits)+")";
            text += "\n => Cap nhat: findLow = 0, idmHigh = Lows[0] = "+DoubleToString(tfData.Lows[0], _Digits)+" ; sTrend == 1; mTrend == 1; LastSwingMajor == 1;";
            text += " => New arrBoHigh = arrTop[0] = " + DoubleToString(tfData.arrTop[0],_Digits) + "; New arrBot = intSLows[0] = " + DoubleToString( tfData.intSLows[0],_Digits);
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
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmSell = false;
               myEAs.signalInternal.sg_getIdmBuy = false;
               // Scan lại zone mới để thêm vào Trade Zone
               scanMarjorTradeZoneHighTF(tfData, bar1);
            }
         }
         
         if (bar3.high <= bar2.high && bar2.high >= bar1.high) { // tim thay dinh high 
            if (typeTickVolume == 1) {
               maxVolume = bar2.tick_volume;
            } else {
               maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
            }
            // continue BOS swing high
            if (tfData.LastSwingMajor == 1 && bar2.high > tfData.arrTop[0]) {
               text += "\n1.2. swing high, sTrend == 1 && mTrend == 1 && LastSwingMajor == 1 && bar2.high ("+DoubleToString(bar2.high, _Digits)+") > arrTop[0] ("+DoubleToString(tfData.arrTop[0], _Digits)+")";
               text += "\n=> Cap nhat: arrTop[0] = bar2.high = "+DoubleToString(bar2.high, _Digits)+" ; sTrend == 1; mTrend == 1; LastSwingMajor == -1;";
               // Update Array Top[0]
               if(tfData.arrTop[0] != bar2.high) {
                  // Add new 
                  tfData.AddToDoubleArray( tfData.arrTop, bar2.high);
                  tfData.AddToDateTimeArray( tfData.arrTopTime, bar2.time);
                  tfData.AddToLongArray(tfData.volArrTop, maxVolume);
                  
                  // add new Zone Bearish
                  tfData.AddToPoiZoneArray( tfData.zArrTop, zone_bearish, limit);
                  // cap nhat waiting top
                  tfData.waitingArrTop = 0;
               } 
               
               tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = -1;
            }
            // HH > HH 
            if (tfData.LastSwingMajor == -1 && bar2.high > tfData.arrTop[0]) {
               text += "\n1.3. sTrend == 1 && mTrend == 1 && LastSwingMajor == -1 && bar2.high > arrTop[0]";
               text += "\n=> Xoa label, Cap nhat: arrTop[0] = bar2.high = "+DoubleToString(bar2.high, _Digits)+" ; sTrend == 1; mTrend == 1; LastSwingMajor == -1;";
               
               // Update Array Top[0] , conditions : L new != L old
               if(tfData.arrTop[0] != bar2.high) {
                  // update point
                  tfData.UpdateDoubleArray(tfData.arrTop, 0, bar2.high);
                  tfData.UpdateDateTimeArray(tfData.arrTopTime, 0, bar2.time);
                  tfData.UpdateLongArray(tfData.volArrTop, 0, maxVolume);
                  // cap nhat Zone bearish
                  tfData.UpdatePoiZoneArray( tfData.zArrTop, 0, zone_bearish);
                  // cap nhat waiting top
                  tfData.waitingArrTop = 0;
               }
               tfData.sTrend = 1; tfData.mTrend = 1; tfData.LastSwingMajor = -1;
            }
         }
         
         //Cross IDM
         if (  
            //tfData.LastSwingMajor == 1 && 
            tfData.findLow == 0 && bar1.low < tfData.idmHigh) {
            text += "\n1.4. Cross IDM Uptrend.  sTrend == 1 && mTrend == 1 && LastSwingMajor == random && bar1.low < idmHigh : " + DoubleToString(bar1.low, _Digits) + "<" + DoubleToString(tfData.idmHigh, _Digits);
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
               
               wVol = GetCumulativeVolume(tfData.arrPbHTime[0], tfData.wvolArrPbLowTime[0], tfData.timeFrame, "Marjor New High");
               tfData.AddToLongArray( tfData.wvolArrPbHigh, wVol);
               tfData.AddToDateTimeArray( tfData.wvolArrPbHighTime, tfData.arrPbHTime[0]);

               // Setup wave volume
               if (tfData.wvMtrend == 0 && tfData.wvolArrPbHighTime[0] > tfData.wvolArrPbLowTime[0]) {
                  tfData.wvMtrend = (tfData.wvolArrPbHigh[0] > tfData.wvolArrPbLow[0]) ? 1 : -1;
                  // Trả về trạng thái chấp nhận Buy or Sell của Marjor sau cú Break khi xác nhận được swing đầu tiên bởi cú quét IDM 
                  tfData.wvIsBuyMarjor = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Marjor", 1);
                  tfData.wvIsSellMarjor = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Marjor", -1);
               }
            
               // add new zone
               marjor_name = MARJOR_TEXT+"_"+BEAR_TEXT+"_"+TimeToString(tfData.zArrTop[0].time);
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, tfData.zArrTop[0], limit, marjor_name); 
               // cap nhat waiting pb high
               tfData.waitingArrPbHigh = 0;
            }
            text += "\n Cap nhat: New arrPbHigh = arrTop[0] = "+ DoubleToString(tfData.arrTop[0], _Digits);
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(IDM_TEXT, tfData.idmHighTime, tfData.idmHigh, bar1.time, tfData.idmHigh, 1, IDM_TEXT, tfData.tfColor, STYLE_DOT);
            text += "\n => Cap nhat findLow = 1; L = bar1.low = "+ DoubleToString(bar1.low, _Digits);
            
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
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmBuy = true;
            }
            
            // Quét toàn bộ các vùng POI để Trade theo Order Block, Order Flow
            //tfData.scanPoiZoneLastTime(tfData, 1);
            // drawMarjorTradeZone(tfData, bar1);
         }
         
         // CHoCH Low
         if (
            //tfData.LastSwingMajor == 1 && 
            bar1.low < tfData.arrPbLow[0] && tfData.arrPbLow[0] != tfData.arrChoLow[0]) {
            text += "\n1.5 sTrend == 1 && mTrend == 1 && LastSwingMajor == random && bar1.low ("+DoubleToString( bar1.low, _Digits) + ") < arrPbLow[0] ("+ DoubleToString(tfData.arrPbLow[0], _Digits)+")";
            text += "\n => Cap nhat => Ve line. sTrend = -1; mTrend = -1; LastSwingMajor = -1; findHigh = 0; idmLow = Highs[0]= "+ DoubleToString( tfData.Highs[0], _Digits);
            text += "\n => Cap nhat => New arrChoLow: = arrPbLow[0] = "+ DoubleToString(tfData.arrPbLow[0], _Digits);
            
            // draw choch Low
            drawLine(CHOCH_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], barTime, tfData.arrPbLow[0], 1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);

            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            tfData.AddToLongArray( tfData.volArrChoLow, tfData.volArrPbLow[0]);
         
            //text += "\n => Cap nhat => POI Bearish : arrPbHigh[0] "+ DoubleToString(tfData.arrPbHigh[0], _Digits);
            
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
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmSell = false;
               myEAs.signalInternal.sg_getIdmBuy = false;
               // // Reset PoiZone Trade Zone belong to Marjor structure
               resetTradeZoneHTF(tfData, zGTradeZoneBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneBullishHTF);
               // Scan lại zone mới để thêm vào Trade Zone
               scanMarjorTradeZoneHighTF(tfData, bar1);
               
               
            }
            
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
                     DoubleToString(tfData.arrPbHigh[0], _Digits) + " != arrChoHigh[0]: "+DoubleToString( tfData.arrChoHigh[0], _Digits);
            text += "---> Update: arrChoHigh[0] = "+ DoubleToString(tfData.arrPbHigh[0], _Digits);
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoHigh, tfData.arrPbHigh[0]);
            tfData.AddToDateTimeArray( tfData.arrChoHighTime, tfData.arrPbHTime[0]);
            tfData.AddToLongArray( tfData.volArrChoHigh, tfData.volArrPbHigh[0]);
            
            // update Point HL
            if (tfData.L != 0 && (tfData.L != tfData.arrPbLow[0] || (tfData.L == tfData.arrPbLow[0] && tfData.LTime != tfData.arrPbLTime[0]))) {
               text += "\n----> IF: L != 0 && L != arrPbLow[0]("+DoubleToString(tfData.arrPbLow[0], _Digits)+") => Update: New arrPbLow[0] = "+DoubleToString( tfData.L, _Digits);
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbLow, tfData.L);
               tfData.AddToDateTimeArray( tfData.arrPbLTime, tfData.LTime);
               tfData.AddToLongArray( tfData.volArrPbLow, tfData.vol_L);
               
               wVol = GetCumulativeVolume(tfData.arrPbLTime[0], tfData.wvolArrPbHighTime[0], tfData.timeFrame, "Marjor BOS High");
               tfData.AddToLongArray( tfData.wvolArrPbLow, wVol);
               tfData.AddToDateTimeArray( tfData.wvolArrPbLowTime, tfData.arrPbLTime[0]);
               
               // Setup wave volume
               if (tfData.wvMtrend != 0 && tfData.wvolArrPbHighTime[0] < tfData.wvolArrPbLowTime[0]) {
                  tfData.wvMtrend = 0;
                  tfData.wvIsBuyMarjor = false;
                  tfData.wvIsSellMarjor = false;
               }

               // Add New Zone Bullish
               // 2. Tìm "điểm neo" (index) dựa trên thời gian của nến đó
               // iBarShift trả về chỉ số của nến tại một thời điểm nhất định
               int indexAnchor = iBarShift(_Symbol, tfData.timeFrame, tfData.L_bar.time);
               if (indexAnchor != -1) {
                  PoiZone barZone = createpoizone_optimized(tfData.timeFrame, indexAnchor, 1);
                  zone_tmp = CreatePoiZone( tfData,barZone.high, barZone.low, tfData.L_bar.open, tfData.L_bar.close, tfData.L_bar.time, clr_marjor_bullish);
               } else {
                  MqlRates bar_tmp = tfData.L_bar;
                  zone_tmp = CreatePoiZone( tfData,bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time, clr_marjor_bullish);
               }
               marjor_name = MARJOR_TEXT+"_"+BULL_TEXT+"_"+TimeToString(zone_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, zone_tmp, limit, marjor_name);
               // update waiting arr pblow
               tfData.waitingArrPbLows = 0;
            }
            
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(BOS_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, BOS_TEXT, tfData.tfColor, STYLE_SOLID);
            
            text += "\n--> Cap nhat POI Bullish: L_idmHigh = idmHigh = "+DoubleToString(tfData.idmHigh, _Digits);
                     
            tfData.L_idmHigh = tfData.idmHigh;
            tfData.L_idmHighTime = tfData.idmHighTime;
            
            tfData.findLow = 0; 
            tfData.idmHigh = tfData.Lows[0]; tfData.idmHighTime = tfData.LowsTime[0]; tfData.vol_idmHigh = tfData.volLows[0]; 
            tfData.L = 0; tfData.vol_L = 0;
            text += ", findLow = 0, idmHigh = "+DoubleToString(tfData.Lows[0], _Digits)+", L = 0";
            
            if (tfData.mFindTarget != 1) {
               tfData.mFindTarget = 1;
               tfData.mStoploss = tfData.arrPbLow[0];
               tfData.mStoplossTime = tfData.arrPbLTime[0];
               tfData.mTarget = 0;
               tfData.mTargetTime = 0;
               tfData.mSnR = tfData.arrPbHigh[0];
               text += " | Continue BOS High M1.6";
            }
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmSell = false;
               myEAs.signalInternal.sg_getIdmBuy = false;
               // // Reset PoiZone Trade Zone belong to Marjor structure
               resetTradeZoneHTF(tfData, zGTradeZoneBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneBullishHTF);
               // Scan lại zone mới để thêm vào Trade Zone
               scanMarjorTradeZoneHighTF(tfData, bar1);
               
            }
            
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
                           
               wVol = GetCumulativeVolume(tfData.arrPbLTime[0], tfData.wvolArrPbHighTime[0], tfData.timeFrame, "Marjor CHoCH High");
               tfData.AddToLongArray( tfData.wvolArrPbLow, wVol);
               tfData.AddToDateTimeArray( tfData.wvolArrPbLowTime, tfData.arrPbLTime[0]);
               
               // Setup wave volume
               if (tfData.wvMtrend != 0 && tfData.wvolArrPbHighTime[0] < tfData.wvolArrPbLowTime[0]) {
                  tfData.wvMtrend = 0;
                  tfData.wvIsBuyMarjor = false;
                  tfData.wvIsSellMarjor = false;
               }

               // Add New Zone Bullish
               // 2. Tìm "điểm neo" (index) dựa trên thời gian của nến đó
               // iBarShift trả về chỉ số của nến tại một thời điểm nhất định
               int indexAnchor = iBarShift(_Symbol, tfData.timeFrame, tfData.L_bar.time);
               if (indexAnchor != -1) {
                  PoiZone barZone = createpoizone_optimized(tfData.timeFrame, indexAnchor, 1);
                  zone_tmp = CreatePoiZone( tfData,barZone.high, barZone.low, tfData.L_bar.open, tfData.L_bar.close, tfData.L_bar.time, clr_marjor_bullish);
               } else {
                  MqlRates bar_tmp = tfData.L_bar;
                  zone_tmp = CreatePoiZone( tfData,bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time, clr_marjor_bullish);
               }
               marjor_name = MARJOR_TEXT+"_"+BULL_TEXT+"_"+TimeToString(zone_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, zone_tmp, limit, marjor_name);
               // update waiting pb low
               tfData.waitingArrPbLows = 0;
            }
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(CHOCH_TEXT, tfData.arrPbHTime[0], tfData.arrPbHigh[0], bar1.time, tfData.arrPbHigh[0], -1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);
            text += "\n => Cap nhat => POI Bullish : L = "+ DoubleToString( tfData.L, _Digits);
            
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
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmSell = false;
               myEAs.signalInternal.sg_getIdmBuy = false;
               // // Reset PoiZone Trade Zone belong to Marjor structure
               resetTradeZoneHTF(tfData, zGTradeZoneBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneBullishHTF);
               // Scan lại zone mới để thêm vào Trade Zone
               scanMarjorTradeZoneHighTF(tfData, bar1);
               
            }
            
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
            text += "\n2.2 sTrend == 1 && mTrend == -1 && LastSwingMajor == -1 && bar1.low < arrPbLow[0] : " + DoubleToString(bar1.low, _Digits) + "<" + DoubleToString(tfData.arrPbLow[0], _Digits);
            text += "\n => Cap nhat => sTrend = -1; mTrend = -1; LastSwingMajor = -1; findHigh = 0; idmLow = Highs[0] = "+DoubleToString(tfData.Highs[0], _Digits);
            text += "\n => Cap nhat => POI Bearish = arrPbHigh[0] : "+ DoubleToString(tfData.arrPbHigh[0], _Digits);
            
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
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmSell = false;
               myEAs.signalInternal.sg_getIdmBuy = false;
               // // Reset PoiZone Trade Zone belong to Marjor structure
               resetTradeZoneHTF(tfData, zGTradeZoneBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneBullishHTF);
               // Scan lại zone mới để thêm vào Trade Zone
               scanMarjorTradeZoneHighTF(tfData, bar1);
               
            }
            
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
            text += "\n-3.1. continue BOS, sTrend == -1 && mTrend == -1 && LastSwingMajor == 1 && bar1.low ("+ DoubleToString(bar1.low, _Digits) +") < arrBot[0] ("+DoubleToString( tfData.arrBot[0], _Digits)+")";
            text += "\n => Cap nhat: findHigh = 0, idmLow = Highs[0] = "+DoubleToString( tfData.Highs[0], _Digits)+" ; sTrend == -1; mTrend == -1; LastSwingMajor == -1;";
            text += " => New arrBoLow = arrBot[0] = " + DoubleToString(tfData.arrBot[0],_Digits) + "; New arrTop = intSHighs[0] = " + DoubleToString(tfData.intSHighs[0],_Digits);               
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
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmSell = false;
               myEAs.signalInternal.sg_getIdmBuy = false;
               // Scan lại zone mới để thêm vào Trade Zone
               scanMarjorTradeZoneHighTF(tfData, bar1);
               // // Reset PoiZone Trade Zone belong to Marjor structure
               //resetTradeZoneHTF(tfData, zGTradeZoneBearishHTF);
               //resetTradeZoneHTF(tfData, zGTradeZoneBullishHTF);
            }
            
         }
         
         if (bar3.low >= bar2.low && bar2.low <= bar1.low) { // tim thay swing low 
            if (typeTickVolume == 1) {
               maxVolume = bar2.tick_volume;
            } else {
               maxVolume = MathMax(MathMax(bar1.tick_volume, bar2.tick_volume), bar3.tick_volume);
            }
            // continue BOS swing low
            if (tfData.LastSwingMajor == -1 && bar2.low < tfData.arrBot[0]) {
               text += "\n-3.2. swing low, sTrend == -1 && mTrend == -1 && LastSwingMajor == -1 && bar2.low ("+DoubleToString(bar2.low, _Digits)+") < arrBot[0] ("+DoubleToString( tfData.arrBot[0], _Digits)+")";
               text += "\n=> Cap nhat: arrBot[0] = bar2.low = "+DoubleToString(bar2.low, _Digits)+" ; sTrend == -1; mTrend == -1; LastSwingMajor == 1;";
               
               // Update ArrayBot[0]
               if(tfData.arrBot[0] != bar2.low) {                                 
                  // Add new point
                  tfData.AddToDoubleArray( tfData.arrBot, bar2.low);
                  tfData.AddToDateTimeArray( tfData.arrBotTime, bar2.time);
                  tfData.AddToLongArray( tfData.volArrBot, maxVolume);
                  // Add new zone bullish
                  tfData.AddToPoiZoneArray( tfData.zArrBot, zone_bullish, limit); 
                  // cap nhat waiting arrBot
                  tfData.waitingArrBot = 0;
               }
               tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = 1;
            }
   
            // LL < LL
            if (tfData.LastSwingMajor == 1 && bar2.low < tfData.arrBot[0]) {
               text += "\n-3.3. sTrend == -1 && mTrend == -1 && LastSwingMajor == 1 && bar2.low < arrBot[0]";
               text += "\n=> Xoa label, Cap nhat: arrBot[0] = bar2.low = "+DoubleToString(bar2.low, _Digits)+" ; sTrend == -1; mTrend == -1; LastSwingMajor == 1;";
               
               // Update ArrayBot[0]
               if(tfData.arrBot[0] != bar2.low) {
                  // Update point
                  tfData.UpdateDoubleArray( tfData.arrBot, 0, bar2.low);
                  tfData.UpdateDateTimeArray( tfData.arrBotTime, 0, bar2.time);
                  tfData.UpdateLongArray( tfData.volArrBot, 0, maxVolume);
                  // Update zone bullish
                  tfData.UpdatePoiZoneArray( tfData.zArrBot, 0, zone_bullish);
                  // cap nhat waiting arrBot
                  tfData.waitingArrBot = 0;
               }
               tfData.sTrend = -1; tfData.mTrend = -1; tfData.LastSwingMajor = 1;
            }
         }
      
         //Cross IDM
         if (
            //tfData.LastSwingMajor == -1 && 
            tfData.findHigh == 0 && bar1.high > tfData.idmLow) {
            text += "\n-3.4. Cross IDM Downtrend, sTrend == -1 && mTrend == -1 && LastSwingMajor == random && bar1.high > idmLow :" + DoubleToString(bar1.high, _Digits) + ">" + DoubleToString( tfData.idmLow,_Digits);
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
               
               wVol = GetCumulativeVolume(tfData.arrPbLTime[0], tfData.wvolArrPbHighTime[0], tfData.timeFrame, "Marjor New Low");
               tfData.AddToLongArray( tfData.wvolArrPbLow, wVol);
               tfData.AddToDateTimeArray( tfData.wvolArrPbLowTime, tfData.arrPbLTime[0]);

               // Setup wave volume
               if (tfData.wvMtrend == 0 && tfData.wvolArrPbLowTime[0] > tfData.wvolArrPbHighTime[0]) {
                  tfData.wvMtrend = (tfData.wvolArrPbLow[0] > tfData.wvolArrPbHigh[0]) ? -1 : 1;
                  // Trả về trạng thái chấp nhận Buy or Sell của Marjor sau cú Break khi xác nhận được swing đầu tiên bởi cú quét IDM 
                  tfData.wvIsBuyMarjor = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Marjor", 1);
                  tfData.wvIsSellMarjor = tfData.getStatusLegalByVolumeOfBreakStruct(tfData, "Marjor", -1);
               }
               
               // Add new zone
               marjor_name = MARJOR_TEXT+"_"+BULL_TEXT+"_"+TimeToString(tfData.zArrBot[0].time);
               tfData.AddToPoiZoneArray( tfData.zArrPbLow, tfData.zArrBot[0], limit, marjor_name);
               // update waiting arr pb low
               tfData.waitingArrPbLows = 0;
            } 
            text += "\n Cap nhat: New arrPbLow = arrBot[0] = "+ DoubleToString( tfData.arrBot[0], _Digits);
            drawPointStructure(tfData, -1, tfData.arrPbLow[0], tfData.arrPbLTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(IDM_TEXT, tfData.idmLowTime, tfData.idmLow, bar1.time, tfData.idmLow, -1, IDM_TEXT, tfData.tfColor, STYLE_DOT);
            text += "\n => Cap nhat findHigh = 1; H = bar1.high = "+ DoubleToString(bar1.high, _Digits);
            
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
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmSell = true;
            }
            // Quét toàn bộ các vùng POI để Trade theo Order Block, Order Flow
            //tfData.scanPoiZoneLastTime(tfData, -1);
            // drawMarjorTradeZone(tfData, bar1);
         }
         
         // CHoCH High
         if (
            //tfData.LastSwingMajor == -1 && 
            bar1.high > tfData.arrPbHigh[0] && tfData.arrPbHigh[0] != tfData.arrChoHigh[0]) {
            text += "\n-3.5 sTrend == -1 && mTrend == -1 && LastSwingMajor == random && bar1.high ("+ DoubleToString(bar1.high, _Digits) +") > arrPbHigh[0] ("+ DoubleToString(tfData.arrPbHigh[0], _Digits)+")";
            text += "\n => Cap nhat => Ve line. sTrend = 1; mTrend = 1; LastSwingMajor = 1; findLow = 0; idmHigh = Lows[0] = "+DoubleToString(tfData.Lows[0], _Digits);
            text += "\n => Cap nhat => New arrChoHigh: = arrPbHigh[0] = "+ DoubleToString(tfData.arrPbHigh[0], _Digits);
                        
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
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmSell = false;
               myEAs.signalInternal.sg_getIdmBuy = false;
               // // Reset PoiZone Trade Zone belong to Marjor structure
               resetTradeZoneHTF(tfData, zGTradeZoneBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneBullishHTF);
               // Scan lại zone mới để thêm vào Trade Zone
               scanMarjorTradeZoneHighTF(tfData, bar1);
               
            }
            
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
            text += "\n-3.6 Continue Bos DOWN. sTrend == -1 && mTrend == -1 & LastSwingMajor == random && bar1.low < arrPbLow[0] ("+DoubleToString(tfData.arrPbLow[0], _Digits)+")"+
                     "&& arrPbLow[0] != arrChoLow[0] ("+DoubleToString(tfData.arrChoLow[0], _Digits)+")";
            text += "---> Update: arrChoLow[0] = "+ DoubleToString(tfData.arrPbLow[0], _Digits);
                                    
            // Add new point
            tfData.AddToDoubleArray( tfData.arrChoLow, tfData.arrPbLow[0]);
            tfData.AddToDateTimeArray( tfData.arrChoLowTime, tfData.arrPbLTime[0]);
            tfData.AddToLongArray( tfData.volArrChoLow, tfData.volArrPbLow[0]);
                        
            // update Point LH         
            if (tfData.H != 0 && (tfData.H != tfData.arrPbHigh[0] || (tfData.H == tfData.arrPbHigh[0] && tfData.HTime != tfData.arrPbHTime[0]))) {
               text += "\n----> IF: H != 0 && H != arrPbHigh[0]("+DoubleToString(tfData.arrPbHigh[0],_Digits)+") => Update: New arrPbHigh[0] = "+DoubleToString(tfData.H,_Digits);
               // Add new point
               tfData.AddToDoubleArray( tfData.arrPbHigh, tfData.H);
               tfData.AddToDateTimeArray( tfData.arrPbHTime, tfData.HTime);
               tfData.AddToLongArray( tfData.volArrPbHigh, tfData.vol_H);
               
               wVol = GetCumulativeVolume(tfData.arrPbHTime[0], tfData.wvolArrPbLowTime[0], tfData.timeFrame, "Marjor BOS Low");
               tfData.AddToLongArray( tfData.wvolArrPbHigh, wVol);
               tfData.AddToDateTimeArray( tfData.wvolArrPbHighTime, tfData.arrPbHTime[0]);
               
               // Setup wave volume
               if (tfData.wvMtrend != 0 && tfData.wvolArrPbLowTime[0] < tfData.wvolArrPbHighTime[0]) {
                  tfData.wvMtrend = 0;
                  tfData.wvIsBuyMarjor = false;
                  tfData.wvIsSellMarjor = false;
               }
               // Add New Zone Bearish
               // 2. Tìm "điểm neo" (index) dựa trên thời gian của nến đó
               // iBarShift trả về chỉ số của nến tại một thời điểm nhất định
               int indexAnchor = iBarShift(_Symbol, tfData.timeFrame, tfData.L_bar.time);
               if (indexAnchor != -1) {
                  PoiZone barZone = createpoizone_optimized(tfData.timeFrame, indexAnchor, -1);
                  zone_tmp = CreatePoiZone( tfData,barZone.high, barZone.low, tfData.L_bar.open, tfData.L_bar.close, tfData.L_bar.time, clr_marjor_bearish);
               } else {
                  MqlRates bar_tmp = tfData.L_bar;
                  zone_tmp = CreatePoiZone( tfData,bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time, clr_marjor_bearish);
               }
               marjor_name = MARJOR_TEXT+"_"+BEAR_TEXT+"_"+TimeToString(zone_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, zone_tmp, limit, marjor_name);
               
               // update waiting arrPbHigh
               tfData.waitingArrPbHigh = 0;
            }
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(BOS_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], bar1.time, tfData.arrPbLow[0], 1, BOS_TEXT, tfData.tfColor, STYLE_SOLID);
            
            text += "\n--> Cap nhat POI Bearish: L_idmLow = idmLow = "+DoubleToString(tfData.idmLow,_Digits);
                     
            tfData.L_idmLow = tfData.idmLow;
            tfData.L_idmLowTime = tfData.idmLowTime;
            
            tfData.findHigh = 0; 
            tfData.idmLow = tfData.Highs[0]; tfData.idmLowTime = tfData.HighsTime[0]; tfData.vol_idmLow = tfData.volHighs[0];
            tfData.H = 0; tfData.vol_H = 0; 
            text += ", findHigh = 0, idmLow = "+DoubleToString( tfData.Highs[0], _Digits)+", H = 0";
            
            if (tfData.mFindTarget != -1) {
               tfData.mFindTarget = -1;
               tfData.mStoploss = tfData.arrPbHigh[0];
               tfData.mStoplossTime = tfData.arrPbHTime[0];
               tfData.mTarget = 0;
               tfData.mTargetTime = 0;
               tfData.mSnR = tfData.arrPbLow[0];
               text += " | Continue BOS Low M-3.6";
            }
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmSell = false;
               myEAs.signalInternal.sg_getIdmBuy = false;
               // // Reset PoiZone Trade Zone belong to Marjor structure
               resetTradeZoneHTF(tfData, zGTradeZoneBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneBullishHTF);
               // Scan lại zone mới để thêm vào Trade Zone
               scanMarjorTradeZoneHighTF(tfData, bar1);
               
            }
            
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
               
               wVol = GetCumulativeVolume(tfData.arrPbHTime[0], tfData.wvolArrPbLowTime[0], tfData.timeFrame, "Marjor CHoCH Low");
               tfData.AddToLongArray( tfData.wvolArrPbHigh, wVol);
               tfData.AddToDateTimeArray( tfData.wvolArrPbHighTime, tfData.arrPbHTime[0]);
               
               // Setup wave volume
               if (tfData.wvMtrend != 0 && tfData.wvolArrPbLowTime[0] < tfData.wvolArrPbHighTime[0]) {
                  tfData.wvMtrend = 0;
                  tfData.wvIsBuyMarjor = false;
                  tfData.wvIsSellMarjor = false;
               }

               // Add New Zone Bearish
               // 2. Tìm "điểm neo" (index) dựa trên thời gian của nến đó
               // iBarShift trả về chỉ số của nến tại một thời điểm nhất định
               int indexAnchor = iBarShift(_Symbol, tfData.timeFrame, tfData.L_bar.time);
               if (indexAnchor != -1) {
                  PoiZone barZone = createpoizone_optimized(tfData.timeFrame, indexAnchor, -1);
                  zone_tmp = CreatePoiZone( tfData,barZone.high, barZone.low, tfData.L_bar.open, tfData.L_bar.close, tfData.L_bar.time, clr_marjor_bearish);
               } else {
                  MqlRates bar_tmp = tfData.L_bar;
                  zone_tmp = CreatePoiZone( tfData,bar_tmp.high, bar_tmp.low, bar_tmp.open, bar_tmp.close, bar_tmp.time, clr_marjor_bearish);
               }
               marjor_name = MARJOR_TEXT+"_"+BEAR_TEXT+"_"+TimeToString(zone_tmp.time);
               tfData.AddToPoiZoneArray( tfData.zArrPbHigh, zone_tmp, limit, marjor_name); 
               // update waiting arrPbHigh
               tfData.waitingArrPbHigh = 0;
            }
            drawPointStructure(tfData, 1, tfData.arrPbHigh[0], tfData.arrPbHTime[0], MAJOR_STRUCTURE, false, enabledDraw);
            drawLine(CHOCH_TEXT, tfData.arrPbLTime[0], tfData.arrPbLow[0], bar1.time, tfData.arrPbLow[0], 1, CHOCH_TEXT, tfData.tfColor, STYLE_SOLID);
            
            text += "\n => Cap nhat => POI bearish H: "+DoubleToString( tfData.H, _Digits);
            
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
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmSell = false;
               myEAs.signalInternal.sg_getIdmBuy = false;
               // // Reset PoiZone Trade Zone belong to Marjor structure
               resetTradeZoneHTF(tfData, zGTradeZoneBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneBullishHTF);
               // Scan lại zone mới để thêm vào Trade Zone
               scanMarjorTradeZoneHighTF(tfData, bar1);
               
            }
            
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
               
            text += "\n-4.2 sTrend == -1 && mTrend == 1 && LastSwingMajor == 1 && bar1.high > arrPbHigh[0] : " + DoubleToString(bar1.high, _Digits) + ">" +DoubleToString(tfData.arrPbHigh[0], _Digits);
            text += "\n => Cap nhat => sTrend = 1; mTrend = 1; LastSwingMajor = 1; findLow = 0; idmHigh = Lows[0] = "+DoubleToString(tfData.Lows[0], _Digits);
            text += "\n => Cap nhat => POI Bullish = arrPbLow[0] : "+ DoubleToString(tfData.arrPbLow[0], _Digits);
            
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
            
            if (tfData.isHighTF) {
               myEAs.signalInternal.sg_getIdmSell = false;
               myEAs.signalInternal.sg_getIdmBuy = false;
               // // Reset PoiZone Trade Zone belong to Marjor structure
               resetTradeZoneHTF(tfData, zGTradeZoneBearishHTF);
               resetTradeZoneHTF(tfData, zGTradeZoneBullishHTF);
               // Scan lại zone mới để thêm vào Trade Zone
               scanMarjorTradeZoneHighTF(tfData, bar1);
               
            }
            
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
            //// ve line
            //DrawDirectionalSegment(line_target, place_start_line_draw, bar1.time, line_dinh, line_day, tfData.tfColor, 1, 3);
         }
      }
            
      // Set Global Value of High Timeframe
      if (tfData.isHighTF) {
         myEAs.signalInternal.sg_sTrend = tfData.sTrend;
         myEAs.signalInternal.sg_vSTrend = tfData.vSTrend;
         
         myEAs.signalInternal.sg_mTrend = tfData.mTrend;
         myEAs.signalInternal.sg_vMTrend = tfData.vMTrend;
         myEAs.signalInternal.sg_wvMTrend = tfData.wvMtrend;
         
         myEAs.signalInternal.sg_wvIsBuyMarjor = tfData.wvIsBuyMarjor;
         myEAs.signalInternal.sg_wvIsSellMarjor = tfData.wvIsSellMarjor;
         
      } else { // set thong so co ban LTF
         myEAs.marketStructStatus.iMSS_H_arrPBHigh_LTF = tfData.arrPbHigh[0];
         myEAs.marketStructStatus.iMSS_L_arrPBLow_LTF = tfData.arrPbLow[0];
      }
      
      if(StringLen(text) > 0) {
         // For Deverlop
         showComment(tfData);
      }
      
      if (isComment == false) {
         textall = "";
      } else {
         if (StringLen(text) > 0) {
            textall += str_marjor+text;
         }
      }
      
      return textall;
   } //--- End Ham cap nhat cau truc thi truong : updatePointTopBot
    
   // Ham tra ve break out hay false break out
   bool checkVolumeBreak(int type_break, MqlRates& barBreak, double value_swing, long vol_swing) {
      bool result = false;
      string text = "";
      text += "==> Info: Bar ("+DoubleToString( ((type_break == 1)? barBreak.high : barBreak.low),_Digits) +") with volume ("+(string)barBreak.tick_volume+") breaked ("+DoubleToString(value_swing,_Digits)+") has volume ("+(string) vol_swing+")";
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
            text += "; \nbodyBar("+DoubleToString(bodyBar,_Digits)+") - percent("+(string)percentIsDojiBar+")/100*highLowBar("+DoubleToString(highLowBar,_Digits)+") ("+(string)(highLowBar*percentIsDojiBar/100)+") = "+ DoubleToString(isDojiBar,_Digits);
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
   //trade.SetExpertMagicNumber(InpMagic);
   ChartSetInteger(0, CHART_SHOW_GRID, false);
//---   
   defaultGlobal();
//---
   prewHighTFStruct.originalDefinition(highTimeFrame);
   prewLowTFStruct.originalDefinition(lowTimeFrame);
//---
      
   //CurrentSpread = NormalizeDouble(Ask - Bid, _Digits);
   // Sau khi tất cả setup xong. bat dâu show noti 
   enabledNotification = true;
   
   // Gửi tin nhắn chào khi EA được gắn vào biểu đồ
   webhook = GetWebhookForSymbol(_Symbol);
   SendDiscordMessage("EA đã được khởi động trên " + _Symbol);
   
   return(INIT_SUCCEEDED);
}


// OnTick function
void OnTick()
{
   // Quản lý các lệnh đang chạy trước
   managerOrderScalpingRobotRunning();
   
   bool isNewBarLow = IsNewBar(lowTimeFrame);
   bool isNewBarHigh = IsNewBar(highTimeFrame);
   
   // Kiểm tra nến mới cho M5
   if(isNewBarLow) {
     lowTFStruct.realTimeDefinition(lowTimeFrame);
   }
   
   // Kiểm tra nến mới cho H1
   if(isNewBarHigh) {
     highTFStruct.realTimeDefinition(highTimeFrame);
   }
   
   // Chỉ hiển thị info struct khi có nến mới hoặc sự thay đổi để tránh quá tải Comment() liên tục
   static datetime lastShowTime = 0;
   datetime currentLowTime = iTime(_Symbol, lowTimeFrame, 0);
   if(currentLowTime != lastShowTime) {
      showInfoStruct();
      lastShowTime = currentLowTime;
   }

   // Chỉ vẽ lại chart khi thực sự có thay đổi đối tượng đồ thị
   if(g_needRedraw) {
      ChartRedraw(0);
      g_needRedraw = false;
   }
}

// Hàm xóa toàn bộ đối tượng đồ thị do EA tạo ra
void DeleteEAObjects()
{
   int total = ObjectsTotal(0, 0, -1);
   for(int i = total - 1; i >= 0; i--)
   {
      string name = ObjectName(0, i, 0, -1);
      if(StringSubstr(name, 0, 7) == "Signal@" ||
         StringSubstr(name, 0, 7) == "DirSeg_" ||
         StringSubstr(name, 0, 5) == "ePOI_" ||
         StringFind(name, "G-LTF-Internal") >= 0 ||
         StringFind(name, "G-Internal") >= 0 ||
         StringFind(name, "G-Marjor") >= 0 ||
         StringFind(name, "Marjor_") >= 0 ||
         StringFind(name, "Internal_") >= 0)
      {
         ObjectDelete(0, name);
      }
   }
}

// OnDeinit function
void OnDeinit(const int reason)
{
   // Dọn dẹp tất cả dữ liệu
   GlobalVars.Clear();
   
   // Xóa tất cả đối tượng đồ thị do EA tạo ra
   DeleteEAObjects();
   
   ChartRedraw(0);
}

// Dinh nghia va xac nhan bien toan cuc
void defaultGlobal() {
   // xac dinh cap low high time frame by minutes
   switch(pairTimeFrameInput)
     {
      case  1:
        lowPairTF = 1;
        highPairTF = 3;
        lowTimeFrame = PERIOD_M1;
        highTimeFrame = PERIOD_M3;
        break;
      case  2:
        lowPairTF = 1;
        highPairTF = 5;
        lowTimeFrame = PERIOD_M1;
        highTimeFrame = PERIOD_M5;
        break;
      case  3:
        lowPairTF = 1;
        highPairTF = 10;
        lowTimeFrame = PERIOD_M1;
        highTimeFrame = PERIOD_M10;
        break;
      case  4:
        lowPairTF = 1;
        highPairTF = 15;
        lowTimeFrame = PERIOD_M1;
        highTimeFrame = PERIOD_M15;
        break;
      case  5:
        lowPairTF = 5;
        highPairTF = 60;
        lowTimeFrame = PERIOD_M5;
        highTimeFrame = PERIOD_H1;
        break;
      case  6:
        lowPairTF = 15;
        highPairTF = 240;
        lowTimeFrame = PERIOD_M15;
        highTimeFrame = PERIOD_H4;
        break;
      case  7:
        lowPairTF = 60;
        highPairTF = 3600;
        lowTimeFrame = PERIOD_H1;
        highTimeFrame = PERIOD_D1;
        break;
      default:
         lowPairTF = 1;
         highPairTF = 15;
         lowTimeFrame = PERIOD_M1;
         highTimeFrame = PERIOD_M15;
        break;
     }
}


//+------------------------------------------------------------------+
//| Hàm kiểm tra nến mới cho bất kỳ khung thời gian nào               |
//+------------------------------------------------------------------+
bool IsNewBar(ENUM_TIMEFRAMES timeframe) {
    static datetime prevLowTime = 0;
    static datetime prevHighTime = 0;
    static datetime prevOtherTime = 0;
    
    datetime currentTime = iTime(_Symbol, timeframe, 0);
    if(currentTime == 0) return false;
    
    if(timeframe == lowTimeFrame) {
        if(prevLowTime != currentTime) {
            prevLowTime = currentTime;
            return true;
        }
    } else if(timeframe == highTimeFrame) {
        if(prevHighTime != currentTime) {
            prevHighTime = currentTime;
            return true;
        }
    } else {
        if(prevOtherTime != currentTime) {
            prevOtherTime = currentTime;
            return true;
        }
    }
    return false;
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

   bool created = false;
   if(ObjectCreate(0, objName, OBJ_ARROW, 0, time, price))
     {
      ObjectSetInteger(0, objName, OBJPROP_ARROWCODE, arrowCode);
      ObjectSetInteger(0, objName, OBJPROP_COLOR, clr);
      if( direction > 0)
         ObjectSetInteger(0, objName, OBJPROP_ANCHOR, ANCHOR_TOP);
      if(direction < 0)
         ObjectSetInteger(0, objName, OBJPROP_ANCHOR, ANCHOR_BOTTOM);
      created = true;
   }
   string objNameDesc = objName + txt;
   if (ObjectCreate(0, objNameDesc, OBJ_TEXT, 0, time, price)) {
      ObjectSetString(0, objNameDesc, OBJPROP_TEXT, " "+txt);
      ObjectSetInteger(0, objNameDesc, OBJPROP_COLOR, clr);
      if( direction > 0)
         ObjectSetInteger(0, objNameDesc, OBJPROP_ANCHOR, ANCHOR_TOP);
      if(direction < 0)
         ObjectSetInteger(0, objNameDesc, OBJPROP_ANCHOR, ANCHOR_BOTTOM);
      created = true;
   }
   if(created) g_needRedraw = true;
}

//+------------------------------------------------------------------+
//| Function to delete objects created by createObj                   |
//+------------------------------------------------------------------+
void deleteObj(datetime time, double price, int arrowCode, string txt) {
   // Create the object name using the same format as createObj
   string objName = "";
   StringConcatenate(objName, "Signal@", time, "at", DoubleToString(price, _Digits), "(", arrowCode, ")");
   
   bool deleted = false;
   // Delete the arrow object
   if(ObjectFind(0, objName) != -1) // Check if the object exists
     {
      ObjectDelete(0, objName);
      deleted = true;
     }
   
   // Create the description object name
   string objNameDesc = objName + txt;
   
   // Delete the text object
   if(ObjectFind(0, objNameDesc) != -1) // Check if the object exists
     {
      ObjectDelete(0, objNameDesc);
      deleted = true;
     }
   if(deleted) g_needRedraw = true;
}


//DrawBox(0,                               // chart_ID
//        "ePOI_" + (string)zone.time,     // name (Duy nhất theo thời gian)
//        0,                               // sub_window
//        zone.time,                       // time1 (Điểm bắt đầu)
//        zone.high,                       // price1
//        TimeCurrent(),                   // time2 (Vẽ đến hiện tại)
//        zone.low,                        // price2
//        zone.zoneColor,                  // clr
//        STYLE_SOLID, 1, true, false, false, true, 0); // Các thông số phụ

void DrawBox(long chart_ID, string name, int sub_window,
             datetime time1, double price1, 
             datetime time2, double price2, 
             color clr, ENUM_LINE_STYLE style, int width, 
             bool back, bool selection, bool ray_right, bool fill, long zorder)
{
   // Kiểm tra xem Object đã tồn tại chưa
   if(ObjectFind(chart_ID, name) != -1) 
   {
      // Nếu đã tồn tại, chỉ cập nhật tọa độ (Quan trọng để kéo dài Box)
      ObjectMove(chart_ID, name, 0, time1, price1);
      ObjectMove(chart_ID, name, 1, time2, price2);
      
      // Cập nhật lại màu sắc (đề phòng trường hợp chuyển trạng thái zone)
      ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_FILL, fill);
      g_needRedraw = true;
      return; // Kết thúc sớm, không cần tạo mới
   }

   // Nếu chưa tồn tại thì mới tạo mới
   if(ObjectCreate(chart_ID, name, OBJ_RECTANGLE, sub_window, time1, price1, time2, price2))
   {
      ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
      ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
      ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_RAY_RIGHT, ray_right);
      ObjectSetInteger(chart_ID, name, OBJPROP_FILL, fill);
      ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, zorder);
      g_needRedraw = true;
   }
}

//+------------------------------- Draw Line -----------------------------------+
void drawLine(string name, datetime  time_start, double price_start, datetime time_end, double price_end, int direction, string displayName, color iColor, int styleDot){
   string objname = name + TimeToString(time_start);
   if (ObjectFind(0, objname) < 0) {
      if(ObjectCreate(0, objname, OBJ_TREND, 0, time_start, price_start, time_end, price_end)) {
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
         g_needRedraw = true;
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
      g_needRedraw = true;
     }
}


//+------------------------------------------------------------------+
//| Hàm: Vẽ Đoạn Giá Có Mũi Tên Hướng                                |
//| * Tên đối tượng được tạo dựa trên Thời gian (duy nhất cho mỗi nến) |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Hàm: Vẽ Đoạn Giá Có Mũi Tên Hướng (Đã sửa lỗi)                   |
//+------------------------------------------------------------------+
//bool DrawDirectionalSegment(
//    const int direction, // 1: Lên, -1: Xuống
//    double price_start_draw, // vị trí đặt nét vẽ
//    datetime time_coord,
//    double price_dinh, // đỉnh tam giác 
//    double price_day, // đáy tam giác
//    color color_val, 
//    int width_val = 1,
//    int style = 1 // style cua duong ke
//    )
//{
//    
//    // Định nghĩa BASE_NAME
//    const string BASE_NAME = "DirSeg_";
//    
//    // TẠO TÊN DUY NHẤT: Kết hợp Tên Cơ Sở và Thời gian của nến
//    string unique_time_str = TimeToString(time_coord, TIME_DATE|TIME_SECONDS);
//    StringReplace(unique_time_str, ":", "_"); // Thay thế dấu : để tránh lỗi tên
//    string seg_name = BASE_NAME + "Seg_" + unique_time_str;
//    string arr_name = BASE_NAME + "Arr_" + unique_time_str;
//    
//    double start_price = price_start_draw; 
//    double high_of_line = (price_dinh > price_day) ? price_dinh - price_day : price_day - price_dinh;
//    double end_price;   
//    int arrow_code;     
//    //Print("=> Target Line: Hướng "+((direction > 0)? "Tăng" : "Giảm")+". Từ (Đỉnh)="+ DoubleToString(price_dinh,_Digits) + " đến (Đáy)="+ DoubleToString(price_day,_Digits));
//    // 1. XÁC ĐỊNH HƯỚNG VÀ VỊ TRÍ MŨI TÊN
//    if (direction == 1) // MŨI TÊN HƯỚNG LÊN 
//    {
//        arrow_code = 233; // SỬA: SYMBOL_ARROW_UP → SYMBOL_ARROWUP
//        end_price   = price_start_draw + high_of_line; // SỬA: fmax → MathMax
//    }
//    else if (direction == -1) // MŨI TÊN HƯỚNG XUỐNG
//    {
//        arrow_code = 234; // SỬA: SYMBOL_ARROW_DOWN → SYMBOL_ARROWDOWN
//        end_price   = price_start_draw - high_of_line; // SỬA: fmin → MathMin
//    }
//    else
//    {
//        Print("Lỗi: Tham số 'direction' không hợp lệ. Chỉ chấp nhận 1 (Lên) hoặc -1 (Xuống).");
//        return false;
//    }
//      //arrow_code = 32;
//    // 2. KIỂM TRA GIÁ TRỊ HỢP LỆ (SỬA LẠI HOÀN TOÀN)
//    if (price_dinh <= 0.0 || price_day <= 0.0 || 
//        !MathIsValidNumber(price_dinh) || !MathIsValidNumber(price_day) ||
//        time_coord <= 0)
//    {
//        Print("Lỗi: Giá trị đầu vào không hợp lệ. Price đỉnh: ", price_dinh, ", Price đáy: ", price_day, ", Time: ", time_coord);
//        return false;
//    }
//
//    // 3. XÓA ĐỐI TƯỢNG CŨ (NẾU TỒN TẠI)
//    ObjectDelete(0, seg_name);
//    ObjectDelete(0, arr_name);
//
//    // 4. VẼ ĐOẠN THẲNG (OBJ_TREND) - SỬA: OBJ_FIBOSEG → OBJ_TREND
//    if (!ObjectCreate(0, seg_name, OBJ_TREND, 0, time_coord, start_price, time_coord, end_price))
//    {
//        Print("Lỗi tạo đoạn thẳng: ", GetLastError());
//        return false;
//    }
//    
//    
//    // Thiết lập thuộc tính cho đoạn thẳng
//    ObjectSetInteger(0, seg_name, OBJPROP_COLOR, color_val);
//    ObjectSetInteger(0, seg_name, OBJPROP_WIDTH, width_val);
//    ObjectSetInteger(0, seg_name, OBJPROP_RAY, false);
//    ObjectSetInteger(0, seg_name, OBJPROP_SELECTABLE, false);
//    // thiet lap kieu ve style cua doan thang
//    switch(style)
//      {
//       case  2: // Dot
//         ObjectSetInteger(0, seg_name, OBJPROP_STYLE, STYLE_DOT);
//         break;
//       case  3: // Dash
//         ObjectSetInteger(0, seg_name, OBJPROP_STYLE, STYLE_DASH);
//         break;
//       case  4: // Dash + dot
//         ObjectSetInteger(0, seg_name, OBJPROP_STYLE, STYLE_DASHDOT);
//         break;
//       default:
//         ObjectSetInteger(0, seg_name, OBJPROP_STYLE, STYLE_SOLID);
//         break;
//      }
//
////    // 5. VẼ MŨI TÊN (OBJ_ARROW_CHECK) - SỬA: OBJ_ARROW → OBJ_ARROW_CHECK
////    if (!ObjectCreate(0, arr_name, OBJ_ARROW_CHECK, 0, time_coord, end_price))
////    {
////        Print("Lỗi tạo mũi tên: ", GetLastError());
////        // Xóa đoạn thẳng đã tạo nếu mũi tên thất bại
////        ObjectDelete(0, seg_name);
////        return false;
////    }
////    
////    // Thiết lập thuộc tính cho mũi tên
////    ObjectSetInteger(0, arr_name, OBJPROP_COLOR, color_val);
////    ObjectSetInteger(0, arr_name, OBJPROP_ARROWCODE, arrow_code);
////    ObjectSetInteger(0, arr_name, OBJPROP_WIDTH, width_val + 2); 
////    ObjectSetInteger(0, arr_name, OBJPROP_SELECTABLE, false);
//
//    // 6. VẼ LẠI BIỂU ĐỒ
//    ChartRedraw();
//    return true;
//}

bool DrawDirectionalSegment(
    const int direction,      // 1: Lên, -1: Xuống
    double price_start_draw,  // Vị trí đặt gốc nét vẽ
    datetime time_coord,      // Thời gian (tọa độ X)
    double price_dinh,        // Đỉnh tham chiếu để tính độ cao
    double price_day,         // Đáy tham chiếu để tính độ cao
    color color_val,          
    int width_val = 1,
    int style = 1             // 1: Solid, 2: Dot, 3: Dash, 4: DashDot
)
{
    // 1. KIỂM TRA GIÁ TRỊ ĐẦU VÀO
    if (price_dinh <= 0.0 || price_day <= 0.0 || time_coord <= 0 || !MathIsValidNumber(price_dinh))
    {
        // Print("Lỗi: Dữ liệu đầu vào không hợp lệ.");
        return false;
    }

    // 2. ĐỊNH NGHĨA TÊN ĐỐI TƯỢNG (Duy nhất theo thời gian của nến)
    const string BASE_NAME = "DirSeg_";
    string unique_time_str = TimeToString(time_coord, TIME_DATE|TIME_SECONDS);
    StringReplace(unique_time_str, ":", "_");
    
    string seg_name = BASE_NAME + "Line_" + unique_time_str;

    // 3. TÍNH TOÁN ĐỘ CAO VÀ GIÁ KẾT THÚC
    double high_of_line = MathAbs(price_dinh - price_day);
    double end_price = (direction == 1) ? (price_start_draw + high_of_line) : (price_start_draw - high_of_line);

    // 4. XỬ LÝ ĐƯỜNG THẲNG (OBJ_TREND)
    // Kiểm tra xem đối tượng với tên này đã tồn tại trên biểu đồ chưa
    bool changed = false;
    if(ObjectFind(0, seg_name) < 0)
    {
        // TRƯỜNG HỢP 1: CHƯA TỒN TẠI -> TẠO MỚI
        if(!ObjectCreate(0, seg_name, OBJ_TREND, 0, time_coord, price_start_draw, time_coord, end_price))
        {
            Print("Lỗi tạo Line: ", GetLastError());
            return false;
        }
        changed = true;
    }
    else
    {
        // TRƯỜNG HỢP 2: ĐÃ TỒN TẠI -> CẬP NHẬT TỌA ĐỘ (Vẽ lại cao/thấp hơn)
        // Di chuyển điểm bắt đầu (Point 0)
        ObjectMove(0, seg_name, 0, time_coord, price_start_draw);
        // Di chuyển điểm kết thúc (Point 1)
        ObjectMove(0, seg_name, 1, time_coord, end_price);
        changed = true;
    }

    // 5. THIẾT LẬP CÁC THUỘC TÍNH HIỂN THỊ
    ObjectSetInteger(0, seg_name, OBJPROP_COLOR, color_val);
    ObjectSetInteger(0, seg_name, OBJPROP_WIDTH, width_val);
    ObjectSetInteger(0, seg_name, OBJPROP_RAY, false);          // Tắt tia kéo dài vô tận
    ObjectSetInteger(0, seg_name, OBJPROP_SELECTABLE, false);   // Không cho phép chọn thủ công để tránh vướng tay
    ObjectSetInteger(0, seg_name, OBJPROP_BACK, false);         // Vẽ trên nến (true nếu muốn vẽ dưới nến)

    // Thiết lập kiểu đường (Style)
    ENUM_LINE_STYLE m_style = STYLE_SOLID;
    switch(style)
    {
        case 2: m_style = STYLE_DOT; break;
        case 3: m_style = STYLE_DASH; break;
        case 4: m_style = STYLE_DASHDOT; break;
        default: m_style = STYLE_SOLID; break;
    }
    ObjectSetInteger(0, seg_name, OBJPROP_STYLE, m_style);

    // 6. CẬP NHẬT LẠI BIỂU ĐỒ ĐỂ HIỂN THỊ NGAY LẬP TỨC
    if(changed) g_needRedraw = true;
    return true;
}

//+------------------------------------------------------------------+
//| Hàm kiểm tra xem có lệnh đang chạy hoặc lệnh chờ hay không       |
//| Trả về true nếu ĐÃ CÓ lệnh, false nếu CHƯA CÓ lệnh               |
//+------------------------------------------------------------------+
bool IsTradeExists(string symbol, long magic)
{
    // 1. Kiểm tra các lệnh đang chạy (Positions)
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(PositionSelectByTicket(ticket))
        {
            if(PositionGetString(POSITION_SYMBOL) == symbol && PositionGetInteger(POSITION_MAGIC) == magic)
            {
                return true; // Đã tìm thấy vị thế đang chạy
            }
        }
    }

    // 2. Kiểm tra các lệnh đang chờ (Pending Orders)
    for(int i = OrdersTotal() - 1; i >= 0; i--)
    {
        ulong ticket = OrderGetTicket(i);
        if(OrderSelect(ticket))
        {
            if(OrderGetString(ORDER_SYMBOL) == symbol && OrderGetInteger(ORDER_MAGIC) == magic)
            {
                return true; // Đã tìm thấy lệnh chờ
            }
        }
    }

    return false; // Không tìm thấy lệnh nào
}

//+------------------------------------------------------------------+
//| Hàm tính toán khối lượng lệnh (Lot) dựa trên rủi ro              |
//+------------------------------------------------------------------+
double CalculateLotSize(double riskPercent, double entryPrice, double stopLossPrice, double minUserLot = 0.03)
{
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount = balance * (riskPercent / 100.0);
    double slDistance = MathAbs(entryPrice - stopLossPrice);
    
    if(slDistance <= 0) return 0;
    
    double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
    double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double lotStep   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
    
    // Tính Lot theo rủi ro
    double lotSize = riskAmount / ((slDistance / tickSize) * tickValue);
    lotSize = MathFloor(lotSize / lotStep) * lotStep;
    
    // Kiểm tra điều kiện tối thiểu 0.03 của bạn
    if(lotSize < minUserLot) 
    {
        Print("Bỏ qua: Lot tính toán (", lotSize, ") < mức tối thiểu (", minUserLot, ")");
        return 0;
    }
    
    // Kiểm tra giới hạn sàn
    double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    if(lotSize > maxLot) lotSize = maxLot;
    
    return lotSize;
}

//+------------------------------------------------------------------+
//| Hàm xoá tất cả các lệnh chờ của cặp tiền này và Magic này        |
//+------------------------------------------------------------------+
//void DeleteAllPendingOrders(string symbol, long magic)
//{
//    // Duyệt ngược từ cuối danh sách lệnh về đầu
//    // Lý do: Khi xoá một lệnh, chỉ số (index) của các lệnh còn lại sẽ bị thay đổi.
//    for(int i = OrdersTotal() - 1; i >= 0; i--)
//    {
//        ulong ticket = OrderGetTicket(i); // Lấy Ticket của lệnh tại vị trí i
//        if(OrderSelect(ticket)) // Chọn lệnh để kiểm tra thông tin
//        {
//            string orderSymbol = OrderGetString(ORDER_SYMBOL);
//            long  orderMagic  = OrderGetInteger(ORDER_MAGIC);
//            
//            // Kiểm tra xem có đúng cặp tiền và Magic Number không
//            if(orderSymbol == symbol && orderMagic == magic)
//            {
//                // Thực hiện xoá lệnh
//                if(trade.OrderDelete(ticket))
//                {
//                    Print("Đã xoá thành công lệnh chờ Ticket #", ticket);
//                }
//                else
//                {
//                    Print("Lỗi khi xoá lệnh #", ticket, ". Mã lỗi: ", GetLastError());
//                }
//            }
//        }
//    }
//}

//+------------------------------------------------------------------+
//| Tổ hợp hàm scalping robot sẽ nằm ở khu vực này                   |
//+------------------------------------------------------------------+


void checkStatusOrderScalpingRobot() {
   if (OrdersTotal() == 0) return;
   
   bool result_pending = true;
   // Kiem tra xem co lenh dang dat sai hay khong
   if(myEAs.valueInternal.vi_TempSwing_High.main.vins_SwingNew > 0 && myEAs.valueInternal.vi_TempSwing_High.main.vins_isSignalConfirm_LTF == 1) {
      if(Ask > myEAs.valueInternal.vi_TempSwing_High.main.vins_SwingNew) result_pending = false;
   } 
   
   if (myEAs.valueInternal.vi_TempSwing_Low.main.vins_SwingNew > 0 && myEAs.valueInternal.vi_TempSwing_Low.main.vins_isSignalConfirm_LTF == 1) {
      if( Bid < myEAs.valueInternal.vi_TempSwing_Low.main.vins_SwingNew) result_pending = false;
   }  
   
   if (result_pending == false) {
      //DeleteAllPendingOrders(_Symbol, InpMagic);
      Print("Xoa lenh pending bi sai");
      Print("Xoa lenh pending bi sai");
   }
}
//+------------------------------------------------------------------+
//| Hàm quản lý lệnh đang chạy                                       |
//+------------------------------------------------------------------+
void managerOrderScalpingRobotRunning() {
  
   // Xoa lenh khong phu hop
   checkStatusOrderScalpingRobot();
   
}


//+------------------------------------------------------------------+
//| KET THUC Tổ hợp hàm scalping robot                               |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Tổ hợp hàm hiển thị thông tin cơ bản ra ngoài chart              |
//+------------------------------------------------------------------+

string inInfoBar(MqlRates& bar1, MqlRates& bar2, MqlRates& bar3) {
   string text = "=====> Bar1 (R) high: "+ DoubleToString(bar1.high,_Digits) +" - low: "+ DoubleToString(bar1.low,_Digits) + " - vol: "+ (string)  bar1.tick_volume +
                  " --- "+" Bar2 high: "+ DoubleToString(bar2.high,_Digits) +" - low: "+ DoubleToString(bar2.low,_Digits)+ " - vol: "+ (string) bar2.tick_volume +
                  " --- "+" Bar3 (L) high: "+ DoubleToString(bar3.high,_Digits) +" - low: "+ DoubleToString(bar3.low,_Digits)+" - vol: "+ (string) bar3.tick_volume+"<=====";
   return text;
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
   text += "#Timeframe: "+ EnumToString(timeframe);
   text += " | Struct is : " + ((tfData.sTrend == 0) ? "Not defined" : ((tfData.sTrend == 1) ? "S UpTrend" : "S DownTrend")) + "( "+ (string) tfData.sTrend + " . "+ (string) tfData.vSTrend+ ")";
   text += " | Marjor Struct is : " + ((tfData.mTrend == 0) ? "Not defined" : ((tfData.mTrend == 1) ? "m UpTrend" : "m DownTrend")) + "( "+ (string) tfData.mTrend + " . "+ (string) tfData.vMTrend+" . "+ (string) tfData.wvMtrend+ ")";
   text += " | Internal is : " + ((tfData.iTrend == 0) ? "Not defined" : ((tfData.iTrend == 1) ? "i UpTrend" : "i DownTrend"))+ "( "+ (string) tfData.iTrend + " . "+ (string) tfData.vItrend + " . "+ (string) tfData.wvItrend+ ")";
   text += " | Gann wave is : " + ((tfData.gTrend == 0) ? "Not defined" : ((tfData.gTrend == 1) ? "g UpTrend" : " DownTrend"))+ "( "+ (string) tfData.gTrend + " . "+ (string) tfData.vGTrend+ ")";
   
   return text;
}

// Todo: 
void showPoiComment(TimeFrameData& tfData) {
   bool show = false;
   string text = "### Timeframe: "+ (string) tfData.isTimeframe;
    if (myEAs.signalInternal.sg_iTrend == 1) {
      Print("zArrPoiZoneLTFBullishBelongHighTF: (LTF)"); ArrayPrint(zArrPoiZoneLTFBullishBelongHighTF);
      Print("zGTradeZoneInternalBullishHTF: "); ArrayPrint(zGTradeZoneInternalBullishHTF);
      
    }
    
    if (myEAs.signalInternal.sg_iTrend == -1) {
      Print("zArrPoiZoneLTFBearishBelongHighTF: (LTF)"); ArrayPrint(zArrPoiZoneLTFBearishBelongHighTF);
      Print("zGTradeZoneInternalBearishHTF: "); ArrayPrint(zGTradeZoneInternalBearishHTF);
    }
    
    if (myEAs.signalInternal.sg_mTrend == 1) {
       show = true;
       //Print("zLows: "); ArrayPrint(tfData.zLows);
       
       Print("zGTradeZoneBullishHTF: "); ArrayPrint(zGTradeZoneBullishHTF);
       //Print("zIntSLows: "); ArrayPrint(tfData.zIntSLows);
      
       //Print("zArrPbLow"); ArrayPrint(tfData.zArrPbLow);
       //Print("zArrIntBullish: "); ArrayPrint(tfData.zArrIntBullish);
       
    }
    if (myEAs.signalInternal.sg_mTrend == -1) {
       show = true;
       //Print("zHighs: "); ArrayPrint(tfData.zHighs);
       
       Print("zGTradeZoneBearishHTF: "); ArrayPrint(zGTradeZoneBearishHTF);
       //Print("zIntSHighs: "); ArrayPrint(tfData.zIntSHighs);
      
       //Print("zArrPbHigh"); ArrayPrint(tfData.zArrPbHigh); 
       //Print("zArrIntBearish: "); ArrayPrint(tfData.zArrIntBearish);
       
    }
   
   //text += "\nEND Timeframe: "+ EnumToString(tfData.timeFrame);
   if (show) {
      Print(getValueTrend(tfData));
      Print(text);
   }
   
   Print("======================= END show PoiComment ======================");
}

// +------------------------------------------------------------------+
// | Hàm trả về chuỗi thông tin chi tiết của InternalSwingData         |
// +------------------------------------------------------------------+
string GetSwingDataLog(string name, const InternalSwingData &data) {
   if(data.vins_SwingNew <= 0) return name + ": [No Data]\n";

   string log = "--- LOG " + name + " ---\n";
   log += TAB_STRING+"Price: " + DoubleToString(data.vins_SwingNew, _Digits) + " | Time: " + TimeToString(data.vins_SwingTimeNew);
   // Thông tin LTF trend
   log += " || LTF mTrend/: " + (string)data.vins_LTF_mTrend + "("+(string) data.vins_LTF_wvmTrend+") | iTrend: " + (string)data.vins_LTF_iTrend + "("+(string) data.vins_LTF_wviTrend+")";
   // Thông tin nến OB
   log += " - OB Price: " + DoubleToString(data.vins_barOrderBlock.high, _Digits) + " - " + DoubleToString(data.vins_barOrderBlock.low, _Digits);
   
   // Các trạng thái xác nhận (Flags)
   log += " - Confirm: Pattern=" + (string)data.vins_isSignalConfirm_Patten + 
          " | Again=" + (string)data.vins_isSignalConfirm_Patten_Again + 
          " | OB=" + (string)data.vins_isSignalConfirm_OB_Patten + 
          " | LTF=" + (string)data.vins_isSignalConfirm_LTF+"\n";
          
   // Vùng giá và thanh khoản
   log += TAB_STRING+"Zone: OF Mitigated=" + (string)data.vins_isOrderFlowMitigated + 
          " | Swept=" + (string)data.vins_isPoiZoneSwept + 
          " | POI Mitigated=" + (string)data.vins_isPoiZoneMitigated;
          
   // Dữ liệu LTF
   log += " - LTF Data: WaveType=" + (string)data.vins_isSignalConfirm_LTF_byWave + 
          " | Trend=" + (string)data.vins_LTF_mTrend + "/" + (string)data.vins_LTF_iTrend;
   log += " - Entry Stop: " + DoubleToString(data.vins_Entry_Stop, _Digits) + "\n";
   
   return log;
}


//+------------------------------------------------------------------+
//| Hàm trả về log file của Internal main hoặc sub                   |
//+------------------------------------------------------------------+
string getSwingInternalLog(string name, const InternalSwingData& data) {
   string log = TAB_STRING+"--- "+name+" ---\n";
   log += TAB_STRING+TAB_STRING+"LTF mTrend = "+(string)data.vins_LTF_mTrend+"; wvmTrend = "+(string)data.vins_LTF_wvmTrend+
            "; iTrend = "+(string)data.vins_LTF_iTrend+"; wvItrend = "+(string)data.vins_LTF_wviTrend;             
   string confirmt_high_LTF = (data.vins_isSignalConfirm_LTF == 0) ? "0 Not scan" : ((data.vins_isSignalConfirm_LTF == 1)? "1 Yes" : "-1 No");
   log += " | Price: "+DoubleToString(data.vins_SwingNew, _Digits)+" | Time: "+TimeToString(data.vins_SwingTimeNew)+
            " | Price OB: "+DoubleToString(data.vins_barOrderBlock.high, _Digits)+" | Time: "+TimeToString(data.vins_barOrderBlock.time)+
            " | Price Stop: "+DoubleToString(data.vins_Entry_Stop, _Digits)+"\n";
   log += TAB_STRING+TAB_STRING+"Active: "+(data.isActive ? "Yes" : "No")+" | isSignalConfirm_Patten: "+(string) data.vins_isSignalConfirm_Patten+
         " | isSignalConfirm_Patten_Again: "+(string) data.vins_isSignalConfirm_Patten_Again+" | isSignalConfirm_LTF: "+confirmt_high_LTF+" | isOrderFlowMitigated: "+((data.vins_isOrderFlowMitigated) ? "Yes" : "No")+
         " | isPoiZoneMitigated: "+((data.vins_isPoiZoneMitigated) ? "Yes" : "No")+" | isPoiZoneSwept: "+((data.vins_isPoiZoneSwept) ? "Yes" : "No");
   return log;
}

void showComment(TimeFrameData& tfData) {
   return;
   //Print("Timeframe: "+ (string) tfData.isTimeframe);
   
      //Print("Highs: "); ArrayPrint(tfData.Highs);
      //Print("HighsTime: "); ArrayPrint(tfData.HighsTime);
      //Print("Vol Highs: "); ArrayPrint(tfData.volHighs);
      //Print("wvolHighs: "); ArrayPrint(tfData.wvolHighs);
      //Print("wvolHighTime: "); ArrayPrint(tfData.wvolHighTime);
      //Print("Lows: "); ArrayPrint(tfData.Lows);
      //Print("LowsTime: "); ArrayPrint(tfData.LowsTime);
      //Print("Vol Lows: "); ArrayPrint(tfData.volLows);
      //Print("wvolLows: "); ArrayPrint(tfData.wvolLows);
      //Print("wvolLowTime: "); ArrayPrint(tfData.wvolLowTime);
      
      //Print("zHighs: "); ArrayPrint(tfData.zHighs);
      //Print("zLows: "); ArrayPrint(tfData.zLows);
      
      Print("intSHighs: "); ArrayPrint(tfData.intSHighs);
      Print("intSHighTime: "); ArrayPrint(tfData.intSHighTime);
//      //Print("Vol intSHighs: "); ArrayPrint(tfData.volIntSHighs);
      Print("wvolIntSHighs"); ArrayPrint(tfData.wvolIntSHighs);
      Print("wvolIntSHighTime: "); ArrayPrint(tfData.wvolIntSHighTime);
//      //Print("zIntSHighs: "); ArrayPrint(tfData.zIntSHighs);
//    
      if (ArraySize(tfData.wvolIntSHighTime) > 0){
         int count = 0;
         string text = "High: ";
         for(int i=0;i<ArraySize(tfData.wvolIntSHighTime);i++){
            if (tfData.wvolIntSHighTime[i] != tfData.intSHighTime[i]) {
               count++;
               text += "\nTim thay khac thoi gian o vi tri key: ["+(string)i+"] co thoi gian la : "+(string) tfData.wvolIntSHighTime[i];
            }  
         }
         if (count > 0) {
            Print(text);
            Print(TAB_STRING);
         }
      }
      Print("intSLows: "); ArrayPrint(tfData.intSLows); 
      Print("intSLowTime: "); ArrayPrint(tfData.intSLowTime); 
//      //Print("Vol intSLows: "); ArrayPrint(tfData.volIntSLows); 
      Print("wvolIntSLows"); ArrayPrint(tfData.wvolIntSLows);
      Print("wvolIntSLowTime"); ArrayPrint(tfData.wvolIntSLowTime);
//      //Print("zIntSLows: "); ArrayPrint(tfData.zIntSLows);
      if (ArraySize(tfData.wvolIntSLowTime) > 0){
         int count = 0;
         string text = "Low: ";
         for(int i=0;i<ArraySize(tfData.wvolIntSLowTime);i++){
            if (tfData.wvolIntSLowTime[i] != tfData.intSLowTime[i]) {
               count++;
               text += "\nTim thay khac thoi gian o vi tri key: ["+(string)i+"] co thoi gian la : "+(string) tfData.wvolIntSLowTime[i];
            }  
         }
         if (count > 0) {
            Print(text);
            Print(TAB_STRING);
         }
      }
      //Print("arrTop: "); ArrayPrint(tfData.arrTop); 
      //Print("Vol arrTop: "); ArrayPrint(tfData.volArrTop);
      //Print("arrBot: "); ArrayPrint(tfData.arrBot); 
      //Print("Vol arrBot: "); ArrayPrint(tfData.volArrBot);
      ////////////////Print("zArrTop: "); ArrayPrint(tfData.zArrTop);
      ////////////////Print("zArrBot: "); ArrayPrint(tfData.zArrBot);
      
      
      // Print("arrPbHigh ("+(string)ArraySize(tfData.arrPbHigh)+"): "); ArrayPrint(tfData.arrPbHigh);
      // Print("wvolArrPbHigh ("+(string)ArraySize(tfData.wvolArrPbHigh)+"): "); ArrayPrint(tfData.wvolArrPbHigh);
      // //Print("Vol arrPbHigh: "); ArrayPrint(tfData.volArrPbHigh);
      // Print("arrPbLow ("+(string)ArraySize(tfData.arrPbLow)+"): "); ArrayPrint(tfData.arrPbLow); 
      // Print("wvolArrPbLow ("+(string)ArraySize(tfData.wvolArrPbLow)+"): ");; ArrayPrint(tfData.wvolArrPbLow); 
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

      
      //Print("arrChoHigh: "+DoubleToString( tfData.arrChoHigh[0], _Digits) + " "+ (string) tfData.arrChoHighTime[0]);
//         Print("Vol arrChoHigh: "); ArrayPrint(tfData.volArrChoHigh);
      //Print("arrChoLow: "+(string) tfData.arrChoLow[0]  + " "+ (string) tfData.arrChoLowTime[0]);
//         Print("Vol arrChoLow: "); ArrayPrint(tfData.volArrChoLow);
      
      //Print("zPoiExtremeHigh: "); ArrayPrint(tfData.zPoiExtremeHigh);
      //Print("zPoiExtremeLow: "); ArrayPrint(tfData.zPoiExtremeLow);
      
      
      //Print("zArrPoiZoneLTFBullishBelongHighTF: "); ArrayPrint(zArrPoiZoneLTFBullishBelongHighTF);
      //Print("zArrPoiZoneLTFBearishBelongHighTF: "); ArrayPrint(zArrPoiZoneLTFBearishBelongHighTF);
      
} 

string GetWebhookForSymbol(string symbol)
{
   string sym = symbol;
   StringToUpper(sym);   // Đưa về chữ hoa

   // Kiểm tra lần lượt từng cặp – ưu tiên các chuỗi dài trước
   if (StringFind(sym, "XAUUSD") >= 0)  return "https://discordapp.com/api/webhooks/1196670174904975460/AcKbwdXZHEKSXZbfFsPI5IX1qqQHaOpKM6gxEhOoI2ydK8nGBIbkZAlxe509FF-vq5c_";
   if (StringFind(sym, "EURUSD") >= 0)  return "https://discordapp.com/api/webhooks/1196675986440343593/Fabtob_JEI1RZHN_C8FLAFCmARWgE2XyhppyiUqon9RkBzhHFycdfbrPO7flgZPxI7e5";
   if (StringFind(sym, "GBPUSD") >= 0)  return "https://discordapp.com/api/webhooks/1196647435058032640/vYJEFRk1z8VGouAPadhermW3yy385Nu9fOAp6b7ghI5M6mJa7e2-nQixStbBS4rfZeJ0";
   if (StringFind(sym, "AUDUSD") >= 0)  return "https://discordapp.com/api/webhooks/1196671358432710677/_ewRs73g3Qr6fp3yYeZf1_horv6RrKAErjCfo6knwVCyDahlX-wlX3D8UKzvNJayDZqv";
   if (StringFind(sym, "NZDUSD") >= 0)  return "https://discordapp.com/api/webhooks/1196674321242927125/WOTOQPuvx-ZHzi-b6oDg9hl-KWnXjTx39e7NSEeLvgB-5EUoGs_Dn73VHZ45N_rH1WpX";
   if (StringFind(sym, "USDJPY") >= 0)  return "https://discordapp.com/api/webhooks/1196677537363918929/oeW9hvEfGedNmdqCQMjuSW7ZaCvq9Wo4GnEODQeclTX_TwJwBl2JubNJsuDtY46IcZow";
   if (StringFind(sym, "BTCUSD") >= 0)  return "https://discordapp.com/api/webhooks/1500489285584027700/WQFRl8c8HhX11EuTe1iaYXnyOhag4X-tbSuZW8gt-7-zDXacRVrnmPmmZ0mRdyn5s9nd";

   // Mặc định: kênh chung cho các symbol khác (có thể để rỗng để không gửi)
   return "https://discordapp.com/api/webhooks/1143626665461821552/eQUQ_OYEn--k6wlEFVJiEdi4s9d8qx7pb9zm_E87lFotnG1lQLIY4t9aU25Y61LWOPM9";
}

void sendNoti(string message = "") {
   if(!enabledNotification) return;
   double iTarget = 0, iStoploss = 0;
   bool iTarget_isMitigatedPoizone = false, iTarget_isSweptSwing = false, iStoploss_isMitigatedPoizone = false, iStoploss_isSweptSwing = false;
   
   double iSwingPullBack = 0;
   bool iSwingPullBack_isMitigatedPoizone = false, iSwingPullBack_isSweptPoizone = false;
   bool iSwingPullBack_isMitigatedOrderFlow = false;
   bool iSwingPullBack_isConfirmLTF = false;
   
   double iSubSwingPullBack = 0;
   bool iSubSwingPullBack_isMitigatedPoizone = false, iSubSwingPullBack_isSweptPoizone = false;
   bool iSubSwingPullBack_isMitigatedOrderFlow = false;
   bool iSubSwingPullBack_isConfirmLTF = false;
   
   if (myEAs.valueInternal.vi_wvIsBuyInternal) { // Buy
      iTarget = myEAs.valueInternal.vi_intSHigh;
      iStoploss = myEAs.valueInternal.vi_intSLow;
      iTarget_isMitigatedPoizone = (myEAs.valueInternal.vi_intSHigh_isMitigatedPoiZone)? true : false;
      iStoploss_isMitigatedPoizone = (myEAs.valueInternal.vi_intSLow_isMitigatedPoiZone)? true : false;
   } else if (myEAs.valueInternal.vi_wvIsSellInternal) { // Sell
      iTarget = myEAs.valueInternal.vi_intSLow;
      iStoploss = myEAs.valueInternal.vi_intSHigh;
      iTarget_isMitigatedPoizone = (myEAs.valueInternal.vi_intSLow_isMitigatedPoiZone)? true : false;
      iStoploss_isMitigatedPoizone = (myEAs.valueInternal.vi_intSHigh_isMitigatedPoiZone)? true : false;
   } else {
      if (myEAs.valueInternal.vi_ITrend == 1) { // Buy
         iTarget = myEAs.valueInternal.vi_intSHigh;
         iStoploss = myEAs.valueInternal.vi_intSLow;   
         iTarget_isMitigatedPoizone = (myEAs.valueInternal.vi_intSHigh_isMitigatedPoiZone)? true : false;
         iStoploss_isMitigatedPoizone = (myEAs.valueInternal.vi_intSLow_isMitigatedPoiZone)? true : false;
      } else if (myEAs.valueInternal.vi_ITrend == -1) { // Sell
         iTarget = myEAs.valueInternal.vi_intSLow;
         iStoploss = myEAs.valueInternal.vi_intSHigh;
         iTarget_isMitigatedPoizone = (myEAs.valueInternal.vi_intSLow_isMitigatedPoiZone)? true : false;
         iStoploss_isMitigatedPoizone = (myEAs.valueInternal.vi_intSHigh_isMitigatedPoiZone)? true : false;
      }
   }
   iTarget_isSweptSwing = (myEAs.valueInternal.vi_isSwept)? true : false;
   iStoploss_isSweptSwing = (myEAs.valueInternal.vi_isSweptPoiZone)? true : false;
   // Set Swing Pullback
   iSwingPullBack_isMitigatedOrderFlow = (myEAs.valueInternal.vi_isMitigatedOrderFlow)? true : false;
   if(myEAs.valueInternal.vi_ITrend == 1) {
      //Main
      iSwingPullBack = myEAs.valueInternal.vi_TempSwing_Low.main.vins_SwingNew;
      iSwingPullBack_isMitigatedPoizone = (myEAs.valueInternal.vi_TempSwing_Low.main.vins_isOrderFlowMitigated)? true: false;
      iSwingPullBack_isSweptPoizone = (myEAs.valueInternal.vi_TempSwing_Low.main.vins_isPoiZoneSwept)? true: false;
      iSwingPullBack_isConfirmLTF = (myEAs.valueInternal.vi_TempSwing_Low.main.vins_isSignalConfirm_LTF == 1)? true: false;
      //Candidate Sub
      iSubSwingPullBack = myEAs.valueInternal.vi_TempSwing_Low.sub.vins_SwingNew;
      iSubSwingPullBack_isMitigatedPoizone = (myEAs.valueInternal.vi_TempSwing_Low.sub.vins_isOrderFlowMitigated)? true: false;
      iSubSwingPullBack_isSweptPoizone = (myEAs.valueInternal.vi_TempSwing_Low.sub.vins_isPoiZoneSwept)? true: false;
      iSubSwingPullBack_isConfirmLTF = (myEAs.valueInternal.vi_TempSwing_Low.sub.vins_isSignalConfirm_LTF == 1)? true: false;
      
   } else {
      //Main
      iSwingPullBack = myEAs.valueInternal.vi_TempSwing_High.main.vins_SwingNew;
      iSwingPullBack_isMitigatedPoizone = (myEAs.valueInternal.vi_TempSwing_High.main.vins_isOrderFlowMitigated)? true: false;
      iSwingPullBack_isSweptPoizone = (myEAs.valueInternal.vi_TempSwing_High.main.vins_isPoiZoneSwept)? true: false;
      iSwingPullBack_isConfirmLTF = (myEAs.valueInternal.vi_TempSwing_High.main.vins_isSignalConfirm_LTF  == 1)? true: false;
      //Candidate Sub
      iSubSwingPullBack = myEAs.valueInternal.vi_TempSwing_High.sub.vins_SwingNew;
      iSubSwingPullBack_isMitigatedPoizone = (myEAs.valueInternal.vi_TempSwing_High.sub.vins_isOrderFlowMitigated)? true: false;
      iSubSwingPullBack_isSweptPoizone = (myEAs.valueInternal.vi_TempSwing_High.sub.vins_isPoiZoneSwept)? true: false;
      iSubSwingPullBack_isConfirmLTF = (myEAs.valueInternal.vi_TempSwing_High.sub.vins_isSignalConfirm_LTF  == 1)? true: false;
   }
   string text = "";
   
   string getIdm = (myEAs.signalInternal.sg_mTrend == 1) ? (string)myEAs.signalInternal.sg_getIdmBuy : (string)myEAs.signalInternal.sg_getIdmSell;
   string isBuyHTF = (myEAs.valueInternal.vi_wvIsBuyInternal)? "Yes" : "No";
   string isSellHTF = (myEAs.valueInternal.vi_wvIsSellInternal)? "Yes" : "No";
   text += StringFormat("IsBuy: %s - IsSell: %s || %s| Mtrend: %d(%d) | get IDM: %s | Itrend: %d(%d) - TP: %s(%s) - SL: %s(%s) - SnR: %s | PullBack Swing => Main: %s: %s(%s), LTF: %s | Sub: %s: %s(%s), LTF: %s",
                              isBuyHTF, isSellHTF, _Symbol, myEAs.valueInternal.vi_mTrend, myEAs.valueInternal.vi_wvmTrend, getIdm, myEAs.valueInternal.vi_ITrend, myEAs.valueInternal.vi_wvITrend,
                              DoubleToString(iTarget,_Digits), ((iTarget_isMitigatedPoizone || iTarget_isSweptSwing)? "W!" : "OK"),  
                              DoubleToString(iStoploss, _Digits), ((iStoploss_isMitigatedPoizone || iStoploss_isSweptSwing)? "OK": "W!"),
                              DoubleToString(myEAs.valueInternal.vi_intSnR,_Digits), ((myEAs.valueInternal.vi_ITrend == 1)? "Low" : "High"), DoubleToString(iSwingPullBack,_Digits), ((iSwingPullBack_isMitigatedPoizone || iSwingPullBack_isSweptPoizone || iSwingPullBack_isMitigatedOrderFlow)? "OK": "W!"), ((iSwingPullBack_isConfirmLTF)? "Confirm": "UnConfirm"),
                              ((myEAs.valueInternal.vi_ITrend == 1)? "Low" : "High"), DoubleToString(iSubSwingPullBack,_Digits), ((iSubSwingPullBack_isMitigatedPoizone || iSubSwingPullBack_isSweptPoizone || iSubSwingPullBack_isMitigatedOrderFlow)? "OK": "W!"),((iSubSwingPullBack_isConfirmLTF)? "Confirm": "UnConfirm")
                              );
   string str_result = message +"\n==> "+ text + "\n---------------END---------------\n";                              
   
   SendDiscordMessage(str_result);
   //SendNotification(str_result);
   //Print(str_result);
   //Print(TAB_STRING);
   
}

bool SendDiscordMessage(string message)
{
   // Escape tất cả ký tự đặc biệt theo chuẩn JSON
   // Cần escape backslash trước tiên để không phá hỏng các lần escape sau
   StringReplace(message, "\\", "\\\\"); // \ -> \\
   StringReplace(message, "\"", "\\\""); // " -> \"
   StringReplace(message, "\n", "\\n");  // xuống dòng thực -> \n
   StringReplace(message, "\r", "");     // loại bỏ ký tự carriage return (nếu có)

   // Tạo JSON payload
   string jsonPayload = StringFormat("{\"content\": \"%s\"}", message);
   
   // In ra để kiểm tra – đây là bước rất quan trọng để bạn biết JSON gửi đi là gì
   Print("Đang gửi JSON: ", jsonPayload);

   // Chuyển sang mảng char đúng độ dài, hỗ trợ UTF-8
   char postData[];
   StringToCharArray(jsonPayload, postData, 0, StringLen(jsonPayload), CP_UTF8);

   char resultData[];
   string resultHeaders;
   int timeout = 5000;
   string headers = "Content-Type: application/json\r\n";

   ResetLastError();
   int response = WebRequest("POST", webhook, headers, timeout, postData, resultData, resultHeaders);

   if(response == -1)
     {
      PrintFormat("Lỗi trong WebRequest. Mã lỗi: %d", GetLastError());
      return false;
     }
   else if(response == 204)
     {
      Print("Đã gửi tin nhắn đến Discord thành công!");
      return true;
     }
   else
     {
      string result = CharArrayToString(resultData);
      PrintFormat("Gửi thất bại! Mã HTTP: %d, phản hồi: %s", response, result);
      return false;
     }
}


string getValueTrend(TimeFrameData& tfData) {
   
   string text; 
   
   text += "\n -------------------------------------------------------------------------------------------------------------------- \n";
   text += GetSwingDataLog("myEAs.valueInternal.candidate_High", myEAs.valueInternal.candidate_High);
   text += GetSwingDataLog("myEAs.valueInternal.vi_TempSwing_High.main", myEAs.valueInternal.vi_TempSwing_High.main);
   text += GetSwingDataLog("myEAs.valueInternal.vi_TempSwing_High.sub", myEAs.valueInternal.vi_TempSwing_High.sub);
   text += "\n ================================== \n";
   text += GetSwingDataLog("myEAs.valueInternal.candidate_Low", myEAs.valueInternal.candidate_Low);
   text += GetSwingDataLog("myEAs.valueInternal.vi_TempSwing_Low.main", myEAs.valueInternal.vi_TempSwing_Low.main);
   text += GetSwingDataLog("myEAs.valueInternal.vi_TempSwing_Low.sub", myEAs.valueInternal.vi_TempSwing_Low.sub);
   
   #define siData myEAs.signalInternal
   text += "\n -------------------------------------------------------------------------------------------------------------------- \n";
   text += "\n### Timeframe: "+ (string) tfData.isTimeframe+"\n";
   text += "($)myEAs.signalInternal (High TF): ";
   text += "sTrend: ("+(string) siData.sg_sTrend+" . "+(string) siData.sg_vSTrend+
            ") ; mTrend: ("+ (string) siData.sg_mTrend+" . "+(string) siData.sg_vMTrend+" . "+(string) siData.sg_wvMTrend+
            ") ; iTrend: ("+(string) siData.sg_iTrend+" . "+(string) siData.sg_vITrend+" . "+(string) siData.sg_wvITrend+
            ") ; getIdmBuy: "+(string) siData.sg_getIdmBuy+"- getIdmSell: "+(string) siData.sg_getIdmSell+
            " ; Signal Buy: " + (string) siData.sg_wvIsBuyInternal + " - Signal Sell: "+ (string) siData.sg_wvIsSellInternal;
   text += "\n -------------------------------------------------------------------------------------------------------------------- \n";
   #undef siData
   
   #define viData myEAs.valueInternal
   text += "($)myEAs.valueInternal (High TF): ";
   text += "iTrend: "+(string)viData.vi_ITrend+" ("+(string)viData.vi_wvITrend+") | IsSwept: "+(viData.vi_isSwept ? "Yes" : "No")+
               " IsMitigatedPoizone: "+(string)(viData.vi_isMitigatedPoiZone ? "Yes" : "No")+" IsSweptPoizone: "+(viData.vi_isSweptPoiZone ? "Yes" : "No");
   text += " | IS Buy: ("+((viData.vi_wvIsBuyInternal)? "Yes" : "No")+") - IS Sell: ("+((viData.vi_wvIsSellInternal)? "Yes" : "No")+")"; 
   text += "\n"+TAB_STRING+"Internal High: "+DoubleToString(viData.vi_intSHigh, _Digits)+" "+TimeToString(viData.vi_intSHighTime)+" - isMitgatedPoiZone: "+(viData.vi_intSHigh_isMitigatedPoiZone ? "Yes" : "No") + 
            " || Internal Low: "+DoubleToString(viData.vi_intSLow, _Digits)+" ("+TimeToString(viData.vi_intSLowTime)+") - isMitgatedPoiZone: "+(viData.vi_intSLow_isMitigatedPoiZone ? "Yes" : "No");
           
   //text += "\n"+getSwingInternalLog("Temp Swing High (Main)", myEAs.valueInternal.vi_TempSwing_High.main);
   text += "\n"+getSwingInternalLog("Temp Swing High (Sub)", viData.vi_TempSwing_High.sub);
   //text += "\n"+getSwingInternalLog("Temp Swing Low (Main)", myEAs.valueInternal.vi_TempSwing_Low.main);
   text += "\n"+getSwingInternalLog("Temp Swing Low (Sub)", viData.vi_TempSwing_Low.sub);
   #undef viData
   
   text += "\n -------------------------------------------------------------------------------------------------------------------- \n";
   text += "($)myEAs.marketStructStatus (High TF) \n";
   text += TAB_STRING+"HTF: Internal High = "+ DoubleToString(myEAs.marketStructStatus.iMSS_intSHighHTFRealTime, _Digits) + " && LTF: gl_H = "+DoubleToString(myEAs.marketStructStatus.iMSS_H_AF_LTFRealTime, _Digits) + " marjor H = "+DoubleToString(myEAs.marketStructStatus.iMSS_H_arrPBHigh_LTF, _Digits)+" iMSS_findH = "+(string) myEAs.marketStructStatus.iMSS_findL+ " - Signal Sell: " + (string) myEAs.marketStructStatus.iMSS_H_pattern_signal+"\n";
   text += TAB_STRING+"HTF: Internal Low = "+ DoubleToString(myEAs.marketStructStatus.iMSS_intSLowHTFRealTime, _Digits) + " && LTF: gl_L = "+ DoubleToString(myEAs.marketStructStatus.iMSS_L_AF_LTFRealTime, _Digits) + " marjor L = "+DoubleToString(myEAs.marketStructStatus.iMSS_L_arrPBLow_LTF, _Digits)+" iMSS_findL = "+ (string) myEAs.marketStructStatus.iMSS_findH + " - Signal Buy: " + (string) myEAs.marketStructStatus.iMSS_L_pattern_signal;
   
   text += "\n -------------------------------------------------------------------------------------------------------------------- \n";
   text += "($)myEAs.statusInternalHTL (High TF to Low TF) \n ";
   text += TAB_STRING+"sHL_ITrend: " + (string) myEAs.statusInternalHTL.sHL_ITrend +"; sHL_vITrend: "+ (string) myEAs.statusInternalHTL.sHL_vITrend + "; sHL_iStoploss: " +DoubleToString(myEAs.statusInternalHTL.sHL_iStoploss,_Digits) + 
            "; sHL_iOrderBlock: "+ (string) myEAs.statusInternalHTL.sHL_mitigate_iOrderBlock +"; sHL_iSnR: "+ DoubleToString (myEAs.statusInternalHTL.sHL_iSnR, _Digits) + "; sHL_iTarget: "+ DoubleToString( myEAs.statusInternalHTL.sHL_iTarget, _Digits)
            + "; sHL_mitigate_iOrderFlow: "+ (string) myEAs.statusInternalHTL.sHL_mitigate_iOrderFlow + "; sHL_mitigate_iOrderBlock: "+ (string) myEAs.statusInternalHTL.sHL_mitigate_iOrderBlock;
   
   text += "\n -------------------------------------------------------------------------------------------------------------------- \n";
   text +=  "($) tfData \n";
   text += TAB_STRING+ "* Struct Trend: [STrend: "+ (string) tfData.sTrend + " vSTrend: "+(string) tfData.vSTrend + ". waitingStrend: pbHigh "+(string) tfData.waitingArrPbHigh + " pbLow " + (string) tfData.waitingArrPbLows +
                     "] _ [Marjor Trend = mTrend: "+(string) tfData.mTrend+ " vMTrend: "+(string) tfData.vMTrend+ " wvMtrend: "+(string) tfData.wvMtrend +  ". waitingMtrend: waitingArrTop "+(string) tfData.waitingArrTop + " waitingArrBot " + (string) tfData.waitingArrBot + " - LastSwingMajor: "+(string) tfData.LastSwingMajor+"]"+
               "\n     [findHigh: "+(string) tfData.findHigh+" - idmHigh: "+DoubleToString(tfData.idmHigh, _Digits)+ " - vol idmHigh: "+(string) tfData.vol_idmHigh+
               " findLow: "+(string) tfData.findLow+" - idmLow: "+DoubleToString( tfData.idmLow,_Digits)+ " - vol idmLow: "+(string) tfData.vol_idmLow+
               " _ mFindtarget: "+(string) tfData.mFindTarget + " mStoploss: " + DoubleToString(tfData.mStoploss,_Digits) + " mSnR: " + DoubleToString(tfData.mSnR,_Digits) + " mTarget: "+ DoubleToString(tfData.mTarget,_Digits) + " mFullTarget: "+ DoubleToString(tfData.mFullTarget,_Digits) +"]"+"\n";
   text += TAB_STRING+"* Internal Trend: iTrend: "+(string) tfData.iTrend+ " vItrend: "+(string) tfData.vItrend + " wvItrend: "+(string) tfData.wvItrend +
               " waitingItrend: IntSHighs "+(string) tfData.waitingIntSHighs + " IntSLows " + (string) tfData.waitingIntSLows +" - LastSwingInternal: "+(string) tfData.LastSwingInternal+ " _ iFindtarget: "+(string) tfData.iFindTarget + 
               "\n     iStoploss: " + DoubleToString(tfData.iStoploss,_Digits) + " iOrderBlock: " + DoubleToString(tfData.iOrderBlock,_Digits) + " iSnR: " + DoubleToString(tfData.iSnR,_Digits) + " iTarget: "+ DoubleToString(tfData.iTarget,_Digits) + " iFullTarget: "+ DoubleToString(tfData.iFullTarget,_Digits) +"\n";
   text += TAB_STRING+"* Gann Trend: gTrend: "+(string) tfData.gTrend+ " vGTrend: "+(string) tfData.vGTrend+ " - LastSwingMeter: "+(string) tfData.LastSwingMeter+ " | | H: "+ DoubleToString( tfData.H, _Digits) +" - L: "+DoubleToString( tfData.L, _Digits);  
//   
//   text += "\n -------------------------------------------------------- END ------------------------------------------------------------ \n";
   return text;
}
