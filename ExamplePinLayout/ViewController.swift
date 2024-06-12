//
//  ViewController.swift
//  ExamplePinLayout
//
//  Created by 황재현 on 6/12/24.
//

import UIKit
import PinLayout
import FlexLayout

// MARK: FlexLayout을 사용하기 위한 3가지
//        1. addItem -> 스택뷰의 addArrangedSubview()와 같음
//        2. flexView의 pin layout 잡기 -> flexView의 위치 잡기
//           (일반적인 autolayout사용의 constraint로 잡지 않는것임을 주의)
//           viewDidLayoutSubviews나 layoutSubview같은 곳에서
//           pin을 가지고 flexView의 레이아웃을 고정
//        3. flexView에 들어간 Children의 layout 잡기

class ViewController: UIViewController {
    /// Flex 뷰
    let flexView = UIView()
    
    /// 스크롤뷰
    let scrollView = UIScrollView()
    /// 스크롤뷰의 내용을 담을 컨텐츠뷰
    let contentView = UIView()
    
    private let label1: UILabel = {
       var label = UILabel()
        label.text = "label1"
        label.backgroundColor = .red
        return label
    }()
    private let label2: UILabel = {
       var label = UILabel()
        label.text = "label2"
        label.backgroundColor = .green
        return label
    }()
    private let label3: UILabel = {
       var label = UILabel()
        label.text = "label3"
        label.backgroundColor = .blue
        return label
    }()
    
    private let boxes = (0...100).map { _ in
        let view = UIView()
        view.backgroundColor = .random
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // PinLayout 콘솔 warning 을 보여줄지 말지 설정 (default: true)
        Pin.logWarnings = true
        
        configureUI()
        
//        configureScrollView()
    }
    
    /// 일반 뷰 구현
    func configureUI() {
        view.addSubview(flexView)
        
        // MARK: 1. addItem
        flexView.flex.padding(16).define { flex in
            flex.addItem(label1)
            flex.addItem(label2)
            flex.addItem(label3)
        }
    }
    
    /// 스크롤뷰로 구현
    func configureScrollView() {
        view.addSubview(flexView)
        
        flexView.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.flex.padding(0).define { flex in
            boxes.forEach { box in
                flex.addItem(box)
                    .height(100)
                    .marginVertical(8)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // MARK: 2. flexView의 위치 잡기
        flexView.pin
            .top(view.pin.safeArea)
            .bottom(view.pin.safeArea)
            .left(16)
            .right(16)
        
        // MARK: 3. flexView의 Children 위치 잡기
        flexView.flex.layout()
        
        scrollView.pin.all()
        contentView.pin.all()
        // 스크롤이 세로방향이라 mode를 adjustHeight
        contentView.flex.layout(mode: .adjustHeight)
        // 콘텐츠뷰의 크기를 알아야 스크롤뷰의 스크롤이 가능
        scrollView.contentSize = contentView.frame.size
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1)
    }
}
