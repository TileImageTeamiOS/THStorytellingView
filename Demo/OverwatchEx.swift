//
//  OverwatchEx.swift
//  Demo
//
//  Created by mac on 2018. 1. 15..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import Foundation
import UIKit

class OverwatchEx {
    let tracer = MarkerView()
    let mercy = MarkerView()
    let reinhardt = MarkerView()
    let hanzo = MarkerView()
    let bastion = MarkerView()
    let tracerText = "전직 오버워치 요원인 트레이서는 시간을 넘나드는 활기찬 모험가이다. \r\n\r\n레나 옥스턴(호출명: 트레이서)은 오버워치의 실험 비행 프로그램에 투입된 최연소 참가자였다. 과감한 비행 기술로 명성을 떨친 그녀는 순간 이동 전투기의 프로토타입, '슬립 스트림'의 실험 대상으로 선발되었다. 하지만 첫 비행에서 전투기는 순간 이동 매트릭스의 오작동에 의해 사라져 버렸고, 레나는 사망한 것으로 여겨졌다. \r\n\r\n레나는 수 개월 후 다시 나타났으나, 이 비극은 그녀를 송두리째 바꿔버렸다. 레나의 분자 구조는 시간의 흐름을 따라가지 못하게 되었다. 그녀는 살아 있는 유령이 되어, '시간과 분리된 상태'에서 몇 시간, 또는 며칠간 사라지며 고통받게 되었다. 심지어 잠깐 현재에 있을 때에도 물리적인 형태를 유지할 수 없었다.\r\n\r\n누구보다 발전된 기술을 가진 오버워치의 의료진과 과학자들까지도 처음 겪어 보는 이 특이 사례에는 속수무책이었다. 트레이서의 상황은 절망적이었으나, 윈스턴이라는 과학자가 트레이서를 현재에 묶을 수 있는 시간 가속기를 개발하며 상황은 반전을 맞았다. 시간 가속기 덕분에 트레이서는 자신의 시간을 조종해 마음대로 속도를 높이거나 줄일 수도 있게 되었다. 새로 얻은 이 능력과 함께, 트레이서는 오버워치의 핵심 요원 중 하나로 거듭났다.\r\n\r\n오버워치가 해체된 뒤, 트레이서는 기회가 있을 때마다 정의의 편에 서서 잘못된 것을 바로잡기 위해 싸우고 있다."
    let mercyText = "수호천사와도 같이 사람을 보살피는 앙겔라 치글러 박사는 발군의 치유사이자 뛰어난 과학자, 열성적인 평화주의자이다.\r\n\r\n치글러는 명망 있는 스위스의 병원에서 외과 과장으로 승진한 후, 나노생물학 분야에서 획기적인 발견을 해내 치명적인 질병 및 부상의 치료에 크게 공헌하였다. 이러한 전문성이 오버워치의 관심을 끌었다.\r\n\r\n전쟁 중에 부모를 잃은 치글러는 군사력으로 세계 평화를 유지한다는 오버워치의 방침에 반발하였다. 그러나 결국 오버워치가 크게 보면 더욱 많은 생명을 구할 기회를 준다는 사실을 깨닫게 되었다. 오버워치의 의학 연구 책임자로서, 앙겔라는 최전선 위기 상황에서의 치료 기술을 향상시키는 연구에 박차를 가했다. 그 결과 탄생한 것이 발키리 신속 대응 슈트로, 치글러 스스로 이것을 숱한 오버워치 임무에서 시험한 바 있다.\r\n\r\n치글러는 오버워치에서 중책을 맡고 있음에도 상관들과, 그리고 조직의 큰 목표와 충돌하곤 했다. 오버워치가 해체된 후로는 전쟁에서 상처받은 자들을 돕는 데 전념하고 있다.\r\n\r\n치글러 박사는 대개 전 세계의 위기 지역에서 망가지고 소외된 이들을 돌보며 시간을 보내지만, 무고한 이들이 위험에 처하면 발키리 슈트를 입고 활약하기를 망설이지 않는다."
    let hanzoText = "궁수와 암살자로서의 기술을 완벽하게 연마한 시마다 한조는 자신이 그 누구에게도 비할 수 없는 전사임을 증명하려고 애쓴다.\r\n\r\n수백 년 동안 이어져 온 암살자 가문 시마다 일족은, 긴 세월 동안 힘을 키우며 무기와 불법 약물을 거래하며 막대한 수익을 올리고 거대한 범죄의 제국을 건설했다. 일족 수장의 큰아들인 한조는 의무적으로 아버지의 뒤를 이어 시마다 제국을 지휘해야 했기에 어린 시절부터 훈련을 받았고, 그 과정에서 타고난 지도자로서의 자질, 그리고 전술과 전략을 이해하는 지혜가 돋보였다. 물론 이보다 더 실용적인 분야인 무술과 검술, 궁술에서도 빼어난 솜씨를 보였다.\r\n\r\n그의 아버지가 갑작스럽게 세상을 떠난 후, 일족의 장로들은 한조에게 사고뭉치 동생을 바로잡아 함께 시마다 제국을 다스리라고 했다. 하지만 동생은 이를 거절하고 말았고, 한조는 어쩔 수 없이 직접 그를 제거해야 했다. 이는 한조의 마음에 지울 수 없는 상처를 남겼고, 결국 그는 아버지의 유산을 거부한 채 자신의 일족과 그간 쌓아온 모든 것을 저버리고 말았다.\r\n\r\n이제 한조는 전 세계를 돌아다니며 전사로서의 실력을 연마하고, 실추된 명예를 회복하는 동시에 과거의 유령을 잠재우려 한다."
    let tracerDict:[String: Bool] = ["isTitleContent": true, "isAudioContent": false,
                                     "isVideoContent": false, "isTextContent": true]
    let mercyDict:[String: Bool] = ["isTitleContent": true, "isAudioContent": true,
                                     "isVideoContent": false, "isTextContent": true]
    let reinhardtDict:[String: Bool] = ["isTitleContent": true, "isAudioContent": false,
                                     "isVideoContent": true, "isTextContent": false]
    let hanzoDict:[String: Bool] = ["isTitleContent": true, "isAudioContent": true,
                                        "isVideoContent": false, "isTextContent": true]
    let bastionDict:[String: Bool] = ["isTitleContent": true, "isAudioContent": false,
                                        "isVideoContent": true, "isTextContent": false]
    func setOverwatchEx(dataSource: MarkerViewDataSource) {
        tracer.set(dataSource: dataSource, origin: CGPoint(x: 2356.16510791752, y: 2448.02251465983), zoomScale: CGFloat(0.36832449916906), contentDict: tracerDict)
        tracer.setTitle(title: "트레이서")
        tracer.setText(title: "", link: "", content: tracerText)
        mercy.set(dataSource: dataSource, origin: CGPoint(x: 2604.44232857886, y: 1536.70551753077), zoomScale: CGFloat(0.33513252482331), contentDict: mercyDict)
        mercy.setTitle(title: "메르시")
        mercy.setText(title: "", link: "http://bit.ly/2DdfdJV", content: mercyText)
        mercy.setAudioContent(audioUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "mercy", ofType:"mp3")!))
        reinhardt.set(dataSource: dataSource, origin: CGPoint(x: 4631.42734847787, y: 1289.33508602314), zoomScale: CGFloat(0.206307889146534), contentDict: reinhardtDict)
        reinhardt.setTitle(title: "라인하르트")
        reinhardt.setVideoContent(videoUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "reinhardt", ofType:"mp4")!))
        hanzo.set(dataSource: dataSource, origin: CGPoint(x: 4805.4798427588, y: 2517.19919460647), zoomScale: CGFloat(0.184199433902629), contentDict: hanzoDict)
        hanzo.setTitle(title: "한조")
        hanzo.setText(title: "", link: "http://bit.ly/2mEvCgD", content: hanzoText)
        hanzo.setAudioContent(audioUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "hanzo", ofType:"mp3")!))
        bastion.set(dataSource: dataSource, origin: CGPoint(x: 7113.34238377875, y: 1967.95929530708), zoomScale: CGFloat(0.331138285339882), contentDict: bastionDict)
        bastion.setTitle(title: "바스티온")
        bastion.setVideoContent(videoUrl: URL(fileURLWithPath: Bundle.main.path(forResource: "Bastion", ofType:"mp4")!))
    }
}

