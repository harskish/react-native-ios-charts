//
//  ABNumberFormatter.swift
//
//
//  Created by Jose Padilla on 2/5/16.
//
//

import Foundation

class ABNumberFormatter : NumberFormatter {
    
    fileprivate var maximumDecimalPlaces: Int = 0;
    fileprivate var minimumDecimalPlaces: Int = 0;
    
    init(minimumDecimalPlaces: Int, maximumDecimalPlaces: Int) {
        if (minimumDecimalPlaces < 0) {
            self.minimumDecimalPlaces = 0;
        } else {
            self.minimumDecimalPlaces = minimumDecimalPlaces;
        }
        if (maximumDecimalPlaces < 0) {
            self.maximumDecimalPlaces = 0;
        } else {
            self.maximumDecimalPlaces = maximumDecimalPlaces;
        }

        super.init();
        
        // Customize appearance
        self.usesSignificantDigits = true;
        self.minimumSignificantDigits = 2;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    /*
    func abbreviateNumber(_ num: Int) -> String {
        var abbrevNum : String = "";
        var number : Float = Float(num);
        if (num >= 1000) {
            let abbrev = ["K", "M", "B"];
            for i in stride(from: (abbrev.count - 1), to: 0, by: -1) {
                let size = Float(pow(Double(10), Double((i+1)*3)));
                if(size <= number) {
                    number = number/size;
                    let numberString = floatToString(number);
                    self.positiveSuffix = abbrev[i];
                    abbrevNum = String(format:"%@", numberString);
                }
            }
        } else {
            self.positiveSuffix = "";
            abbrevNum = String(format:"%d", Int(number));
        }
        
        return abbrevNum;
    }
    */
    
    func abbreviateNumber(number: Int) -> String {
        var num : Double = Double(number);
        let sign = ((num < 0) ? "-" : "");

        num = fabs(num);

        if (num < 1000.0) {
            self.positiveSuffix = "";
            self.negativeSuffix = "";
            return "\(sign)\(num)";
        }

        let units : [String] = ["K", "M", "B", "T"];
        let exp:Int = Int(log10(num) / 3.0 );
        
        self.positiveSuffix = units[exp-1];
        self.negativeSuffix = units[exp-1];
      
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;

        return "\(sign)\(roundedNum)";
    }

    
    
    func floatToString(_ val: Float) -> String {
        var ret = String(format:"%.\(self.maximumDecimalPlaces)f", val);
        var c = UniChar(String(ret.characters.last! as Character));
        while (c == 48) {
            ret = ret.substring(to: ret.characters.index(ret.startIndex, offsetBy: ret.characters.count - 1));
            c = UniChar(String(ret.characters.last! as Character));
            if(c == 46) {
                ret = ret.substring(to: ret.characters.index(ret.startIndex, offsetBy: ret.characters.count - 1));
            }
        }
        let formatter = NumberFormatter();
        formatter.minimumFractionDigits = self.minimumDecimalPlaces;
        formatter.maximumFractionDigits = self.maximumDecimalPlaces;
        let floatValue = (ret as NSString).floatValue
        return formatter.string(from: NSNumber(value: floatValue))!;
    }
    
    override func string(for obj: Any?) -> String? {
        let value = self.abbreviateNumber(number: obj as! Int);
        if String(value.characters.last!) == "0" {
            return super.string(for: Int(value)!);
        }
        
        return super.string(for: Float(value)!);
    }
}
