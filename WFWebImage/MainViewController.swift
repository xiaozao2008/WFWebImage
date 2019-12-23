//
//  MainViewController.swift
//  WFWebImage
//
//  Created by yongji.wang on 2019/12/17.
//  Copyright © 2019 yongji.wang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urls = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577097258534&di=9b33150e7202f00a5946a811a39c6c77&imgtype=0&src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2015%2F0408%2F779334da99e40adb587d0ba715eca102.jpg", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577097258534&di=2ca8de5d08dd912975b621517484f9fc&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fc83d70cf3bc79f3d6e7bf85db8a1cd11738b29c0.jpg", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577097258534&di=d059a9b6e0aa53168580ee609298fb75&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%3D580%2Fsign%3Db57187fbbf3eb13544c7b7b3961fa8cb%2Fa826bd003af33a87dc2bab09c55c10385343b57a.jpg", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577097258534&di=0fe6722894184fd0ec222aff55be70b2&imgtype=0&src=http%3A%2F%2Fdl.ppt123.net%2Fpptbj%2F201603%2F2016030410190920.jpg", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577097258534&di=b773ce0cd8015da8d73737147d4c4153&imgtype=0&src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2014%2F1006%2Fe94e4f70870be76a018dff428306c5a3.jpg", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577097258533&di=fbcd82154b3ef3a053762b5a46dd0784&imgtype=0&src=http%3A%2F%2Fi2.w.yun.hjfile.cn%2Fdoc%2F201303%2F54c809bf-1eb2-400b-827f-6f024d7d599b_01.jpg"]
        
        
        WFWebImageConfig.default.memoryCache.countLimit = Int.max
        WFWebImageConfig.default.memoryCache.totalCostLimit = Int.max
        view.addSubview(imageView)
        var count = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let path = urls.randomElement()!
            count += 1
            if count >= 200 {
                timer.invalidate()
            }
            self.imageView.wf.image(path)
        }
        imageView.frame = CGRect(x: 0, y: 100, width: 400, height: 400)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
