//+------------------------------------------------------------------+
//|                                                   MovingStopLoss.mqh |
//|                                                    Michal Futera |
//|                                       https://linktr.ee/mjfutera |
//+------------------------------------------------------------------+
#property copyright "Michal Futera"
#property link      "https://linktr.ee/mjfutera"
#property strict
#property version   "1.01"

//Ruchomy Stop Loss
void MovingSLbyMichal(int enter);
double pips = 1*pow(0.1,Digits);
double price =enter*pips;
double sl_buy = Bid-price;
double sl_sell = Ask+price;

for(int i=0; i<OrdersTotal(); i++) {
  if(OrderSelect(i,SELECT_BY_POS)==true &&
    OrderSymbol()==ChartSymbol()) {
    if(OrderType()==0) {
      if(OrderStopLoss()==0 || OrderStopLoss()<sl_buy) {
        bool Modify = OrderModify(OrderTicket(),OrderOpenPrice(),sl_buy,OrderTakeProfit(),0,clrGreen);
      }
    } else if(OrderType()==1) {
      if(OrderStopLoss()==0 || OrderStopLoss()>sl_sell) {
        bool Modify = OrderModify(OrderTicket(),OrderOpenPrice(),sl_sell,OrderTakeProfit(),0,clrGreen);
      }
    }
  }
}

