//+------------------------------------------------------------------+
//|                                             SMC_Framework.mq5    |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Smart Money Concept Framework"
#property version   "1.00"
#property strict
#property indicator_chart_window

//+------------------------------------------------------------------+
//| Input Parameters                                                 |
//+------------------------------------------------------------------+
input ENUM_TIMEFRAMES   HTF = PERIOD_H1;        // Higher Timeframe
input ENUM_TIMEFRAMES   LTF = PERIOD_M5;       // Lower Timeframe
input int               SwingPeriod = 5;        // Swing Detection Period
input bool              DrawSwingPoints = true; // Draw Swing Points

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
datetime lastHtfBarTime;
datetime lastLtfBarTime;

//+------------------------------------------------------------------+
//| Swing Point Structure                                            |
//+------------------------------------------------------------------+
struct SwingPoint
{
   datetime time;
   double price;
   bool isHigh;
};

//+------------------------------------------------------------------+
//| Market Structure Class                                           |
//+------------------------------------------------------------------+
class CMarketStructure
{
private:
   ENUM_TIMEFRAMES   m_timeframe;
   int               m_swingPeriod;
   string            m_swingPrefix;
   
   // Kiểm tra swing high
   bool IsSwingHigh(int index)
   {
      int start = index + m_swingPeriod;
      int end = index - m_swingPeriod;
      
      if(start >= Bars(_Symbol, m_timeframe) || end < 0) 
         return false;
         
      double high = iHigh(_Symbol, m_timeframe, index);
      
      // Kiểm tra left side
      for(int i = 1; i <= m_swingPeriod; i++)
      {
         if(iHigh(_Symbol, m_timeframe, index+i) > high) 
            return false;
      }
      
      // Kiểm tra right side
      for(int i = 1; i <= m_swingPeriod; i++)
      {
         if(iHigh(_Symbol, m_timeframe, index-i) > high) 
            return false;
      }
      
      return true;
   }
   
   // Kiểm tra swing low
   bool IsSwingLow(int index)
   {
      int start = index + m_swingPeriod;
      int end = index - m_swingPeriod;
      
      if(start >= Bars(_Symbol, m_timeframe) || end < 0) 
         return false;
         
      double low = iLow(_Symbol, m_timeframe, index);
      
      // Kiểm tra left side
      for(int i = 1; i <= m_swingPeriod; i++)
      {
         if(iLow(_Symbol, m_timeframe, index+i) < low) 
            return false;
      }
      
      // Kiểm tra right side
      for(int i = 1; i <= m_swingPeriod; i++)
      {
         if(iLow(_Symbol, m_timeframe, index-i) < low) 
            return false;
      }
      
      return true;
   }
   
   // Vẽ swing point lên biểu đồ
   void DrawSwingPoint(datetime time, double price, bool isHigh, color clr)
   {
      string name = m_swingPrefix + (isHigh ? "High_" : "Low_") + TimeToString(time);
      
      if(ObjectFind(0, name) < 0)
      {
         if(isHigh)
         {
            ObjectCreate(0, name, OBJ_ARROW_DOWN, 0, time, price);
            ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_TOP);
         }
         else
         {
            ObjectCreate(0, name, OBJ_ARROW_UP, 0, time, price);
            ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_BOTTOM);
         }
         ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
         ObjectSetInteger(0, name, OBJPROP_WIDTH, 2);
         ObjectSetInteger(0, name, OBJPROP_BACK, true);
      }
   }

public:
   // Constructor
   void CMarketStructure(ENUM_TIMEFRAMES tf, int swingPeriod)
   {
      m_timeframe = tf;
      m_swingPeriod = swingPeriod;
      m_swingPrefix = "SWING_" + EnumToString(tf) + "_";
   }
   
   // Lấy các swing points mới nhất
   void GetSwingPoints(SwingPoint &swings[])
   {
      ArrayResize(swings, 0);
      int count = 0;
      int bars = Bars(_Symbol, m_timeframe);
      
      // Chỉ kiểm tra các bar gần nhất để tối ưu
      int checkDepth = m_swingPeriod * 3 + 10;
      if(checkDepth > bars) checkDepth = bars;
      
      for(int i = 1; i < checkDepth; i++)
      {
         if(IsSwingHigh(i))
         {
            count++;
            ArrayResize(swings, count);
            swings[count-1].time = iTime(_Symbol, m_timeframe, i);
            swings[count-1].price = iHigh(_Symbol, m_timeframe, i);
            swings[count-1].isHigh = true;
            
            if(DrawSwingPoints)
               DrawSwingPoint(swings[count-1].time, swings[count-1].price, true, clrRed);
         }
         else if(IsSwingLow(i))
         {
            count++;
            ArrayResize(swings, count);
            swings[count-1].time = iTime(_Symbol, m_timeframe, i);
            swings[count-1].price = iLow(_Symbol, m_timeframe, i);
            swings[count-1].isHigh = false;
            
            if(DrawSwingPoints)
               DrawSwingPoint(swings[count-1].time, swings[count-1].price, false, clrBlue);
         }
      }
   }
};

//+------------------------------------------------------------------+
//| Global Instances                                                 |
//+------------------------------------------------------------------+
CMarketStructure htfMS(HTF, SwingPeriod);
CMarketStructure ltfMS(LTF, SwingPeriod);

//+------------------------------------------------------------------+
//| Expert Initialization Function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Xóa các đối tượng cũ khi backtest
   ObjectsDeleteAll(0, "SWING_");
   
   // Lấy thời gian bar hiện tại
   lastHtfBarTime = iTime(_Symbol, HTF, 0);
   lastLtfBarTime = iTime(_Symbol, LTF, 0);
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert Tick Function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Kiểm tra bar mới trên HTF
   datetime currentHtfTime = iTime(_Symbol, HTF, 0);
   if(currentHtfTime != lastHtfBarTime)
   {
      lastHtfBarTime = currentHtfTime;
      ProcessHTF();
   }
   
   // Kiểm tra bar mới trên LTF
   datetime currentLtfTime = iTime(_Symbol, LTF, 0);
   if(currentLtfTime != lastLtfBarTime)
   {
      lastLtfBarTime = currentLtfTime;
      ProcessLTF();
   }
}

//+------------------------------------------------------------------+
//| Process Higher Timeframe                                         |
//+------------------------------------------------------------------+
void ProcessHTF()
{
   SwingPoint swings[];
   htfMS.GetSwingPoints(swings);
   
   // Đếm số swing point
   int highCount = 0;
   int lowCount = 0;
   for(int i = 0; i < ArraySize(swings); i++)
   {
      if(swings[i].isHigh) highCount++;
      else lowCount++;
   }
   
   Print(StringFormat("HTF: %s Swing Highs: %d, Swing Lows: %d", 
          EnumToString(HTF), highCount, lowCount));
}

//+------------------------------------------------------------------+
//| Process Lower Timeframe                                          |
//+------------------------------------------------------------------+
void ProcessLTF()
{
   SwingPoint swings[];
   ltfMS.GetSwingPoints(swings);
   
   // Đếm số swing point
   int highCount = 0;
   int lowCount = 0;
   for(int i = 0; i < ArraySize(swings); i++)
   {
      if(swings[i].isHigh) highCount++;
      else lowCount++;
   }
   
   Print(StringFormat("LTF: %s Swing Highs: %d, Swing Lows: %d", EnumToString(LTF), highCount, lowCount));
}