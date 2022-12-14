//+------------------------------------------------------------------+
//|                                                   biblioteka.mqh |
//|                                                    Michal Futera |
//|                                       https://linktr.ee/mjfutera |
//+------------------------------------------------------------------+
#property copyright "Michal Futera"
#property link      "https://linktr.ee/mjfutera"
#property strict
#property version   "1.01"
//+------------------------------------------------------------------+
//Średnia cena świecy
double MiddlePricebyMichal(int bar)
  {
   double ope=Open[bar];
   double clo=Close[bar];
   double ext = (ope+clo)/2;
   return(ext);
  }

//+------------------------------------------------------------------+
//Typ świecy
int CandleTypeByMichal(int enter)
  {
   int bar = enter;
   double ope=Open[bar];
   double clo=Close[bar];
   if(ope>clo)  //świeca spadkowa (czarna)
     {
      int exit=1;
      return(exit);
     }
   else
      if(ope<clo)  //świeca wzrostowa (biała)
        {
         int exit=2;
         return(exit);
        }
      else //krzyż
        {
         int exit=3;
         return(exit);
        }

  }
//+------------------------------------------------------------------+
//Wielkość Pozycji
double VolumeSizeByMichal(int enter)
  {
   double v_1=AccountBalance(); //pobierz wartość konta
   double v_2=MathFloor(v_1); // zaokrąglenie w dół
   double v_3=v_2/100;
   double v_4=v_3/enter;//całkoita wielkość wszystkich pozycji
   double v_5=MathFloor(v_4)*0.01;
   return(v_5);
  }
//+------------------------------------------------------------------+
//Czy cena jest w chmurze Ichimoku
int PriceInIchimokuCloud(int period, int tenkan, int kijun, int spanbb, int swieca)
  {
   double SpanA = iIchimoku(ChartSymbol(),period,tenkan,kijun,spanbb,MODE_SENKOUSPANA,swieca);
   double SpanB = iIchimoku(ChartSymbol(),period,tenkan,kijun,spanbb,MODE_SENKOUSPANB,swieca);
   if(SpanA>Close[swieca] && SpanB>Close[swieca])
     {
      return(3); //Cena poniżej chmury - wartość 3
     }
   else
      if(Close[swieca]>SpanA && Close[swieca]>SpanB)
        {
         return(2); //Cena powyżej chmury - wartość 2
        }
      else
        {
         return(1); //Cena w chmurze - wartość 1
        }

  }

//+------------------------------------------------------------------+
//Zamykanie zleceń
void CloseOrdersByMichal(int type)
  {
   int orders=OrdersTotal(); //Ilość wszystkich aktywnych zleceń
   if(orders>0)//
     {
      if(type==1) //Wszystkie kupna z wykresu
        {
         for(int i=OrdersTotal()-1; i>=0; i--)//Przegląda każdą pozycję
           {
            if(OrderSelect(i,SELECT_BY_POS)==true)//Przetwarza konkretną pozycję
              {
               if(OrderSymbol()==ChartSymbol())//Czy pozycja jest z tego wykresu
                 {
                  if(OrderType()==OP_BUY)
                    {
                     bool ClosedOrder = OrderClose(OrderTicket(),OrderLots(),Bid,2,clrNONE);
                     if(!ClosedOrder)
                       {
                        Alert("Error "+DoubleToStr(GetLastError(),0));
                       }
                    }
                  else
                    {
                     Alert("Error "+DoubleToStr(GetLastError(),0));
                    }
                 }
               else
                 {
                  Alert("Error "+DoubleToStr(GetLastError(),0));
                 }
              }
            else
              {
               Alert("Error "+DoubleToStr(GetLastError(),0));
              }
           }

        }
      else
         if(type==2) //Wszytkie sprzedaży z wykresu
           {
            for(int i=OrdersTotal()-1; i>=0; i--)//Przegląda każdą pozycję
              {
               if(OrderSelect(i,SELECT_BY_POS)==true)//Przetwarza konkretną pozycję
                 {
                  if(OrderSymbol()==ChartSymbol())//Czy pozycja jest z tego wykresu
                    {
                     if(OrderType()==OP_SELL)
                       {
                        bool ClosedOrder = OrderClose(OrderTicket(),OrderLots(),Ask,2,clrNONE);
                        if(!ClosedOrder)
                          {
                           Alert("Error "+DoubleToStr(GetLastError(),0));
                          }
                       }
                     else
                       {
                        Alert("Error "+DoubleToStr(GetLastError(),0));
                       }
                    }
                  else
                    {
                     Alert("Error "+DoubleToStr(GetLastError(),0));
                    }
                 }
               else
                 {
                  Alert("Error "+DoubleToStr(GetLastError(),0));
                 }
              }
           }
         else
            if(type==3) //Wszystkie zyskowne z wykresu
              {
               for(int i=OrdersTotal()-1; i>=0; i--)//Przegląda każdą pozycję
                 {
                  if(OrderSelect(i,SELECT_BY_POS)==true)//Przetwarza konkretną pozycję
                    {
                     if(OrderSymbol()==ChartSymbol())//Czy pozycja jest z tego wykresu
                       {
                        if(OrderProfit()>0)//Czy jest zysk
                          {
                           if(OrderType()==OP_SELL)
                             {
                              bool ClosedOrder = OrderClose(OrderTicket(),OrderLots(),Ask,2,clrNONE);
                              if(!ClosedOrder)
                                {
                                 Alert("Error "+DoubleToStr(GetLastError(),0));
                                }
                             }
                           else
                              if(OrderType()==OP_BUY)
                                {
                                 bool ClosedOrder = OrderClose(OrderTicket(),OrderLots(),Bid,2,clrNONE);
                                 if(!ClosedOrder)
                                   {
                                    Alert("Error "+DoubleToStr(GetLastError(),0));
                                   }
                                }
                              else
                                {
                                 Alert("Error "+DoubleToStr(GetLastError(),0));
                                }
                          }
                        else
                          {
                           Alert("Error "+DoubleToStr(GetLastError(),0));
                          }
                       }
                     else
                       {
                        Alert("Error "+DoubleToStr(GetLastError(),0));
                       }
                    }
                  else
                    {
                     Alert("Error "+DoubleToStr(GetLastError(),0));
                    }
                 }
              }
            else
               if(type==4) //Wszystkie stratne z wykresu
                 {
                  for(int i=OrdersTotal()-1; i>=0; i--)//Przegląda każdą pozycję
                    {
                     if(OrderSelect(i,SELECT_BY_POS)==true)//Przetwarza konkretną pozycję
                       {
                        if(OrderSymbol()==ChartSymbol())//Czy pozycja jest z tego wykresu
                          {
                           if(OrderProfit()<0)//Czy jest zysk
                             {
                              if(OrderType()==OP_SELL)
                                {
                                 bool ClosedOrder = OrderClose(OrderTicket(),OrderLots(),Ask,2,clrNONE);
                                 if(!ClosedOrder)
                                   {
                                    Alert("Error "+DoubleToStr(GetLastError(),0));
                                   }
                                }
                              else
                                 if(OrderType()==OP_BUY)
                                   {
                                    bool ClosedOrder = OrderClose(OrderTicket(),OrderLots(),Bid,2,clrNONE);
                                    if(!ClosedOrder)
                                      {
                                       Alert("Error "+DoubleToStr(GetLastError(),0));
                                      }
                                   }
                                 else
                                   {
                                    Alert("Error "+DoubleToStr(GetLastError(),0));
                                   }
                             }
                           else
                             {
                              Alert("Error "+DoubleToStr(GetLastError(),0));
                             }
                          }
                        else
                          {
                           Alert("Error "+DoubleToStr(GetLastError(),0));
                          }
                       }

                    }

                 }
               else
                  if(type==5) //Wszystkie w ogóle z wykresu
                    {
                     for(int i=OrdersTotal()-1; i>=0; i--)//Przegląda każdą pozycję
                       {
                        if(OrderSelect(i,SELECT_BY_POS)==true)//Przetwarza konkretną pozycję
                          {
                           if(OrderSymbol()==ChartSymbol())//Czy pozycja jest z tego wykresu
                             {
                              if(OrderType()==OP_SELL)
                                {
                                 bool ClosedOrder = OrderClose(OrderTicket(),OrderLots(),Ask,2,clrNONE);
                                 if(!ClosedOrder)
                                   {
                                    Alert("Error "+DoubleToStr(GetLastError(),0));
                                   }
                                }
                              else
                                 if(OrderType()==OP_BUY)
                                   {
                                    bool ClosedOrder = OrderClose(OrderTicket(),OrderLots(),Bid,2,clrNONE);
                                    if(!ClosedOrder)
                                      {
                                       Alert("Error "+DoubleToStr(GetLastError(),0));
                                      }
                                   }
                             }
                          }
                       }
                    }
                  else
                     if(type==6) //Wszystkie w ogóle na raz
                       {
                        for(int i=OrdersTotal()-1; i>=0; i--)//Przegląda każdą pozycję
                          {
                           if(OrderSelect(i,SELECT_BY_POS)==true)//Przetwarza konkretną pozycję
                             {
                              if(OrderType()==OP_SELL)
                                {
                                 bool ClosedOrder = OrderClose(OrderTicket(),OrderLots(),Ask,2,clrNONE);
                                 if(!ClosedOrder)
                                   {
                                    Alert("Error "+DoubleToStr(GetLastError(),0));
                                   }
                                }
                              else
                                 if(OrderType()==OP_BUY)
                                   {
                                    bool ClosedOrder = OrderClose(OrderTicket(),OrderLots(),Bid,2,clrNONE);
                                    if(!ClosedOrder)
                                      {
                                       Alert("Error "+DoubleToStr(GetLastError(),0));
                                      }
                                   }
                             }
                          }
                       }
                     else
                       {
                        Alert("Błąd numer 1 dla typu zamykanych danych. Kod błedu to:"+DoubleToStr(GetLastError(),0));
                       }
     }

  }
//+------------------------------------------------------------------+
//Max Orders by Michał - Zwraca ilość otwartych zleceń dla wykresu wg typu
int MaxOrdersByMichal(int order_type)
  {
   int MaximumOrders=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==ChartSymbol() && OrderType()==order_type)
           {
            MaximumOrders = MaximumOrders+1;
            continue;
           }
        }
     }
   return(MaximumOrders);
  }
//+------------------------------------------------------------------+
double PipsToPriceByMichal(int myPips)
  {
   double v1 = 1*pow(0.1,Digits);
   double myPrice =v1*myPips;
   return(myPrice);
  }
//+------------------------------------------------------------------+
/*void CountBarsByMichal(int bar)
  {
   for(int i=0; i<=bar; i++)
     {
      datetime Date = iTime(NULL,0,i);
      string text = DoubleToString(i,0);
      bool counted = ObjectCreate(NULL,text,OBJ_TEXT,0,Date,High[i]+0.005);
     }
   for(int i=0; i<bar; i++)
     {
      string text = DoubleToString(i,0);
      bool named = ObjectSetText(i,text,0,NULL,clrNONE);
     }
  }
  */
//+------------------------------------------------------------------+
datetime LastOrder()
  {
   datetime to_return=0;
   for(int i=OrdersHistoryTotal(); i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
        {
         if(OrderSymbol()==ChartSymbol())
           {
            to_return = OrderCloseTime();
            break;
           }
        }
     }
   return(to_return);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GoodToOpen(int period, int shift, int seconds)
  {
   bool ok=false;
   datetime last_order = LastOrder();
   int last_order_int = (int)last_order;
   datetime bar = iTime(ChartSymbol(),period,shift);
   int bar_int = (int)bar;
   if(last_order_int<(bar_int-seconds))
     {
      ok=true;
     }
     else
       {
        ok=false;
       }
   return(ok);
  }
  
//+------------------------------------------------------------------+
