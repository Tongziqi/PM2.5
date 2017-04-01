/**
 Copyright (c) 2016-present, Facebook, Inc. All rights reserved.
 
 The examples provided by Facebook are for non-commercial testing and evaluation
 purposes only. Facebook reserves all rights not expressly granted.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit
import IGListKit
import ChameleonFramework
import SwiftyJSON

final class EmbeddedSectionController: IGListSectionController, IGListSectionType {
    
    var entry: ForecastEntry!
    var json: JSON = []
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
    }
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 120, height: 70)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        
        let cell = collectionContext?.dequeueReusableCell(withNibName: "WeatherUICollectionViewCell", bundle: nil, for: self, at: index) as? WeatherUICollectionViewCell
        let name = entry.imageString ?? ""
        
        cell?.image.image = UIImage(named: detectPicture(value: name, weather: UserSetting.WeatherCondition)
        )
        
        cell?.dataLabel.text = entry.dataLabel
        cell?.temptureLabel.text = entry.temperature
        cell?.weather.text = entry.weatherLabel
        return cell!
    }
    
    func didUpdate(to object: Any) {
        entry = object as? ForecastEntry
    }
    
    func didSelectItem(at index: Int) {}
    
}
