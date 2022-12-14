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
void MovingSLbyMichal(int enter) {
  
  double myPips = 1*pow(0.1,Digits);
  double myPrice =enter*myPips;
  double sl_buy = Bid-myPrice;
  double sl_sell = Ask+myPrice;

  for(int i=0; i<OrdersTotal(); i++) {
    if(OrderSelect(i,SELECT_BY_POS)==true && OrderSymbol()==ChartSymbol())  {
      if(OrderType()==0 && (OrderStopLoss()==0 || OrderStopLoss()<sl_buy))  {
        bool Modify = OrderModify(OrderTicket(),OrderOpenPrice(),sl_buy,OrderTakeProfit(),0,clrGreen);
        } else if (OrderType()==1 && (OrderStopLoss()==0 || OrderStopLoss()>sl_sell)) {
        bool Modify = OrderModify(OrderTicket(),OrderOpenPrice(),sl_sell,OrderTakeProfit(),0,clrGreen);
        }
      }
    }
}


