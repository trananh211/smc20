//+------------------------------------------------------------------+
//|                                            Scalping_Robot_V2.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "2.01"

#include <Trade\Trade.mqh>

CTrade                  trade;
CPositionInfo           posinfo;
COrderInfo              ordinfo;

input group "=== Trading Profiles ==="
enum SystemType {Forex=0, BitCoin=1, _Gold=2, US_Indices=3};
input SystemType SType = 0; // Trading system applied (Forex, Crypto, Gold, Indices)
int SysChoice;

input group "=== Common Trading Inputs ==="   
input double                  minVolume                        = 0.01; // Min volume to start
input double                  RiskPercent                      = 2;    // Risk as % of Trading Capital
input ENUM_TIMEFRAMES         Timeframe                        = PERIOD_CURRENT; // Time frame to run
input int                     InpMagic                         = 298347; // EA indentification no
input string                  TradeComment                     = "Scalping Robot"; // Trade Comment

string dotSpace = "----------------------------------------------------";

enum StartHour {Inactive_SH=0, _1_SH=1, _2_SH=2, _3_SH=3, _4_SH=4, _5_SH=5, _6_SH=6, _7_SH=7, _8_SH=8, _9_SH=9, _10_SH=10, _11_SH=11, _12_SH=12, _13_SH=13, _14_SH=14, _15_SH=15, _16_SH=16, _17_SH=17, _18_SH=18, _19_SH=19, _20_SH=20, _21_SH=21, _22_SH=22, _23_SH=23, _24_SH=24 };
input StartHour SHInput = _6_SH; // Start Hour

enum EndHour {Inactive_EH=0, _1_EH=1, _2_EH=2, _3_EH=3, _4_EH=4, _5_EH=5, _6_EH=6, _7_EH=7, _8_EH=8, _9_EH=9, _10_EH=10, _11_EH=11, _12_EH=12, _13_EH=13, _14_EH=14, _15_EH=15, _16_EH=16, _17_EH=17, _18_EH=18, _19_EH=19, _20_EH=20, _21_EH=21, _22_EH=22, _23_EH=23, _24_EH=24 };
input EndHour EHInput = _21_EH; // End Hour

string                        PairCurency;
int                           SHChoice;
int                           EHChoice;
int                           BarsN = 5;
int                           ExpirationBars = 100;
int                           OrderDistPoints= 100;
double                        Tppoints, Slpoints, TslTriggerPoints, TslPoints;
int                           handleRSI, handleMovAvg;

input color                   ChartColorTradingOff             = clrPink;  // Chart color when EA is Inactive
input color                   ChartColorTradingOn              = clrWhite; // Chart color when EA is Active      
bool                          Tradingenabled                   = true;
input bool                    HideIndicators                   = true;     // Hide indicator on Chart?
string                        TradingEnabledComm               = "";

input group "=== Forex Trading Inputs ==="   
input int                     TppointsInput                    = 350; // Take Profit (10 Points = 1 pip)
input int                     SlpointsInput                    = 250; // Stoploss Points (10 Points = 1 pip)
input int                     TslTriggerPointsInput            = 20;  // Points in Profit before Trailing
input int                     TslPointsInput                   = 10;  // Trailing Stoploss Points

input group "=== Cryto Related Inputs ==="   
input double                  TPasPct                          = 0.4; // TP as % of Price
input double                  SLasPct                          = 0.4; // SL as % of Price
input double                  TSLasPctofTP                     = 5;   // Trail SL as % of TP
input double                  TSLTgrasPctofTP                  = 7;   // Trigger of Trail SL % of Tp

input group "=== Gold Related Inputs ==="   
input double                  TPasPctGold                      = 1; // TP as % of Price (Cent) 1 - (Standard) - 1
input double                  SLasPctGold                      = 2.5; // SL as % of Price (Cent) 2.5 - (Standard) - 0.35
input double                  TSLasPctofTPGold                 = 20; // Trail SL as % of TP (Cent) 20 - (Standard) - 10 
input double                  TSLTgrasPctofTPGold              = 30; // Trigger of Trail SL % of Tp (Cent) 30 - (Standard) - 15

input group "=== Indices Related Inputs ==="   
input double                  TPasPctIndices                   = 0.2;
input double                  SLasPctIndices                   = 0.2;
input double                  TSLasPctofTPIndices              = 5;
input double                  TSLTgrasPctofTPIndices           = 7;

input group "=== News Filter ==="
input bool                    NewFilterOn                      = true; // Filter for Level 3 News?
enum                          sep_dropdown{ comma=0, semicolon=1};
input sep_dropdown            separator                        = comma;
input string                  KeyNews                          = "BCB,NFP,JOLTS,Nonfarm,PMI,GDP,Confidence,Interest Rate";
input string                  NewsCurrencies                   = "USD,GBP,EUR,JPY,BRL";
input int                     DaysNewsLookUp                   = 100;
input int                     StopBeforeMin                    = 15;
input int                     StartTradingMin                  = 15;
bool                          TrDisabledNews                   = false;

ushort                        sep_code;
string                        Newstoavoid[];
datetime                      LastNewsAvoided;

input group "=== RSI Filter ==="
input bool                    RSIFilterOn                      = false;
input ENUM_TIMEFRAMES         RSITimeframe                     = PERIOD_H1;
input int                     RSIlowerlvl                      = 20;
input int                     RSIUpperlvl                      = 80;
input int                     RSI_MA                           = 14;
input ENUM_APPLIED_PRICE      RSI_AppPrice                     = PRICE_MEDIAN;

input group "=== Moving Average Filter ==="        
input bool                    MAFilterOn                       = false;
input ENUM_TIMEFRAMES         MATimeframe                      = PERIOD_H4;
input double                  PctPricefromMA                   = 3;
input int                     MA_Period                        = 200;
input ENUM_MA_METHOD          MA_Mode                          = MODE_EMA;
input ENUM_APPLIED_PRICE      MA_AppPrice                      = PRICE_MEDIAN;

input group "=== Only For Tester ==="
input bool exTime = false;
enum ExStartHour {ExInactive_SH=0, _1_ExSH=1, _2_ExSH=2, _3_ExSH=3, _4_ExSH=4, _5_ExSH=5, _6_ExSH=6, _7_ExSH=7, _8_ExSH=8, _9_ExSH=9, _10_ExSH=10, _11_ExSH=11, _12_ExSH=12, _13_ExSH=13, _14_ExSH=14, _15_ExSH=15, _16_ExSH=16, _17_ExSH=17, _18_ExSH=18, _19_ExSH=19, _20_ExSH=20, _21_ExSH=21, _22_ExSH=22, _23_ExSH=23, _24_ExSH=24 };
input ExStartHour ExSHInput = _5_ExSH;
enum ExEndHour {ExInactive_EH=0, _1_ExEH=1, _2_ExEH=2, _3_ExEH=3, _4_ExEH=4, _5_ExEH=5, _6_ExEH=6, _7_ExEH=7, _8_ExEH=8, _9_ExEH=9, _10_ExEH=10, _11_ExEH=11, _12_ExEH=12, _13_ExEH=13, _14_ExEH=14, _15_ExEH=15, _16_ExEH=16, _17_ExEH=17, _18_ExEH=18, _19_ExEH=19, _20_ExEH=20, _21_ExEH=21, _22_ExEH=22, _23_ExEH=23, _24_ExEH=24 };
input ExEndHour ExEHInput = _12_ExEH; 

int ExSHChoice, ExEHChoice;
datetime time_Local, time_server, time_gmt;
string today;
int Hournow;
string _news_text = "";

//+------------------------------------------------------------------+
int OnInit()
{
   trade.SetExpertMagicNumber(InpMagic);
   ChartSetInteger(0, CHART_SHOW_GRID, false);
   ChartSetInteger(0, CHART_AUTOSCROLL, true);
   ChartSetInteger(0, CHART_SHIFT, true);
   ChartSetInteger(0, CHART_MODE, CHART_CANDLES);
   
   
   SHChoice = (int)SHInput;
   EHChoice = (int)EHInput;
   SysChoice = (int)SType;
   if (SysChoice == 0) {
      PairCurency = "Forex";
   } else if (SysChoice == 1) {
      PairCurency = "Bitcoin";
   } else if (SysChoice == 2) {
      PairCurency = "Gold";
   } else if (SysChoice == 3) {
      PairCurency = "US_Indices";
   }
   
   Tppoints = TppointsInput;
   Slpoints = SlpointsInput;
   TslTriggerPoints = TslTriggerPointsInput;
   TslPoints = TslPointsInput;
   
   if(HideIndicators) TesterHideIndicators(true);
   
   handleRSI = iRSI(_Symbol, RSITimeframe, RSI_MA, RSI_AppPrice);
   handleMovAvg = iMA(_Symbol, MATimeframe, MA_Period, 0, MA_Mode, MA_AppPrice);
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {}

void OnTick()
{
   bool accept_trade = true;
   MqlDateTime tm={}, gmt;
   
   time_server = TimeTradeServer(tm);
   time_Local = TimeLocal();
   time_gmt = TimeGMT(tm);
   
   today = EnumToString((ENUM_DAY_OF_WEEK)tm.day_of_week);
   TimeGMT(gmt);
   Hournow = gmt.hour;
   _news_text = "";
   
   TrailStop();
   
   if (IsRSIFilter() || IsUpcomingNews() || IsMAFilter()) {
      CloseAllOrders();
      accept_trade = false;
      Tradingenabled = false;
      ChartSetInteger(0, CHART_COLOR_BACKGROUND, ChartColorTradingOff);
      if (TradingEnabledComm != "Printed") Print(TradingEnabledComm);
      TradingEnabledComm = "Printed";
      return;
   }
   
   Tradingenabled = true;
   accept_trade = true;
   if (TradingEnabledComm != "") {
      Print("Trading is enabled again");
      TradingEnabledComm = "";
   }
   
   ChartSetInteger(0, CHART_COLOR_BACKGROUND, ChartColorTradingOn);
   showTotal();
   
   if(!IsNewBar()) return;
   
   ExSHChoice = (int)ExSHInput;
   ExEHChoice = (int)ExEHInput;
   
   if (exTime) {
      if (Hournow >= ExSHChoice && Hournow <= ExEHChoice) {
         CloseAllOrders(); accept_trade = false; return;
      }
   } else {
      if ((Hournow < SHChoice && SHChoice != 0) || (Hournow >= EHChoice && EHChoice != 0)) {
         CloseAllOrders(); accept_trade = false; return;
      }
   }
   
   // Profile Adjustments
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   if (SysChoice == 1) { // Bitcoin
      Tppoints = ask * TPasPct; Slpoints = ask * SLasPct; OrderDistPoints = (int)(Tppoints/2);
      TslPoints = Tppoints * TSLasPctofTP/100; TslTriggerPoints = Tppoints * TSLTgrasPctofTP/100;
      PairCurency = "Bitcoin";
   } else if (SysChoice == 2) { // Gold
      Tppoints = ask * TPasPctGold; Slpoints = ask * SLasPctGold; OrderDistPoints = (int)(Tppoints/2);
      TslPoints = Tppoints * TSLasPctofTPGold/100; TslTriggerPoints = Tppoints * TSLTgrasPctofTPGold/100;
      PairCurency = "Gold";
   } else if (SysChoice == 3) { // Indices
      Tppoints = ask * TPasPctIndices; Slpoints = ask * SLasPctIndices; OrderDistPoints = (int)(Tppoints/2);
      TslPoints = Tppoints * TSLasPctofTPIndices/100; TslTriggerPoints = Tppoints * TSLTgrasPctofTPIndices/100;
      PairCurency = "Indices";
   }
   
   int BuyTotal = 0, SellTotal = 0;
   for (int i=OrdersTotal()-1; i>=0; i--){ 
      if(ordinfo.SelectByIndex(i) && ordinfo.Symbol() == _Symbol && ordinfo.Magic() == InpMagic){
         ENUM_ORDER_TYPE oType = ordinfo.OrderType();
         if (oType == ORDER_TYPE_BUY_STOP || oType == ORDER_TYPE_BUY_LIMIT) BuyTotal++;
         if (oType == ORDER_TYPE_SELL_STOP || oType == ORDER_TYPE_SELL_LIMIT) SellTotal++;
      }
   }
   for (int i=PositionsTotal()-1; i>=0; i--){
      if(posinfo.SelectByIndex(i) && posinfo.Symbol() == _Symbol && posinfo.Magic() == InpMagic){
         if(posinfo.PositionType() == POSITION_TYPE_BUY) BuyTotal++;
         if(posinfo.PositionType() == POSITION_TYPE_SELL) SellTotal++;
      }
   }
   
   if (accept_trade) {
      if (BuyTotal <= 0) { double high = findHigh(); if (high > 0) SendBuyOrder(high); }
      if (SellTotal <= 0) { double low = findLow(); if (low > 0) SendSellOrder(low); }
   }
}

//+------------------------------------------------------------------+
double findHigh() {
   double highestHigh = 0;
   for(int i = 0; i < 200; i++) {
      double high = iHigh(_Symbol, Timeframe, i);
      if(i > BarsN && iHighest(_Symbol,Timeframe,MODE_HIGH,BarsN*2+1,i-BarsN) == i) {
         if (high > highestHigh) return high;
      }
      highestHigh = MathMax(high, highestHigh);
   }
   return -1;
}

double findLow() {
   double lowestLow = DBL_MAX;
   for(int i = 0; i < 200; i++) {
      double low = iLow(_Symbol, Timeframe, i);
      if(i > BarsN && iLowest(_Symbol,Timeframe,MODE_LOW,BarsN*2+1,i-BarsN) == i) {
         if (low < lowestLow) return low;
      }
      lowestLow = MathMin(low, lowestLow);
   }
   return -1;
}

bool IsNewBar(){
   static datetime previousTime = 0;
   datetime currentTime = iTime(_Symbol, Timeframe, 0);
   if (previousTime != currentTime) { previousTime = currentTime; return true; }
   return false;
}

void SendBuyOrder(double entry) {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if (ask > entry - OrderDistPoints * _Point) return;
   double tp = entry + Tppoints * _Point;
   double sl = entry - Slpoints * _Point;
   double lots = (RiskPercent > 0) ? calcLots(entry - sl) : minVolume;
   datetime expiration = iTime(_Symbol, Timeframe, 0) + ExpirationBars * PeriodSeconds(Timeframe);
   trade.BuyStop(lots, entry, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, expiration);
}

void SendSellOrder(double entry) {
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if (bid < entry + OrderDistPoints * _Point) return;
   double tp = entry - Tppoints * _Point;
   double sl = entry + Slpoints * _Point;
   double lots = (RiskPercent > 0) ? calcLots(sl - entry) : minVolume;
   datetime expiration = iTime(_Symbol, Timeframe, 0) + ExpirationBars * PeriodSeconds(Timeframe);
   trade.SellStop(lots, entry, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, expiration);
}

double calcLots (double slPoints){
   double risk = AccountInfoDouble(ACCOUNT_BALANCE) * RiskPercent / 100;
   double ticksize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tickvalue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE); 
   double lotstep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP); 
   double minvolume = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN); 
   double maxvolume = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double volumelimit = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_LIMIT);
   if (slPoints <= 0) return minvolume;
   double moneyPerLotstep = slPoints / ticksize * tickvalue * lotstep;
   if (moneyPerLotstep <= 0) return minvolume;
   double lots = MathFloor(risk / moneyPerLotstep) * lotstep;
   if(volumelimit!=0) lots = MathMin(lots, volumelimit);
   if(maxvolume!=0) lots = MathMin(lots, maxvolume);
   if(minvolume!=0) lots = MathMax(lots, minvolume); 
   return NormalizeDouble(lots,2);
}

void CloseAllOrders() {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
      if(posinfo.SelectByIndex(i) && posinfo.Magic() == InpMagic && posinfo.Symbol() == _Symbol) { trade.PositionClose(posinfo.Ticket()); Sleep(50); }
   for(int i = OrdersTotal() - 1; i >= 0; i--)
      if(ordinfo.SelectByIndex(i) && ordinfo.Magic() == InpMagic && ordinfo.Symbol() == _Symbol) { trade.OrderDelete(ordinfo.Ticket()); Sleep(50); }
}

void TrailStop() {
   double sl = 0, tp = 0;
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   for (int i = PositionsTotal() - 1; i>=0; i--) {
      if (posinfo.SelectByIndex(i) && posinfo.Magic() == InpMagic && posinfo.Symbol() == _Symbol) {
         ulong ticket = posinfo.Ticket();
         if (posinfo.PositionType() == POSITION_TYPE_BUY) {
            if((bid - posinfo.PriceOpen()) > TslTriggerPoints*_Point) {
               tp = posinfo.TakeProfit(); sl = bid - (TslPoints * _Point);
               if (sl > posinfo.StopLoss() || posinfo.StopLoss() == 0) trade.PositionModify(ticket,sl,tp);
            }
         } else {
            if ((posinfo.PriceOpen() - ask) > TslTriggerPoints * _Point) {
               tp = posinfo.TakeProfit(); sl = ask + (TslPoints * _Point);
               if (sl < posinfo.StopLoss() || posinfo.StopLoss() == 0) trade.PositionModify(ticket,sl,tp);
            }
         }
      }
   }
}

bool IsUpcomingNews() {
   if (!NewFilterOn) return false;
   if (TrDisabledNews && TimeCurrent() - LastNewsAvoided < StartTradingMin*60) return true;
   TrDisabledNews = false;
   string sep = (separator == comma) ? "," : ";";
   sep_code = StringGetCharacter(sep,0);
   int k = StringSplit(KeyNews, sep_code, Newstoavoid);
   MqlCalendarValue values[];
   datetime starttime = TimeCurrent();
   datetime endtime = starttime + 86400 * DaysNewsLookUp;
   CalendarValueHistory(values, starttime, endtime, NULL, NULL);
   for(int i=0; i<ArraySize(values); i++) {
      MqlCalendarEvent event; CalendarEventById(values[i].event_id, event);
      MqlCalendarCountry country; CalendarCountryById(event.country_id, country);
      if(StringFind(NewsCurrencies, country.currency) < 0) continue;
      for(int j=0; j<k; j++) {
         if (StringFind(event.name, Newstoavoid[j]) >= 0) {
            _news_text += "Next News: " + country.currency + ": " + event.name + " -> " + (string)values[i].time + "\n";
            if (values[i].time - starttime < StopBeforeMin*60) {
               LastNewsAvoided = values[i].time; TrDisabledNews = true;
               TradingEnabledComm = "Trading disabled due to: " + event.name;
               return true;
            }
         }
      }
   }
   return false;
}

bool IsRSIFilter() {
   if (!RSIFilterOn) return false;
   double RSI[]; CopyBuffer(handleRSI, 0, 0, 1, RSI);
   if (RSI[0] > RSIUpperlvl || RSI[0] < RSIlowerlvl) {
      TradingEnabledComm = "Trading disabled: RSI filter"; return true;
   }
   return false;
}

bool IsMAFilter() {
   if (!MAFilterOn) return false;
   double MovAvg[]; CopyBuffer(handleMovAvg, 0, 0, 1, MovAvg);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   if (ask > MovAvg[0] * (1 + PctPricefromMA/100) || ask < MovAvg[0] * (1 - PctPricefromMA/100)) {
      TradingEnabledComm = "Trading disabled: MA filter"; return true;
   }
   return false;
}

double showTotal() {
   int solenhbuy = 0, solenhsell = 0;
   double profit = 0, lotBuy = 0, lotSell = 0;
   double spread = SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   // Profile Adjustments
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   if (SysChoice == 1) { // Bitcoin
      Tppoints = ask * TPasPct; Slpoints = ask * SLasPct; OrderDistPoints = (int)(Tppoints/2);
      TslPoints = Tppoints * TSLasPctofTP/100; TslTriggerPoints = Tppoints * TSLTgrasPctofTP/100;
      PairCurency = "Bitcoin";
   } else if (SysChoice == 2) { // Gold
      Tppoints = ask * TPasPctGold; Slpoints = ask * SLasPctGold; OrderDistPoints = (int)(Tppoints/2);
      TslPoints = Tppoints * TSLasPctofTPGold/100; TslTriggerPoints = Tppoints * TSLTgrasPctofTPGold/100;
      PairCurency = "Gold";
   } else if (SysChoice == 3) { // Indices
      Tppoints = ask * TPasPctIndices; Slpoints = ask * SLasPctIndices; OrderDistPoints = (int)(Tppoints/2);
      TslPoints = Tppoints * TSLasPctofTPIndices/100; TslTriggerPoints = Tppoints * TSLTgrasPctofTPIndices/100;
      PairCurency = "Indices";
   }
   
   string text = "Today is "+ today +"\n" +
         "Local Time  = "+ (string)time_Local + "\n"+
         "GMT Time    = "+  (string)time_gmt +"\n"+
         "Pair: System = "+_Symbol+" + Selected: = "+PairCurency+" - Spread = "+ DoubleToString(spread, Digits()) +"\n"+
         "Risk: " + (string)((RiskPercent > 0) ? (string)RiskPercent + "%" : "Fixed Lot") +  " - 1 point = " + (string)_Point +"\n"+
         "TP Point = " + DoubleToString((Tppoints * _Point), _Digits) + " - SL Point = "+ DoubleToString((Slpoints * _Point), _Digits) + "\n"+
         "Price move : "+ DoubleToString((TslTriggerPoints*_Point), _Digits) + " with Entry. Begin Trailing with "+ DoubleToString((TslPoints * _Point), _Digits) + "\n"+
         dotSpace+ "\n";

   for(int i=0; i<PositionsTotal(); i++) {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket) && PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == InpMagic) {
         ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         if(type == POSITION_TYPE_BUY) { solenhbuy++; lotBuy += PositionGetDouble(POSITION_VOLUME); }
         else { solenhsell++; lotSell += PositionGetDouble(POSITION_VOLUME); }
         profit += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      }
   }
   string _text = "Positions Buy/Sell: " + (string)solenhbuy + "/" + (string)solenhsell + "\n" +
                  "Profit: " + DoubleToString(profit, 2) + "\n" +
                  "Equity: " + DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY), 2);
   Comment(_text + "\n" + dotSpace + "\n" + text + _news_text);
   return profit;
}