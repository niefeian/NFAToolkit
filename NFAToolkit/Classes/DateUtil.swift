//
//  DateUtil.swift
//  Pods-Tools_Example
//
//  Created by 聂飞安 on 2019/8/15.
//


import Foundation

@objc open class DateUtil : NSObject {
      

      /// 时间差：客户端与服务器的时间差,采用服务端-客户端
      fileprivate static var timediff : TimeInterval = 0
      
      open class func calcTimeDiff(_ servtime : Double, beginCall : Double) {
          let client_seconds = Date().timeIntervalSince1970 * 1000
          timediff = servtime - beginCall - (client_seconds - beginCall) / 2
      }
      
      /// 获取到1970年的时间差。注意，这个独立成一个方法主要是需要包含服务端与客户端的时间差
      open class func getTimeSince1970() -> TimeInterval {
          //+客户端与服务端时间差
          return Date().timeIntervalSince1970 + timediff/1000
      }
      
      open class func getTimeStamp() -> TimeInterval {
          return Date().timeIntervalSince1970 * 1000 + timediff
      }
      
      /// 当前时间。加上了客户端与服务端的时间差
      open class func curDate() -> Date {
          return Date(timeIntervalSince1970: getTimeSince1970())
      }
      
      /// 2016年起点
      open class func time2016() -> Date {
          return dateTimeFromStr("2015-01-01 00:00:00")
      }
      
      /// 获取年月日...秒的时间
      open class func dateTimeToStr(_ date : Date) -> String {
          
          return formatDateToStr(date, format: "yyyy-MM-dd HH:mm:ss")
      }
      
      
      open class func dateTimeToStr2(_ date : Date) -> String {
          
          return formatDateToStr(date, format: "yyyy年MM月dd日 HH:mm:ss")
      }
      
      
      /// 获取年月日的时间
      open class func dateToStr(_ date : Date) -> String {
          return formatDateToStr(date, format: "yyyy-MM-dd")
      }
    
    
    open class func  deltasCalculated(_ maxDate : Date , _ date : Date) -> (Int,Int,Int) {
        
        let dateStrings = dateToStr(date).components(separatedBy: "-")
        let maxdateStrings = dateToStr(maxDate).components(separatedBy: "-")
        if dateStrings.count == 3
        {
            let oldYear = Int(dateStrings[0]) ?? 2020
            let oldMonth = Int(dateStrings[1]) ?? 1
            let oldDay = Int(dateStrings[2]) ?? 2
            
            var maxYear = Int(maxdateStrings[0]) ?? 2020
            var maxMonth = Int(maxdateStrings[1]) ?? 1
            let maxDay = Int(maxdateStrings[2]) ?? 2
            
            var dayNum = 0
            var monthNum = 0
            if maxDay < oldDay
            {
                dayNum = maxDay + reDayCount(maxYear, maxMonth) - oldDay
                maxMonth -= 1
            }
            else
            {
               dayNum = maxDay - oldDay
            }
            
            if maxMonth < oldMonth
            {
                 monthNum = maxMonth - oldMonth + 12
                maxYear -= 1
            }
            else
            {
              monthNum = maxMonth - oldMonth
            }
            
            return (maxYear-oldYear,monthNum,dayNum)
            
        }
        return (0,0,0)
    }
    
    open class func getYMD(_ date : Date) -> (Int,Int,Int) {
        let dateStrings = dateToStr(date).components(separatedBy: "-")
        if dateStrings.count == 3
        {
            let oldYear = Int(dateStrings[0]) ?? 2020
            let oldMonth = Int(dateStrings[1]) ?? 1
            let oldDay = Int(dateStrings[2]) ?? 2
            return (oldYear,oldMonth,oldDay)
        }
         return (2020,1,1)
    }
    
    open class func addDateToStr(_ date : Date , year : Int = 0, month : Int = 0 , day : Int = 0 ) -> Date {
        let dateStrings = dateToStr(date).components(separatedBy: "-")
        if dateStrings.count == 3
        {
             var oldYear = Int(dateStrings[0]) ?? 2020
             var oldMonth = Int(dateStrings[1]) ?? 1
             let oldDay = Int(dateStrings[2]) ?? 2
            
            //日期转换成增加了多少的年月日
            func dayCarry(_ surplusDay : Int , carryMonth : Int = 0 , carryYear : Int = 0)->(Int,Int,Int)
            {
                if surplusDay > 0 && reDayCount(oldYear+carryYear, oldMonth+carryMonth) < surplusDay
                {
                    return dayCarry(surplusDay - reDayCount(oldYear+carryYear, oldMonth+carryMonth), carryMonth: carryMonth + 1, carryYear: carryYear + 1)
                }
                else
                {
                    return (surplusDay,carryMonth,carryYear)
                }
            }
            
            let days = dayCarry(oldDay+day, carryMonth: 0, carryYear: 0)
            let maxMonth = oldMonth + days.1 + month
            oldMonth = (maxMonth - 1 )%12 + 1
            oldYear = Int(floor(Double(maxMonth/12))) + year + oldYear
            return dateFromStr("\(oldYear)-\(getDayString(oldMonth))-\(getDayString(days.0))")
        }
        return date
    }
    
    
    open class func getDayString(_ day : Int) -> String {
        return day < 10 ?  "0\(day)" : "\(day)"
    }
    
    
    //根据年月获得当月共多少天
       
      
      open class func dateToStrCN(_ date : Date) -> String {
          return formatDateToStr(date, format: "yyyy年MM月dd")
      }
      
      open class func dateToStrCNM(_ date : Date) -> String {
          
          return formatDateToStr(date, format: "yyyy年MM月")
      }
      
      /// 获取格式化的日期
     @objc open class func formatDateToStr(_ date : Date, format : String) -> String {
          let df = DateFormatter()
          df.dateFormat = format
          return df.string(from: date)
      }
      
      /// 文本转时间
      open class func dateTimeFromStr(_ strDate : String) -> Date {
          return formatStrToDate(strDate, format: "yyyy-MM-dd HH:mm:ss")
      }
      
      open class func dateTimeFromStrCND(_ strDate : String) -> Date {
          return formatStrToDate(strDate, format: "yyyy年MM月dd")
      }
      
      open class func dateFromStr(_ strDate : String) -> Date {
          return formatStrToDate(strDate, format: "yyyy-MM-dd")
      }
      
    @objc open class func formatStrToDate(_ strDate : String, format : String) -> Date {
          let fmt = DateFormatter()
          fmt.dateFormat = format
          return fmt.date(from: strDate)!
      }
      
           /// 转换秒成时间格式
      open class func transTimeIntervalToYYYYMMDD(_ curTimes : TimeInterval , showAll : Bool = false) -> String{
            let h = Int(curTimes / 3600)
            var t = ""
            if h > 0 {
                if h > 0 && h < 10 {
                    t = "0\(h):"
                } else {
                    t = "\(h):"
                }
            }
            else if showAll
            {
               t = "00:"
            }
            let min = Int((Int(curTimes) - h * 3600) / 60)
            if min > 0 {
                if min < 10 {
                    t += "0\(min):"
                } else {
                    t += "\(min):"
                }
            } else if t != "" {
                t += "00:"
            }
            
            let sec = Int(curTimes.truncatingRemainder(dividingBy: 60))
            if sec > 0 {
                if sec < 10 {
                    t += "0\(sec)"
                } else {
                    t += "\(sec)"
                }
            } else if t != "" {
                t += "00"
            }
            return t
        }
      
      /// 获取显示的时间：传入毫秒数
      open class func getShowTimeWithMillisecond(_ toTime : Double) -> String{
          return getShowTime(toTime / 1000)
      }
      
      /// 传入秒数
      open class func getShowTime(_ toTime : Double, simpleDateFormat : String = "MM/dd") -> String{
          // 比较时间
          let toDateTime = Date(timeIntervalSince1970: toTime)
          let toDate = DateUtil.formatDateToStr(toDateTime, format : "yyyy/MM/dd")
          // 当前日期
          let curDateTime = DateUtil.curDate()
          let curDate = DateUtil.formatDateToStr(curDateTime, format : "yyyy/MM/dd")
          
          if toDate == curDate {
              // 同一天
              return DateUtil.formatDateToStr(toDateTime, format : "HH:mm")
          } else {
              if (toDate.prefix(5) == curDate.prefix(5)) {
                  // 同一年
                  return DateUtil.formatDateToStr(toDateTime, format : simpleDateFormat)
              } else {
                  return toDate
              }
          }
      }
      
      
    /// 获得显示显示：原始格式：yyyyMMddHHmmss。
    /// 刚刚、xx分钟前、xx小时前、同一年的显示月-日，最后yyyy/MM/dd
    @objc open class func getShowTime2(_ time : String, format : String = "yyyyMMddHHmmss") -> String{
        let dateTime = DateUtil.formatStrToDate(time, format: format)
        return showTime(forTimeDate: dateTime)
    }
    
    
    @objc open class func showTime(timeTimeInterval : Double) -> String{
        let dateTime = Date.init(timeIntervalSince1970: TimeInterval(timeTimeInterval))
        return showTime(forTimeDate: dateTime)
    }
    
    @objc open class func showTime(forTimeDate : Date) -> String{
        
        let curDate = DateUtil.formatDateToStr(forTimeDate, format : "yyyy/MM/dd")
        let today = DateUtil.curDate()
        let date = DateUtil.formatDateToStr(today, format : "yyyy/MM/dd")
        var ret : String!
        if date == curDate {
            let oldTime = forTimeDate.timeIntervalSince1970
            let nowTime = getTimeSince1970()
            let sub = nowTime - oldTime
            if sub < 60 {
                ret = "刚刚"
            } else if sub < 60 * 60 {
                ret = "\(Int(sub / 60))分钟前"
            } else {
                ret = "\(Int(sub / 3600))小时前"
            }
        } else {
            if (date.prefix(5) == curDate.prefix(5)) {
                ret = DateUtil.formatDateToStr(forTimeDate, format : "MM-dd")
            } else {
                ret = curDate
            }
        }
        return ret
    }
    
      
      /// 返回MM-dd HH:mm 格式
      open class func getShowDateTime(_ time : String, format : String = "yyyyMMddHHmmss") -> String{
          let dateTime = DateUtil.formatStrToDate(time, format: format)
          let curDate = DateUtil.formatDateToStr(dateTime, format : "yyyy/MM/dd")
          let today = DateUtil.curDate()
          let date = DateUtil.formatDateToStr(today, format : "yyyy/MM/dd")
          var ret : String!
          if (date.prefix(5) == curDate.prefix(5)) {
              // 同一年
              ret = DateUtil.formatDateToStr(dateTime, format : "MM-dd HH:mm")
          } else {
              ret = curDate
          }
          
          return ret
      }
      
    /// 获得显示显示：原始格式：yyyyMMddHHmmss
      open class func getShowTime(_ time : String, format : String = "yyyyMMddHHmmss") -> String{
          return getShowDate(DateUtil.formatStrToDate(time, format: format))
      }
    
    @objc open class func getShowDate(_ dateTime : Date) -> String {
        let curDate = DateUtil.formatDateToStr(dateTime, format : "yyyy/MM/dd")
        let today = DateUtil.curDate()
        let date = DateUtil.formatDateToStr(today, format : "yyyy/MM/dd")
        var ret : String!
        if date == curDate {
            // 同一天
            let oldTime = dateTime.timeIntervalSince1970
            let nowTime = getTimeSince1970()
            let sub = nowTime - oldTime
            if sub < 60 {
                ret = "刚刚"
            } else if sub < 60 * 60 {
                ret = "\(Int(sub / 60))分钟前"
            } else {
                ret = "\(Int(sub / 3600))小时前"
            }
        } else {
            if (date.prefix(5) == curDate.prefix(5)) {
                // 同一年
                ret = DateUtil.formatDateToStr(dateTime, format : "MM月dd日 HH:mm")
            } else {
                ret = curDate
            }
        }
        return ret
    }
    
    
    open class func dateToStrt(_ date : Date) -> String {
        return formatDateToStr(date, format: "yyyy-MM-dd-HH")
    }
      
      open class func startOfThisWeek() -> Date {
          let date = Date()
          let calendar = NSCalendar.current
          let components = calendar.dateComponents(
              Set<Calendar.Component>([.yearForWeekOfYear, .weekOfYear]), from: date)
          let startOfWeek = calendar.date(from: components)!
          return startOfWeek
      }
      
      open class func endOfThisWeek(returnEndTime:Bool = false) -> Date {
          let calendar = NSCalendar.current
          var components = DateComponents()
          if returnEndTime {
              components.day = 7
              components.second = -1
          } else {
              components.day = 6
          }
          
          let endOfMonth =  calendar.date(byAdding: components, to: startOfThisWeek())!
          return endOfMonth
      }
      
      //本月开始日期
      open class func startOfCurrentMonth() -> Date {
          let date = Date()
          let calendar = NSCalendar.current
          let components = calendar.dateComponents(
              Set<Calendar.Component>([.year, .month]), from: date)
          let startOfMonth = calendar.date(from: components)!
          return startOfMonth
      }
      
      //本月结束日期
      open class func endOfCurrentMonth(returnEndTime:Bool = false) -> Date {
          let calendar = NSCalendar.current
          var components = DateComponents()
          components.month = 1
          if returnEndTime {
              components.second = -1
          } else {
              components.day = -1
          }
          
          let endOfMonth =  calendar.date(byAdding: components, to: startOfCurrentMonth())!
          return endOfMonth
      }
      
      
      open class func currentMonth()->String{
          let startOfMonth = self.dateToStrCN(startOfCurrentMonth())
          let endOfMonth = self.dateToStrCN(endOfCurrentMonth())
          return startOfMonth + "日-" + endOfMonth.subString(start: endOfMonth.count-2, length: 2)
      }
      
      open class func thisWeek()->String{
          let startOfMonth = self.dateToStrCN(startOfThisWeek())
          let endOfMonth = self.dateToStrCN(endOfThisWeek())
          return startOfMonth + "日-"  + endOfMonth.subString(start: endOfMonth.count-2, length: 2)
      }
      
      open class func currentYear()->String{
          let startOfMonth = self.dateToStrCN(startOfCurrentYear())
          let endOfMonth = self.dateToStrCN(endOfCurrentYear())
          return startOfMonth + "日-"  + endOfMonth.subString(start: endOfMonth.count-5, length: 5)
      }
      
      //本年开始日期
      open class func startOfCurrentYear() -> Date {
          let date = Date()
          let calendar = NSCalendar.current
          let components = calendar.dateComponents(Set<Calendar.Component>([.year]), from: date)
          let startOfYear = calendar.date(from: components)!
          return startOfYear
      }
      
      //本年结束日期
      open class func endOfCurrentYear(returnEndTime:Bool = false) -> Date {
          let calendar = NSCalendar.current
          var components = DateComponents()
          components.year = 1
          if returnEndTime {
              components.second = -1
          } else {
              components.day = -1
          }
          
          let endOfYear = calendar.date(byAdding: components, to: startOfCurrentYear())!
          return endOfYear
      }
      
      open class func erayWeekOfYear2(_ date : Date) -> String {
          let calendar: Calendar = Calendar(identifier: .gregorian)
          return  " 【\(calendar.component(.weekOfYear, from: date))周】" + featureWeekday(date).replacingOccurrences(of: "星期", with: "周")
      }
      
    open class func featureWeekday(_ date : Date) -> String {
          let calendar = Calendar.current
          let weekDay = calendar.component(.weekday, from: date)
          switch weekDay {
          case 1:
              return "星期日"
          case 2:
              return "星期一"
          case 3:
              return "星期二"
          case 4:
              return "星期三"
          case 5:
              return "星期四"
          case 6:
              return "星期五"
          case 7:
              return "星期六"
          default:
              return ""
          }
      }
      
      
    open class func reDayCount(_ year : Int ,_ month : Int) -> Int {
        if [1,3,5,7,8,10,12].contains(month){
          return 31
        }else if month == 2 {
          if year%4 == 0 {
              return 29
          }else{
              return 28
          }
        } else {
          return 30
        }
    }
}
