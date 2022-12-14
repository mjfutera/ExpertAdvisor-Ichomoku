//+------------------------------------------------------------------+
//|                                           Ichimoku by Michal.mq4 |
//|                                                    Michal Futera |
//|                                       https://linktr.ee/mjfutera |
//+------------------------------------------------------------------+
#property copyright "Michal Futera"
#property link      "https://linktr.ee/mjfutera"
#property version   "1.01"
#property strict
#include <../biblioteka.mqh>
#include <../MovingStopLoss.mqh>

//Wartości wejściowe
input int max_pozycji = 3; //Maksymalna ilość wszystkich pozycji
input double max_margin_level = 6;//Minimalny Margin Level - znaleźć funkcję do wyświetlania
enum inter
  {
   A=PERIOD_M1, //Jednom inutowy
   B=PERIOD_M5, //Pięcio minutowy
   C=PERIOD_M15, //Piętnasto minutowy
   D=PERIOD_M30, //Trzydziesto minutowy
   E=PERIOD_H1, //Jedno godzinny
   F=PERIOD_H4, //Cztero godzinny
   G=PERIOD_D1, //Dzienny
   H=PERIOD_W1, //Tygodniowy
   I=PERIOD_MN1 //Miesięczny
  };
input inter interwal=D; //Interwał
input int tenk=9; //Tenkan Sen
input int kiju=26; //Kijun Sen
input int chik=26; //Chikou Span
input int spanA=26; //Span A - Okresy do przodu
input int spanB=52; //Span B - Okresy do tyłu
input int MaxOrders=1; //Maksymalna ilość transakcji na raz
input int SL=300; //Wielkość Stop Loss
input int TP=800;//Wielkość Take Profit
input int sec=1800; // Minimalna przerwa między zmaówieniami w sekundach
double SpanA_table[40];
double SpanB_table[40];
double Chikou_table[40];
double TenkanSen_table[40];
double KijunSen_table[40];
enum Moving
  {
   No,   //Nie
   Yes  //Tak
  };
input Moving StopLoss=Yes; //Moving Stop Loss


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   /*Zapełnia tabele wartościami Ichimoku*/
   for(int i=0; i<30; i++)
     {
      SpanA_table[i]=iIchimoku(ChartSymbol(),interwal,tenk,kiju,spanB,MODE_SENKOUSPANA,i);//Chmura
      SpanB_table[i]=iIchimoku(ChartSymbol(),interwal,tenk,kiju,spanB,MODE_SENKOUSPANB,i);//Chmura
      Chikou_table[i]=iIchimoku(ChartSymbol(),interwal,tenk,kiju,spanB,MODE_CHIKOUSPAN,i);//Filtr
      TenkanSen_table[i]=iIchimoku(ChartSymbol(),interwal,tenk,kiju,spanB,MODE_TENKANSEN,i);//Ma się przeciąć z KijunSen
      KijunSen_table[i]=iIchimoku(ChartSymbol(),interwal,tenk,kiju,spanB,MODE_KIJUNSEN,i);//Ma się przeciąć z TenkanSen
     }

   /*Oblicza wielkość dla otwieranej pozycji*/
   double Size = VolumeSizeByMichal(MaxOrders);

   /*Pokazuje stan ceny wg. chumry Ichimoku*/
   int PriceStatus = PriceInIchimokuCloud(interwal,tenk,kiju,spanB,0);

   /*Czy minęła godzina od ostatniego zamówienia*/
   bool OkToOpen = GoodToOpen(interwal,0,sec);

   /*Właściwy skrypt*/
   if(PriceStatus==2 && AboveCloud()==true && Piatek20()==false && OkToOpen==true && IchimokuFilter()==2)//Powyżej chmury - status 2 - kupno
     {
      if(MaxOrdersByMichal(OP_BUY)==0 && MaxOrdersByMichal(OP_SELL)==0)
        {
         //--- obliczyć ceny stoploss i takeprofit
         double LevelStopLoss   = Ask - (SL * _Point);
         double LevelTakeProfit = Ask + (TP * _Point);
         //--- znormalizować ceny
         LevelStopLoss   = NormalizeDouble(LevelStopLoss, _Digits);
         LevelTakeProfit = NormalizeDouble(LevelTakeProfit, _Digits);
         int OrderIsOpened = OrderSend(NULL,OP_BUY,Size,Ask,2,LevelStopLoss,LevelTakeProfit,NULL,0,0,clrNONE);
         SendNotification("Otwarto zlecenie typu "+DoubleToStr(OrderType(),0)+" o numerze "+DoubleToStr(OrderTicket(),0));
         }
     }
   else
      if(PriceStatus==3 && BelowCloud()==true && Piatek20()==false && OkToOpen==true && IchimokuFilter()==3)//Poniżej chmury - status 3 - sprzedaż
        {
         if(MaxOrdersByMichal(OP_BUY)==0 && MaxOrdersByMichal(OP_SELL)==0)
         {
         double LevelStopLoss   = Bid + (SL * _Point);
         double LevelTakeProfit = Bid - (TP * _Point);
         //--- znormalizować ceny
         LevelStopLoss   = NormalizeDouble(LevelStopLoss, _Digits);
         LevelTakeProfit = NormalizeDouble(LevelTakeProfit, _Digits);
         int OrderIsOpened = OrderSend(NULL,OP_SELL,Size,Bid,2,LevelStopLoss,LevelTakeProfit,NULL,0,0,clrNONE);
         }
        }

   /*Moving StopLoss aktywacja*/
   if(StopLoss == Yes)
     {
      MovingSLbyMichal(SL);
     }

   /*Piątek 20 - zamykanie zleceń*/
   if(Piatek20()==true)
     {
      CloseOrdersByMichal(5);
     }
//Komentarz po prawej u góry
   string prices="";
   string Okey="";
   string piatek="";
   if(PriceStatus==1)
     {
      prices = "Cena w chmurze";
     }
   else
      if(PriceStatus==2)
        {
         prices = "Cena powyżej chmury";
        }
      else
         if(PriceStatus==3)
           {
            prices = "Cena poniżej chmury";
           }
   if(OkToOpen==true)
     {
      Okey="Tak";
     }
   else
      if(OkToOpen==false)
        {
         Okey="Nie";
        }
   if(Piatek20()==true)
     {
      piatek="Tak";
     }
   else
      if(Piatek20()==false)
        {
         piatek="Nie";
        }
   Comment(
      "Wielkość pozycji to "+DoubleToStr(Size,2)+"\n"+
      prices+"\n"+
      "Czy minęło "+DoubleToStr(sec,0)+" sekund "+Okey+"\n"+
      "Piątek 20 "+piatek
   );

  }
//+------------------------------------------------------------------+
bool Piatek20() // Nie otwieraj w piątek po 20 - Ichimoku by Michal
  {
   if(DayOfWeek()==5 && Hour()>=20)
     {
      bool v1=true;
      return (v1);
     }
   else
     {
      bool v1=false;
      return (v1);
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
bool BelowCloud() //Poniżej chmury
  {
   bool JestOk=false;
   if(KijunSen_table[0]<TenkanSen_table[0])
     {
      for(int i=0; i<5; i++)
        {
         if(KijunSen_table[i]<TenkanSen_table[i])//Już przecięciu
           {
            JestOk=false;
            break;
           }
         else
            if(KijunSen_table[i]==TenkanSen_table[i])
              {
               continue;
              }
            else
               if(KijunSen_table[i]>TenkanSen_table[i])
                 {
                  JestOk=true;
                  break;
                 }
        }
     }
   return(JestOk);
  }
//+------------------------------------------------------------------+
bool AboveCloud() //Powyżej chmury
  {
   bool JestOk=false;
   if(KijunSen_table[0]>TenkanSen_table[0])
     {
      for(int i=0; i<5; i++)
        {
         if(KijunSen_table[i]>TenkanSen_table[i])//Już przecięciu
           {
            JestOk=false;
            break;
           }
         else
            if(KijunSen_table[i]==TenkanSen_table[i])
              {
               continue;
              }
            else
               if(KijunSen_table[i]<TenkanSen_table[i])
                 {
                  JestOk=true;
                  break;
                 }
        }
     }
   return(JestOk);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

int IchimokuFilter()
{
   int status=0;
   if(TenkanSen_table[26]>Chikou_table[0]>KijunSen_table[26]||TenkanSen_table[26]<Chikou_table[0]<KijunSen_table[26])//Filtr w chmurze
     {
      status=1;
     }
   else if(Chikou_table[0]>KijunSen_table[26]>TenkanSen_table[26]||Chikou_table[0]>TenkanSen_table[26]>KijunSen_table[26])//Filtr powyżej chmury
          {
           if(Chikou_table[1]<KijunSen_table[27]<TenkanSen_table[27]||Chikou_table[1]<TenkanSen_table[27]<KijunSen_table[27])
             {
              status=2;
             }
          }
          else if(Chikou_table[0]<KijunSen_table[26]<TenkanSen_table[26]||Chikou_table[0]<TenkanSen_table[26]<KijunSen_table[26])//Filtr poniżej chmury
                 {
                  if(Chikou_table[1]>KijunSen_table[27]>TenkanSen_table[27]||Chikou_table[1]>TenkanSen_table[27]>KijunSen_table[27])
                    {
                     status=3;
                    }
                 }
    return(status);
}