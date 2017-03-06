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

final class HorizontalSectionController: IGListSectionController, IGListSectionType, IGListAdapterDataSource {
    
    var json: JSON = []
    var entry: ForecastEntry!
    
    let loader = ForecastDataLoader()

    lazy var adapter: IGListAdapter = {
        let adapter = IGListAdapter(updater: IGListAdapterUpdater(),
                                    viewController: self.viewController,
                                    workingRangeSize: 0)
        adapter.dataSource = self
        return adapter
    }()

    init(json: JSON) {
        self.json = json
    }
    
    
    func numberOfItems() -> Int {
        return 1
    }

    func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: collectionContext!.containerSize.height)
    }

    func cellForItem(at index: Int) -> UICollectionViewCell {
        
        // 水平的cell
        let cell = collectionContext!.dequeueReusableCell(of: EmbeddedCollectionViewCell.self, for: self, at: index) as! EmbeddedCollectionViewCell
        adapter.collectionView = cell.collectionView
        return cell
    }

    func didUpdate(to object: Any) {
        entry = object as? ForecastEntry
    }

    func didSelectItem(at index: Int) {
        
    }

    //MARK: IGListAdapterDataSource
    
    
    // 这个水平的cell里面拥有的7个天气

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        if json != [] {
            loader.loadLatest(json: json)
        } else {
            loader.loadDefault()
        }
        return  loader.datas as [IGListDiffable]
    }

    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        return EmbeddedSectionController()
    }

    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }

}
